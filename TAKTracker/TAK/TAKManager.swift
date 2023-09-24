//
//  TAKManager.swift
//  TAK Spike
//
//  Created by Cory Foy on 7/4/23.
//

import Foundation
import MapKit
import Network
import SwiftTAK
import UIKit

class TAKManager: NSObject, URLSessionDelegate, ObservableObject {
    private let udpMessage = CoTUDPMessage()
    private let udpChatMessage = ChatUDPMessage()
    private let tcpMessage = TCPMessage()
    private let chatBroadcastListener = BroadcastListener(host: "224.10.10.1", port: "17012")
    private let cotMessage : COTMessage
    
    @Published var isConnectedToServer = false
    @Published var chatMessages: [String] = []
    
    override init() {
        cotMessage = COTMessage(staleTimeMinutes: SettingsStore.global.staleTimeMinutes, deviceID: UIDevice.current.identifierForVendor!.uuidString, phoneModel: AppConstants.getPhoneModel(), phoneOS: AppConstants.getPhoneOS(), appPlatform: AppConstants.TAK_PLATFORM, appVersion: AppConstants.getAppVersion())
        super.init()
        udpMessage.connect()
        udpChatMessage.connect()
        TAKLogger.debug("[TAKManager]: establishing TCP Message Connect")
        tcpMessage.connect()
    }
    
    private func sendToUDP(message: String) {
        let messageContent = Data(message.utf8)
        udpMessage.send(messageContent)
    }
    
    private func sendToUDPChat(message: String) {
        let messageContent = Data(message.utf8)
        udpChatMessage.send(messageContent)
    }
    
    private func sendToTCP(message: String) {
        let messageContent = Data(message.utf8)
        tcpMessage.send(messageContent)
    }
    
    func broadcastLocation(location: CLLocation) {
        let message = cotMessage.generateCOTXml(heightAboveElipsoid: location.altitude.description, latitude: location.coordinate.latitude.formatted(), longitude: location.coordinate.longitude.formatted(), callSign: SettingsStore.global.callSign, group: SettingsStore.global.team, role: SettingsStore.global.role, phoneBatteryStatus: AppConstants.getPhoneBatteryStatus().description)

        TAKLogger.debug("[TAKManager]: Getting ready to broadcast location CoT")
        TAKLogger.debug(message)
        sendToUDP(message: message)
        sendToTCP(message: message)
        TAKLogger.debug("[TAKManager]: Done broadcasting")
    }
    
    func initiateEmergencyAlert(location: CLLocation?) {
        let alertType = EmergencyType(rawValue: SettingsStore.global.activeAlertType)!
        
        let alert = cotMessage.generateEmergencyCOTXml(latitude: location?.coordinate.latitude.formatted() ?? "", longitude: location?.coordinate.longitude.formatted() ?? "", callSign: SettingsStore.global.callSign, emergencyType: alertType, isCancelled: false)

        TAKLogger.debug("[TAKManager]: Getting ready to broadcast emergency alert CoT")
        TAKLogger.debug(alert)
        sendToUDP(message: alert)
        sendToTCP(message: alert)
        TAKLogger.debug("[TAKManager]: Done broadcasting emergency alert")
    }
    
    func cancelEmergencyAlert(location: CLLocation?) {
        SettingsStore.global.activeAlertType = ""
        SettingsStore.global.isAlertActivated = false
        
        let alertType = EmergencyType.Cancel
        
        let alert = cotMessage.generateEmergencyCOTXml(latitude: location?.coordinate.latitude.formatted() ?? "", longitude: location?.coordinate.longitude.formatted() ?? "", callSign: SettingsStore.global.callSign, emergencyType: alertType, isCancelled: true)

        TAKLogger.debug("[TAKManager]: Getting ready to broadcast emergency alert cancellation CoT")
        TAKLogger.debug(alert)
        sendToUDP(message: alert)
        sendToTCP(message: alert)
        TAKLogger.debug("[TAKManager]: Done broadcasting emergency alert cancellation")
    }
    
    func sendChatMessage(message: String) {
        chatMessages.append(message)
        let destination = "\(SettingsStore.global.takServerUrl):\(SettingsStore.global.takServerPort)"
        let chat = generateChatMessage(message: message,
                                                  sender: SettingsStore.global.callSign,
                                                  destinationUrl: destination)
        TAKLogger.debug("[TAKManager]: Getting ready to broadcast chat message \(message)")
        TAKLogger.debug("[TAKManager]: \(chat)")
        sendToUDPChat(message: chat)
        sendToUDP(message: chat)
        sendToTCP(message: chat)
        TAKLogger.debug("[TAKManager]: Done broadcasting chat message")
    }
    
    public func generateChatMessage(message: String,
                                    sender: String,
                                    receiver: String = "All Chat Rooms",
                                    destinationUrl: String) -> String {
        let cotType = "b-t-f"
        let cotHow = "h-g-i-g-o"
        let ONE_DAY = 60.0*60.0*24.0
        let eventTime = Date()
        let stale = Date().addingTimeInterval(ONE_DAY)
        
        let from = sender
        let conversationID = UUID().uuidString
        let messageID = UUID().uuidString
        
        let eventUID = "GeoChat.\(from).\(conversationID).\(messageID)"
        
        var cotEvent = COTEvent(version: "2.0", uid: eventUID, type: cotType, how: cotHow, time: eventTime, start: eventTime, stale: stale)
        
        cotEvent.childNodes.append(COTPoint(lat: "0.0", lon: "0.0", hae: "9999999.0", ce: "9999999.0", le: "9999999.0"))

        var cotDetail = COTDetail()
        
        cotDetail.childNodes.append(COTContact(callsign: from))
        
        let remarksSource = "BAO.F.TAKTracker.\(from)"
        
        let cotChat = COTChat(senderCallsign: from, messageID: messageID)
        let cotLink = COTLink(relation: "p-p", type: "a-f-G-U-C", uid: messageID)
        let cotRemarks = COTRemarks(source: remarksSource, timestamp: Date().ISO8601Format(), message: message)
        
        cotDetail.childNodes.append(cotChat)
        cotDetail.childNodes.append(cotLink)
        cotDetail.childNodes.append(cotRemarks)
        
        cotEvent.childNodes.append(cotDetail)
        
        return "<?xml version=\"1.0\" standalone=\"yes\"?>" + cotEvent.toXml()
    }
}
