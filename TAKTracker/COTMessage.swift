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
    
    public func generateCOTXml(location: CLLocationCoordinate2D) -> String {
        let cotTimeout = settingsStore.staleTimeMinutes * 60.0
        let stale = Date().addingTimeInterval(cotTimeout) //needs to be to ISOString Maybe?
        let staleString = ISO8601DateFormatter().string(from: stale)
        let nowString = ISO8601DateFormatter().string(from: Date())
        
        let eventAttrs = "version=\"2.0\" " +
        "uid=\"" + settingsStore.userID + "\" " +
        "type=\"" + settingsStore.cotType + "\" " +
        "how=\"" + settingsStore.cotType + "\" " +
        "time=\"" + nowString + "\" " +
        "start=\"" + nowString + "\" " +
        "stale=\"" + staleString + "\""
        
        let point = "<point " +
        "lat=\"" + location.latitude.description + "\" " +
        "lon=\"" + location.longitude.description + "\" " +
        "hae=\"9999999.0\" " +
        "ce=\"9999999.0\" " +
        "le=\"9999999.0\" " +
            "></point>"
        let detail = "<detail><contact callsign=\"" + settingsStore.callSign + "\" /><remarks></remarks></detail>"
        
        return "<?xml version=\"1.0\" standalone=\"yes\"?>" +
            "<event " + eventAttrs + ">" +
            point +
            detail +
            "</event>"
    }

}
