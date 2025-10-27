//
//  ServerInformationDisplay.swift
//  TAKTracker
//
//  Created by Craig Clayton on 10/17/25.
//
import Foundation
import SwiftTAK
import SwiftUI

struct ServerInformationDisplay: View {
    @StateObject var settingsStore: SettingsStore = SettingsStore.global
    
    var body: some View {
        NavigationView {
            List {
                Group {
                    VStack {
                        HStack {
                            Text("Host Name")
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(settingsStore.takServerUrl)
                        }
                    }
                    
                    VStack {
                        HStack {
                            Text("Port")
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(settingsStore.takServerPort)
                        }
                    }
                }
                .multilineTextAlignment(.trailing)
            }
        }
    }
}
