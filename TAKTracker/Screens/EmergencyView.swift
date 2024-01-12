//
//  EmergencyView.swift
//  TAKTracker
//
//  Created by Cory Foy on 7/13/23.
//

import Foundation
import MapKit
import SwiftTAK
import SwiftUI

struct EmergencyView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var takManager: TAKManager
    @EnvironmentObject var location: LocationManager

    @State var alertActivated: Bool = false
    @State var alertConfirmed: Bool = false
    @State var alertType: EmergencyType = EmergencyType.NineOneOne
    
    let defaultBackgroundColor = Color(UIColor.systemBackground)

    var body: some View {
        List {
            Text("Emergency Beacon")
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.system(size: 18, weight: .heavy))
                .listRowSeparator(.hidden)
            Text("Turn on both switches to initiate emergency beacon")
                .frame(maxWidth: .infinity, alignment: .center)
                .listRowSeparator(.hidden)
            Group {
                VStack {
                    HStack {
                        Text("Activate Alert")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    Picker(selection: $alertActivated, label: Text("Activate Alert"), content: {
                        Text("Off").tag(false)
                        Text("On").tag(true)
                    })
                    .pickerStyle(.segmented)
                    .background(alertActivated ? Color.red : defaultBackgroundColor)
                    .onAppear {
                        if(SettingsStore.global.isAlertActivated) {
                            // Default to cancelling the alert if one
                            // is active when we open the screen
                            alertType = EmergencyType.Cancel
                        }
                    }
                }
            }
            .listRowSeparator(.hidden)
            
            Group {
                VStack {
                    HStack {
                        Text("Confirm Alert")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    Picker(selection: $alertConfirmed, label: Text("Confirm Alert"), content: {
                        Text("Off").tag(false)
                        Text("On").tag(true)
                    })
                    .pickerStyle(.segmented)
                    .background(alertConfirmed ? Color.red : defaultBackgroundColor)
                }
            }
            .listRowSeparator(.hidden)
            
            Group {
                VStack {
                    HStack {
                        Text("Alert Type")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    Picker(selection: $alertType, label: Text("Alert Type"), content: {
                        ForEach(EmergencyType.allCases) { emergency_type in
                            Text(emergency_type.rawValue)
                        }
                    })
                    .pickerStyle(.menu)
                }
            }
            .listRowSeparator(.hidden)
            
            HStack {
                Spacer()
                Button("Cancel", role: .destructive) {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                
                Button("OK", role: .none) {
                    if(alertType == EmergencyType.Cancel) {
                        SettingsStore.global.activeAlertType = alertType.rawValue
                        SettingsStore.global.isAlertActivated = false
                        takManager.cancelEmergencyAlert(location: location.lastLocation)
                        TAKLogger.debug("Alert Cancelled")
                    } else {
                        SettingsStore.global.activeAlertType = alertType.rawValue
                        SettingsStore.global.isAlertActivated = true
                        takManager.initiateEmergencyAlert(location: location.lastLocation)
                        TAKLogger.debug("Alert Activated!")
                    }
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .disabled(!(alertActivated && alertConfirmed))
            }
        }
    }
}
