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
                    Text("Server Address")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.secondary)
                    Spacer()
                }
                TextField("Server Address", text: $settingsStore.takServerUrl)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.URL)
                    .onSubmit {
                        SettingsStore.global.takServerChanged = true
                    }
            }
            .padding(.top, 20)
        }

        Group {
            VStack {
                HStack {
                    Text("Server Port")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.secondary)
                    Spacer()
                }
                TextField("Server Port", text: $settingsStore.takServerPort)
                    .keyboardType(.numberPad)
                    .onSubmit {
                        SettingsStore.global.takServerChanged = true
                    }
            }
            .padding(.top, 20)
        }
    }
}
