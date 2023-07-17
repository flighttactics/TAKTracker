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

class TAKManagerV2: NSObject {//}, URLSessionDelegate {
    
//    private let fiveMinutes = 5.0 * 6.0 * 1000.0
//    private let udpBroadcastIP = NWEndpoint.Host("239.2.3.1")
//    private let udpBrodcastPort = NWEndpoint.Port(6969)
//
//    private let tcpBroadcastIP = NWEndpoint.Host("192.168.62.201")
//    private let tcpBrodcastPort = NWEndpoint.Port(8089)
//
//    //private let webSocketURL = URL(string: "wss://takathon.thetaksyndicate.org:8089")!
//    //private let webSocketURL = URL(string: "wss://192.168.62.201:8089")!
//
//    override init() {
//        super.init()
//    }
//
//    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//        NSLog("In handler")
//
//        var rootCert:PKCS12
//        var userCert:PKCS12
//
//        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust || challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodClientCertificate
//        {
//            NSLog("ST: STEP 1")
//
//            guard let rootFile = Bundle.main.url(forResource: "truststore-root", withExtension: "p12"),
//                  let rootP12Data = try? Data(contentsOf: rootFile) else {
//                // Loading of the p12 file's data failed.
//                completionHandler(.performDefaultHandling, nil)
//                return
//            }
//
//            NSLog("ST: STEP 2")
//
//            // Interpret the data in the P12 data blob with
//            // a little helper class called `PKCS12`.
//            let password = "atakatak" // Obviously this should be stored or entered more securely.
//            let rootP12Contents = PKCS12(data: rootP12Data, password: password)
//
//            rootCert = rootP12Contents
//
//            NSLog("ST: DONE")
//
//            NSLog("CC: STEP 1")
//
//            guard let userFile = Bundle.main.url(forResource: "foyc", withExtension: "p12"),
//                  let userP12Data = try? Data(contentsOf: userFile) else {
//                // Loading of the p12 file's data failed.
//                completionHandler(.performDefaultHandling, nil)
//                return
//            }
//
//            NSLog("CC: STEP 2")
//
//            let userP12Contents = PKCS12(data: userP12Data, password: password)
//
//            userCert = userP12Contents
//            NSLog("CC: DONE")
//        } else {
//            completionHandler(.performDefaultHandling, nil)
//            NSLog("GO BYEBYE")
//            return
//        }
//
//        let protectionSpace = challenge.protectionSpace
//
//        guard let serverTrust = protectionSpace.serverTrust else {
//            completionHandler(.performDefaultHandling, nil)
//            return
//        }
//
//        let certificates = [rootCert, userCert]
//        let policy = SecPolicyCreateSSL(false, nil)
//        var optionalTrust: SecTrust?
//        let status = SecTrustCreateWithCertificates(certificates as AnyObject,
//                                                    policy,
//                                                    &optionalTrust)
//
//        SecTrustSetAnchorCertificates(serverTrust, certificates as CFArray)
//
//        guard let identity = certificates.last!.identity else {
//            // Creating a PKCS12 never fails, but interpretting th contained data can. So again, no identity? We fall back to default.
//            completionHandler(.performDefaultHandling, nil)
//            return
//        }
//
//        //let credential = URLCredential(trust: serverTrust)
//        let credential = URLCredential(identity: identity,
//                                   certificates: certificates,
//                                    persistence: .none)
//        challenge.sender?.use(credential, for: challenge)
//        completionHandler(.useCredential, credential)
////
//
////        challenge.sender?.use(credential, for: challenge)
////        completionHandler(.useCredential, credential)
//    }
//
//    private func sendToUDP(message: String) {
//        guard let multicast = try? NWMulticastGroup(for:
//            [ .hostPort(host: udpBroadcastIP, port: udpBrodcastPort) ])
//        else { NSLog("No Multicast capabilities"); return }
//
//        let group = NWConnectionGroup(with: multicast, using: .udp)
//
//        group.setReceiveHandler(maximumMessageSize: 16384, rejectOversizedMessages: false) { (message, content, isComplete) in
//            NSLog("Received message from \(String(describing: message.remoteEndpoint))")
//
//            let sendContent = Data("ack".utf8)
//            message.reply(content: sendContent)
//        }
//
//        let messageContent = Data(message.utf8)
//        group.stateUpdateHandler = { (nwConnectionState) in
//            switch nwConnectionState {
//            case .failed(let error):
//                NSLog("UDP: " + error.debugDescription)
//                NSLog("UDP: " + error.localizedDescription)
//                group.cancel()
//                return
//            default:
//                NSLog("UDP State: " + String(describing: nwConnectionState))
//            }
//        }
//        group.start(queue: .main)
//        group.send(content: messageContent, completion: {(error) in NSLog("UDP Done with error \(String(describing: error))")})
//        group.cancel()
//    }
//
//    private func sendToTCP(message: String) {
//        let queue = DispatchQueue(label: "TCP TAK", attributes: .concurrent)
//        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
//        let connection = NWConnection(host: "192.168.62.201", port: 8089, using: .tcp)
//        connection.stateUpdateHandler = { (nwConnectionState) in
//            switch nwConnectionState {
//            case .failed(let error):
//                NSLog("TCP: " + error.debugDescription)
//                NSLog("TCP: " + error.localizedDescription)
//                connection.cancel()
//                return
//            default:
//                NSLog("TCP State: " + String(describing: nwConnectionState))
//            }
//        }
//        connection.start(queue: queue)
//        NSLog("Getting ready to connection send TCP")
//        let messageContent = Data(message.utf8)
//        connection.send(content: messageContent, completion: NWConnection.SendCompletion.contentProcessed(({ (NWError) in
//              if (NWError == nil) {
//                  NSLog("Data was sent to TCP")
//              } else {
//                  NSLog("ERROR! Error when TCP data (Type: Data) sending. NWError: \n \(NWError!)")
//              }
//            })))
//    }
//
////    private func sendToWebsocket(message: String) {
////        NSLog("sendToWebSocket")
////        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
////        let webSocketTask = session.webSocketTask(with: webSocketURL)
////        webSocketTask.resume()
////        let message = URLSessionWebSocketTask.Message.string("Hello Socket")
////        webSocketTask.send(message) { error in
////            if let error = error {
////                NSLog("WebSocket sending error: \(error)")
////            } else {
////                NSLog("Message Sent")
////            }
////        }
////        webSocketTask.receive { result in
////            switch result {
////            case .failure(let error):
////                print("Failed to receive message: \(error)")
////            case .success(let message):
////                switch message {
////                case .string(let text):
////                    print("Received text message: \(text)")
////                case .data(let data):
////                    print("Received binary message: \(data)")
////                @unknown default:
////                    fatalError()
////                }
////            }
////        }
////
////        let cert = PKCS12.init(mainBundleResource: "truststore-root", resourceType: "p12", password: "atakatak");
////
////        self.sessionManager.delegate.sessionDidReceiveChallenge = { session, challenge in
////            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodClientCertificate {
////                return (URLSession.AuthChallengeDisposition.useCredential, self.cert.urlCredential());
////            }
////            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
////                return (URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!));
////            }
////            return (URLSession.AuthChallengeDisposition.performDefaultHandling, Optional.none);
////        }
////    }
//
//    func broadcastLocation(location: CLLocationCoordinate2D, userId: String) {
//        //speed, course, altitude, coordinate.latitude, coordinate.longitude
//
//        let message = generateCOTXml(location: location, userId: userId)
//
//        NSLog("Getting Ready to send to ALL THE THINGS")
////        sendToUDP(message: message)
//        sendToTCP(message: message)
//        //sendToWebsocket(message: message)
//        NSLog("Done broadcasting")
//    }
//
//    private func generateCOTXml(location: CLLocationCoordinate2D, userId: String) -> String {
//        let stale = Date().addingTimeInterval(fiveMinutes) //needs to be to ISOString Maybe?
//        let staleString = ISO8601DateFormatter().string(from: stale)
//        let nowString = ISO8601DateFormatter().string(from: Date())
//
//        let eventAttrs = "version=\"2.0\" " +
//        "uid=\"TS-20230704\" " +
//        "type=\"a-F-A\" " +
//        "how=\"m-g\" " +
//        "time=\"" + nowString + "\" " +
//        "start=\"" + nowString + "\" " +
//        "stale=\"" + staleString + "\""
//
//        let point = "<point " +
//        "lat=\"" + location.latitude.description + "\" " +
//        "lon=\"" + location.longitude.description + "\" " +
//        "hae=\"30.0\" " +
//        "ce=\"9999999.0\" " +
//        "le=\"9999999.0\" " +
//            "></point>"
//        let detail = "<detail><contact callsign=\"Taylor Swift\" /><remarks>TS 4 LYFE</remarks></detail>"
//
//        return "<?xml version=\"1.0\" standalone=\"yes\"?>" +
//            "<event " + eventAttrs + ">" +
//            point +
//            detail +
//            "</event>"
//    }
//
//    /*
//
//     const events = incidentJsons.map((incidentJson) => {
//         return {
//             "payload": {
//                 "event": {
//                     "_attributes": {
//                         "version": "2.0",
//                         "uid": incidentJson["id"],
//                         "type": "a-f-A",
//                         "how": "m-g",
//                         "time": new Date(Date.now()).toISOString(),
//                         "start": new Date(Date.now()).toISOString(),
//                         "stale": stale
//                     },
//                     "point": {
//                         "_attributes": {
//                             "lat": incidentJson["lat"],
//                             "lon": incidentJson["lng"],
//                             "hae": "30.0",
//                             "ce": "9999999.0",
//                             "le": "9999999.0"
//                         }
//                     },
//                     "detail": {
//                         "contact": {
//                             "_attributes": {
//                                 "callsign": incidentJson["name"]
//                             }
//                         },
//                         "remarks": "Test Remarks"
//                     }
//                 }
//
//             }
//         }
//     });
//
//     <?xml version="1.0" standalone="yes"?>
//     <event
//         version="2.0"
//         uid="J-01334"
//         type="a-h-G"
//         time="2017-10-30T11:43:38.07Z"
//         start="2017-10-30T11:43:38.07Z"
//         stale="2017-10-30T11:55:38.07Z">
//             <detail></detail>
//             <point
//                 lat="30.0090027"
//                 lon="-85.9578735"
//                 hae="1"
//                 ce="1"
//                 le="1"/>
//     </event>
//
//     */

}
