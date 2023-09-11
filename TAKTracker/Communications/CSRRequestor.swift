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
import X509

enum CSREnrollmentStatus : CustomStringConvertible {
    case NotStarted
    case Connecting
    case Enrolling
    case Failed
    case Succeeded
    
    var description: String {
        switch self {
        case .NotStarted: return "Not Started"
        case .Connecting: return "Connecting"
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
    
    var host = "https://\(SettingsStore.global.takServerUrl)"
    var csrPort = TAKConstants.DEFAULT_CSR_PORT
    var tlsConfigPath = TAKConstants.CERT_CONFIG_PATH
    var csrRequestPath = TAKConstants.certificateSigningPath(
        clientUid: TAKConstants.getClientID(),
        appVersion: TAKConstants.getAppVersion())

    //This is used for adding basic auth to the request
    var username = SettingsStore.global.takServerUsername
    var password = SettingsStore.global.takServerPassword
    
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
    
    func beginEnrollment() {
        enrollmentStatus = CSREnrollmentStatus.Connecting
        let path = csrRequestPath
        let method = "POST"

        let loginString = String(format: "%@:%@", username, password)
        TAKLogger.debug("Auth String: \(loginString)")
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()

        // create the request
        let url = URL(string: "\(host):\(csrPort)\(path)")!
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("text/plain; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON

        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        TAKLogger.debug("[CSRRequestor] Attemping to CSR to: \(String(describing: url))")
        
        let session = URLSession(configuration: URLSessionConfiguration.ephemeral,
                                               delegate: self,
                                               delegateQueue: OperationQueue.main)
        
        // TODO: Pull O/OU from the TLS Config API
        generateSigningRequest(
            commonName: username,
            hostName: SettingsStore.global.takServerUrl,
            organizationName: "FLIGHTTACTICS",
            organizationUnitName: "TAK")

        let rawCertData = Data(derEncodedCertificate)
        let certData = rawCertData.base64EncodedString()
        TAKLogger.debug("certData as Data")
        TAKLogger.debug(String(describing: certData));
        
        request.httpBody = rawCertData.base64EncodedData()
        
        // TODO: Actually let the user know this failed if it, uh, fails
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                TAKLogger.error("[CSRRequestor] Error: \(error)")
                TAKLogger.error("[CSRRequestor] Response: \(String(describing: response))")
                TAKLogger.error("[CSRRequestor] Data: \(String(describing: data))")
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                TAKLogger.error("[CSRRequestor] Error: \(String(describing: error))")
                TAKLogger.error("[CSRRequestor] Response: \(String(describing: response))")
                TAKLogger.error("[CSRRequestor] Data: \(String(describing: data))")
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
                                return
                            }
                            
                            let certData = SecCertificateCopyData(identityCert) as Data
                            
                            //let responseCertData = certString.data(using: String.Encoding.utf8)!
                            SettingsStore.global.userCertificate = certData
                            SettingsStore.global.userCertificatePassword = ""
                            SettingsStore.global.takServerChanged = true
                        }
                    }
                } catch let error as NSError {
                    TAKLogger.error("[CSRRequestor] Could not parse the cert")
                    TAKLogger.error(error.debugDescription)
                }
            } else {
                TAKLogger.debug("[CSRRequestor] Got a response! \(String(describing: response.statusCode))")
                TAKLogger.debug(String(describing: response.mimeType))
                TAKLogger.debug(String(describing: data))
                
                TAKLogger.debug("Attempting Cert parse")
                do {
                    let received: [UInt8] = Array(data!)
                    let responseCert = try Certificate(derEncoded: received)
                    TAKLogger.debug(String(describing: responseCert))
                } catch let error as NSError {
                    TAKLogger.error("[CSRRequestor] Could not parse the cert")
                    TAKLogger.error(error.debugDescription)
                }
            }
        }
        task.resume()

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
            
            // TODO: GET THIS OUT OF HERE!
            TAKLogger.debug("***SENSITIVE INFO FOLLOWS***")
            TAKLogger.debug(swiftCryptoKey.pemRepresentation)

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
