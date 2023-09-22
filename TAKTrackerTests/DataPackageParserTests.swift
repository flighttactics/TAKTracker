//
//  DataPackageParserTests.swift
//  TAKTrackerTests
//
//  Created by Cory Foy on 9/12/23.
//

import Crypto
import _CryptoExtras
import Foundation
import SwiftASN1
import SwiftTAK
import X509
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
    
    func testRetrievingTrustStore() throws {
        let bundle = Bundle(for: Self.self)
        guard let certificateURL = bundle.url(forResource: TestConstants.USER_CERTIFICATE_NAME, withExtension: TestConstants.CERTIFICATE_FILE_EXTENSION) else {
            throw XCTestError(.failureWhileWaiting, userInfo: ["FileError": "Could not open test server certificate"])
        }
        
        let certData = try Data(contentsOf: certificateURL)
        let parsedCert = PKCS12(data: certData, password: "atakatak")
        let certArray = [ parsedCert ]
        let policy = SecPolicyCreateBasicX509()
        var optionalTrust: SecTrust?
        let status = SecTrustCreateWithCertificates(certArray as AnyObject,
                                                    policy,
                                                    &optionalTrust)
        guard status == errSecSuccess else { TAKLogger.error("Failed! \(status)"); return }
        let trust = optionalTrust!    // Safe to force unwrap now
        TAKLogger.debug("Made it here!")

//        TAKLogger.debug("Cert: " + String(describing: parsedCert))
//        TAKLogger.debug("Trust: " + String(describing: parsedCert.trust))
//        TAKLogger.debug("Cert Chain Count: " + String(describing: parsedCert.certChain?.count))
//        let parsedCert = try Certificate(derEncoded: certData)
//
//        var serializer = DER.Serializer()
//        try serializer.serialize(parsedCert)
//        let derData = Data(serializer.serializedBytes)
//
//        try CertificateManager.addIdentity(clientCertificate: derData, label: hostName)
//        XCTAssertNotNil(CertificateManager.getIdentity(label: hostName), "Identity not found for hostName \(hostName)")
//        XCTAssertNotNil(SettingsStore.global.retrieveIdentity(label: hostName), "Identity not found in SettingsStore for \(hostName)")
        
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
