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
    @StateObject var chatMessage:ChatMessage = ChatMessage()
    @StateObject var takManager: TAKManager
    
    //background #5b5557
    let lightGray = Color(hue: 0.94, saturation: 0.03, brightness: 0.35)
    //header: #3d3739
    let darkGray = Color(hue: 0.94, saturation: 0.05, brightness: 0.23)
    
    var body: some View {
        VStack {
            if(!takManager.chatMessages.isEmpty) {
                List {
                    ForEach(takManager.chatMessages, id: \.self) { msg in
                        Text(msg)
                    }
                }
            }
            Spacer()
            HStack {
                TextField("Message", text: $chatMessage.message)
                Button("Send") {
                    TAKLogger.debug("Send")
                    takManager.sendChatMessage(message: chatMessage.message)
                }
            }
            .background(darkGray)
            .foregroundColor(.white)
        }
        .background(lightGray)
        .padding()
    }
}

/**
 From: https://github.com/deptofdefense/AndroidTacticalAssaultKit-CIV/blob/22d11cba15dd5cfe385c0d0790670bc7e9ab7df4/commoncommo/core/atakcotcaptures.txt#L4
    - Non-Chat UDP Port 6969
    - Chat UDP Port 17012
    UIDs in  messages are for the message.
    They don't identify the event originator. Only consider unique
    id for a contact if the contact info is present.
 */

/**
 From https://github.com/deptofdefense/AndroidTacticalAssaultKit-CIV/blob/22d11cba15dd5cfe385c0d0790670bc7e9ab7df4/commoncommo/core/atakcotcaptures.txt#L357
 <?xml version='1.0' encoding='UTF-8' standalone='yes'?>
 <event version='2.0' uid='GeoChat.ANDROID-88:32:9B:40:EC:D0.All Chat Rooms.b4936fac-b0ca-4fd3-892d-35596f0dc749'
                      type='b-t-f' time='2015-11-02T13:30:10.794Z'
                      start='2015-11-02T13:30:10.794Z' stale='2015-11-03T13:30:10.794Z'
                      how='h-g-i-g-o'>
                <point lat='0.0' lon='0.0' hae='9999999.0' ce='9999999' le='9999999' />
        <detail>
              <__chat id='All Chat Rooms' chatroom='All Chat Rooms'>
                   <chatgrp id='All Chat Rooms' uid0='ANDROID-88:32:9B:40:EC:D0' uid1='All Chat Rooms'/>
              </__chat>
              <link relation='p-p' type='a-f-G-U-C' uid='ANDROID-88:32:9B:40:EC:D0'/>
              <remarks source='BAO.F.ATAK.ANDROID-88:32:9B:40:EC:D0'
                       time='2015-11-02T13:30:10.794Z'>Roger</remarks>
              <__serverdestination destinations='192.168.79.115:4242:tcp:ANDROID-88:32:9B:40:EC:D0'/>
              <precisionlocation geopointsrc='???' altsrc='???'/>
        </detail>
 </event>
 */
