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
    @StateObject var settingsStore: SettingsStore = SettingsStore.global
    let defaultBackgroundColor = Color(UIColor.systemBackground)
    @State var isProcessingDataPackage: Bool = false

    var body: some View {
        List {
            UserInformation()
            ServerInformation()
            ConnectionOptions(isProcessingDataPackage: $isProcessingDataPackage)
            DeviceOptions()
            AdvancedModeToggle()
            
            if(settingsStore.enableAdvancedMode) {
                MapOptions()
                TAKOptions()
            }
            AboutInformation()
        }
    }
}
