//
//  QRCodeParser.swift
//  TAKTracker
//
//  Created by Cory Foy on 7/18/24.
//

import Foundation

struct CertificateEnrollmentParameters: Equatable {
    var hostName: String = ""
    var serverURL: String = ""
    var serverPort: String = ""
    var active: String = ""
    var username: String = ""
    var password: String = ""
    
    var shouldAutoSubmit: Bool = false
    var wasInvalidString: Bool = false
    
    public static func == (lhs: CertificateEnrollmentParameters, rhs: CertificateEnrollmentParameters) -> Bool {
        return lhs.hostName == rhs.hostName &&
        lhs.serverURL == rhs.serverURL &&
        lhs.serverPort == rhs.serverPort &&
        lhs.active == rhs.active &&
        lhs.username == rhs.username &&
        lhs.password == rhs.password
    }
}

class QRCodeParser {
    var originalString: String
    
    static func parse(_ scannedString: String) -> CertificateEnrollmentParameters {
        let parser = QRCodeParser(scannedString: scannedString)
        return parser.parse()
    }
    
    private init(scannedString: String) {
        originalString = scannedString.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func parse() -> CertificateEnrollmentParameters {
        guard originalString.count > 0 else {
            return CertificateEnrollmentParameters(wasInvalidString: true)
        }
        
        // Parsing Strategy determination
        if(originalString.split(separator: ",").count == 4) {
            return parseAsITAKQRCode()
        } else if(originalString.starts(with: "{")) {
            return parseAsATAKRegistrationQRCode()
        }

        return CertificateEnrollmentParameters(wasInvalidString: true)
    }
    
    // iTAK QR Codes are of the form "serverName,serverURL,serverPort,serverProtocol"
    func parseAsITAKQRCode() -> CertificateEnrollmentParameters {
        let codeParts = originalString.split(separator: ",")
        guard codeParts.count == 4 else {
            return CertificateEnrollmentParameters(wasInvalidString: true)
        }

        let serverName = codeParts[0]
        let serverURL = codeParts[1]
        let serverPort = codeParts[2]
        let serverProtocol = codeParts[3]
        TAKLogger.debug("[ConnectionOptions]: QR Code complete! \(serverName) at \(serverURL):\(serverPort) (\(serverProtocol))")
        
        guard let _ = URL(string: String(serverURL)), let _ = Int(serverPort) else {
            return CertificateEnrollmentParameters(wasInvalidString: true)
        }
        
        return CertificateEnrollmentParameters(
            hostName: String(serverName),
            serverURL: String(serverURL),
            serverPort: String(serverPort)
        )
    }
    
    // ATAK QR Codes are json with complete cert enrollment information
    func parseAsATAKRegistrationQRCode() -> CertificateEnrollmentParameters {
        guard let json = try? JSONSerialization.jsonObject(with: Data(originalString.utf8), options: []) as? [String: Any] else {
            print("***Unable to parse JSON")
            return CertificateEnrollmentParameters(wasInvalidString: true)
        }
        
        guard let serverCreds = json["serverCredentials"] as? [String: String] else {
            print("***Unable to parse serverCredentials")
            return CertificateEnrollmentParameters(wasInvalidString: true)
        }
        
        guard let connectionString = serverCreds["connectionString"] else {
            print("***Unable to parse connectionString")
            return CertificateEnrollmentParameters(wasInvalidString: true)
        }
        
        let connectionStringParts = connectionString.split(separator: ":")
        let serverURL = String(connectionStringParts[0])
        let serverPort = String(connectionStringParts[1])
        
        guard let _ = URL(string: String(serverURL)), let _ = Int(serverPort) else {
            return CertificateEnrollmentParameters(wasInvalidString: true)
        }
        
        var response = CertificateEnrollmentParameters(serverURL: serverURL, serverPort: serverPort)
        
        guard let userCreds = json["userCredentials"] as? [String: String] else {
            print("***Unable to parse userCredentials")
            return response
        }
        
        response.username = userCreds["username"] ?? ""
        response.password = userCreds["password"] ?? ""
        
        if(!response.username.isEmpty && !response.password.isEmpty) {
            response.shouldAutoSubmit = true
        }
        
        return response
    }
}
