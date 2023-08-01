//
//  TCPMessage.swift
//  TAKTracker
//
//  Created by Cory Foy on 7/12/23.
//

import Foundation
import Network

class TCPMessage: NSObject, ObservableObject {
    @Published var connected: Bool?

    var connection: NWConnection?
    
    func send(_ payload: Data) {
        guard let connected = connected else {
            return
        }
        let reconnectStatus = SettingsStore.global.shouldTryReconnect
        let connectionStatus = SettingsStore.global.connectionStatus
        if(!connected &&
           reconnectStatus &&
           connectionStatus == "Failed") {
            TAKLogger.debug("Connection should be retried, so retrying")
            reconnect()
            return
//        } else if (SettingsStore.global.takServerChanged) {
//            TAKLogger.debug("TAKServer was marked as changing, so reconnecting")
//            reconnect()
//            return
        } else if (!connected) {
            return
        }
        TAKLogger.debug("[TCPMessage]: Sending TCP Data")
        connection!.send(content: payload, completion: .contentProcessed({ sendError in
            if let error = sendError {
                TAKLogger.debug("[TCPMessage]: Unable to process and send the data: \(error)")
            } else {
                TAKLogger.debug("[TCPMessage]: Data has been sent")
            }
        }))
    }
    
    func reconnect() {
        guard let connection = connection else {
            TAKLogger.debug("Connection was already not viable on reconnect")
            connect()
            return
        }
        connection.cancel()
        TAKLogger.debug("TCP Message Reconnect calling connect")
        connect()
    }
    
    func connect() {
        TAKLogger.debug("TCP Message Connect called")
        
        let serverUrl = SettingsStore.global.takServerUrl
        let serverPort = SettingsStore.global.takServerPort
        
        if (serverUrl.isEmpty || serverPort.isEmpty) {
            TAKLogger.debug("[TCPMessage]: Host/Port not set. Cancelling connection.")
            return
        }
        
        let host = NWEndpoint.Host(SettingsStore.global.takServerUrl)
        let port = NWEndpoint.Port(SettingsStore.global.takServerPort)!
        
        let password = SettingsStore.global.userCertificatePassword
        let userP12Data = SettingsStore.global.userCertificate
        if(userP12Data.count == 0) {
            TAKLogger.debug("[TCPMessage]: Unable to load TLS certificate. Cancelling connection.")
            return
        }
        TAKLogger.debug("userP12Data: \(String(describing: userP12Data))")
        
        let userP12Contents = PKCS12(data: userP12Data, password: password)
        
        guard let clientIdentity = userP12Contents.identity else {
            TAKLogger.debug("[TCPMessage]: Unable to load TLS identity. Cancelling connection.")
            return
        }
        TAKLogger.debug("Client Identity")
        TAKLogger.debug(String(describing: clientIdentity))
        
        
        let options = NWProtocolTLS.Options()
        let securityOptions = options.securityProtocolOptions
        let params = NWParameters(tls: options, tcp: .init())
        
        sec_protocol_options_set_local_identity(
           securityOptions,
           sec_identity_create(clientIdentity)!
        )
        
        TAKLogger.debug("sic-ci")
        TAKLogger.debug(String(describing: sec_identity_create(clientIdentity)!))
        
        sec_protocol_options_set_verify_block(securityOptions, { (_, trust, completionHandler) in
            TAKLogger.debug("Entering Verify Block")
            let isTrusted = true
            completionHandler(isTrusted)
        }, .main)
        
        TAKLogger.debug(String(describing: params))
        connection = NWConnection(host: host, port: port, using: params)
        TAKLogger.debug(String(describing: connection))
        
        connection!.stateUpdateHandler = { (newState) in
            self.connected = false
            DispatchQueue.main.async {
                SettingsStore.global.isConnectedToServer = false
                SettingsStore.global.shouldTryReconnect = false
                SettingsStore.global.connectionStatus = "Starting"
            }
            
            switch (newState) {
            case .preparing:
                TAKLogger.debug("[TCPMessage]: Entered state: preparing")
                DispatchQueue.main.async {
                    SettingsStore.global.connectionStatus = "Attempting to Connect"
                }
            case .ready:
                TAKLogger.debug("[TCPMessage]: Entered state: ready")
                self.connected = true
                DispatchQueue.main.async {
                    SettingsStore.global.isConnectedToServer = true
                    SettingsStore.global.connectionStatus = "Connected"
                }
            case .setup:
                TAKLogger.debug("[TCPMessage]: Entered state: setup")
                DispatchQueue.main.async {
                    SettingsStore.global.connectionStatus = "Setup"
                }
            case .cancelled:
                TAKLogger.debug("[TCPMessage]: Entered state: cancelled")
                DispatchQueue.main.async {
                    SettingsStore.global.connectionStatus = "Cancelled"
                }
            case .waiting:
                TAKLogger.debug("[TCPMessage]: Entered state: waiting")
                DispatchQueue.main.async {
                    SettingsStore.global.connectionStatus = "Waiting"
                }
            case .failed:
                TAKLogger.debug("[TCPMessage]: Entered state: failed")
                DispatchQueue.main.async {
                    SettingsStore.global.isConnectedToServer = false
                    SettingsStore.global.connectionStatus = "Failed"
                }
            default:
                TAKLogger.debug("[TCPMessage]: Entered an unknown state")
                DispatchQueue.main.async {
                    SettingsStore.global.connectionStatus = "Unknown"
                }
            }
        }
        
        connection!.viabilityUpdateHandler = { (isViable) in
            if (isViable) {
                TAKLogger.debug("[TCPMessage]: Connection is viable")
            } else {
                DispatchQueue.main.async {
                    SettingsStore.global.connectionStatus = "Disconnected"
                    SettingsStore.global.isConnectedToServer = false
                    SettingsStore.global.shouldTryReconnect = true
                }
                TAKLogger.debug("[TCPMessage]: Connection is not viable")
            }
        }
        
        connection!.betterPathUpdateHandler = { (betterPathAvailable) in
            if (betterPathAvailable) {
                TAKLogger.debug("[TCPMessage]: A better path is availble")
            } else {
                TAKLogger.debug("[TCPMessage]: No better path is available")
            }
        }
        
        connection!.start(queue: .global())
    }
    
    func connectNonTls() {
        
        if(SettingsStore.global.takServerUrl.isEmpty || SettingsStore.global.takServerPort.isEmpty) {
            TAKLogger.debug("[TCPMessage]: No TAK Server Endpoint configured")
            return
        }
        
        let host = NWEndpoint.Host(SettingsStore.global.takServerUrl)
        let port = NWEndpoint.Port(SettingsStore.global.takServerPort)!
        
        connection = NWConnection(host: host, port: port, using: .tls)
        
        connection!.stateUpdateHandler = { (newState) in
            self.connected = false
            switch (newState) {
            case .preparing:
                TAKLogger.debug("[TCPMessage]: Entered state: preparing")
            case .ready:
                TAKLogger.debug("[TCPMessage]: Entered state: ready")
                self.connected = true
            case .setup:
                TAKLogger.debug("[TCPMessage]: Entered state: setup")
            case .cancelled:
                TAKLogger.debug("[TCPMessage]: Entered state: cancelled")
            case .waiting:
                TAKLogger.debug("[TCPMessage]: Entered state: waiting")
            case .failed:
                TAKLogger.debug("[TCPMessage]: Entered state: failed")
            default:
                TAKLogger.debug("[TCPMessage]: Entered an unknown state")
            }
        }
        
        connection!.viabilityUpdateHandler = { (isViable) in
            if (isViable) {
                TAKLogger.debug("[TCPMessage]: Connection is viable")
            } else {
                TAKLogger.debug("[TCPMessage]: Connection is not viable")
            }
        }
        
        connection!.betterPathUpdateHandler = { (betterPathAvailable) in
            if (betterPathAvailable) {
                TAKLogger.debug("[TCPMessage]: A better path is availble")
            } else {
                TAKLogger.debug("[TCPMessage]: No better path is available")
            }
        }
        
        connection!.start(queue: .global())
    }
}
