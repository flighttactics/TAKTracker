//
//  ConnectionOptions.swift
//  TAKTracker
//
//  Created by Cory Foy on 9/22/23.
//

import CodeScanner
import Foundation
import SwiftTAK
import SwiftUI
import AVFoundation


import SwiftUI

enum ConnectionOptions: String, CaseIterable, Hashable {
    case enrollment        = "Certificate Enrollment"
    case scanQRCode        = "Scan QR Code"
    case uploadDataPackage = "Upload a Data Package"
}

struct ConnectionOptionsScreen: View {
    @Binding var selected: ConnectionOptions?   // ← single selection now
    var onSkip: () -> Void = {}

    var body: some View {
        VStack(spacing: 12) {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Choose your connection method:")
                            .font(.headline)

                        VStack(spacing: 12) {
                            ForEach(ConnectionOptions.allCases, id: \.self) { option in
                                CapsuleListButton(option: option, selection: $selected)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }

                if let choice = selected {
                    Section {
                        Text("Selected: \(choice.rawValue)")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .listStyle(.insetGrouped)

            // Optional skip row
            if selected == nil {
                Button("Skip for now") { onSkip() }
                    .padding(.bottom, 8)
            }
        }
    }

    private func select(_ option: ConnectionOptions) {
        // Single-selection: tap again to deselect
        selected = (selected == option) ? nil : option
    }
}
