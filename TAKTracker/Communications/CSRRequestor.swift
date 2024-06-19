//
//  CSRRequestor.swift
//  TAKTracker
//
//  Created by Cory Foy on 8/18/23.
//

import Crypto
import _CryptoExtras
import Foundation
import SwiftASN1
import SwiftTAK
import X509

enum CSREnrollmentStatus : CustomStringConvertible {
    case NotStarted
    case Connecting
    case Configuring
    case Enrolling
    case Failed
    case Succeeded
    case Untrusted
    
    var description: String {
        switch self {
        case .NotStarted: return "Not Started"
        case .Connecting: return "Connecting"
        case .Configuring: return "Configuring"
        case .Enrolling: return "Enrolling"
        case .Failed: return "Failed"
        case .Succeeded: return "Succeeded"
        case .Untrusted: return "Untrusted Server SSL"
        }
    }
}

struct Order: Codable {
    let customerId: String
    let items: [String]
}

struct CSRConfiguration {
    let configHttpMethod: String = "GET"
    let httpMethod: String = "POST"
    
    var didError = false
    var error: Error? = nil
    var response: URLResponse? = nil
    var responseData: Data? = nil

    var orgName: String = ""
    var orgUnitName: String = ""
    
    var host: String {
        get { return "https://\(SettingsStore.global.takServerUrl)" }
    }
    var port: String {
        get { return SettingsStore.global.takServerCSRPort }
    }
    var configPath: String {
        get { return TAKConstants.CERT_CONFIG_PATH }
    }
    var csrPath: String {
        get { return TAKConstants.certificateSigningPath(
            clientUid: AppConstants.getClientID(),
            appVersion: AppConstants.getAppReleaseAndBuildVersion()) }
    }
    
    var configURL: URL {
        get { return URL(string: "\(host):\(port)\(configPath)")! }
    }
    
    var csrURL: URL {
        get { return URL(string: "\(host):\(port)\(csrPath)")! }
    }
    
}

class CSRRequestor: NSObject, ObservableObject, URLSessionDelegate {
    @Published var enrollmentStatus: CSREnrollmentStatus = CSREnrollmentStatus.NotStarted;

    var derEncodedCertificate: [UInt8] = []
    var derEncodedPrivateKey: Data = Data()
    var config = CSRConfiguration()
    
    var tlsConfigPath = TAKConstants.CERT_CONFIG_PATH
    var csrRequestPath = TAKConstants.certificateSigningPath(
        clientUid: AppConstants.getClientID(),
        appVersion: AppConstants.getAppReleaseAndBuildVersion())
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
            if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodClientCertificate) {
                TAKLogger.debug("[CSRRequestor] CSR Request recieved a client auth challenge. Rejecting.")
                completionHandler(.rejectProtectionSpace, nil)
            }
            if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
                TAKLogger.debug("[CSRRequestor] Auth Trust challenge for \(challenge.protectionSpace.host)")
                guard let serverTrust = challenge.protectionSpace.serverTrust else {
                    TAKLogger.debug("[CSRRequestor] No Server Trust in Auth Trust Challenge. Using default handling.")
                    completionHandler(.performDefaultHandling, nil)
                    return
                }

                let credential = URLCredential(trust: serverTrust)
                challenge.sender?.use(credential, for: challenge)
                completionHandler(.useCredential, credential)
            }
    }
    
    func generateAuthHeaderString() -> String {
        let username = SettingsStore.global.takServerUsername
        let password = SettingsStore.global.takServerPassword

        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        return "Basic \(base64LoginString)"
    }
    
    func generateConfigRequest() -> URLRequest {
        var caConfigRequest = URLRequest(url: config.configURL)
        caConfigRequest.httpMethod = config.configHttpMethod
        caConfigRequest.setValue("text/plain; charset=utf-8", forHTTPHeaderField: "Content-Type")
        caConfigRequest.setValue(generateAuthHeaderString(), forHTTPHeaderField: "Authorization")
        TAKLogger.debug("[CSRRequestor] Attemping to get CA Config from: \(String(describing: config.configURL))")
        return caConfigRequest
    }
    
    func logEnrollmentError() {
        config.didError = true
        TAKLogger.error("[CSRRequestor] Error: \(config.error.debugDescription)")
        TAKLogger.error("[CSRRequestor] Response: \(String(describing: config.response))")
        TAKLogger.error("[CSRRequestor] Data: \(String(describing: config.responseData))")
        
        if(config.error != nil && config.error!.localizedDescription.debugDescription.contains("SSL error")) {
            self.enrollmentStatus = CSREnrollmentStatus.Untrusted
        } else {
            self.enrollmentStatus = CSREnrollmentStatus.Failed
        }
    }
    
    func processConfigResponse(data: Data, dataString: String) {
        var caConfigEntries : [String:String] = [:]
        self.enrollmentStatus = CSREnrollmentStatus.Configuring
        
        TAKLogger.debug("[CSRRequestor] got data: \(dataString)")
        let xmlParser = XMLParser(data: data)
        let responseParser = TAKCAConfigResponseParser()
        xmlParser.delegate = responseParser
        xmlParser.parse()
        caConfigEntries = responseParser.nameEntries
        TAKLogger.debug("[CSRRequestor] got name entries \(String(describing: caConfigEntries))")
        
        if caConfigEntries["O"] != nil {
            self.config.orgName = caConfigEntries["O"]!
        }
        
        if caConfigEntries["OU"] != nil {
            self.config.orgUnitName = caConfigEntries["OU"]!
        }
    }
    
    func generateCSRRequest() -> URLRequest {
        var csrRequest = URLRequest(url: self.config.csrURL)
        csrRequest.httpMethod = self.config.httpMethod
        csrRequest.setValue("text/plain; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON

        csrRequest.setValue(self.generateAuthHeaderString(), forHTTPHeaderField: "Authorization")
        
        TAKLogger.debug("[CSRRequestor] Attemping to CSR to: \(String(describing: self.config.csrURL))")
        return csrRequest
    }
    
    func wrapCertificate(certString: String) -> String {
        return """
-----BEGIN CERTIFICATE-----
\(certString)
-----END CERTIFICATE-----
"""
    }
    
    func certStringToDER(certString: String) -> Data {
        var serializer = DER.Serializer()
        let wrappedCert = wrapCertificate(certString: certString)
        TAKLogger.debug("Found cert")
        TAKLogger.debug(certString)
        do {
            let parsedCert = try Certificate(pemEncoded: wrappedCert)
            TAKLogger.debug("[CSRRequestor] [certStringToDER] Issuer: \(parsedCert.issuer)")
            TAKLogger.debug("[CSRRequestor] [certStringToDER] Serial Number: \(parsedCert.serialNumber)")
            try serializer.serialize(parsedCert)
        } catch {
            TAKLogger.error("Error converting certificate string \(certString): \(error)")
            return Data()
        }
        return Data(serializer.serializedBytes)
    }
    
    func storeCSRResponse(data: Data, dataString: String) {
        TAKLogger.debug("[CSRRequestor] got data: \(dataString)")
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        var trustChain: [Data] = []
        do {
            if let dictionary = json as? [String: String] {
                let caCerts = dictionary.filter({$0.key.starts(with: "ca")})
                caCerts.forEach { certEntry in
                    let derData = self.certStringToDER(certString: certEntry.value)
                    trustChain.append(derData)
                }

                if let certString = dictionary["signedCert"] {
                    let derData = certStringToDER(certString: certString)
                    SettingsStore.global.userCertificate = derData
                    TAKLogger.debug("[CSRRequestor]: Attemping to add Identity")
                    try CertificateManager.addIdentity(clientCertificate: derData, label: SettingsStore.global.takServerUrl)
                    
                    TAKLogger.debug("[CSRRequestor]: Identity Added")
                    SettingsStore.global.serverCertificate = Data()
                    SettingsStore.global.takServerChanged = true
                    self.enrollmentStatus = CSREnrollmentStatus.Succeeded
                }
                
                SettingsStore.global.serverCertificateTruststore = trustChain
            }
        } catch let error as NSError {
            TAKLogger.error("[CSRRequestor] Could not parse the cert")
            TAKLogger.error(error.debugDescription)
            self.enrollmentStatus = CSREnrollmentStatus.Failed
        }
    }
    
    func makeCSRRequest() {
        // create the request
        var csrRequest = generateCSRRequest()
        let session = URLSession(configuration: URLSessionConfiguration.ephemeral,
                                               delegate: self,
                                               delegateQueue: OperationQueue.main)
        
        self.generateSigningRequest(
            commonName: SettingsStore.global.takServerUsername,
            hostName: SettingsStore.global.takServerUrl,
            organizationName: self.config.orgName,
            organizationUnitName: self.config.orgUnitName)

        let rawCertData = Data(self.derEncodedCertificate)
        let certData = rawCertData.base64EncodedString()
        TAKLogger.debug("certData as Data")
        TAKLogger.debug(String(describing: certData));
        
        csrRequest.httpBody = rawCertData.base64EncodedData()
        
        self.enrollmentStatus = CSREnrollmentStatus.Enrolling
        
        // TODO: Actually let the user know this failed if it, uh, fails
        let task = session.dataTask(with: csrRequest) { data, response, error in
            self.config.responseData = data
            self.config.response = response
            self.config.error = error
            
            if error != nil {
                self.logEnrollmentError()
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                self.logEnrollmentError()
                return
            }
            if let mimeType = response.mimeType,
                (mimeType == "application/json" || mimeType == "text/plain"),
                let data = data,
                let dataString = String(data: data, encoding: .utf8) {
                self.storeCSRResponse(data: data, dataString: dataString)
            } else {
                TAKLogger.error("Unknown response from server when attempting Certificate Enrollment")
                self.enrollmentStatus = CSREnrollmentStatus.Failed
            }
        }
        task.resume()
    }
    
    func beginEnrollment() {
        enrollmentStatus = CSREnrollmentStatus.Connecting
        
        // Retrieve the TLS Config Variables
        let caConfigRequest = generateConfigRequest()
        let caConfigSession = URLSession(configuration: URLSessionConfiguration.ephemeral,
                                               delegate: self,
                                               delegateQueue: OperationQueue.main)
        let caConfigTask = caConfigSession.dataTask(with: caConfigRequest) { data, response, error in
            self.config.responseData = data
            self.config.response = response
            self.config.error = error
            
            if error != nil {
                self.logEnrollmentError()
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                self.logEnrollmentError()
                return
            }
            if let mimeType = response.mimeType,
                mimeType == "text/plain",
                let data = data,
                let dataString = String(data: data, encoding: .utf8) {
                self.processConfigResponse(data: data, dataString: dataString)
                self.makeCSRRequest()
            } else {
                TAKLogger.error("[CSRRequestor] Unknown response from server when attempting CA Config")
                self.logEnrollmentError()
            }
        }
        caConfigTask.resume()
    }
    
    func generateSigningRequest(commonName: String,
                                hostName: String,
                                organizationName: String,
                                organizationUnitName: String) {
        do {
            let privateKeyTag = "tak.flighttactics.com-\(hostName)-pk"
            
            let certData = try CertificateManager.generateTaggedPrivateKey(privateKeyTag: privateKeyTag)
            let swiftCryptoKey = try _RSA.Signing.PrivateKey(derRepresentation: certData)

            generateSigningRequest(commonName: commonName, hostName: hostName, organizationName: organizationName, organizationUnitName: organizationUnitName, privateKey: swiftCryptoKey)

        } catch let error as NSError {
            TAKLogger.error("[CSRRequestor] Could not create the CSR")
            TAKLogger.error(error.debugDescription)
        }
    }
    
    func generateSigningRequest(commonName: String,
                                hostName: String,
                                organizationName: String,
                                organizationUnitName: String,
                                privateKey: _RSA.Signing.PrivateKey) {
        do {

            let key = Certificate.PrivateKey(privateKey)

            let subjectName = try DistinguishedName {
                CommonName(commonName)
                OrganizationName(organizationName)
                OrganizationalUnitName(organizationUnitName)
            }
            
            TAKLogger.debug("[CSRRequestor] Creating Certificate")
            
            let csr = try CertificateSigningRequest(
                version: .v1,
                subject: subjectName,
                privateKey: key,
                attributes: CertificateSigningRequest.Attributes(),
                signatureAlgorithm: .sha256WithRSAEncryption)
            
            TAKLogger.debug("[CSRRequestor] Serializing")
            var serializer = DER.Serializer()
            try serializer.serialize(csr)

            derEncodedCertificate = serializer.serializedBytes
            derEncodedPrivateKey = privateKey.derRepresentation
        } catch let error as NSError {
            TAKLogger.error("[CSRRequestor] Could not create the CSR")
            TAKLogger.error(error.debugDescription)
        }
    }
}
