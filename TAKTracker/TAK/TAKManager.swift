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
    private let udpMessage = UDPMessage()
    private let tcpMessage = TCPMessage()
    private let cotMessage : COTMessage
    
    @Published var isConnectedToServer = false
    
    override init() {
        cotMessage = COTMessage(staleTimeMinutes: SettingsStore.global.staleTimeMinutes, deviceID: UIDevice.current.identifierForVendor!.uuidString, phoneModel: AppConstants.getPhoneModel(), phoneOS: AppConstants.getPhoneOS(), appPlatform: AppConstants.TAK_PLATFORM, appVersion: AppConstants.getAppVersion())
        super.init()
        udpMessage.connect()
        TAKLogger.debug("[TAKManager]: establishing TCP Message Connect")
        tcpMessage.connect()
    }
    
    private func sendToUDP(message: String) {
        let messageContent = Data(message.utf8)
        udpMessage.send(messageContent)
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
}
