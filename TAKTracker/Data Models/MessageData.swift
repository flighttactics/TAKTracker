//
//  MessageData.swift
//  TAKTracker
//
//  Created by Craig Clayton on 1/4/24.
//

import Foundation

struct MessageData: Decodable, Identifiable {
    let id: UUID
    let userUId: String
    let callSign: String
    let message: String
    let createAt: Date
    let expiresAt: Date
    var dateSent: Date = Date.now
    var dateReceived = Date.now
    
    static var defaultIncomingMessage1 = Self(id: UUID(), userUId: "incoming", callSign: "TXDPS Vandenheuvel 606", message: "get an Android", createAt: Date.now, expiresAt: Date.now)
    static var defaultIncomingMessage2 = Self(id: UUID(), userUId: "incoming", callSign: "TXDPS Ross 622", message: "Howdy", createAt: Date.now, expiresAt: Date.now)
    static var defaultIncomingMessage3 = Self(id: UUID(), userUId: "incoming", callSign: "TXDPS Ross 622", message: "Donec sed odio dui. Sed posuere consectetur est at lobortis. Integer posuere erat a ante venenatis dapibus posuere velit aliquet. Nulla vitae elit libero, a pharetra augue.", createAt: Date.now, expiresAt: Date.now)
    static var defaultOutgoingMessage1 = Self(id: UUID(), userUId: "outgoing", callSign: "", message: "Hello from iTAK", createAt: Date.now, expiresAt: Date.now)
    static var defaultOutgoingMessage2 = Self(id: UUID(), userUId: "outgoing", callSign: "", message: "Test", createAt: Date.now, expiresAt: Date.now)
    static var defaultOutgoingMessage3 = Self(id: UUID(), userUId: "outgoing", callSign: "", message: "Sed posuere consectetur est at lobortis. Etiam porta sem malesuada magna mollis euismod. Morbi leo risus, porta ac consectetur ac, vestibulum at eros.", createAt: Date.now, expiresAt: Date.now)
    
    func isFromCurrentUser() -> Bool {
        if userUId == "incoming" { return false }
        else { return true }
    }
}
