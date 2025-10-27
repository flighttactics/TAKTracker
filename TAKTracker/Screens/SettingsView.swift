//
//  SettingsView.swift
//  TAKTracker
//
//  Created by Cory Foy on 7/13/23.
//

import Foundation
import MapKit
import SwiftTAK
import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var settingsStore: SettingsStore = SettingsStore.global
    let defaultBackgroundColor = Color(UIColor.systemBackground)
    @State var isProcessingDataPackage: Bool = false
    var teamColor: TeamColor? { TeamColor(rawValue: settingsStore.team) }

    var body: some View {
        NavigationView {
            List {
                Section(header:
                            Text("User Information")
                    .font(.system(size: 14, weight: .medium))
                ) {
                    NavigationLink(destination: UserInformation()) {
                        HStack {
                            Circle()
                                .fill(teamColor?.color ?? .secondary)
                                .frame(width: 20, height: 20)
                            Text(settingsStore.callSign)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section(header:
                            Text("Server Information")
                    .font(.system(size: 14, weight: .medium))
                ) {
                    NavigationLink(destination: ServerInformationDisplay()) {
                        Text(settingsStore.takServerUrl.isEmpty ? "takserver.takps.org" : settingsStore.takServerUrl)
                    }
                }
                
                Section {
                    ConnectionOptionsView(displayMode: .button)
                }
                
                Section {
                    SituationalAwarenessOptions()
                    AdvancedOptions()
                    AboutInformation()
                }
            }
            .navigationBarTitle("Settings")
            .navigationBarItems(trailing: Button("Dismiss", action: {
                dismiss()
            }))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

