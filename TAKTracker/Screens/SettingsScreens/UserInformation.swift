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
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.secondary)
                    Spacer()
                }
                TextField("Call Sign", text: $settingsStore.callSign)
                    .keyboardType(.asciiCapable)
            }
            .padding(.top, 20)
        }
        
        Group {
            VStack {
                HStack {
                    Text("Team")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.secondary)
                    Spacer()
                }
                Picker("Choose your team", selection: $settingsStore.team) {
                    ForEach(TAKConstants.TEAM_COLORS, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(.menu)
                HStack {
                    Text("Role")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.secondary)
                    Spacer()
                }
                Picker("Choose your role", selection: $settingsStore.role) {
                    ForEach(TAKConstants.TEAM_ROLES, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(.menu)
            }
            .padding(.top, 20)
        }
    }
}
