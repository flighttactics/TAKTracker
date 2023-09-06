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

enum CSREnrollmentStatus {
    case NotStarted
    case Connecting
    case Enrolling
    case Failed
    case Succeeded
}

struct Order: Codable {
    let customerId: String
    let items: [String]
}

class CSRRequestor: NSObject, ObservableObject, URLSessionDelegate {
    @Published var enrollmentStatus: CSREnrollmentStatus = CSREnrollmentStatus.NotStarted;

    var derEncodedCertificate: [UInt8] = []
    var derEncodedPrivateKey: Data = Data()
    
    var host = "https://tak.flighttactics.com"
    var csrPort = "8446"
    var tlsConfigPath = "/Marti/api/tls/config"
    var csrRequestPath = "/Marti/api/tls/signClient/v2?clientUid=A12345&version=v1.0.13-iTAKTracker"

    //This is used for adding basic auth to the request
    var username = "foyc"
    var password = "iTakKill3rComing!"
    
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
        
        generateSelfSignedCertificate(commonName: "foyc", hostName: "tak.flighttactics.com")
        let rawCertData = Data(derEncodedCertificate)
        let certData = rawCertData.base64EncodedString()
        TAKLogger.debug("certData as Data")
        TAKLogger.debug(String(describing: certData));
        
        request.httpBody = rawCertData.base64EncodedData()
        
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
                    var received: [UInt8] = Array(data!)
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
    
    func generateSelfSignedCertificate(commonName: String, hostName: String) {
        do {
            let swiftCryptoKey = try _RSA.Signing.PrivateKey(keySize: .bits2048)
            let key = Certificate.PrivateKey(swiftCryptoKey)

            let subjectName = try DistinguishedName {
                CommonName(commonName)
                OrganizationName("FLIGHTTACTICS")
                OrganizationalUnitName("TAK")
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
            derEncodedPrivateKey = swiftCryptoKey.derRepresentation
        } catch let error as NSError {
            TAKLogger.error("[CSRRequestor] Could not create the CSR")
            TAKLogger.error(error.debugDescription)
        }
    }
}
