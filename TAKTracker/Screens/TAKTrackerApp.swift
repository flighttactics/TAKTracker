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
    @StateObject var onboardManager: OnboardingManager = OnboardingManager()
    @StateObject var takManager: TAKManager = TAKManager()
    @StateObject var settingsStore = SettingsStore.global
    
    init() {
        TAKLogger.debug("Hello, TAK Tracker!")
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if settingsStore.hasOnboarded {
                    MainScreen()
                         .task { AppCoordinator.configure(using: settingsStore, for: .main) }
                         .onChange(of: scenePhase) { phase in
                             AppCoordinator.handleScenePhase(phase, settings: settingsStore)
                         }
                } else {
                    OnboardingView()
                        .task { AppCoordinator.configure(using: settingsStore, for: .onboarding) }
                }
            }
            .environmentObject(locationManager)
            .environmentObject(takManager)
            .environmentObject(onboardManager)
            .environmentObject(settingsStore)
            .preferredColorScheme(.dark)
        }
    }
}
