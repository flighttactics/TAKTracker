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
    private let settingsStore = SettingsStore()
    
    init (fileLocation:URL) {
        super.init()
        archiveLocation = fileLocation
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
        else { NSLog("userCertificate \(fileName) not found in archive"); return }

        _ = try? archive.extract(certFile) { data in
            settingsStore.userCertificate = data
        }
    }
    
    func storeServerCertificate(archive: Archive, fileName: String) {
        guard let certFile = archive[fileName]
        else { NSLog("serverCertificate \(fileName) not found in archive"); return }

        _ = try? archive.extract(certFile) { data in
            settingsStore.serverCertificate = data
        }
    }
    
    func storePreferences(preferences: TAKPreferences) {
        settingsStore.userCertificatePassword = preferences.userCertificatePassword
        settingsStore.serverCertificatePassword = preferences.serverCertificatePassword
        
        settingsStore.takServerUrl = preferences.serverConnectionAddress()
        settingsStore.takServerPort = preferences.serverConnectionPort()
        settingsStore.takServerProtocol = preferences.serverConnectionProtocol()
    }
    
    func parsePrefsFile(archive:Archive, prefsFile: String) -> TAKPreferences {
        let prefsParser = TAKPreferencesParser()
        
        guard let prefFile = archive[prefsFile]
        else { NSLog("prefFile not in archive"); return prefsParser.preferences }

        _ = try? archive.extract(prefFile) { data in
            let xmlParser = XMLParser(data: data)
            NSLog(String(describing: xmlParser))
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
            NSLog("Prefs file: \(manifestParser.prefsFile())")
            prefsFile = manifestParser.prefsFile()
        }
        return prefsFile
    }

}
