//
//  DeviceOptions.swift
//  TAKTracker
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation
import SwiftUI

struct DeviceOptions: View {
    @StateObject var settingsStore: SettingsStore = SettingsStore.global
    
    var body: some View {
        Group {
            VStack {
                HStack {
                    Text("Disable Screen Sleep")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.secondary)
                    Spacer()
                }

                Picker(selection: $settingsStore.disableScreenSleep, label: Text("Screen Sleep Disabled"), content: {
                    Text("Yes").tag(true)
                    Text("No").tag(false)
                })
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding(.top, 20)
        }
    }
}
