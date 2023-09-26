//
//  TAK_SpikeApp.swift
//  TAK Spike
//
//  Created by Cory Foy on 7/3/23.
//

import SwiftUI

@main
struct TAKTrackerApp: App {
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject var locationManager: LocationManager = LocationManager()
    @StateObject var takManager: TAKManager = TAKManager()
    
    init() {
        TAKLogger.debug("Hello, TAK Tracker!")
        SettingsStore.global.isConnectingToServer = false
        SettingsStore.global.isConnectedToServer = false
        SettingsStore.global.shouldTryReconnect = true
        SettingsStore.global.connectionStatus = "Disconnected"
    }

    var body: some Scene {
        WindowGroup {
            if(!SettingsStore.global.hasOnboarded) {
                OnboardingView(locationManager: locationManager, takManager: takManager)
            } else {
                MainScreen(manager: locationManager, takManager: takManager)
                    .onAppear {
                        UIApplication.shared.isIdleTimerDisabled = SettingsStore.global.disableScreenSleep
                        SettingsStore.global.isConnectedToServer = false
                        SettingsStore.global.shouldTryReconnect = true
                        UIDevice.current.isBatteryMonitoringEnabled = true
                    }
                    .onChange(of: scenePhase) { newPhase in
                        if newPhase == .inactive {
                            TAKLogger.debug("[ScenePhase] Moving to inactive")
                            SettingsStore.global.shouldTryReconnect = true
                        } else if newPhase == .active {
                            TAKLogger.debug("[ScenePhase] Moving to active")
                            SettingsStore.global.shouldTryReconnect = true
                        } else if newPhase == .background {
                            TAKLogger.debug("[ScenePhase] Moving to background")
                            SettingsStore.global.shouldTryReconnect = true
                        }
                    }
            }
        }
    }
}
