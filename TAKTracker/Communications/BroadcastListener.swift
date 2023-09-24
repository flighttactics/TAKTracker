//
//  BroadcastListener.swift
//  TAKTracker
//
//  Created by Cory Foy on 9/23/23.
//

import Foundation
import Network

class BroadcastListener: ObservableObject {
    // New data will be place in this variable to be received by observers
    @Published private(set) public var messageReceived: Data?
    // When there is an active listening NWConnection this will be `true`
    @Published private(set) public var isReady: Bool = false
    // Default value `true`, this will become false if the UDPListener ceases listening for any reason
    @Published public var listening: Bool = true
    
//    var multicast: NWMulticastGroup?
//    var connectionGroup: NWConnectionGroup?
    
    init(host: String, port: String) {
        TAKLogger.debug("[BroadcastListener] init")
        let endpointHost = NWEndpoint.Host(host)
        let endpointPort = NWEndpoint.Port(port)!
        
        TAKLogger.debug("[BroadcastListener] Creating Multicast Group")
        guard let multicast = try? NWMulticastGroup(for:
            [ .hostPort(host: endpointHost, port: endpointPort) ])
            else { return }
        
        TAKLogger.debug("[BroadcastListener] Creating Connection Group")
        let group = NWConnectionGroup(with: multicast, using: .udp)
        
        group.setReceiveHandler(maximumMessageSize: 64000, rejectOversizedMessages: true) { (message, content, isComplete) in
            TAKLogger.debug("[BroadcastListener] Received message from \(String(describing: message.remoteEndpoint))")
            TAKLogger.debug("[BroadcastListener] Identifier \(message.identifier)")
            TAKLogger.debug("[BroadcastListener] Is Complete? \(isComplete)")
            if(content != nil) {
                TAKLogger.debug("[BroadcastListener] Message Stats \(String(describing: content))")
                do {
                    let msg = try Atakmap_Commoncommo_Protobuf_V1_CotEvent(serializedData: content!, partial: true)
                    TAKLogger.debug("[BroadcastListener] Message \(String(describing: msg))")
                } catch let error as NSError {
                    TAKLogger.error("[BroadcastListener] Unable to parse content")
                    TAKLogger.error("[BroadcastListener] \(error.description)")
                }
            }
            
//            let sendContent = Data("ack".utf8)
//            message.reply(content: sendContent)
        }
        
        group.stateUpdateHandler = { (newState) in
            TAKLogger.debug("[BroadcastListener] Group entered state \(String(describing: newState))")
        }
        
        TAKLogger.debug("[BroadcastListener] Starting Group")
        group.start(queue: .main)
    }
}
