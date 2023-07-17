//
//  TCPMessage.swift
//  TAKTracker
//
//  Created by Cory Foy on 7/12/23.
//

import Foundation
import Network

class TCPMessage: NSObject, ObservableObject {
    
    private let settingsStore = SettingsStore()
    
    @Published var connected: Bool?

    var connection: NWConnection?
    
    func send(_ payload: Data) {
        NSLog("[TCPMessage]: Sending TCP Data")
        connection!.send(content: payload, completion: .contentProcessed({ sendError in
            if let error = sendError {
                NSLog("[TCPMessage]: Unable to process and send the data: \(error)")
            } else {
                NSLog("[TCPMessage]: Data has been sent")
            }
        }))
    }
    
    func connect() {
        let host = NWEndpoint.Host(settingsStore.takServerIP)
        let port = NWEndpoint.Port(settingsStore.takServerPort)!
        
        let password = "atakatak" // Obviously this should be stored or entered more securely.
        guard let userFile = Bundle.main.url(forResource: "foyc", withExtension: "p12"),
              let userP12Data = try? Data(contentsOf: userFile) else {
            NSLog("[TCPMessage]: Unable to load TLS certificate. Cancelling connection.")
            return
        }
        
        let userP12Contents = PKCS12(data: userP12Data, password: password)
        
        let clientIdentity = userP12Contents.identity!
        
        let options = NWProtocolTLS.Options()
        let securityOptions = options.securityProtocolOptions
        
        sec_protocol_options_set_local_identity(
           securityOptions,
           sec_identity_create(clientIdentity)!
        )
        
        sec_protocol_options_set_verify_block(securityOptions, { (_, trust, completionHandler) in
            let isTrusted = true
            completionHandler(isTrusted)
        }, .main)
        
        let params = NWParameters(tls: options)
        connection = NWConnection(host: host, port: port, using: params)
        
        connection!.stateUpdateHandler = { (newState) in
            self.connected = false
            switch (newState) {
            case .preparing:
                NSLog("[TCPMessage]: Entered state: preparing")
            case .ready:
                NSLog("[TCPMessage]: Entered state: ready")
                self.connected = true
            case .setup:
                NSLog("[TCPMessage]: Entered state: setup")
            case .cancelled:
                NSLog("[TCPMessage]: Entered state: cancelled")
            case .waiting:
                NSLog("[TCPMessage]: Entered state: waiting")
            case .failed:
                NSLog("[TCPMessage]: Entered state: failed")
            default:
                NSLog("[TCPMessage]: Entered an unknown state")
            }
        }
        
        connection!.viabilityUpdateHandler = { (isViable) in
            if (isViable) {
                NSLog("[TCPMessage]: Connection is viable")
            } else {
                NSLog("[TCPMessage]: Connection is not viable")
            }
        }
        
        connection!.betterPathUpdateHandler = { (betterPathAvailable) in
            if (betterPathAvailable) {
                NSLog("[TCPMessage]: A better path is availble")
            } else {
                NSLog("[TCPMessage]: No better path is available")
            }
        }
        
        connection!.start(queue: .global())
    }
    
    func connectNonTls() {
        
        if(settingsStore.takServerIP.isEmpty || settingsStore.takServerPort.isEmpty) {
            NSLog("[TCPMessage]: No TAK Server Endpoint configured")
            return
        }
        
        let host = NWEndpoint.Host(settingsStore.takServerIP)
        let port = NWEndpoint.Port(settingsStore.takServerPort)!
        
        connection = NWConnection(host: host, port: port, using: .tls)
        
        connection!.stateUpdateHandler = { (newState) in
            self.connected = false
            switch (newState) {
            case .preparing:
                NSLog("[TCPMessage]: Entered state: preparing")
            case .ready:
                NSLog("[TCPMessage]: Entered state: ready")
                self.connected = true
            case .setup:
                NSLog("[TCPMessage]: Entered state: setup")
            case .cancelled:
                NSLog("[TCPMessage]: Entered state: cancelled")
            case .waiting:
                NSLog("[TCPMessage]: Entered state: waiting")
            case .failed:
                NSLog("[TCPMessage]: Entered state: failed")
            default:
                NSLog("[TCPMessage]: Entered an unknown state")
            }
        }
        
        connection!.viabilityUpdateHandler = { (isViable) in
            if (isViable) {
                NSLog("[TCPMessage]: Connection is viable")
            } else {
                NSLog("[TCPMessage]: Connection is not viable")
            }
        }
        
        connection!.betterPathUpdateHandler = { (betterPathAvailable) in
            if (betterPathAvailable) {
                NSLog("[TCPMessage]: A better path is availble")
            } else {
                NSLog("[TCPMessage]: No better path is available")
            }
        }
        
        connection!.start(queue: .global())
    }
}
