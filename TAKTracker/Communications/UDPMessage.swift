//
//  UDPMessage.swift
//  TAKTracker
//
//  Created by Cory Foy on 7/12/23.
//

import Foundation
import Network

class CoTUDPMessage : UDPMessage {
    init(connection: NWConnection? = nil) {
        super.init(host: "239.2.3.1",
              port: 6969)
    }
}

class ChatUDPMessage : UDPMessage {
    init(connection: NWConnection? = nil) {
        super.init(host: "224.10.10.1",
              port: 17012)
    }
}

class UDPMessage: NSObject, ObservableObject {
    var connection: NWConnection? = nil
    
    var host: NWEndpoint.Host
    var port: NWEndpoint.Port
    
    init(host: NWEndpoint.Host, port: NWEndpoint.Port) {
        self.host = host
        self.port = port
    }
    
    @Published var connected: Bool?
    
    func send(_ payload: Data) {
        TAKLogger.debug("[UDPMessage]: Sending UDP Data")
        connection!.send(content: payload, completion: .contentProcessed({ sendError in
            if let error = sendError {
                TAKLogger.debug("[UDPMessage]: Unable to process and send the data: \(error)")
            } else {
                TAKLogger.debug("[UDPMessage]: Data has been sent")
            }
        }))
    }
    
    func connect() {
        TAKLogger.debug("[UDPMessage]: Connecting to UDP")
        connection = NWConnection(host: host, port: port, using: .udp)
        
        connection!.stateUpdateHandler = { (newState) in
            self.connected = false
            switch (newState) {
            case .preparing:
                TAKLogger.debug("[UDPMessage]: Entered state: preparing")
            case .ready:
                TAKLogger.debug("[UDPMessage]: Entered state: ready")
                self.connected = true
            case .setup:
                TAKLogger.debug("[UDPMessage]: Entered state: setup")
            case .cancelled:
                TAKLogger.debug("[UDPMessage]: Entered state: cancelled")
            case .waiting:
                TAKLogger.debug("[UDPMessage]: Entered state: waiting")
            case .failed:
                TAKLogger.debug("[UDPMessage]: Entered state: failed")
            default:
                TAKLogger.debug("[UDPMessage]: Entered an unknown state")
            }
        }
        
        connection!.viabilityUpdateHandler = { (isViable) in
            if (isViable) {
                TAKLogger.debug("[UDPMessage]: Connection is viable")
            } else {
                TAKLogger.debug("[UDPMessage]: Connection is not viable")
            }
        }
        
        connection!.betterPathUpdateHandler = { (betterPathAvailable) in
            if (betterPathAvailable) {
                TAKLogger.debug("[UDPMessage]: A better path is availble")
            } else {
                TAKLogger.debug("[UDPMessage]: No better path is available")
            }
        }
        TAKLogger.debug("[UDPMessage]: Starting UDP Connection")
        connection!.start(queue: .global())
    }
}
