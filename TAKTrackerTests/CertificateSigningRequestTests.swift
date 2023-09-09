//
//  CertificateSigningRequestTests.swift
//  TAKTrackerTests
//
//  Created by Cory Foy on 9/5/23.
//

import Crypto
import _CryptoExtras
import Foundation
import SwiftASN1
import X509
import XCTest

final class CertificateSigningRequestTests: XCTestCase {
    
    var certString = ""

    override func setUpWithError() throws {
        certString = """
-----BEGIN CERTIFICATE-----
MIIDUzCCAjugAwIBAgIEWTNX9jANBgkqhkiG9w0BAQsFADBuMQswCQYDVQQGEwJV
UzELMAkGA1UECBMCTkMxFTATBgNVBAcTDEhJTExTQk9ST1VHSDEWMBQGA1UEChMN
RkxJR0hUVEFDVElDUzEMMAoGA1UECxMDVEFLMRUwEwYDVQQDEwxpbnRlcm1lZGlh
dGUwHhcNMjMwOTA2MDcxMzU0WhcNMjMxMDA2MTkxMzU0WjA1MQ0wCwYDVQQDEwRm
b3ljMRYwFAYDVQQKEw1GTElHSFRUQUNUSUNTMQwwCgYDVQQLEwNUQUswggEiMA0G
CSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCy/VHy4Cb5HJw48SaCGT+9I7uPYP7I
u+HVPn154dZhtC8WLgW1F4TSpqWTq7fWFLnj6GBxvvP1rM4OQZaTc1DQ27nwF3ex
lDPikCQ0BID10tHoqJD6NxZghxWNpRU9ufSm1/JDGK4b+SsZUFGYB3Y1Fc/b/CAz
+a2o/OvE3iSCcKO1Dm2kW3MRc/BFysb4ogYRAW/He4fk9Vje8YgoMO2g/hjrjtyq
EILgZPDSKs4g2620Uo3SH15yFohyEb9SaJSVZNtsYEZP6ECFiHVX4ygbdESW5yFx
NB4VtSpAB7zQaSwCB84BRwU4yLZMZNJbxlLNWmTMIqogNItCT8KYCsOLAgMBAAGj
MjAwMB4GA1UdJQQXMBUGCCsGAQUFBwMCBgkqhkiG9w0BCQcwDgYDVR0PAQH/BAQD
AgPIMA0GCSqGSIb3DQEBCwUAA4IBAQA3ihAndhQHGZT4dODhalHLHhFGT7cOlSLW
CwRFzPRswYPRvVAXie6ufKGtq/S7Ij5pXnxSrDd5L3dXF7MtbPN5P1JBchLsaK8f
BYgxjynZg4FvUXc6jM+vtrP5poRnkjl6wRI025GThxjDggETac4CesJgcdvoVUyX
XyAOmpGe9LViRpzvWXANC8JdSliukpx3MMx72u91zZj8qlF6sCy4CgILET8Ysxg8
Khny092FgIWBhCeVfu8Q5uxf69MmHUUrcF9UfCZGC1cCFdl0hEJdBPRhT7Ddszfm
lZZhcZub16BnXMT2G7m81f6XujMskrnPg3gLnLDDNlOz6gdUf70B
-----END CERTIFICATE-----
"""
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testEnsureCertStorageMatches() throws {
        let bundle = Bundle(for: Self.self)
        let testZip = bundle.url(forResource: TestConstants.ITAK_DATA_PACKAGE_NAME, withExtension: "zip")
        let dpp = TAKDataPackageParser.init(fileLocation: testZip!)
        dpp.parse()
        let str = String(decoding: SettingsStore.global.userCertificate, as: UTF8.self)
        let parsedCert = PKCS12(data: SettingsStore.global.userCertificate, password: "atakatak")
        XCTAssertEqual(parsedCert.label, certString)
    }

    func testParseCertificate() throws {
        let parsedCert = try Certificate(pemEncoded: certString)
        NSLog(String(describing: parsedCert))
        
        let pem = try parsedCert.serializeAsPEM()
        let pemData = Data(pem.derBytes)
        var serializer = DER.Serializer()
        try serializer.serialize(parsedCert)
        let derData = Data(serializer.serializedBytes)
        
        guard let certificateRef = SecCertificateCreateWithData(kCFAllocatorDefault, derData as CFData) else {
                TAKLogger.error("Could not create certificate, data was not valid DER encoded X509 cert")
                XCTAssert(false, "Keychain failed")
                return
                //throw KeychainError.invalidX509Data
            }
        
        TAKLogger.debug("CertificateRef: \(String(describing: certificateRef))")
        
        var identity: SecIdentity
        let certs: NSArray = [certificateRef]
        //let status = SecIdentityCreateWithCertificate(nil, certificateRef, &identity)
        //guard status == errSecSuccess else { TAKLogger.error("Could not create SecIdentity") }
        sec_identity_create_with_certificates(identity, certs)
        
//        let pkcs = PKCS12(data: certificateRef, password: "")
//        NSLog(String(describing: pkcs))
        
        XCTAssert(parsedCert.issuer.description != "", "parsedCert Issuer Empty")
    }
}
