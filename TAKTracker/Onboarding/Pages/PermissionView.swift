//
//  PermissionView.swift
//  TAKTracker
//
//  Created by Craig Clayton on 10/8/25.
//

import SwiftUI

struct PermissionView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var onboardingManager: OnboardingManager

    var body: some View {
        List {
            VStack {
                VStack(spacing: 16) {
                    Text("Welcome to TAK Tracker!").bold()

                    if !onboardingManager.hasAskedPermissions {
                        Text("Let's start by granting permissions to track and broadcast your location")

                        Button("Set Location Permissions") {
                            locationManager.requestAlwaysAuthorization()
                            onboardingManager.hasAskedPermissions = true
                            onboardingManager.nextStep()   // moves enum to .userInfo
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.bottom, 20)

                    } else {
                        switch locationManager.statusString {
                        case "notDetermined":
                            Text("Requesting permissions")

                        case "authorizedWhenInUse":
                            Text("We also need to request to always track your location so it will continue to work in the background")
                            Button("Enable Background Tracking") {
                                locationManager.requestAlwaysAuthorization()
                            }
                            .buttonStyle(.borderedProminent)

                        case "authorizedAlways":
                            Text("Location Permissions granted. Now let's set up your user information")

                        default:
                            Text("No Location Permissions were granted. You will need to change this in your device settings to enable location tracking.")
                        }
                    }
                }
                .multilineTextAlignment(.center)
                .padding(.vertical)
            }
        }
    }
}

#Preview {
    PermissionView()
        .environmentObject(LocationManager())
        .environmentObject(OnboardingManager())
}
