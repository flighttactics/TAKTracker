//
//  CertEnrollmentScreen.swift
//  TAKTracker
//
//  Created by Craig Clayton on 10/9/25.
//
import SwiftUI
import CodeScanner
import Foundation
import SwiftTAK
import AVFoundation
import Combine


struct CertEnrollmentScreen: View {
    @Binding var form: CertForm
    var statusText: String
    var showContinue: Bool
    var onScanTapped: () -> Void = {}
    var onSubmitTapped: () -> Void = {}
    var onContinue: () -> Void = {}

    @State private var showPassword = false
        

    var body: some View {
        VStack(spacing: 0) {
            Form {
                Section("Server Options") {
                    labeledField("Host Name") {
                        TextField("Host Name", text: $form.serverURL)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.URL)
                    }
                    labeledField("Username") {
                        TextField("Username", text: $form.username)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.asciiCapable)
                    }
                    labeledField("Password") {
                        HStack(spacing: 8) {
                            Group {
                                if showPassword {
                                    TextField("Password", text: $form.password)
                                } else {
                                    SecureField("Password", text: $form.password)
                                }
                            }
                            Button {
                                showPassword.toggle()
                            } label: {
                                Image(systemName: showPassword ? "eye" : "eye.slash")
                                    .foregroundStyle(.secondary)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                Section("Advanced Options") {
                    labeledField("Port") {
                        TextField("Server Port", text: $form.serverPort)
                            .keyboardType(.numberPad)
                    }
                    labeledField("Cert Enroll Port") {
                        TextField("Cert Enroll Port", text: $form.csrPort)
                            .keyboardType(.numberPad)
                    }
                    labeledField("Secure API Port") {
                        TextField("Secure API Port", text: $form.secureApiPort)
                            .keyboardType(.numberPad)
                    }
                }
            }

            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    if showContinue {
                        Button("Continue", action: onContinue)
                            .buttonStyle(.borderedProminent)
                    } else {
                        Button("Scan QR", action: onScanTapped)
                        Button("Start Enrollment", action: onSubmitTapped)
                    }
                }
                .buttonStyle(.borderedProminent)

                Text(statusText)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 12)
        }
    }

    @ViewBuilder
    private func labeledField<Content: View>(_ label: String, @ViewBuilder _ field: () -> Content) -> some View {
        HStack {
            Text(label).foregroundStyle(.secondary)
            field()
                .multilineTextAlignment(.trailing)
        }
    }
}


struct CertForm: Equatable {
    var serverURL = ""
    var serverPort = ""
    var username = ""
    var password = ""
    var csrPort = ""
    var secureApiPort = ""

    static func fromSettings(_ s: SettingsStore) -> CertForm {
        CertForm(serverURL: s.takServerUrl,
                 serverPort: s.takServerPort,
                 username: s.takServerUsername,
                 password: s.takServerPassword,
                 csrPort: s.takServerCSRPort,
                 secureApiPort: s.takServerSecureAPIPort)
    }
}

import SwiftUI
import CodeScanner
import AVFoundation
import SwiftTAK

final class EnrollmentVM: ObservableObject {
    @Published var statusText: String = "Status: Idle"
    @Published var succeeded: Bool = false

    let settings = SettingsStore.global
    let csr = CSRRequestor()

    private var cancelBag = Set<AnyCancellable>() // if you use Combine; else remove

    init() {
        // If CSRRequestor exposes a publisher or KVO, wire it here.
        // For illustration, we’ll poll its status in a simple way:
        // Replace with your real observation.
        // You can also expose csr.enrollmentStatus directly.
    }

    func submit(form: CertForm) {
        settings.takServerUrl           = form.serverURL
        settings.takServerPort          = form.serverPort
        settings.takServerUsername      = form.username
        settings.takServerPassword      = form.password
        settings.takServerCSRPort       = form.csrPort
        settings.takServerSecureAPIPort = form.secureApiPort

        csr.beginEnrollment()
        statusText = "Status: \(csr.enrollmentStatus.description)"
        // If CSRRequestor updates `enrollmentStatus` async, update `statusText`
        // in whatever callback it provides; when success:
        if csr.enrollmentStatus == .Succeeded {
            succeeded = true
            statusText = "Status: Succeeded"
        }
    }
}

