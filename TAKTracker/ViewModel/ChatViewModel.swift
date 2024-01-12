//
//  ChatViewModel.swift
//  TAKTracker
//
//  Created by Craig Clayton on 1/4/24.
//

import Foundation

class ChatViewModel: ObservableObject {
    @Published var messages: [MessageData] = []
    
    init(messages: [MessageData] = []) {
        self.messages = ChatViewModel.data
    }
    
    static let data = [
        MessageData.defaultOutgoingMessage1,
        MessageData.defaultIncomingMessage1,
        MessageData.defaultIncomingMessage2,
        MessageData.defaultOutgoingMessage2,
        MessageData.defaultOutgoingMessage3,
        MessageData.defaultIncomingMessage3
    ]
    
    func send(_ message: String) {
        print(message)
    }
}
