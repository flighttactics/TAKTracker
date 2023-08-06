//
//  TAKDataPackageParser.swift
//  TAKTracker
//
//  Created by Cory Foy on 7/25/23.
//

import UIKit
import ZIPFoundation

class TAKDataPackageParser: NSObject {
    
    let MANIFEST_FILE = "manifest.xml"
    var dataPackageContents: [String] = []
    
    var archiveLocation: URL?
    
    init (fileLocation:URL) {
        TAKLogger.debug("Initializing TAKDPP")
        archiveLocation = fileLocation
        super.init()
    }
    
    func parse() {
        processArchive()
    }
    
    private
    func processArchive() {
        TAKLogger.debug("Entering processArchive")
        guard let sourceURL = archiveLocation
        else {
            TAKLogger.error("Unable to access sourceURL variable \(String(describing: archiveLocation))")
            return
        }

        guard let archive = Archive(url: sourceURL, accessMode: .read)
        else {
            TAKLogger.error("Unable to access archive at location \(String(describing: archiveLocation))")
            return
        }
        
        TAKLogger.debug("Files in archive")
        dataPackageContents = archive.map { entry in
            return entry.path
        }
        TAKLogger.debug(String(describing: dataPackageContents))
        
        let prefsFile = retrievePrefsFile(archive: archive)
        let prefs = parsePrefsFile(archive: archive, prefsFile: prefsFile)
        storeUserCertificate(archive: archive, fileName: prefs.userCertificateFileName())
        storeServerCertificate(archive: archive, fileName: prefs.serverCertificateFileName())
        storePreferences(preferences: prefs)
        TAKLogger.debug("processArchive Complete")
    }
    
    func storeUserCertificate(archive: Archive, fileName: String) {
        guard let certFile = archive[fileName]
        else { TAKLogger.debug("userCertificate \(fileName) not found in archive"); return }

        var certData = Data()
        _ = try? archive.extract(certFile) { data in
            certData.append(data)
        }
        SettingsStore.global.userCertificate = certData
    }
    
    func storeServerCertificate(archive: Archive, fileName: String) {
        guard let certFile = archive[fileName]
        else { TAKLogger.debug("serverCertificate \(fileName) not found in archive"); return }

        var certData = Data()
        _ = try? archive.extract(certFile) { data in
            certData.append(data)
        }
        SettingsStore.global.serverCertificate = certData
    }
    
    func storePreferences(preferences: TAKPreferences) {
        SettingsStore.global.userCertificatePassword = preferences.userCertificatePassword
        SettingsStore.global.serverCertificatePassword = preferences.serverCertificatePassword
        
        SettingsStore.global.takServerUrl = preferences.serverConnectionAddress()
        SettingsStore.global.takServerPort = preferences.serverConnectionPort()
        SettingsStore.global.takServerProtocol = preferences.serverConnectionProtocol()
        SettingsStore.global.takServerChanged = true
    }
    
    func parsePrefsFile(archive:Archive, prefsFile: String) -> TAKPreferences {
        let prefsParser = TAKPreferencesParser()
        
        guard let prefFile = archive[prefsFile]
        else { TAKLogger.debug("prefFile not in archive"); return prefsParser.preferences }

        var prefData = Data()
        _ = try? archive.extract(prefFile) { data in
            prefData.append(data)
        }
        let xmlParser = XMLParser(data: prefData)
        TAKLogger.debug(String(describing: xmlParser))
        xmlParser.delegate = prefsParser
        xmlParser.parse()
        return prefsParser.preferences
    }
    
    func retrievePrefsFile(archive:Archive) -> String {
        var prefsFile = ""
        
        if let prefFileLocation = dataPackageContents.first(where: {
            $0.hasSuffix(".pref")
        }) {
            prefsFile = prefFileLocation
        } else {
            guard let takManifest = archive["manifest.xml"]
            else { return prefsFile }

            var manifestData = Data()
            _ = try? archive.extract(takManifest) { data in
                manifestData.append(data)
            }
            let xmlParser = XMLParser(data: manifestData)
            let manifestParser = TAKManifestParser()
            xmlParser.delegate = manifestParser
            xmlParser.parse()
            TAKLogger.debug("Prefs file: \(manifestParser.prefsFile())")
            prefsFile = manifestParser.prefsFile()
        }
        return prefsFile
    }

}
