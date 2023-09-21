//
//  AlertView.swift
//  TAKTracker
//
//  Created by Cory Foy on 7/13/23.
//

import Foundation
import SwiftUI

struct AlertView: View {
    @Environment(\.dismiss) var dismiss
    @State var alertActivated: Bool = false
    @State var alertConfirmed: Bool = false
    @State var alertType: String = "Cancel"
    
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
                    .background(alertActivated ? Color.red : Color.white)
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
                    .background(alertConfirmed ? Color.red : Color.white)
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
                        Text("911 Alert").tag("911 Alert")
                        Text("In Contact").tag("In Contact")
                        Text("Cancel Alert").tag("Cancel Alert")
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
                    if(alertType == "Cancel Alert") {
                        SettingsStore.global.activeAlertType = alertType
                        SettingsStore.global.isAlertActivated = false
                        TAKLogger.debug("Alert Cancelled")
                    } else {
                        SettingsStore.global.activeAlertType = alertType
                        SettingsStore.global.isAlertActivated = true
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
