//
//  AppCoordinator.swift
//  TAKTracker
//
//  Created by Craig Clayton on 10/8/25.
//

import SwiftUI

enum AppMode { case onboarding, main }

enum AppCoordinator {
    static func configure(using s: SettingsStore, for mode: AppMode) {
        s.isConnectingToServer = false
        s.connectionStatus = "Disconnected"
        s.isConnectedToServer = false
        s.shouldTryReconnect = true
        UIApplication.shared.isIdleTimerDisabled = s.disableScreenSleep
        s.lastAppVersionRun = AppConstants.getAppReleaseVersion()
        
        switch mode {
        case .onboarding:
            s.shouldTryReconnect = false
            UIDevice.current.isBatteryMonitoringEnabled = false
        case .main:
            s.shouldTryReconnect = true
            UIDevice.current.isBatteryMonitoringEnabled = true
        }
    }
    
    static func handleScenePhase(_ phase: ScenePhase, settings s: SettingsStore) {
        switch phase {
        case .active:       TAKLogger.debug("[ScenePhase] Moving to active")
        case .inactive:     TAKLogger.debug("[ScenePhase] Moving to inactive")
        case .background:   TAKLogger.debug("[ScenePhase] Moving to background")
        @unknown default:   TAKLogger.debug("[ScenePhase] Moving to unknown")
        }
        
        s.shouldTryReconnect = true
    }
}
