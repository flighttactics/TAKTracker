//
//  TCPMessage.swift
//  TAKTracker
//
//  Created by Cory Foy on 7/12/23.
//

import Foundation
import Network

class TCPMessage: NSObject, ObservableObject {
    
    private let host = NWEndpoint.Host("192.168.0.49")
    private let port = NWEndpoint.Port(8089)
    
    @Published var connected: Bool?

    var connection: NWConnection?
    
    func loadCerts() {
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
    }
    
    func send(_ payload: Data) {
        NSLog("Sending TCP Data")
        connection!.send(content: payload, completion: .contentProcessed({ sendError in
            if let error = sendError {
                NSLog("Unable to process and send the data: \(error)")
            } else {
                NSLog("Data has been sent")
            }
        }))
    }
    
    func connect() {
        connection = NWConnection(host: host, port: port, using: .tcp)
        
        connection!.stateUpdateHandler = { (newState) in
            self.connected = false
            switch (newState) {
            case .preparing:
                NSLog("Entered state: preparing")
            case .ready:
                NSLog("Entered state: ready")
                self.connected = true
            case .setup:
                NSLog("Entered state: setup")
            case .cancelled:
                NSLog("Entered state: cancelled")
            case .waiting:
                NSLog("Entered state: waiting")
            case .failed:
                NSLog("Entered state: failed")
            default:
                NSLog("Entered an unknown state")
            }
        }
        
        connection!.viabilityUpdateHandler = { (isViable) in
            if (isViable) {
                NSLog("Connection is viable")
            } else {
                NSLog("Connection is not viable")
            }
        }
        
        connection!.betterPathUpdateHandler = { (betterPathAvailable) in
            if (betterPathAvailable) {
                NSLog("A better path is availble")
            } else {
                NSLog("No better path is available")
            }
        }
        
        connection!.start(queue: .global())
    }
}
