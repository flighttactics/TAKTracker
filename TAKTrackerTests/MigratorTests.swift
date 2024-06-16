//
//  MigratorTests.swift
//  TAKTracker
//
//  Created by Cory Foy on 6/10/24.
//

import Foundation
import NIOSSL
import SwiftTAK
import XCTest

final class MigratorTests: TAKTrackerTestCase {
    let migrator = Migrator()
    var certData: Data? = nil
    var expectedCertChain: [Data] = []
    
    override func setUpWithError() throws {
        let bundle = Bundle(for: Self.self)
        SettingsStore.global.serverCertificateTruststore = []
        expectedCertChain = []
        
        guard let certificateURL = bundle.url(forResource: TestConstants.SERVER_CERTIFICATE_NAME, withExtension: TestConstants.CERTIFICATE_FILE_EXTENSION) else {
            throw XCTestError(.failureWhileWaiting, userInfo: ["FileError": "Could not open test server certificate"])
        }
        
        certData = try Data(contentsOf: certificateURL)
        let p12Bundle = try NIOSSLPKCS12Bundle(buffer: Array(certData!), passphrase: Array(TestConstants.DEFAULT_CERT_PASSWORD.utf8))
        try p12Bundle.certificateChain.forEach { cert in
            try expectedCertChain.append(Data(cert.toDERBytes()))
        }
    }
    
    func testMigrationConsideredSuccessfulIfNoMigrationsNeeded() throws {
        XCTAssertTrue(migrator.migrationSucceeded)
    }
    
    func testMigrateServerCertToTruststoreArray() throws {
        // This is the logic from v1.0 - v1.2 when processing a data package
        // Note it also did not store the server cert password
        // (But we did store the User Cert Password, so we'll have to assume they're the same)
        SettingsStore.global.serverCertificate = certData!
        SettingsStore.global.userCertificatePassword = TestConstants.DEFAULT_CERT_PASSWORD
        migrator.migrateServerCertificateToTrust()

        XCTAssertEqual(expectedCertChain, SettingsStore.global.serverCertificateTruststore)
    }
    
    func testMigrateServerCertToTruststoreArrayShowsSuccessfulProcessing() throws {
        SettingsStore.global.serverCertificate = certData!
        SettingsStore.global.userCertificatePassword = TestConstants.DEFAULT_CERT_PASSWORD
        migrator.migrateServerCertificateToTrust()

        XCTAssertTrue(migrator.status.first!.migrationSucceeded)
    }
    
    func testOverallStatusShowsSuccessfulProcessing() throws {
        SettingsStore.global.serverCertificate = certData!
        SettingsStore.global.userCertificatePassword = TestConstants.DEFAULT_CERT_PASSWORD
        migrator.migrateServerCertificateToTrust()

        XCTAssertTrue(migrator.migrationSucceeded)
    }
    
    func testMigrationPopulatesAMigrationStatus() throws {
        migrator.migrate(from: ReleasedAppVersions.v12.rawValue)
        XCTAssertTrue(migrator.status.count > 0)
    }
    
    func testMigrationStopsIfTrustoreAlreadyEstablished() throws {
        SettingsStore.global.serverCertificateTruststore = expectedCertChain
        migrator.migrateServerCertificateToTrust()
        let migrationStatus = migrator.status.first!
        XCTAssertFalse(migrationStatus.migrationSucceeded)
        XCTAssertEqual(migrationStatus.migrationErrors.first, "Truststore already existed so not overwriting")
    }
    
    func testOverallStatusShowsOverallFailureWhenErrorDuringProcessing() throws {
        SettingsStore.global.serverCertificateTruststore = expectedCertChain
        migrator.migrateServerCertificateToTrust()
        migrator.migrateServerCertificateToTrust()

        XCTAssertFalse(migrator.migrationSucceeded)
    }
    
    func testMigrationStopsIfNoCertToParse() throws {
        SettingsStore.global.serverCertificate = Data()
        migrator.migrateServerCertificateToTrust()
        let migrationStatus = migrator.status.first!
        XCTAssertFalse(migrationStatus.migrationSucceeded)
        XCTAssertEqual(migrationStatus.migrationErrors.first, "No server certificate to migrate")
    }
    
    func testMigrationStopsIfInvalidOrNoPassword() throws {
        SettingsStore.global.serverCertificate = certData!
        SettingsStore.global.userCertificatePassword = "WRONG234"
        migrator.migrateServerCertificateToTrust()
        let migrationStatus = migrator.status.first!
        XCTAssertFalse(migrationStatus.migrationSucceeded)
        XCTAssertEqual(migrationStatus.migrationErrors.first, "Could not migrate server certificate")
    }
}
