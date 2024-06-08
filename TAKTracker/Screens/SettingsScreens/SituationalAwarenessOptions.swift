//
//  SituationalAwarenessOptions.swift
//  TAKTracker
//
//  Created by Cory Foy on 3/25/24.
//

import Foundation
import SwiftUI

struct SituationalAwarenessOptions: View {
    var body: some View {
        NavigationLink(destination: SituationalAwarenessScreen()) {
            Text("Situational Awareness")
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SituationalAwarenessScreen: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var settingsStore: SettingsStore = SettingsStore.global
    
    var body: some View {
        List {
            AdvancedModeToggle()
            if(settingsStore.enableAdvancedMode) {
                MapOptions()
            }
        }
        .navigationTitle("Situational Awareness")
    }
}
