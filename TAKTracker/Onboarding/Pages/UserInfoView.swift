//
//  UserInfoView.swift
//  TAKTracker
//
//  Created by Craig Clayton on 10/8/25.
//

import SwiftUI
import SwiftTAK

enum UserInfoSettings {
    case phoneNumber
    case additionalInfo
    case all
}

struct UserInfoView: View {
    @EnvironmentObject var settingsStore: SettingsStore
    let type: UserInfoSettings

    init(type: UserInfoSettings = .all) { self.type = type }
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Spacer()
                    Text("User Information")
                        .font(.headline).fontWeight(.semibold)
                    Spacer()
                }
                .listRowSeparator(.hidden)
                
                HStack {
                    Text("Call Sign")
                        .foregroundColor(.secondary)
                    Spacer()
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
                
                if type == .all || type == .phoneNumber {
                    HStack {
                        Text("Phone Number")
                            .foregroundColor(.secondary)
                        Spacer()
                        TextField("Phone Number", text: $settingsStore.phoneNumber)
                            .keyboardType(.phonePad)
                            .multilineTextAlignment(.trailing)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .frame(maxWidth: 200)
                    }
                }
                if type == .all || type == .additionalInfo {
                    Section {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Additional Information")
                                .foregroundColor(.secondary)
                            
                            ZStack(alignment: .topLeading) {
                                if settingsStore.additionalInformation.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    
                                    Text("Add any notes, capabilities, or relevant details…")
                                        .foregroundColor(.secondary.opacity(0.5))
                                        .padding(.horizontal, 2)
                                        .padding(.vertical, 10)
                                }
                                TextEditor(text: $settingsStore.additionalInformation)
                                    .opacity(1) // ensure visible when not empty
                                    .scrollContentBackground(.hidden)
                            }
                            .frame(minHeight: 80)
                            .background(Color(uiColor: .secondarySystemBackground))
                            .cornerRadius(8)
                            .padding(.top, 4)
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    UserInfoView(type: .all)
}
