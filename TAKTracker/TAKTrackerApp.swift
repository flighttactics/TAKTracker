//
//  TAK_SpikeApp.swift
//  TAK Spike
//
//  Created by Cory Foy on 7/3/23.
//

import SwiftUI

@main
struct TAKTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            MainScreen(manager: LocationManager())
                .onAppear {
                    UIApplication.shared.isIdleTimerDisabled = SettingsStore.global.disableScreenSleep
                    SettingsStore.global.isConnectedToServer = false
                    SettingsStore.global.shouldTryReconnect = true
                }
        }
    }
}
