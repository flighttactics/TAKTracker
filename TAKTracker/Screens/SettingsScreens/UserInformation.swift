//
//  UserInformation.swift
//  TAKTracker
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation
import SwiftTAK
import SwiftUI

struct UserInformation: View {
    @StateObject var settingsStore: SettingsStore = SettingsStore.global
    
    var body: some View {
        Group {
            VStack {
                HStack {
                    Text("Call Sign")
                        .foregroundColor(.secondary)
                    TextField("Call Sign", text: $settingsStore.callSign)
                        .keyboardType(.asciiCapable)
                        .multilineTextAlignment(.trailing)
                }
                Picker("Choose your team", selection: $settingsStore.team) {
                    ForEach(TAKConstants.TEAM_COLORS, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(.menu)
                            .foregroundColor(.secondary)
                Picker("Choose your role", selection: $settingsStore.role) {
                    ForEach(TAKConstants.TEAM_ROLES, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(.menu)
                            .foregroundColor(.secondary)
                
            }
        }
    }
}
