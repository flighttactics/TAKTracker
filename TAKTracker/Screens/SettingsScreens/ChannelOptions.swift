//
//  ChannelOptions.swift
//  TAKTracker
//
//  Created by Cory Foy on 7/10/24.
//

import Foundation
import MapKit
import SwiftUI

struct ChannelOptionsDetail: View {
    @StateObject var settingsStore: SettingsStore = SettingsStore.global
    @StateObject var channelManager: ChannelManager = ChannelManager()
    @State private var isRotating = 0.0
    @State var channelState = true
    
    var body: some View {
        List {
            Text("Server Channels")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.secondary)
            if(channelManager.isLoading) {
                HStack {
                    Text("Retrieving Channels")
                    Image(systemName: "arrowshape.turn.up.right.circle")
                    .rotationEffect(.degrees(isRotating))
                    .onAppear {
                        withAnimation(.linear(duration: 1)
                                .speed(0.1).repeatForever(autoreverses: false)) {
                            isRotating = 360.0
                        }
                    }
                }
            } else if(channelManager.activeChannels.isEmpty) {
                Text("No Channels Available for \(settingsStore.takServerUrl)")
            } else {
                ForEach(channelManager.activeChannels, id:\.name) { channel in
                    VStack {
                        HStack {
                            Button {
                                channelManager.toggleChannel(channel: channel)
                            } label: {
                                if(channel.active) {
                                    Image(systemName: "eye.fill")
                                } else {
                                    Image(systemName: "eye.slash")
                                }
                                
                            }
                            Text(channel.name)
                        }
                    }
                    .padding(.top, 20)
                }
            }
        }
        .onAppear {
            channelManager.retrieveChannels()
        }
    }
}

struct ChannelOptions: View {
    var body: some View {
        NavigationLink(destination: ChannelOptionsDetail()) {
            Text("Channel Options")
        }
    }
}
