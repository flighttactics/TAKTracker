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

class TAKManager: NSObject, URLSessionDelegate {
    private let udpMessage = UDPMessage()
    private let tcpMessage = TCPMessage()
    private let cotMessage = COTMessage()
    
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
        let messageContent = Data(message.utf8)
        tcpMessage.send(messageContent)
    }
    
    func broadcastLocation(location: CLLocation) {
        let message = cotMessage.generateCOTXml(location: location)

        NSLog("Getting ready to broadcast location CoT")
        NSLog(message)
        sendToUDP(message: message)
        sendToTCP(message: message)
        NSLog("Done broadcasting")
    }
}
