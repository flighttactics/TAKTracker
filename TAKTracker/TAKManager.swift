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
    private let udpBroadcastIP = NWEndpoint.Host("239.2.3.1")
    private let udpBrodcastPort = NWEndpoint.Port(6969)
    
    private let tcpBroadcastIP = NWEndpoint.Host("192.168.62.201")
    private let tcpBrodcastPort = NWEndpoint.Port(8089)
    
    private let udpMessage = UDPMessage()
    private let cotMessage = COTMessage()
    
    override init() {
        super.init()
        udpMessage.connect()
    }
    
    private func sendToUDP(message: String) {
        let messageContent = Data(message.utf8)
        udpMessage.send(messageContent)
    }
    
    private func sendToTCP(message: String) {
        
        let password = "atakatak" // Obviously this should be stored or entered more securely.
        guard let userFile = Bundle.main.url(forResource: "foyc", withExtension: "p12"),
              let userP12Data = try? Data(contentsOf: userFile) else {
            NSLog("BAD MOON RISING 1. BYE!")
            return
        }
        
        guard let rootFile = Bundle.main.url(forResource: "truststore-root", withExtension: "p12"),
              let rootP12Data = try? Data(contentsOf: rootFile) else {
            NSLog("BAD MOON RISING 2. BYE!")
            return
        }
        
        let rootP12Contents = PKCS12(data: rootP12Data, password: password)
        //let rootCert = rootP12Contents

        let userP12Contents = PKCS12(data: userP12Data, password: password)
        
        let clientIdentity = userP12Contents.identity!
        
        let options = NWProtocolTLS.Options()
        sec_protocol_options_set_local_identity(options.securityProtocolOptions, sec_identity_create(clientIdentity)!)

        sec_protocol_options_set_challenge_block(options.securityProtocolOptions, { (_, completionHandler) in
            completionHandler(sec_identity_create(clientIdentity)!)
        }, .main)

        let parameters = NWParameters(tls: options)
        
        let queue = DispatchQueue(label: "TCP TAK", attributes: .concurrent)
        let connection = NWConnection(host: "192.168.62.201", port: 8089, using: parameters)
        connection.stateUpdateHandler = { (nwConnectionState) in
            switch nwConnectionState {
            case .failed(let error):
                NSLog("TCP: " + error.debugDescription)
                NSLog("TCP: " + error.localizedDescription)
                connection.cancel()
                return
            default:
                NSLog("TCP State: " + String(describing: nwConnectionState))
            }
        }
        connection.start(queue: queue)
        NSLog("Getting ready to connection send TCP")
        let messageContent = Data(message.utf8)
        connection.send(content: messageContent, completion: NWConnection.SendCompletion.contentProcessed(({ (NWError) in
              if (NWError == nil) {
                  NSLog("Data was sent to TCP")
              } else {
                  NSLog("ERROR! Error when TCP data (Type: Data) sending. NWError: \n \(NWError!)")
              }
            })))
    }
    
    func broadcastLocation(location: CLLocationCoordinate2D) {
        //speed, course, altitude, coordinate.latitude, coordinate.longitude
        
        let message = cotMessage.generateCOTXml(location: location)

        NSLog("Getting Ready to send to ALL THE THINGS")
        NSLog(message)
        sendToUDP(message: message)
        //sendToTCP(message: message)
        //sendToWebsocket(message: message)
        NSLog("Done broadcasting")
    }
}
