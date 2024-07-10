//
//  TAKDataPackageParser.swift
//  TAKTracker
//
//  Created by Cory Foy on 7/25/23.
//

import Foundation
import NIOSSL
import SwiftTAK

class TAKDataPackageParser: NSObject {
    var archiveLocation: URL
    var parsingErrors: [String] = []
    
    init (fileLocation: URL) {
        TAKLogger.debug("[TAKDataPackageParser]: Initializing")
        archiveLocation = fileLocation
        super.init()
    }
    
    func parse() {
        let parser = DataPackageParser(fileLocation: archiveLocation)
        parser.parse()
        let contents = parser.packageContents
        storeUserCertificate(packageContents: contents)
        storeServerCertificate(packageContents: contents)
        storePreferences(packageContents: contents)
        TAKLogger.debug("[TAKDataPackageParser]: Completed Parsing")
    }
    
    func storeUserCertificate(packageContents: DataPackageContents) {
        TAKLogger.debug("[TAKDataPackageParser]: Storing User Certificate")
        
        DispatchQueue.global(qos: .background).async {
            //Parse the cert file
            let parsedCert = PKCS12(data: packageContents.userCertificate, password: packageContents.userCertificatePassword)
            
            guard let identity = parsedCert.identity else {
                self.parsingErrors.append("No User Certificate found")
                TAKLogger.error("[TAKDataPackageParser]: Identity was not present in the parsed cert")
                return
            }
            
            SettingsStore.global.storeIdentity(identity: identity, label: packageContents.serverURL)
            
            TAKLogger.debug("[TAKDataPackageParser]: User Certificate Stored")
        }
    }
    
    func storeServerCertificate(packageContents: DataPackageContents) {
        TAKLogger.debug("[TAKDataPackageParser]: Storing Server Certificate")
        
        let serverCerts = packageContents.serverCertificates
        var serverCertChain: [Data] = []
        
        guard !serverCerts.isEmpty else {
            parsingErrors.append("No Server truststore certificate was found in the data package")
            SettingsStore.global.serverCertificateTruststore = serverCertChain
            return
        }
        
        do {
            try serverCerts.forEach { serverCert in
                let p12Bundle = try NIOSSLPKCS12Bundle(buffer: Array(serverCert.certificateData), passphrase: Array(serverCert.certificatePassword.utf8))
                try p12Bundle.certificateChain.forEach { cert in
                    try serverCertChain.append(Data(cert.toDERBytes()))
                }
            }
        } catch {
            parsingErrors.append("Could not process server certificates \(error)")
            TAKLogger.error("[TAKDataPackageParser]: Unable to store Server Certificate from Data Package: \(error)")
        }
        
        if(serverCertChain.isEmpty) {
            parsingErrors.append("No Server truststore certificate was found in the data package")
        }
        
        TAKLogger.debug("[TAKDataPackageParser]: Storing cert chain with \(serverCertChain.count) cert(s)")
        SettingsStore.global.serverCertificateTruststore = serverCertChain
    }
    
    func storePreferences(packageContents: DataPackageContents) {        
        SettingsStore.global.takServerUrl = packageContents.serverURL
        SettingsStore.global.takServerPort = packageContents.serverPort
        SettingsStore.global.takServerProtocol = packageContents.serverProtocol
        SettingsStore.global.takServerChanged = true
    }

}
