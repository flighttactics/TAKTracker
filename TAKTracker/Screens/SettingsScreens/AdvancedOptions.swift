//
//  AdvancedOptions.swift
//  TAKTracker
//
//  Created by Cory Foy on 3/25/24.
//

import Foundation
import SwiftUI

struct AdvancedOptions: View {
    var body: some View {
        NavigationLink(destination: AdvancedOptionsScreen()) {
            Text("Advanced Options")
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AdvancedOptionsScreen: View {
    var body: some View {
        List {
            DeviceOptions()
            TAKOptions()
        }
        .navigationTitle("Advanced Options")
    }
}
