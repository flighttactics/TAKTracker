//
//  ConnectionOptionsView.swift
//  TAKTracker
//
//  Created by Craig Clayton on 10/9/25.
//
import SwiftUI

struct ConnectToTAKServerSheet: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("Connect to a TAK Server")
                    .font(.headline)
                Text("Configure your TAK Server connection here.")
                    .foregroundStyle(.secondary)
                Spacer()
            }
            .padding()
            .navigationTitle("Connect")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

enum ConnectionOptionsDisplayMode {
    case button
    case text
}

struct ConnectionOptionsView: View {
    var isProcessingDataPackage: Bool = false
    @EnvironmentObject var onboaringManager: OnboardingManager
    var displayMode: ConnectionOptionsDisplayMode = .button

    
    @State var isShowingAlert = false
    @State private var isPresentingConnectionOptions = false
    
    var body: some View {
        Group {
            switch displayMode {
            case .button:
                Button(action: { isPresentingConnectionOptions = true }) {
                    Text("Connect to a TAK Server")
                }
                .buttonStyle(.borderedProminent)
            case .text:
                Button(action: { onboaringManager.nextStep() }) {
                    Text("Connect to a TAK Server")
                        .foregroundStyle(.primary)
                }
                .buttonStyle(.plain)
            }

            if(SettingsStore.global.takServerUrl != "") {
                Button(role: .destructive) {
                    SettingsStore.global.clearConnection()
                    isShowingAlert = true
                } label: {
                    Text("Delete Current TAK Server Connection")
                        .foregroundStyle(.white)
                }
                .contentShape(Rectangle())
            }
        }
        .alert(isPresented: $isShowingAlert) {
            Alert(title: Text("Server Connection"), message: Text("The TAK Server Connection has been removed"), dismissButton: .default(Text("OK")))
        }
    }
}

