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
import TAKTracker

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

    func testParseCertificate() throws {
        var received: [UInt8] = Array(Data(certString.utf8).base64EncodedData())
        
        //let parsedCert = PKCS12(data: Data(certString.utf8).base64EncodedData(), password: "atakatak")
        let parsedCert = try Certificate(pemEncoded: certString)
        NSLog(String(describing: parsedCert))
        
        XCTAssert(parsedCert.issuer.description != "", "parsedCert Issuer Empty")
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
}
