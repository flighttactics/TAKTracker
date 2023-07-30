//
//  TAKDataPackageParser.swift
//  TAKTracker
//
//  Created by Cory Foy on 7/25/23.
//

import UIKit
import ZIPFoundation

class TAKDataPackageParser: NSObject {
    var archiveLocation: URL?
    
    init (fileLocation:URL) {
        archiveLocation = fileLocation
        super.init()
    }
    
    func parse() {
        processArchive()
    }
    
    private
    func processArchive() {
        guard let sourceURL = archiveLocation,
            let archive = Archive(url: sourceURL, accessMode: .read)
        else { return }
        
        let prefsFile = retrievePrefsFile(archive: archive)
        let prefs = parsePrefsFile(archive: archive, prefsFile: prefsFile)
        storeUserCertificate(archive: archive, fileName: prefs.userCertificateFileName())
        storeServerCertificate(archive: archive, fileName: prefs.serverCertificateFileName())
        storePreferences(preferences: prefs)
        
    }
    
    func storeUserCertificate(archive: Archive, fileName: String) {
        guard let certFile = archive[fileName]
        else { TAKLogger.debug("userCertificate \(fileName) not found in archive"); return }

        _ = try? archive.extract(certFile) { data in
            SettingsStore.global.userCertificate = data
        }
    }
    
    func storeServerCertificate(archive: Archive, fileName: String) {
        guard let certFile = archive[fileName]
        else { TAKLogger.debug("serverCertificate \(fileName) not found in archive"); return }

        _ = try? archive.extract(certFile) { data in
            SettingsStore.global.serverCertificate = data
        }
    }
    
    func storePreferences(preferences: TAKPreferences) {
        SettingsStore.global.userCertificatePassword = preferences.userCertificatePassword
        SettingsStore.global.serverCertificatePassword = preferences.serverCertificatePassword
        
        SettingsStore.global.takServerUrl = preferences.serverConnectionAddress()
        SettingsStore.global.takServerPort = preferences.serverConnectionPort()
        SettingsStore.global.takServerProtocol = preferences.serverConnectionProtocol()
        SettingsStore.global.shouldTryReconnect = true
    }
    
    func parsePrefsFile(archive:Archive, prefsFile: String) -> TAKPreferences {
        let prefsParser = TAKPreferencesParser()
        
        guard let prefFile = archive[prefsFile]
        else { TAKLogger.debug("prefFile not in archive"); return prefsParser.preferences }

        _ = try? archive.extract(prefFile) { data in
            let xmlParser = XMLParser(data: data)
            TAKLogger.debug(String(describing: xmlParser))
            xmlParser.delegate = prefsParser
            xmlParser.parse()
        }
        return prefsParser.preferences
    }
    
    func retrievePrefsFile(archive:Archive) -> String {
        var prefsFile = ""
        
        guard let takManifest = archive["manifest.xml"]
        else { return prefsFile }

        _ = try? archive.extract(takManifest) { data in
            let xmlParser = XMLParser(data: data)
            let manifestParser = TAKManifestParser()
            xmlParser.delegate = manifestParser
            xmlParser.parse()
            TAKLogger.debug("Prefs file: \(manifestParser.prefsFile())")
            prefsFile = manifestParser.prefsFile()
        }
        return prefsFile
    }

}
