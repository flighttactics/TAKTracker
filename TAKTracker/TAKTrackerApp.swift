//
//  TAK_SpikeApp.swift
//  TAK Spike
//
//  Created by Cory Foy on 7/3/23.
//

import SwiftUI

@main
struct TAKTrackerApp: App {
    @StateObject var settingsStore = SettingsStore()

    var body: some Scene {
        WindowGroup {
            MainScreen(manager: LocationManager())
                .environmentObject(settingsStore)
        }
    }
}
