//
//  TAKOptions.swift
//  TAKTracker
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation
import SwiftUI

struct TAKOptions: View {
    @StateObject var settingsStore: SettingsStore = SettingsStore.global
    
    @State private var numberFormatter: NumberFormatter = {
        var nf = NumberFormatter()
        nf.numberStyle = .decimal
        return nf
    }()
    
    var body: some View {
        Group {
            VStack {
                HStack {
                    Text("Broadcast Interval (sec)")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.secondary)
                    Spacer()
                }
                TextField("Broadcast Interval", value: $settingsStore.broadcastIntervalSeconds,
                          formatter: numberFormatter)
                .keyboardType(.decimalPad)
            }
            .padding(.top, 20)
        }
        
        Group {
            VStack {
                HStack {
                    Text("Stale Time (mins)")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.secondary)
                    Spacer()
                }
                TextField("Stale Time",
                          value: $settingsStore.staleTimeMinutes,
                          formatter: numberFormatter)
                .keyboardType(.decimalPad)
            }
            .padding(.top, 20)
        }
    }
}
