//
//  TCPMessage.swift
//  TAKTracker
//
//  Created by Cory Foy on 7/12/23.
//

import Foundation
import Network

enum ConnectionStatus : String, CustomStringConvertible {
    case Starting = "Starting"
    case AttemptingToConnect = "Attempting to Connect"
    case Connected = "Connected"
    case Setup = "Setup"
    case Cancelled = "Cancelled"
    case Waiting = "Waiting"
    case Failed = "Failed"
    case Unknown = "Unknown"
    case Disconnected = "Disconnected"
    
    public var description: String {
        return self.rawValue
    }
}

class TCPMessage: NSObject, ObservableObject {
    var connection: NWConnection?
    
    var serverPort: String
    var serverUrl: String
    
    override init() {
        serverUrl = SettingsStore.global.takServerUrl
        serverPort = SettingsStore.global.takServerPort
        TAKLogger.debug("[TCPMessage]: Init")
    }
    
    func send(_ payload: Data) {
        let shouldForceReconnect = SettingsStore.global.takServerChanged
        let readyToSend = SettingsStore.global.isConnectedToServer && !shouldForceReconnect
        
        if(readyToSend) {
            TAKLogger.debug("[TCPMessage]: Sending TCP Data")
            connection!.send(content: payload, completion: .contentProcessed({ sendError in
                if let error = sendError {
                    TAKLogger.debug("[TCPMessage]: Error sending message: \(error)")
                } else {
                    TAKLogger.debug("[TCPMessage]: Message has been sent")
                }
            }))
        } else {
            TAKLogger.debug("[TCPMessage]: Reconnecting as we were not ready to send")
            reconnect()
        }
    }
    
    func reconnect() {
        
        if(SettingsStore.global.isConnectingToServer) {
            TAKLogger.debug("[TCPMessage]: We're already trying to connect to the server")
            return
        }
        
        guard let connection = connection else {
            TAKLogger.debug("[TCPMessage]: Connection was not viable so doing a full connect")
            SettingsStore.global.isConnectingToServer = false
            connect()
            return
        }

        let connectionStatus = SettingsStore.global.connectionStatus
        let nonRetriableStates = [
            ConnectionStatus.AttemptingToConnect.description,
            ConnectionStatus.Connected.description,
            ConnectionStatus.Setup.description,
            ConnectionStatus.Starting.description
        ]
        let isRetriable = !nonRetriableStates.contains(connectionStatus)

        if (SettingsStore.global.takServerChanged) {
            TAKLogger.debug("[TCPMessage]: TAKServer was marked as changing, so cancelling and reconnecting")
            SettingsStore.global.takServerChanged = false
            connection.forceCancel()
            connect()
            return
        } else if(isRetriable) {
            TAKLogger.debug("[TCPMessage]: Connection is in retriable state \(connectionStatus), so retrying")
            connect()
            return
        } else {
            TAKLogger.debug("[TCPMessage]: Connection was not in a retriable state (\(connectionStatus)). Ignoring.")
            return
        }
    }
    
    func connect() {
        TAKLogger.debug("[TCPMessage]: TCP Message Connect called")
        let connectionStatus = SettingsStore.global.connectionStatus
        let isConnecting = SettingsStore.global.isConnectingToServer

        if(isConnecting) {
            TAKLogger.debug("[TCPMessage]: Already trying to connect, so ignoring")
            return
        } else if(connectionStatus == ConnectionStatus.Connected.description && !SettingsStore.global.takServerChanged) {
            TAKLogger.debug("[TCPMessage]: Already connected, so ignoring")
            return
        }
        
        if (serverUrl.isEmpty || serverPort.isEmpty) {
            TAKLogger.debug("[TCPMessage]: Host/Port not set. Cancelling connection.")
            connectionFailed()
            return
        }
        
        DispatchQueue.main.async {
            SettingsStore.global.isConnectingToServer = true
        }
        
        let host = NWEndpoint.Host(serverUrl)
        let port = NWEndpoint.Port(serverPort)!
        
        TAKLogger.debug("[TCPMessage]: Attempting to connect to \(String(describing: host)):\(String(describing: port))")
        
        // TODO: Are there ways of connecting to a server that don't require a certificate identity?
        // TODO: i.e. OAuth, etc?
        guard let clientIdentity = SettingsStore.global.retrieveIdentity(label: SettingsStore.global.takServerUrl) else {
            TAKLogger.error("[TCPMessage]: Identity was not stored in the keychain")
            connectionFailed()
            return
        }
        
        let options = NWProtocolTLS.Options()
        let securityOptions = options.securityProtocolOptions
        let params = NWParameters(tls: options, tcp: .init())
        
        sec_protocol_options_set_local_identity(
           securityOptions,
           sec_identity_create(clientIdentity)!
        )
        
        // TODO: This is where we need to verify the intermediate certificate
        sec_protocol_options_set_verify_block(securityOptions, { (_, trust, completionHandler) in
            TAKLogger.debug("[TCPMessage]: Entering Verify Block")
            let isTrusted = true
            completionHandler(isTrusted)
        }, .main)
        
        TAKLogger.debug("[TCPMessage]: " + String(describing: params))
        connection = NWConnection(host: host, port: port, using: params)
        TAKLogger.debug("[TCPMessage]: " + String(describing: connection))
        
        connection!.stateUpdateHandler = stateUpdateHandler
        connection!.viabilityUpdateHandler = viabilityUpdateHandler
        connection!.betterPathUpdateHandler = betterPathUpdateHandler
        
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
        
        connection!.stateUpdateHandler = stateUpdateHandler
        connection!.viabilityUpdateHandler = viabilityUpdateHandler
        connection!.betterPathUpdateHandler = betterPathUpdateHandler
        
        connection!.start(queue: .global())
    }
    
    func connectionFailed() {
        DispatchQueue.main.async {
            SettingsStore.global.isConnectingToServer = false
        }
    }
    
    func betterPathUpdateHandler(betterPathAvailable: Bool) {
        if (betterPathAvailable) {
            TAKLogger.debug("[TCPMessage]: A better path is availble")
        } else {
            TAKLogger.debug("[TCPMessage]: No better path is available")
        }
    }
    
    func viabilityUpdateHandler(isViable: Bool) {
        if (isViable) {
            TAKLogger.debug("[TCPMessage]: Connection is viable")
        } else {
            DispatchQueue.main.async {
                SettingsStore.global.connectionStatus = ConnectionStatus.Disconnected.description
                SettingsStore.global.isConnectedToServer = false
                SettingsStore.global.shouldTryReconnect = true
            }
            TAKLogger.debug("[TCPMessage]: Connection is not viable")
        }
    }
    
    func stateUpdateHandler(newState: NWConnection.State) {
        DispatchQueue.main.async {
            SettingsStore.global.isConnectingToServer = true
            SettingsStore.global.isConnectedToServer = false
            SettingsStore.global.shouldTryReconnect = false
            SettingsStore.global.takServerChanged = false
            SettingsStore.global.connectionStatus = ConnectionStatus.Starting.description
        }
        
        switch (newState) {
        case .preparing:
            TAKLogger.debug("[TCPMessage]: Entered state: preparing")
            DispatchQueue.main.async {
                SettingsStore.global.connectionStatus = ConnectionStatus.AttemptingToConnect.description
            }
        case .ready:
            TAKLogger.debug("[TCPMessage]: Entered state: ready")
            DispatchQueue.main.async {
                SettingsStore.global.isConnectedToServer = true
                SettingsStore.global.isConnectingToServer = false
                SettingsStore.global.connectionStatus = ConnectionStatus.Connected.description
            }
        case .setup:
            TAKLogger.debug("[TCPMessage]: Entered state: setup")
            DispatchQueue.main.async {
                SettingsStore.global.connectionStatus = ConnectionStatus.Setup.description
            }
        case .cancelled:
            TAKLogger.debug("[TCPMessage]: Entered state: cancelled")
            DispatchQueue.main.async {
                SettingsStore.global.isConnectingToServer = false
                SettingsStore.global.shouldTryReconnect = true
                SettingsStore.global.connectionStatus = ConnectionStatus.Cancelled.description
            }
        case .waiting:
            TAKLogger.debug("[TCPMessage]: Entered state: waiting")
            DispatchQueue.main.async {
                SettingsStore.global.connectionStatus = ConnectionStatus.Waiting.description
            }
        case .failed:
            TAKLogger.debug("[TCPMessage]: Entered state: failed")
            DispatchQueue.main.async {
                SettingsStore.global.isConnectedToServer = false
                SettingsStore.global.isConnectingToServer = false
                SettingsStore.global.shouldTryReconnect = true
                SettingsStore.global.connectionStatus = ConnectionStatus.Failed.description
            }
        default:
            TAKLogger.debug("[TCPMessage]: Entered an unknown state")
            DispatchQueue.main.async {
                SettingsStore.global.connectionStatus = ConnectionStatus.Unknown.description
            }
        }
    }
}
