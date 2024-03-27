//
//  TAKCAConfigResponseParser.swift
//  TAKTracker
//
//  Created by Cory Foy on 9/14/23.
//

import Foundation

class TAKCAConfigResponseParser: NSObject, XMLParserDelegate {
    var nameEntries : [String:String] = [:]
    
    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String : String] = [:]
    ) {
        if(elementName == "nameEntry") {
            if let nameVal = attributeDict["name"],
               let valueVal = attributeDict["value"] {
                // Only ever take the first value coming back
                if(!nameEntries.keys.contains(nameVal)) {
                    nameEntries[nameVal] = valueVal
                } else {
                    TAKLogger.info("[TAKConfigResponseParser]: Multiple entries received for \(nameVal), only using first")
                }
            }
        }
        
    }
}
