//
//  DataPackageParserTests.swift
//  TAKTrackerTests
//
//  Created by Cory Foy on 9/12/23.
//

import SwiftTAK
import XCTest
import ZIPFoundation

final class DataPackageParserTests: XCTestCase {
    var parser:TAKDataPackageParser? = nil
    var archiveURL:URL? = nil

    override func setUpWithError() throws {
        let bundle = Bundle(for: Self.self)
        archiveURL = bundle.url(forResource: TestConstants.ITAK_DATA_PACKAGE_NAME, withExtension: "zip")
        parser = TAKDataPackageParser.init(fileLocation: archiveURL!)
        
        let cleanUpQuery: [String: Any] = [kSecClass as String:  kSecClassIdentity,
                                           kSecAttrLabel as String: TestConstants.TEST_HOST]
        SecItemDelete(cleanUpQuery as CFDictionary)
    }
    
    func testCertParserStoresIdentityInKeychain() throws {
        let bundle = Bundle(for: Self.self)
        guard let certificateURL = bundle.url(forResource: TestConstants.USER_CERTIFICATE_NAME, withExtension: TestConstants.CERTIFICATE_FILE_EXTENSION) else {
            throw XCTestError(.failureWhileWaiting, userInfo: ["FileError": "Could not open test user certificate"])
        }
        
        let certData = try Data(contentsOf: certificateURL)
        
        var contents = DataPackageContents()
        contents.userCertificate = certData
        contents.userCertificatePassword = TestConstants.DEFAULT_CERT_PASSWORD
        contents.serverURL = TestConstants.TEST_HOST
        
        parser!.storeUserCertificate(packageContents: contents)
        
        let getquery: [String: Any] = [kSecClass as String:  kSecClassIdentity,
                                       kSecAttrLabel as String: TestConstants.TEST_HOST,
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
