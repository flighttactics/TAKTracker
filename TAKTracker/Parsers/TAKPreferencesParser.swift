//
//  TAKPreferencesParser.swift
//  TAKTracker
//
//  Created by Cory Foy on 7/26/23.
//

import UIKit
import Foundation

struct TAKPreferences {
    var userCertificateFile = ""
    var userCertificatePassword = ""
    var serverCertificateFile = ""
    var serverCertificatePassword = ""
    var serverDescription = ""
    var serverConnectionString = ""
    var serverEnabled = true
    
    func userCertificateFileName() -> String {
        let splitFile = userCertificateFile.components(separatedBy: "/")
        TAKLogger.debug(String(describing: splitFile))
        return splitFile[splitFile.count-1]
    }
    
    func serverCertificateFileName() -> String {
        let splitFile = serverCertificateFile.components(separatedBy: "/")
        TAKLogger.debug(String(describing: splitFile))
        return splitFile[splitFile.count-1]
    }
    
    func serverConnectionAddress() -> String {
        let splitFile = serverConnectionString.components(separatedBy: ":")
        return splitFile[0]
    }
    
    func serverConnectionPort() -> String {
        let splitFile = serverConnectionString.components(separatedBy: ":")
        return splitFile[1]
    }
    
    func serverConnectionProtocol() -> String {
        let splitFile = serverConnectionString.components(separatedBy: ":")
        return splitFile[2]
    }
}

class TAKPreferencesParser: NSObject, XMLParserDelegate {
    var preferences: TAKPreferences = TAKPreferences()
    
    private var textBuffer: String = ""
    private var currentAttr: String = ""
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        textBuffer += string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if(elementName == "entry") {
            switch currentAttr {
            case("description0"):
                preferences.serverDescription = textBuffer
            case("connectString0"):
                preferences.serverConnectionString = textBuffer
            case("caLocation"):
                preferences.serverCertificateFile = textBuffer
            case("caPassword"):
                preferences.serverCertificatePassword = textBuffer
            case("clientPassword"):
                preferences.userCertificatePassword = textBuffer
            case("certificateLocation"):
                preferences.userCertificateFile = textBuffer
                    
            default:
                currentAttr = ""
                textBuffer = ""
            }
        }
    }
    
    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String : String] = [:]
    ) {
        if(elementName == "entry") {
            for (attr_key, attr_val) in attributeDict {
                if(attr_key == "key") {
                    currentAttr = attr_val
                    textBuffer = ""
                }
            }
        }
        
    }
}
