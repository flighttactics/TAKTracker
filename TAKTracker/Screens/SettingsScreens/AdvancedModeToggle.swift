//
//  AdvancedModeToggle.swift
//  TAKTracker
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation
import SwiftUI

struct AdvancedModeToggle: View {
    @StateObject var settingsStore: SettingsStore = SettingsStore.global
    
    var body: some View {
        Group {
            VStack {
                HStack {
                    Text("Enable Map Display")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.secondary)
                    Spacer()
                }

                Picker(selection: $settingsStore.enableAdvancedMode, label: Text("Map Display"), content: {
                    Text("On").tag(true)
                    Text("Off").tag(false)
                })
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding(.top, 20)
        }
    }
}
