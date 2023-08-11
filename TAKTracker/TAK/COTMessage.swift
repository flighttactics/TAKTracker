//
//  COTMessage.swift
//  TAKTracker
//
//  Created by Cory Foy on 7/12/23.
//

import Foundation
import MapKit

protocol COTNode {
    func toXml() -> String
}

struct COTEvent : COTNode {
    var version:String
    var uid:String
    var type:String
    var how:String
    var time:Date
    var start:Date
    var stale:Date
    var childNodes:[COTNode] = []
    
    func toXml() -> String {
        return "<event " +
        "version='\(version)' " +
        "uid='\(uid)' " +
        "type='\(type)' " +
        "how='\(how)' " +
        "time='\(ISO8601DateFormatter().string(from: time))' " +
        "start='\(ISO8601DateFormatter().string(from: start))' " +
        "stale='\(ISO8601DateFormatter().string(from: stale))'" +
        ">" +
        childNodes.map { $0.toXml() }.joined() +
        "</event>"
    }
}

struct COTPoint : COTNode {
    var lat:String
    var lon:String
    var hae:String
    var ce:String
    var le:String
    
    func toXml() -> String {
        return "<point " +
        "lat='\(lat)' " +
        "lon='\(lon)' " +
        "hae='\(hae)' " +
        "ce='\(ce)' " +
        "le='\(le)'" +
        "></point>"
    }
}

struct COTDetail : COTNode {
    var childNodes:[COTNode] = []
    
    func toXml() -> String {
        return "<detail>" +
        childNodes.map { $0.toXml() }.joined() +
        "</detail>"
    }
}

struct COTRemarks : COTNode {
    
    func toXml() -> String {
        return "<remarks></remarks>"
    }
}

struct COTGroup : COTNode {
    var name:String
    var role:String
    
    func toXml() -> String {
        return "<__group " +
        "name='\(name)' " +
        "role='\(role)'" +
        "></__group>"
    }
}

struct COTStatus : COTNode {
    var battery:String
    
    func toXml() -> String {
        return "<status " +
        "battery='\(battery)'" +
        "></status>"
    }
}

struct COTTakV : COTNode {
    var device:String
    var platform:String
    var os:String
    var version:String
    
    func toXml() -> String {
        return "<takv " +
        "device='\(device)' " +
        "platform='\(platform)' " +
        "os='\(os)' " +
        "version='\(version)'" +
        "></takv>"
    }
}

struct COTTrack : COTNode {
    var speed:String
    var course:String
    
    func toXml() -> String {
        return "<track " +
        "speed='\(speed)' " +
        "course='\(course)'" +
        "></track>"
    }
}

struct COTContact : COTNode {
    var endpoint:String = "*:-1:stcp"
    var phone:String = ""
    var callsign:String
    
    func toXml() -> String {
        return "<contact " +
        "endpoint='\(endpoint)' " +
        "phone='\(phone)' " +
        "callsign='\(callsign)'" +
        "></contact>"
    }
}

struct COTUid : COTNode {
    var callsign:String
    
    func toXml() -> String {
        return "<uid " +
        "Droid='\(callsign)'" +
        "></uid>"
    }
}

/*
 Based on Greg's comments here: https://github.com/snstac/pytak/issues/20#issuecomment-1478007463
 there is an <auth> node that initially gets sent. It looks like this:
 <auth><cot username="test_username" password="test_password" uid="ANDROID-359307100100375"/></auth>
 */

class COTMessage: NSObject {
    public func generateCOTXml(location: CLLocation) -> String {
        let cotTimeout = SettingsStore.global.staleTimeMinutes * 60.0
        let deviceID = UIDevice.current.identifierForVendor!.uuidString
        
        var cotEvent = COTEvent(version: "2.0", uid: deviceID, type: SettingsStore.global.cotType, how: SettingsStore.global.cotHow, time: Date(), start: Date(), stale: Date().addingTimeInterval(cotTimeout))
        
        let cotPoint = COTPoint(lat: location.coordinate.latitude.formatted(), lon: location.coordinate.longitude.formatted(), hae: location.altitude.description, ce: "9999999.0", le: "9999999.0")
        
        var cotDetail = COTDetail()
        
        cotDetail.childNodes.append(COTContact(callsign: SettingsStore.global.callSign))
        cotDetail.childNodes.append(COTRemarks())
        cotDetail.childNodes.append(COTGroup(name: "Cyan", role: "Team Member"))
        cotDetail.childNodes.append(COTUid(callsign: SettingsStore.global.callSign))
        cotDetail.childNodes.append(COTTakV(device: "iPhone 14", platform: "iTAK-Tracker-CIV", os: "iOS", version: "1.03"))
        
        cotEvent.childNodes.append(cotPoint)
        cotEvent.childNodes.append(cotDetail)
        
        return "<?xml version=\"1.0\" standalone=\"yes\"?>" + cotEvent.toXml()
    }
}
