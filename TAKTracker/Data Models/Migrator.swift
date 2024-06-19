//
//  Migrator.swift
//  TAKTracker
//
//  Created by Cory Foy on 6/10/24.
//

import Foundation
import NIOSSL

struct MigrationStatus {
    var name: String
    var version: ReleasedAppVersions
    var migrationSucceeded = false
    var migrationErrors: [String] = []
}

enum ReleasedAppVersions : String, CustomStringConvertible, CaseIterable {
    case v10 = "1.0"
    case v11 = "1.1"
    case v12 = "1.2"
    case v13 = "1.3"
    
    public var description: String {
        return self.rawValue
    }
}

class Migrator: ObservableObject {
    static let RELEASED_VERSIONS = ReleasedAppVersions.allCases
    
    
    static func currentReleasedVersion() -> ReleasedAppVersions {
        guard let appVersion = ReleasedAppVersions(rawValue: AppConstants.getAppReleaseVersion()) else {
            TAKLogger.error("UNCONFIGURED APP VERSION FOUND")
            return ReleasedAppVersions.v13
        }
        return appVersion
    }
    
    var status: [MigrationStatus] = []
    
    var migrationSucceeded: Bool {
        get {
            return !status.contains(where: { $0.migrationSucceeded == false })
        }
    }
    
    func migrate(from: String) {
        TAKLogger.debug("[Migrator]: Attempting to migrate from \(from)")
        
        var version = ReleasedAppVersions(rawValue: from)
        
        if(version == nil) {
            // 1.3 is when we started establishing app version last run storage
            version = ReleasedAppVersions.v12
        }
        
        switch version! {
        case ReleasedAppVersions.v10, ReleasedAppVersions.v11, ReleasedAppVersions.v12:
            migrateServerCertificateToTrust()
        case ReleasedAppVersions.v13:
            TAKLogger.debug("[Migrator]: No migrations needed")
            return
        }
    }
    
    func migrateServerCertificateToTrust() {
        TAKLogger.debug("[Migrator]: Attempting to migrate Server Cert to Trust")
        var migrationStatus = MigrationStatus(name: "Server Certificate Into Trust", version: Migrator.currentReleasedVersion())

        let settingsStore = SettingsStore.global
        
        guard settingsStore.serverCertificateTruststore.isEmpty else {
            migrationStatus.migrationSucceeded = true
            TAKLogger.debug("[Migrator] Truststore setting was already set, so ignoring migration")
            status.append(migrationStatus)
            return
        }
        
        let certData = settingsStore.serverCertificate
        
        var certPW = settingsStore.serverCertificatePassword
        
        if(certPW.isEmpty) {
            // v1.0-v1.2 did not store the server Cert password, but did store
            // the user cert password. Generally these would be the same
            certPW = settingsStore.userCertificatePassword
        }
        
        if(certPW.isEmpty) {
            // It's still empty so fall back to the standard TAK default
            certPW = "atakatak"
        }
        
        guard !certData.isEmpty else {
            migrationStatus.migrationSucceeded = false
            migrationStatus.migrationErrors.append("No server certificate to migrate")
            status.append(migrationStatus)
            return
        }
        
        do {
            let p12Bundle = try NIOSSLPKCS12Bundle(buffer: Array(certData), passphrase: Array(certPW.utf8))
            var certChain: [Data] = []
            try p12Bundle.certificateChain.forEach { cert in
                try certChain.append(Data(cert.toDERBytes()))
            }
            settingsStore.serverCertificateTruststore = certChain
            migrationStatus.migrationSucceeded = true
        } catch {
            TAKLogger.error("[Migrator]: Fatal error attempting to migrate cert \(error)")
            migrationStatus.migrationSucceeded = false
            migrationStatus.migrationErrors.append("Could not migrate server certificate")
        }
        status.append(migrationStatus)
    }
}
