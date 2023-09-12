//
//  DataPackageParserTests.swift
//  TAKTrackerTests
//
//  Created by Cory Foy on 9/12/23.
//

import XCTest
import ZIPFoundation

final class DataPackageParserTests: XCTestCase {
    
    let defaultPassword = "atakatak"
    let userCertFileName = "foyc.p12"
    let host = "tak.flighttactics.com"
    
    var parser:TAKDataPackageParser? = nil
    var archiveURL:URL? = nil

    override func setUpWithError() throws {
        let bundle = Bundle(for: Self.self)
        archiveURL = bundle.url(forResource: TestConstants.ITAK_DATA_PACKAGE_NAME, withExtension: "zip")
        parser = TAKDataPackageParser.init(fileLocation: archiveURL!)
        
        let cleanUpQuery: [String: Any] = [kSecClass as String:  kSecClassIdentity,
                                       kSecAttrLabel as String: host]
        SecItemDelete(cleanUpQuery as CFDictionary)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCertParserFindsIdentity() throws {
        parser!.parse()
        let parsedCert = PKCS12(data: SettingsStore.global.userCertificate, password: defaultPassword)
        XCTAssertNotNil(parsedCert.identity, "No identity found when parsing data package")
    }
    
    func testCertParserStoresIdentityInKeychain() throws {
        var prefs = TAKPreferences()
        prefs.userCertificateFile = userCertFileName
        prefs.userCertificatePassword = defaultPassword
        prefs.serverConnectionString = "\(host):8080"
        
        guard let archive = Archive(url: archiveURL!, accessMode: .read) else {
            throw XCTestError(.failureWhileWaiting, userInfo: ["ArchiveError": "Could not open archive"])
        }
        parser!.storeUserCertificate(archive: archive, prefs: prefs)
        
        let getquery: [String: Any] = [kSecClass as String:  kSecClassIdentity,
                                       kSecAttrLabel as String: host,
                                       kSecReturnRef as String: kCFBooleanTrue!]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(getquery as CFDictionary, &item)
        guard status == errSecSuccess else {
            XCTFail("Identity was not stored in the keychain \(String(describing: status))")
            return
        }
        let identity = item as! SecIdentity

        XCTAssertNotNil(identity, "Identity was not stored in the Keychain")

    }

}
