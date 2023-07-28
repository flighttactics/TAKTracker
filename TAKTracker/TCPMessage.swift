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
        guard let connected = connected else {
            return
        }
        if(!connected) { return }
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
        let host = NWEndpoint.Host(settingsStore.takServerUrl)
        let port = NWEndpoint.Port(settingsStore.takServerPort)!
        
        let password = settingsStore.userCertificatePassword
        let userP12Data = settingsStore.userCertificate
        if(userP12Data.count == 0) {
            NSLog("[TCPMessage]: Unable to load TLS certificate. Cancelling connection.")
            return
        }
        
        let userP12Contents = PKCS12(data: userP12Data, password: password)
        let clientIdentity = userP12Contents.identity!
        NSLog("Client Identity")
        NSLog(String(describing: clientIdentity))
        
        
        let options = NWProtocolTLS.Options()
        let securityOptions = options.securityProtocolOptions
        let params = NWParameters(tls: options, tcp: .init())
        
        sec_protocol_options_set_local_identity(
           securityOptions,
           sec_identity_create(clientIdentity)!
        )
        
        NSLog("sic-ci")
        NSLog(String(describing: sec_identity_create(clientIdentity)!))
        
        sec_protocol_options_set_verify_block(securityOptions, { (_, trust, completionHandler) in
            NSLog("Entering Verify Block")
            let isTrusted = true
            completionHandler(isTrusted)
        }, .main)
        
        NSLog(String(describing: params))
        connection = NWConnection(host: host, port: port, using: params)
        NSLog(String(describing: connection))
        
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
        
        if(settingsStore.takServerUrl.isEmpty || settingsStore.takServerPort.isEmpty) {
            NSLog("[TCPMessage]: No TAK Server Endpoint configured")
            return
        }
        
        let host = NWEndpoint.Host(settingsStore.takServerUrl)
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
