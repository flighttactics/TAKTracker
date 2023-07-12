//
//  WebSocket.swift
//  TAKTracker
//
//  Created by Cory Foy on 7/11/23.
//

import Foundation
import Network

class WebSocket: NSObject, URLSessionWebSocketDelegate {
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Web Socket did connect")
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Web Socket did disconnect")
    }
    
//    func ping() {
//        self.webSocketTask.sendPing { error in
//        if let error = error {
//          print("Error when sending PING \(error)")
//        } else {
//            print("Web Socket connection is alive")
//            DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
//                self.ping()
//            }
//        }
//      }
//    }
//
//    func send() {
//        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
//            self.send()
//            self.webSocketTask.send(.string("New Message")) { error in
//              if let error = error {
//                print("Error when sending a message \(error)")
//              }
//            }
//        }
//    }
//
//
//    func receive() {
//      webSocketTask.receive { result in
//        switch result {
//        case .success(let message):
//          switch message {
//          case .data(let data):
//            print("Data received \(data)")
//          case .string(let text):
//            print("Text received \(text)")
//          }
//        case .failure(let error):
//          print("Error when receiving \(error)")
//        }
//
//          self.receive()
//      }
//    }
}
