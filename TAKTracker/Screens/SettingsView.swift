//
//  SettingsView.swift
//  TAKTracker
//
//  Created by Cory Foy on 7/13/23.
//

import Foundation
import MapKit
import SwiftTAK
import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var settingsStore: SettingsStore = SettingsStore.global
    let defaultBackgroundColor = Color(UIColor.systemBackground)
    @State var isProcessingDataPackage: Bool = false

    var body: some View {
        NavigationView {
            List {
                UserInformation()
                ServerInformation()
                ConnectionOptions(isProcessingDataPackage: $isProcessingDataPackage)
                SituationalAwarenessOptions()
                AdvancedOptions()
                AboutInformation()
            }
            .navigationBarTitle("Settings")
            .navigationBarItems(trailing: Button("Dismiss", action: {
                dismiss()
            }))
        }
    }
}
