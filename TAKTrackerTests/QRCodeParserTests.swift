//
//  QRCodeParserTests.swift
//  TAKTrackerTests
//
//  Created by Cory Foy on 7/18/24.
//

import Foundation
import XCTest

class QRCodeParserTests: TAKTrackerTestCase {
    func testParsingValidiTAKReturnsProperData() throws {
        let expected = CertificateEnrollmentParameters(hostName: "Test Server", serverURL: "test.example.com", serverPort: "8089", username: "", password: "", shouldAutoSubmit: false, wasInvalidString: false)
        let iTAKString = "Test Server,test.example.com,8089,ssl"
        let actual = QRCodeParser.parse(iTAKString)
        XCTAssertEqual(expected, actual)
    }
    
    func testParsingInvalidiTAKReturnsErrorResponse() {
        let expected = CertificateEnrollmentParameters(wasInvalidString: true)
        let iTAKString = "Test Server,,,"
        let actual = QRCodeParser.parse(iTAKString)
        XCTAssertEqual(expected, actual)
    }
    
    func testParsingInvalidiTAKPortReturnsErrorResponse() {
        let expected = CertificateEnrollmentParameters(wasInvalidString: true)
        let iTAKString = "Test Server,test.example.com,abc,ssl"
        let actual = QRCodeParser.parse(iTAKString)
        XCTAssertEqual(expected, actual)
    }
    
    func testParsingInvalidiTAKServerReturnsErrorResponse() {
        let expected = CertificateEnrollmentParameters(wasInvalidString: true)
        let iTAKString = "Test Server,,8089,ssl"
        let actual = QRCodeParser.parse(iTAKString)
        XCTAssertEqual(expected, actual)
    }
    
    func testParsingValidATAKQRReturnsProperData() throws {
        let expected = CertificateEnrollmentParameters(hostName: "", serverURL: "test.example.com", serverPort: "8089", username: "jexample", password: ".A9QvmRf?II81Y1#6b$nKdSF,", shouldAutoSubmit: true, wasInvalidString: false)
        let atakString = """
 {
    "passphrase":"false",
    "type":"registration",
    "serverCredentials":{
        "connectionString":"test.example.com:8089:ssl"
    },
    "userCredentials":{
        "username":"jexample",
        "password":".A9QvmRf?II81Y1#6b$nKdSF,",
        "registrationId":"92dc5931-e528-45e1-baee-64cc7cd7e053"
    }
  }
"""
        let actual = QRCodeParser.parse(atakString)
        XCTAssertEqual(expected, actual)
    }
    
    func testParsingValidATAKQRWithNoUsernameAndPWReturnsProperData() throws {
        let expected = CertificateEnrollmentParameters(hostName: "", serverURL: "test.example.com", serverPort: "8089", username: "", password: "", shouldAutoSubmit: false, wasInvalidString: false)
        let atakString = """
 {
    "passphrase":"false",
    "type":"registration",
    "serverCredentials":{
        "connectionString":"test.example.com:8089:ssl"
    }
  }
"""
        let actual = QRCodeParser.parse(atakString)
        XCTAssertEqual(expected, actual)
    }
    
    func testParsingInvalidATAKQRReturnsErrorResponse() {
        let expected = CertificateEnrollmentParameters(wasInvalidString: true)
        let atakString = """
{
    "passphrase":"false",
    "type":"registration"
}
"""
        let actual = QRCodeParser.parse(atakString)
        XCTAssertEqual(expected, actual)
    }
    
    func testParsingInvalidATAKQRPortReturnsErrorResponse() {
        let expected = CertificateEnrollmentParameters(wasInvalidString: true)
        let atakString = """
 {
    "passphrase":"false",
    "type":"registration",
    "serverCredentials":{
        "connectionString":"test.example.com:abc:ssl"
    },
    "userCredentials":{
        "username":"jexample",
        "password":".A9QvmRf?II81Y1#6b$nKdSF,",
        "registrationId":"92dc5931-e528-45e1-baee-64cc7cd7e053"
    }
  }
"""
        let actual = QRCodeParser.parse(atakString)
        XCTAssertEqual(expected, actual)
    }
    
    func testParsingInvalidATAKQRServerReturnsErrorResponse() {
        let expected = CertificateEnrollmentParameters(wasInvalidString: true)
        let atakString = """
 {
    "passphrase":"false",
    "type":"registration",
    "serverCredentials":{
        "connectionString":":8089:ssl"
    },
    "userCredentials":{
        "username":"jexample",
        "password":".A9QvmRf?II81Y1#6b$nKdSF,",
        "registrationId":"92dc5931-e528-45e1-baee-64cc7cd7e053"
    }
  }
"""
        let actual = QRCodeParser.parse(atakString)
        XCTAssertEqual(expected, actual)
    }
}
