//
//  MessageVieww.swift
//  TAKTracker
//
//  Created by Craig Clayton on 1/4/24.
//

import SwiftUI

struct MessageView: View {
    var message: MessageData
    var viewWidth: CGFloat = 0
    
    var body: some View {
//        if message.isFromCurrentUser() {
//            OutgoingMessageView(message: message)
//        } else {
//            IncomingMessageView(message: message)
//        }
        VStack(alignment: .leading, spacing: -10) {
            if !message.isFromCurrentUser() {
                Text(message.callSign)
            }
            ZStack {
                Text(message.message)
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .background(message.isFromCurrentUser() ? Color.baseUserChatColor : Color.baseIncomingChatColor)
                    .cornerRadius(13)
                    .foregroundStyle(.primary)
            }
            .frame(width: viewWidth * 0.7, alignment: message.isFromCurrentUser() ? .trailing : .leading)
            .padding(.vertical)
            
        }
    }
}

#Preview {
    VStack {
        MessageView(message: MessageData.defaultIncomingMessage1)
        MessageView(message: MessageData.defaultOutgoingMessage1)
    }
}
