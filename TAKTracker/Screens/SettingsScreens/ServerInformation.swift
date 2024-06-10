//
//  ServerInformation.swift
//  TAKTracker
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation
import SwiftUI

struct ServerInformation: View {
    @StateObject var settingsStore: SettingsStore = SettingsStore.global
    
    var body: some View {
        Group {
            VStack {
                HStack {
                    Text("Host Name")
                        .foregroundColor(.secondary)
                    TextField("Host Name", text: $settingsStore.takServerUrl)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.URL)
                        .onSubmit {
                            SettingsStore.global.takServerChanged = true
                        }
                }
            }
            
            VStack {
                HStack {
                    Text("Port")
                        .foregroundColor(.secondary)
                    TextField("Server Port", text: $settingsStore.takServerPort)
                        .keyboardType(.numberPad)
                        .onSubmit {
                            SettingsStore.global.takServerChanged = true
                        }
                }
            }
        }
        .multilineTextAlignment(.trailing)
    }
}

struct ServerInformationDisplay: View {
    @StateObject var settingsStore: SettingsStore = SettingsStore.global
    
    var body: some View {
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
