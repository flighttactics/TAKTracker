//
//  ChatView.swift
//  TAKTracker
//
//  Created by Cory Foy on 7/13/23.
//

import Foundation
import SwiftUI

class ChatMessage: ObservableObject {
    @Published var message = ""
}

struct ChatView: View {
    @StateObject var chatMessage:ChatMessage
    
    //background #5b5557
    let lightGray = Color(hue: 0.94, saturation: 0.03, brightness: 0.35)
    //header: #3d3739
    let darkGray = Color(hue: 0.94, saturation: 0.05, brightness: 0.23)
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                TextField("Message", text: $chatMessage.message)
                Button("Send") {
                    TAKLogger.debug("Send")
                }
            }
            .background(darkGray)
            .foregroundColor(.white)
        }
        .background(lightGray)
        .padding()
    }
}
