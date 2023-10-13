//
//  ChatView.swift
//  TAKTracker
//
//  Created by Cory Foy on 7/13/23.
//

import Foundation
import SwiftUI

enum BubblePosition {
    case left
    case right
}

struct ChatBubble<Content>: View where Content: View {
    let position: BubblePosition
    let color : Color
    let content: () -> Content
    init(position: BubblePosition, color: Color, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.color = color
        self.position = position
    }
    
    var body: some View {
        HStack(spacing: 0 ) {
            content()
                .padding(.all, 15)
                .foregroundColor(Color.white)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .overlay(
                    Image(systemName: "arrowtriangle.left.fill")
                        .foregroundColor(color)
                        .rotationEffect(Angle(degrees: position == .left ? -50 : -130))
                        .offset(x: position == .left ? -5 : 5)
                    ,alignment: position == .left ? .bottomLeading : .bottomTrailing)
        }
        .padding(position == .left ? .leading : .trailing , 15)
        .padding(position == .right ? .leading : .trailing , 60)
        .frame(width: UIScreen.main.bounds.width, alignment: position == .left ? .leading : .trailing)
    }
}

struct ChatView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.timestamp, order: .reverse)]) var messages: FetchedResults<ChatMessage>
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    
    @State var chatMessage: String = ""
    
    func send() {
        if(chatMessage.isEmpty) {
            return
        }
        
        let msg = ChatMessage(context: managedObjectContext)
        msg.group = "All Chat Rooms"
        msg.sender = SettingsStore.global.callSign
        msg.message = chatMessage
        msg.timestamp = Date()
        PersistenceController.shared.save()
        TAKLogger.debug("Saved")
        chatMessage = ""
    }
    
    
    //background #5b5557
    let lightGray = Color(hue: 0.94, saturation: 0.03, brightness: 0.35)
    //header: #3d3739
    let darkGray = Color(hue: 0.94, saturation: 0.05, brightness: 0.23)
    
    var body: some View {
        NavigationView {
            VStack {
                List(messages) { message in
                    let fromUs = (message.sender == SettingsStore.global.callSign)
                    let bubblePos = fromUs ? BubblePosition.right : BubblePosition.left
                    let bubbleCol = fromUs ? Color.green : Color.gray
                    if(!fromUs) {
                        Text(message.sender ?? "Unknown")
                    }
                    ChatBubble(position: bubblePos, color: bubbleCol) {
                        Text(message.message ?? "Unknown")
                    }
                    .scaleEffect(x: 1, y: -1, anchor: .center)
                }
                .listRowSeparator(.hidden)
                .scaleEffect(x: 1, y: -1, anchor: .center)
                .offset(x: 0, y: 2)
                
                HStack {
                    TextField("Type a message", text: $chatMessage)
                    Button(action: self.send) {
                        Text("Send")
                    }
                }.padding()
            }
            .navigationBarItems(leading: Text("TAK Chat"), trailing: Button("Dismiss", action: {
                dismiss()
            }))
        }
    }
}
