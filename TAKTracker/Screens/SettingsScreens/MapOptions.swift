//
//  MapOptions.swift
//  TAKTracker
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation
import MapKit
import SwiftUI

struct MapOptions: View {
    @StateObject var settingsStore: SettingsStore = SettingsStore.global
    
    var body: some View {
        Group {
            VStack {
                HStack {
                    Text("Map Type")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.secondary)
                    Spacer()
                }
                Picker(selection: $settingsStore.mapTypeDisplay, label: Text("Map Type"), content: {
                    Text("Standard").tag(MKMapType.standard.rawValue)
                    Text("Hybrid").tag(MKMapType.hybrid.rawValue)
                    Text("Satellite").tag(MKMapType.satellite.rawValue)
                    Text("Flyover").tag(MKMapType.hybridFlyover.rawValue)
                })
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding(.top, 20)
        }
    }
}
