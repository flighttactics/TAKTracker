//
//  TAKDataPackageParser.swift
//  TAKTracker
//
//  Created by Cory Foy on 7/25/23.
//

import Foundation
import SwiftTAK

class TAKDataPackageParser: NSObject {
    var archiveLocation: URL
    
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
        
        //Parse the cert file
        let parsedCert = PKCS12(data: packageContents.userCertificate, password: packageContents.userCertificatePassword)
        
        guard let identity = parsedCert.identity else {
            TAKLogger.error("[TAKDataPackageParser]: Identity was not present in the parsed cert")
            return
        }
        
        SettingsStore.global.storeIdentity(identity: identity, label: packageContents.serverURL)
        
        TAKLogger.debug("[TAKDataPackageParser]: User Certificate Stored")
    }
    
    func storeServerCertificate(packageContents: DataPackageContents) {
        SettingsStore.global.serverCertificate = packageContents.serverCertificate
    }
    
    func storePreferences(packageContents: DataPackageContents) {        
        SettingsStore.global.takServerUrl = packageContents.serverURL
        SettingsStore.global.takServerPort = packageContents.serverPort
        SettingsStore.global.takServerProtocol = packageContents.serverProtocol
        SettingsStore.global.takServerChanged = true
    }

}
