//
//  COTMessage.swift
//  TAKTracker
//
//  Created by Cory Foy on 7/12/23.
//

import Foundation
import MapKit

class COTMessage: NSObject {
    
    private let cotTimeout = 2.0 * 60.0
    
    public func generateCOTXml(location: CLLocationCoordinate2D, userId: String) -> String {
        let stale = Date().addingTimeInterval(cotTimeout) //needs to be to ISOString Maybe?
        let staleString = ISO8601DateFormatter().string(from: stale)
        let nowString = ISO8601DateFormatter().string(from: Date())
        
        let eventAttrs = "version=\"2.0\" " +
        "uid=\"TS-20230704\" " +
        "type=\"a-f-G\" " +
        "how=\"m-g\" " +
        "time=\"" + nowString + "\" " +
        "start=\"" + nowString + "\" " +
        "stale=\"" + staleString + "\""
        
        let point = "<point " +
        "lat=\"" + location.latitude.description + "\" " +
        "lon=\"" + location.longitude.description + "\" " +
        "hae=\"30.0\" " +
        "ce=\"9999999.0\" " +
        "le=\"9999999.0\" " +
            "></point>"
        let detail = "<detail><contact callsign=\"Taylor Swift\" /><remarks>TS + TAK 4 LYFE</remarks></detail>"
        
        return "<?xml version=\"1.0\" standalone=\"yes\"?>" +
            "<event " + eventAttrs + ">" +
            point +
            detail +
            "</event>"
    }

}
