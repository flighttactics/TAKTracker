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

class TAKManager: NSObject {
    
    private let fiveMinutes = 5.0 * 6.0 * 1000.0
    private let udpBroadcastIP = NWEndpoint.Host("239.2.3.1")
    private let udpBrodcastPort = NWEndpoint.Port(6969)
    
    override init() {
        super.init()
    }
    
    func broadcastLocation(location: CLLocationCoordinate2D, userId: String) {
        //speed, course, altitude, coordinate.latitude, coordinate.longitude
        NSLog(generateCOTXml(location: location, userId: userId))
        guard let multicast = try? NWMulticastGroup(for:
            [ .hostPort(host: udpBroadcastIP, port: udpBrodcastPort) ])
        else { NSLog("No Multicast capabilities"); return }
        NSLog(String(describing: multicast.members))
        
        let group = NWConnectionGroup(with: multicast, using: .udp)
        
        group.setReceiveHandler(maximumMessageSize: 16384, rejectOversizedMessages: false) { (message, content, isComplete) in
            print("Received message from \(String(describing: message.remoteEndpoint))")

            let sendContent = Data("ack".utf8)
            message.reply(content: sendContent)
        }
        
        let groupSendContent = Data(generateCOTXml(location: location, userId: userId).utf8)
        group.stateUpdateHandler = { (newState) in
            print("Group entered state \(String(describing: newState))")
        }
        group.start(queue: .main)
        NSLog("getting ready to broadcast \(String(describing: groupSendContent))")
        group.send(content: groupSendContent, completion: {(error) in NSLog("Done with error \(String(describing: error))")})
        
//        let connection = NWConnection(host: udpBroadcastIP, port: udpBrodcastPort, using: .udp)
//        connection.stateUpdateHandler = { (nwConnectionState) in
//            switch nwConnectionState {
//            case .failed(let error):
//                NSLog(error.debugDescription)
//                NSLog(error.localizedDescription)
//                connection.cancel()
//            default:
//                NSLog(String(describing: nwConnectionState))
//            }
//        }
//        connection.start(queue: queue)
//        NSLog("Getting ready to connection send UDP")
//        connection.send(content: groupSendContent, completion: NWConnection.SendCompletion.contentProcessed(({ (NWError) in
//              if (NWError == nil) {
//                  NSLog("Data was sent to UDP")
//              } else {
//                  NSLog("ERROR! Error when UDP data (Type: Data) sending. NWError: \n \(NWError!)")
//              }
//            })))
        
        NSLog("Done broadcasting")
        group.cancel()
    }
    
    private func generateCOTXml(location: CLLocationCoordinate2D, userId: String) -> String {
        let stale = Date().addingTimeInterval(fiveMinutes) //needs to be to ISOString Maybe?
        let staleString = ISO8601DateFormatter().string(from: stale)
        let nowString = ISO8601DateFormatter().string(from: Date())
        
        let eventAttrs = "version=\"2.0\" " +
        "uid=\"TS-20230704\" " +
        "type=\"a-F-A\" " +
        "how=\"m-g\" " +
        "time=\"" + nowString + "\" " +
        "start=\"" + nowString + "\" " +
        "stale=\"" + staleString + "\""
        
        let point = "<point " +
        "lat=\"" + location.latitude.description + "\" " +
        "lon=\"" + location.longitude.description + "\" " +
        "hae=\"30.0\" " +
        "ce=\"9999999.0\" " +
        "le=\"9999999.0\" " +
            "></point>"
        let detail = "<detail><contact callsign=\"Taylor Swift\" /><remarks>TS 4 LYFE</remarks></detail>"
        
        return "<?xml version=\"1.0\" standalone=\"yes\"?>" +
            "<event " + eventAttrs + ">" +
            point +
            detail +
            "</event>"
    }
    
    /*

     const events = incidentJsons.map((incidentJson) => {
         return {
             "payload": {
                 "event": {
                     "_attributes": {
                         "version": "2.0",
                         "uid": incidentJson["id"],
                         "type": "a-f-A",
                         "how": "m-g",
                         "time": new Date(Date.now()).toISOString(),
                         "start": new Date(Date.now()).toISOString(),
                         "stale": stale
                     },
                     "point": {
                         "_attributes": {
                             "lat": incidentJson["lat"],
                             "lon": incidentJson["lng"],
                             "hae": "30.0",
                             "ce": "9999999.0",
                             "le": "9999999.0"
                         }
                     },
                     "detail": {
                         "contact": {
                             "_attributes": {
                                 "callsign": incidentJson["name"]
                             }
                         },
                         "remarks": "Test Remarks"
                     }
                 }

             }
         }
     });

     <?xml version="1.0" standalone="yes"?>
     <event
         version="2.0"
         uid="J-01334"
         type="a-h-G"
         time="2017-10-30T11:43:38.07Z"
         start="2017-10-30T11:43:38.07Z"
         stale="2017-10-30T11:55:38.07Z">
             <detail></detail>
             <point
                 lat="30.0090027"
                 lon="-85.9578735"
                 hae="1"
                 ce="1"
                 le="1"/>
     </event>
     
     */

}
