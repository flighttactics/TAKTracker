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
    
    var description: String {
        switch self {
        case .NotStarted: return "Not Started"
        case .Connecting: return "Connecting"
        case .Configuring: return "Configuring"
        case .Enrolling: return "Enrolling"
        case .Failed: return "Failed"
        case .Succeeded: return "Succeeded"
        }
    }
}

struct Order: Codable {
    let customerId: String
    let items: [String]
}

class CSRRequestor: NSObject, ObservableObject, URLSessionDelegate {
    @Published var enrollmentStatus: CSREnrollmentStatus = CSREnrollmentStatus.NotStarted;

    var derEncodedCertificate: [UInt8] = []
    var derEncodedPrivateKey: Data = Data()
    
    var csrPort = TAKConstants.DEFAULT_CSR_PORT
    var tlsConfigPath = TAKConstants.CERT_CONFIG_PATH
    var csrRequestPath = TAKConstants.certificateSigningPath(
        clientUid: AppConstants.getClientID(),
        appVersion: AppConstants.getAppVersion())
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
            if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodClientCertificate) {
                TAKLogger.debug("CSR Request recieved a client auth challenge. Rejecting.")
                completionHandler(.rejectProtectionSpace, nil)
            }
            if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
                TAKLogger.debug("Auth Trust challenge for \(challenge.protectionSpace.host)")
                guard let serverTrust = challenge.protectionSpace.serverTrust else {
                    TAKLogger.debug("No Server Trust in Auth Trust Challenge. Using default handling.")
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
        TAKLogger.debug("Auth String: \(loginString)")
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        return "Basic \(base64LoginString)"
    }
    
    func beginEnrollment() {
        enrollmentStatus = CSREnrollmentStatus.Connecting
        let caConfigMethod = "GET"
        let csrMethod = "POST"
        let host = "https://\(SettingsStore.global.takServerUrl)"
        var caConfigEntries : [String:String] = [:]
        var orgNameEntry = ""
        var orgUnitNameEntry = ""
        
        // Retrieve the TLS Config Variables
        let caConfigURL = URL(string: "\(host):\(csrPort)\(tlsConfigPath)")!
        var caConfigRequest = URLRequest(url: caConfigURL)
        caConfigRequest.httpMethod = caConfigMethod
        caConfigRequest.setValue("text/plain; charset=utf-8", forHTTPHeaderField: "Content-Type")
        caConfigRequest.setValue(generateAuthHeaderString(), forHTTPHeaderField: "Authorization")
        TAKLogger.debug("[CSRRequestor] Attemping to get CA Config from: \(String(describing: caConfigURL))")
        
        let caConfigSession = URLSession(configuration: URLSessionConfiguration.ephemeral,
                                               delegate: self,
                                               delegateQueue: OperationQueue.main)
        let caConfigTask = caConfigSession.dataTask(with: caConfigRequest) { data, response, error in
            if let error = error {
                TAKLogger.error("[CSRRequestor] Error: \(error)")
                TAKLogger.error("[CSRRequestor] Response: \(String(describing: response))")
                TAKLogger.error("[CSRRequestor] Data: \(String(describing: data))")
                self.enrollmentStatus = CSREnrollmentStatus.Failed
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                TAKLogger.error("[CSRRequestor] Error: \(String(describing: error))")
                TAKLogger.error("[CSRRequestor] Response: \(String(describing: response))")
                TAKLogger.error("[CSRRequestor] Data: \(String(describing: data))")
                self.enrollmentStatus = CSREnrollmentStatus.Failed
                return
            }
            if let mimeType = response.mimeType,
                mimeType == "text/plain",
                let data = data,
                let dataString = String(data: data, encoding: .utf8) {
                
                self.enrollmentStatus = CSREnrollmentStatus.Configuring
                
                TAKLogger.debug("[CSRRequestor] got data: \(dataString)")
                let xmlParser = XMLParser(data: data)
                let responseParser = TAKCAConfigResponseParser()
                xmlParser.delegate = responseParser
                xmlParser.parse()
                caConfigEntries = responseParser.nameEntries
                TAKLogger.debug("[CSRRequestor] got name entries \(String(describing: caConfigEntries))")
                
                if caConfigEntries["O"] != nil {
                    orgNameEntry = caConfigEntries["O"]!
                }
                
                if caConfigEntries["OU"] != nil {
                    orgUnitNameEntry = caConfigEntries["OU"]!
                }
                
                // create the request
                let csrURL = URL(string: "\(host):\(self.csrPort)\(self.csrRequestPath)")!
                var csrRequest = URLRequest(url: csrURL)
                csrRequest.httpMethod = csrMethod
                csrRequest.setValue("text/plain; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON

                csrRequest.setValue(self.generateAuthHeaderString(), forHTTPHeaderField: "Authorization")
                
                TAKLogger.debug("[CSRRequestor] Attemping to CSR to: \(String(describing: csrURL))")
                
                let session = URLSession(configuration: URLSessionConfiguration.ephemeral,
                                                       delegate: self,
                                                       delegateQueue: OperationQueue.main)
                
                self.generateSigningRequest(
                    commonName: SettingsStore.global.takServerUsername,
                    hostName: SettingsStore.global.takServerUrl,
                    organizationName: orgNameEntry,
                    organizationUnitName: orgUnitNameEntry)

                let rawCertData = Data(self.derEncodedCertificate)
                let certData = rawCertData.base64EncodedString()
                TAKLogger.debug("certData as Data")
                TAKLogger.debug(String(describing: certData));
                
                csrRequest.httpBody = rawCertData.base64EncodedData()
                
                self.enrollmentStatus = CSREnrollmentStatus.Enrolling
                
                // TODO: Actually let the user know this failed if it, uh, fails
                let task = session.dataTask(with: csrRequest) { data, response, error in
                    if let error = error {
                        TAKLogger.error("[CSRRequestor] Error: \(error)")
                        TAKLogger.error("[CSRRequestor] Response: \(String(describing: response))")
                        TAKLogger.error("[CSRRequestor] Data: \(String(describing: data))")
                        self.enrollmentStatus = CSREnrollmentStatus.Failed
                        return
                    }
                    guard let response = response as? HTTPURLResponse,
                        (200...299).contains(response.statusCode) else {
                        TAKLogger.error("[CSRRequestor] Error: \(String(describing: error))")
                        TAKLogger.error("[CSRRequestor] Response: \(String(describing: response))")
                        TAKLogger.error("[CSRRequestor] Data: \(String(describing: data))")
                        self.enrollmentStatus = CSREnrollmentStatus.Failed
                        return
                    }
                    if let mimeType = response.mimeType,
                        (mimeType == "application/json" || mimeType == "text/plain"),
                        let data = data,
                        let dataString = String(data: data, encoding: .utf8) {
                        TAKLogger.debug("[CSRRequestor] got data: \(dataString)")
                        let json = try? JSONSerialization.jsonObject(with: data, options: [])
                        TAKLogger.debug(String(describing: json))
                        do {
                            if let dictionary = json as? [String: String] {
                                if var certString = dictionary["signedCert"] {
                                    certString = """
-----BEGIN CERTIFICATE-----
\(certString)
-----END CERTIFICATE-----
"""
                                    let parsedCert = try Certificate(pemEncoded: certString)
                                    TAKLogger.debug("Parsed Certificate:")
                                    TAKLogger.debug(String(describing: parsedCert))
                                    TAKLogger.debug("Storing Certificate")
                                    
                                    TAKLogger.debug("Serializing to DER")
                                    var serializer = DER.Serializer()
                                    try serializer.serialize(parsedCert)
                                    let derData = Data(serializer.serializedBytes)
                                    TAKLogger.debug("Attemping to add Identity")
                                    try CertificateManager.addIdentity(clientCertificate: derData, label: SettingsStore.global.takServerUrl)
                                    
                                    TAKLogger.debug("Identity Added")
                                    
                                    guard let identityCert = CertificateManager.getCertificate(label: SettingsStore.global.takServerUrl) else {
                                        TAKLogger.error("Could not get Identity Cert")
                                        self.enrollmentStatus = CSREnrollmentStatus.Failed
                                        return
                                    }
                                    
                                    let certData = SecCertificateCopyData(identityCert) as Data
                                    
                                    //let responseCertData = certString.data(using: String.Encoding.utf8)!
                                    SettingsStore.global.userCertificate = certData
                                    SettingsStore.global.userCertificatePassword = ""
                                    SettingsStore.global.takServerChanged = true
                                    self.enrollmentStatus = CSREnrollmentStatus.Succeeded
                                }
                            }
                        } catch let error as NSError {
                            TAKLogger.error("[CSRRequestor] Could not parse the cert")
                            TAKLogger.error(error.debugDescription)
                            self.enrollmentStatus = CSREnrollmentStatus.Failed
                        }
                    } else {
                        TAKLogger.error("Unknown response from server when attempting Certificate Enrollment")
                        self.enrollmentStatus = CSREnrollmentStatus.Failed
                    }
                }
                task.resume()
            } else {
                TAKLogger.error("Unknown response from server when attempting CA Config")
                self.enrollmentStatus = CSREnrollmentStatus.Failed
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
            let publicKeyAccount = "tak.flighttactics.com=\(hostName)-\(commonName)"
            let publicKeyService = "tak.flighttactics.com-\(hostName)-public"
            
            let certData = try CertificateManager.generateKeyPairWithPublicKeyAsGenericPassword(privateKeyTag: privateKeyTag, publicKeyAccount: publicKeyAccount, publicKeyService: publicKeyService)
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
