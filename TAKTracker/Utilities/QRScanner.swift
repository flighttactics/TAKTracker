//
//  QRScanner.swift
//  TAKTracker
//
//  Created by Craig Clayton on 10/17/25.
//

import SwiftUI
import CodeScanner
import AVFoundation



struct QRScanner: View {
    @Environment(\.dismiss) private var dismiss

    /// Called with the scanned QR string. The sheet auto-dismisses after calling this.
    let onResult: (String) -> Void
    var onDone: () -> Void = {}
    var onAutoSubmitEnroll: () -> Void = {}
    @State private var isAuthorized = false
    @State private var hasDeterminedAuth = false

    var body: some View {
        Group {
            if isAuthorized {
                NavigationView {
                    CodeScannerView(
                        codeTypes: [.qr],
                        showViewfinder: true,
                        simulatedData: "MyTAK,tak.example.com,8089,SSL",
                        shouldVibrateOnSuccess: true,
                        videoCaptureDevice: AVCaptureDevice.zoomedCameraForQRCode()
                    ) { response in
                        if case let .success(result) = response {
                            onResult(result.string)
                            dismiss()
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Cancel") { dismiss() }
                        }
                    }
                }
            } else if hasDeterminedAuth {
                VStack(spacing: 16) {
                    Text("Camera access is required to scan a QR code.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                    HStack(spacing: 12) {
                        Button("Open Settings") {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                            }
                        }
                        Button("Cancel") { dismiss() }
                    }
                }
                .padding()
            } else {
                ProgressView("Requesting Camera Access…")
            }
        }
        .task {
            await checkOrRequestAuthorization()
        }
    }
}

// MARK: - Camera Authorization
private extension QRScanner {
    func checkOrRequestAuthorization() async {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            isAuthorized = true
            hasDeterminedAuth = true
        case .notDetermined:
            await withCheckedContinuation { continuation in
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    DispatchQueue.main.async {
                        self.isAuthorized = granted
                        self.hasDeterminedAuth = true
                        continuation.resume()
                    }
                }
            }
        default:
            isAuthorized = false
            hasDeterminedAuth = true
        }
    }
}
