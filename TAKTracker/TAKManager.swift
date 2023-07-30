//
//  TAKManager.swift
//  TAK Spike
//
//  Created by Cory Foy on 7/4/23.
//

import Foundation
import MapKit
import Network
import UIKit

class TAKManager: NSObject, URLSessionDelegate, ObservableObject {
    private let udpMessage = UDPMessage()
    private let tcpMessage = TCPMessage()
    private let cotMessage = COTMessage()
    
    @Published var isConnectedToServer = false
    
    override init() {
        super.init()
        udpMessage.connect()
        tcpMessage.connect()
    }
    
    private func sendToUDP(message: String) {
        let messageContent = Data(message.utf8)
        udpMessage.send(messageContent)
    }
    
    private func sendToTCP(message: String) {
        if(!SettingsStore.global.isConnectedToServer && SettingsStore.global.shouldTryReconnect) {
            tcpMessage.connect()
        } else {
            let messageContent = Data(message.utf8)
            tcpMessage.send(messageContent)
        }
    }
    
    func broadcastLocation(location: CLLocation) {
        let message = cotMessage.generateCOTXml(location: location)

        TAKLogger.debug("Getting ready to broadcast location CoT")
        TAKLogger.debug(message)
        sendToUDP(message: message)
        sendToTCP(message: message)
        TAKLogger.debug("Done broadcasting")
    }
}
