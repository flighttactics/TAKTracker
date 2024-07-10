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
    @StateObject var settingsStore = SettingsStore.global
    @StateObject private var dataController = DataController.shared
    
    init() {
        TAKLogger.debug("Hello, TAK Tracker!")
    }

    var body: some Scene {
        WindowGroup {
            if(!settingsStore.hasOnboarded) {
                OnboardingView(locationManager: locationManager, takManager: takManager)
                    .environmentObject(locationManager)
                    .environmentObject(takManager)
                    .environmentObject(settingsStore)
                    .environment(\.managedObjectContext, dataController.cotDataContainer.viewContext)
                    .onAppear {
                        dataController.startCleanUpTimer()
                        settingsStore.isConnectingToServer = false
                        settingsStore.connectionStatus = "Disconnected"
                        settingsStore.isConnectedToServer = false
                        settingsStore.shouldTryReconnect = false
                        settingsStore.lastAppVersionRun = AppConstants.getAppReleaseVersion()
                        UIApplication.shared.isIdleTimerDisabled = settingsStore.disableScreenSleep
                    }
            } else {
                MainScreen()
                    .environmentObject(locationManager)
                    .environmentObject(takManager)
                    .environmentObject(settingsStore)
                    .environment(\.managedObjectContext, dataController.cotDataContainer.viewContext)
                    .onAppear {
                        dataController.startCleanUpTimer()
                        settingsStore.isConnectingToServer = false
                        settingsStore.connectionStatus = "Disconnected"
                        settingsStore.isConnectedToServer = false
                        settingsStore.shouldTryReconnect = true
                        UIApplication.shared.isIdleTimerDisabled = settingsStore.disableScreenSleep
                        UIDevice.current.isBatteryMonitoringEnabled = true
                    }
                    .onChange(of: scenePhase) { newPhase in
                        if newPhase == .inactive {
                            TAKLogger.debug("[ScenePhase] Moving to inactive")
                            settingsStore.shouldTryReconnect = true
                        } else if newPhase == .active {
                            TAKLogger.debug("[ScenePhase] Moving to active")
                            settingsStore.shouldTryReconnect = true
                        } else if newPhase == .background {
                            TAKLogger.debug("[ScenePhase] Moving to background")
                            settingsStore.shouldTryReconnect = true
                        }
                    }
                    .preferredColorScheme(.dark)
                
            }
        }
    }
}
