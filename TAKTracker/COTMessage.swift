//
//  COTMessage.swift
//  TAKTracker
//
//  Created by Cory Foy on 7/12/23.
//

import Foundation
import MapKit

class COTMessage: NSObject {
    private let settingsStore = SettingsStore()
    
    public func generateCOTXml(location: CLLocation) -> String {
        let cotTimeout = settingsStore.staleTimeMinutes * 60.0
        let stale = Date().addingTimeInterval(cotTimeout) //needs to be to ISOString Maybe?
        let staleString = ISO8601DateFormatter().string(from: stale)
        let nowString = ISO8601DateFormatter().string(from: Date())
        
        var eventAttributes: [String: String] = [:]
        eventAttributes["version"] = "2.0"
        eventAttributes["uid"] = settingsStore.callSign
        eventAttributes["type"] = settingsStore.cotType
        eventAttributes["how"] = settingsStore.cotHow
        eventAttributes["time"] = nowString
        eventAttributes["start"] = nowString
        eventAttributes["stale"] = staleString
        
        var pointAttributes: [String: String] = [:]
        pointAttributes["lat"] = location.coordinate.latitude.formatted()
        pointAttributes["lon"] = location.coordinate.longitude.formatted()
        pointAttributes["hae"] = location.altitude.description
        pointAttributes["ce"] = "9999999.0"
        pointAttributes["le"] = "9999999.0"
        
        let point = "<point " + mapXmlAttrs(nodeAttributes: pointAttributes) + "></point>"
        
        let detail = "<detail><contact callsign=\"\(settingsStore.callSign)\" /><remarks></remarks></detail>"
        
        return "<?xml version=\"1.0\" standalone=\"yes\"?>" +
            "<event " + mapXmlAttrs(nodeAttributes: eventAttributes) + ">" +
            point +
            detail +
            "</event>"
    }
    
    private func mapXmlAttrs(nodeAttributes:[String: String]) -> String {
        return nodeAttributes.compactMap( { (key, value) -> String in
            return "\(key)=\"\(value)\""
        }).joined(separator: " ")
    }

}
