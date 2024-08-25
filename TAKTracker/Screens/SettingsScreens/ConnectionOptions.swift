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

func didDismissCertEnrollment() {
    // Clean up the variables
    let settingsStore = SettingsStore.global
    settingsStore.serverCertificate = Data()
    settingsStore.serverCertificatePassword = ""
    settingsStore.takServerPassword = ""
    settingsStore.takServerUsername = ""
}

struct DataPackageEnrollment: View {
    @Binding var isProcessingDataPackage: Bool
    @StateObject var settingsStore: SettingsStore = SettingsStore.global

    @State var isShowingFilePicker = false
    @State var isShowingAlert = false
    @State var alertText: String = ""
    
    var body: some View {
        Group {
            VStack(alignment: .center) {
                HStack {
                    Button {
                        isShowingFilePicker.toggle()
                    } label: {
                        HStack {
                            Text("Connect with a Data Package")
                            Spacer()
                            Image(systemName: "square.and.arrow.up")
                                .multilineTextAlignment(.trailing)
                        }
                        .contentShape(Rectangle())
                        
                    }
                    .buttonStyle(.plain)
                    .fileImporter(isPresented: $isShowingFilePicker, allowedContentTypes: [.zip], allowsMultipleSelection: false, onCompletion: { results in
                        switch results {
                        case .success(let fileurls):
                            isProcessingDataPackage = true
                            for fileurl in fileurls {
                                if(fileurl.startAccessingSecurityScopedResource()) {
                                    TAKLogger.debug("Processing Package at \(String(describing: fileurl))")
                                    let tdpp = TAKDataPackageParser(
                                        fileLocation: fileurl
                                    )
                                    tdpp.parse()
                                    fileurl.stopAccessingSecurityScopedResource()
                                    isProcessingDataPackage = false
                                    if(tdpp.parsingErrors.isEmpty) {
                                        alertText = "Data package processed successfully!"
                                    } else {
                                        alertText = "Data package could not be processed\n\n\(tdpp.parsingErrors.joined(separator: "\n\n"))"
                                    }
                                    isShowingAlert = true
                                } else {
                                    TAKLogger.error("Unable to securely access  \(String(describing: fileurl))")
                                }
                            }
                            isProcessingDataPackage = false
                        case .failure(let error):
                            isProcessingDataPackage = false
                            TAKLogger.debug(String(describing: error))
                        }
                        
                    })
                }
            }
        }
        .alert(isPresented: $isShowingAlert) {
            Alert(title: Text("Data Package"), message: Text(alertText), dismissButton: .default(Text("OK")))
        }
    }
}

struct ConnectionOptions: View {
    @Binding var isProcessingDataPackage: Bool
    @State var isShowingAlert = false
    
    var body: some View {
        Group {
            NavigationLink(destination: ConnectionOptionsScreen(isProcessingDataPackage: $isProcessingDataPackage)) {
                Text("Connect to a TAK Server")
            }
            if(SettingsStore.global.takServerUrl != "") {
                Button(role: .destructive) {
                    SettingsStore.global.clearConnection()
                    isShowingAlert = true
                } label: {
                    Text("Delete Current TAK Server Connection")
                }
                .contentShape(Rectangle())
            }
        }
        .alert(isPresented: $isShowingAlert) {
            Alert(title: Text("Server Connection"), message: Text("The TAK Server Connection has been removed"), dismissButton: .default(Text("OK")))
        }
    }
}

struct ConnectionOptionsScreen: View {
    @Binding var isProcessingDataPackage: Bool
    
    @State var isShowingFilePicker = false
    @State var isShowingAlert = false
    @State var alertText: String = ""

    var body: some View {
        VStack {
            Text("Choose a connection method:")
            Group {
                NavigationLink(destination: CertEnrollmentScreen(isProcessingDataPackage: $isProcessingDataPackage)) {
                    Text("Certificate Enrollment")
                }
                
                NavigationLink(destination: CertEnrollmentScreen(
                    isProcessingDataPackage: $isProcessingDataPackage,
                    isPresentingQRScanner: true
                )) {
                    Text("Scan QR code")
                }

                Button {
                    isShowingFilePicker.toggle()
                } label: {
                    Text("Upload a Data Package")
                }
                .fileImporter(isPresented: $isShowingFilePicker, allowedContentTypes: [.zip], allowsMultipleSelection: false, onCompletion: { results in
                    switch results {
                    case .success(let fileurls):
                        isProcessingDataPackage = true
                        for fileurl in fileurls {
                            if(fileurl.startAccessingSecurityScopedResource()) {
                                TAKLogger.debug("Processing Package at \(String(describing: fileurl))")
                                let tdpp = TAKDataPackageParser(
                                    fileLocation: fileurl
                                )
                                tdpp.parse()
                                fileurl.stopAccessingSecurityScopedResource()
                                isProcessingDataPackage = false
                                if(tdpp.parsingErrors.isEmpty) {
                                    alertText = "Data package processed successfully!"
                                } else {
                                    alertText = "Data package could not be processed\n\n\(tdpp.parsingErrors.joined(separator: "\n\n"))"
                                }
                                isShowingAlert = true
                            } else {
                                TAKLogger.error("Unable to securely access  \(String(describing: fileurl))")
                            }
                        }
                        isProcessingDataPackage = false
                    case .failure(let error):
                        isProcessingDataPackage = false
                        TAKLogger.debug(String(describing: error))
                    }
                })
                // NavigationLink(destination: OAuthEnrollmentStart()) {
                //     Text("Sit(X) OAuth")
                // }
            }
            .buttonStyle(.borderedProminent)
        }
        .alert(isPresented: $isShowingAlert) {
            Alert(title: Text("Data Package"), message: Text(alertText), dismissButton: .default(Text("OK")))
        }
    }
}

struct CertEnrollmentScreen: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var settingsStore: SettingsStore = SettingsStore.global
    @StateObject var csrRequest: CSRRequestor = CSRRequestor()
    @Binding var isProcessingDataPackage: Bool
    
    @State var isPresentingQRScanner = false
    @State var qrCodeResult: String = ""
    @State var shouldShowQRCodeFailureAlert = false
    @State var isShowingPassword = false
    
    @State var formServerURL = ""
    @State var formServerPort = ""
    @State var formUsername = ""
    @State var formPassword = ""
    @State var formCSRPort = ""
    @State var formSecureAPIPort = ""
    
    var isAuthorized: Bool {
        get {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            
            // Determine if the user previously authorized camera access.
            var isAuthorized = status == .authorized
            
            // If the system hasn't determined the user's authorization status,
            // explicitly prompt them for approval.
            if status == .notDetermined {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { accessGranted in
                    guard accessGranted == true else { return }
                    isAuthorized = status == .authorized
                    isPresentingQRScanner = true
                })
            }
            
            return isAuthorized
        }
    }


    func setUpCaptureSession() {
        if isAuthorized {
            isPresentingQRScanner = true
        } else {
            TAKLogger.debug("[ConnectionOptions]: Camera Unauthorized")
        }
    }
    
    func processQRCode(_ scannedString: String) {
        TAKLogger.debug("[ConnectionOptions] Parsing QR code \(scannedString)")
        let response = QRCodeParser.parse(scannedString)
        if(response.wasInvalidString) {
            shouldShowQRCodeFailureAlert = true
            return
        }
        
        formServerURL = response.serverURL
        formServerPort = response.serverPort
        formUsername = response.username
        formPassword = response.password
        
        if(response.shouldAutoSubmit) {
            submitCertEnrollmentForm()
        }
    }
    
    func submitCertEnrollmentForm() {
        settingsStore.takServerUrl = formServerURL
        settingsStore.takServerPort = formServerPort
        settingsStore.takServerUsername = formUsername
        settingsStore.takServerPassword = formPassword
        settingsStore.takServerCSRPort = formCSRPort
        settingsStore.takServerSecureAPIPort = formSecureAPIPort
        csrRequest.beginEnrollment()
    }
    
    var body: some View {
        VStack {
            List {
                Group {
                    Section(header:
                                Text("Server Options")
                        .font(.system(size: 14, weight: .medium))
                    ) {
                        VStack {
                            HStack {
                                Text("Host Name")
                                    .foregroundColor(.secondary)
                                TextField("Host Name", text: $formServerURL)
                                    .autocorrectionDisabled(true)
                                    .textInputAutocapitalization(.never)
                                    .keyboardType(.URL)
                            }
                        }
                        VStack {
                            HStack {
                                Text("Username")
                                    .foregroundColor(.secondary)
                                TextField("Username", text: $formUsername)
                                    .autocorrectionDisabled(true)
                                    .textInputAutocapitalization(.never)
                                    .keyboardType(.asciiCapable)
                            }
                        }
                        VStack {
                            HStack {
                                Text("Password")
                                    .foregroundColor(.secondary)
                                if isShowingPassword {
                                    Image(systemName: "eye")
                                        .onTapGesture {
                                            isShowingPassword.toggle()
                                        }
                                        .foregroundColor(.secondary)
                                    TextField("Password", text: $formPassword)
                                } else {
                                    Image(systemName: "eye.slash")
                                        .onTapGesture {
                                            isShowingPassword.toggle()
                                        }
                                        .foregroundColor(.secondary)
                                    SecureField("Password", text: $formPassword)
                                }
                                
                            }
                        }
                    }
                    
                    Section(header:
                                Text("Advanced Options")
                                .font(.system(size: 14, weight: .medium))
                    ) {
                        VStack {
                            HStack {
                                Text("Port")
                                    .foregroundColor(.secondary)
                                TextField("Server Port", text: $formServerPort)
                                    .keyboardType(.numberPad)
                            }
                        }
                        
                        VStack {
                            HStack {
                                Text("Cert Enroll Port")
                                    .foregroundColor(.secondary)
                                TextField("Cert Enroll Port", text: $formCSRPort)
                                    .keyboardType(.numberPad)
                            }
                        }
                        
                        VStack {
                            HStack {
                                Text("Secure API Port")
                                    .foregroundColor(.secondary)
                                TextField("Secure API Port", text: $formSecureAPIPort)
                                    .keyboardType(.numberPad)
                            }
                        }
                    }
                }
                .multilineTextAlignment(.trailing)
            }
            
            VStack(alignment: .center) {
                HStack {
                    if(csrRequest.enrollmentStatus == .Succeeded) {
                        Button("Close", role: .none) {
                            dismiss()
                        }
                    } else {
                        Button("Scan QR", role: .none) {
                            setUpCaptureSession()
                        }
                        Button("Start Enrollment", role: .none) {
                            submitCertEnrollmentForm()
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                
                Text("Status: " + csrRequest.enrollmentStatus.description)
                Text("For Server \(SettingsStore.global.takServerUrl)")
            }
            .sheet(isPresented: $isPresentingQRScanner, onDismiss: {
                processQRCode(qrCodeResult)
            }) {
                NavigationView {
                    CodeScannerView(
                        codeTypes: [.qr],
                        showViewfinder: true,
                        simulatedData: "MyTAK,tak.example.com,8089,SSL",
                        shouldVibrateOnSuccess: true,
                        videoCaptureDevice: AVCaptureDevice.zoomedCameraForQRCode()
                    ) { response in
                        if case let .success(result) = response {
                            qrCodeResult = result.string
                            isPresentingQRScanner = false
                        }
                    }
                    .toolbar {
                        ToolbarItem {
                            Button("Cancel", action: { isPresentingQRScanner = false })
                        }
                    }
                }
            }
            .alert(isPresented: $shouldShowQRCodeFailureAlert) {
                Alert(title: Text("QR Code Failure"), message: Text("The QR Code you scanned did not contain connection information. Please try a different QR code"), dismissButton: .default(Text("OK")))
            }
        }
        .onAppear(perform: {
            formServerURL = settingsStore.takServerUrl
            formServerPort = settingsStore.takServerPort
            formUsername = settingsStore.takServerUsername
            formPassword = settingsStore.takServerPassword
            formCSRPort = settingsStore.takServerCSRPort
            formSecureAPIPort = settingsStore.takServerSecureAPIPort
        })
    }
}
