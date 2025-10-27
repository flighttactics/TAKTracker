//
//  ServerPageView.swift
//  TAKTracker
//
//  Created by Craig Clayton on 10/8/25.
//

import SwiftUI

struct ServerPageView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var onboardingManager: OnboardingManager

    @State private var isProcessingDataPackage = false

    var body: some View {
        List {
            VStack(alignment: .center, spacing: 16) {
                Text("Would you like to connect to a TAK Server?")
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .font(.headline)

                Button("Connect to a TAK Server") {
                    // Option A: use the manager’s linear nextStep (server → connections)
                    onboardingManager.nextStep()

                    // Option B (equivalent): jump explicitly
                    // onboardingManager.currentStep = .connections
                }
                .buttonStyle(.borderedProminent)

                if let status = serverStatusText {
                    Text(status)
                }

                Text("You can add a server later in Settings")
                    .foregroundColor(.secondary)
                    .padding(.bottom, 15)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }

    private var serverStatusText: String? {
        if isProcessingDataPackage {
            return "Processing Data Package..."
        } else if !SettingsStore.global.takServerUrl.isEmpty {
            return "Configured TAK Server \(SettingsStore.global.takServerUrl)"
        } else {
            return nil
        }
    }
}


#Preview {
    ServerPageView()
}


