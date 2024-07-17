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

struct CertificateEnrollmentParameters: View {
    @StateObject var settingsStore: SettingsStore = SettingsStore.global
    
    @State var requiresIntermediateCertificate: Bool = false
    @State var isShowingFilePicker: Bool = false
    @State var certFileName: String = ""
    
    var body: some View {
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
                            TextField("Host Name", text: $settingsStore.takServerUrl)
                                .autocorrectionDisabled(true)
                                .textInputAutocapitalization(.never)
                                .keyboardType(.URL)
                                .onSubmit {
                                    SettingsStore.global.takServerChanged = true
                                }
                        }
                    }
                    VStack {
                        HStack {
                            Text("Username")
                                .foregroundColor(.secondary)
                            TextField("Username", text: $settingsStore.takServerUsername)
                                .autocorrectionDisabled(true)
                                .textInputAutocapitalization(.never)
                                .keyboardType(.asciiCapable)
                        }
                    }
                    VStack {
                        HStack {
                            Text("Password")
                                .foregroundColor(.secondary)
                            SecureField("Password", text: $settingsStore.takServerPassword)
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
                            TextField("Server Port", text: $settingsStore.takServerPort)
                                .keyboardType(.numberPad)
                                .onSubmit {
                                    SettingsStore.global.takServerChanged = true
                                }
                        }
                    }
                    
                    VStack {
                        HStack {
                            Text("CSR Port")
                                .foregroundColor(.secondary)
                            TextField("CSR Port", text: $settingsStore.takServerCSRPort)
                                .keyboardType(.numberPad)
                        }
                    }
                }
            }
            .multilineTextAlignment(.trailing)
            
            // TODO: This is the UI for uploading an intermediate cert
            // Swift was having issues parsing the TAK provided p12 files
            // So commenting out for now
            
//            Group {
//                VStack {
//                    Toggle(isOn: $requiresIntermediateCertificate) {
//                        Text("Do you have an intermediate certificate?")
//                    }
//                }
//                .padding(.top, 20)
//            }
//            if(requiresIntermediateCertificate) {
//                VStack {
//                    HStack {
//                        Text("Server Certificate")
//                            .font(.system(size: 18, weight: .medium))
//                            .foregroundColor(.secondary)
//                        Spacer()
//                    }
//                    Button("Upload Certificate", role: .none) {
//                        isShowingFilePicker.toggle()
//                    }
//                    .buttonStyle(.bordered)
//                    .fileImporter(isPresented: $isShowingFilePicker, allowedContentTypes: [.pkcs12], allowsMultipleSelection: false, onCompletion: { results in
//
//                        switch results {
//                        case .success(let fileurls):
//                            for fileurl in fileurls {
//                                if(fileurl.startAccessingSecurityScopedResource()) {
//                                    TAKLogger.debug("Processing file at \(String(describing: fileurl))")
//                                    do {
//                                        settingsStore.serverCertificate = try Data(contentsOf: fileurl)
//                                        certFileName = fileurl.lastPathComponent
//                                    } catch {
//                                        TAKLogger.error("Unable to process file at \(String(describing: fileurl))")
//                                    }
//                                    fileurl.stopAccessingSecurityScopedResource()
//                                } else {
//                                    TAKLogger.error("Unable to securely access \(String(describing: fileurl))")
//                                }
//                            }
//                        case .failure(let error):
//                            TAKLogger.debug(String(describing: error))
//                        }
//                    })
//                    if(!certFileName.isEmpty) {
//                        Text("Cert: \(certFileName)")
//                    }
//                }
//                VStack {
//                    HStack {
//                        Text("Certificate Password")
//                            .font(.system(size: 18, weight: .medium))
//                            .foregroundColor(.secondary)
//                        Spacer()
//                    }
//                    SecureField("Certificate Password", text: $settingsStore.serverCertificatePassword)
//                }
//                .padding(.top, 20)
//            }
            
        }
    }
}

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
                        isProcessingDataPackage = true
                        isShowingFilePicker.toggle()
                    } label: {
                        HStack {
                            Text("Connect with a Data Package")
                            Spacer()
                            Image(systemName: "square.and.arrow.up")
                                .multilineTextAlignment(.trailing)
                        }
                        
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
                                isProcessingDataPackage = false
                            }
                        case .failure(let error):
                            TAKLogger.debug(String(describing: error))
                            isProcessingDataPackage = false
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
    
    var body: some View {
        NavigationLink(destination: ConnectionOptionsScreen(isProcessingDataPackage: $isProcessingDataPackage)) {
            Text("Connect with credentials")
        }
        DataPackageEnrollment(isProcessingDataPackage: $isProcessingDataPackage)
    }
}

struct ConnectionOptionsScreen: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var settingsStore: SettingsStore = SettingsStore.global
    @StateObject var csrRequest: CSRRequestor = CSRRequestor()
    @Binding var isProcessingDataPackage: Bool
    
    @State var isPresentingQRScanner = false
    @State var qrCodeResult: String = ""
    @State var shouldShowQRCodeFailureAlert = false
    
    @State var formServerURL = ""
    @State var formServerPort = ""
    @State var formSecureAPIPort = ""
    @State var formUsername = ""
    @State var formPassword = ""
    @State var formCSRPort = ""
    
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
        guard scannedString.count > 0 else {
            shouldShowQRCodeFailureAlert = true
            return
        }

        let codeParts = scannedString.split(separator: ",")
        guard codeParts.count == 4 else {
            shouldShowQRCodeFailureAlert = true
            return
        }

        let serverName = codeParts[0]
        let serverURL = codeParts[1]
        let serverPort = codeParts[2]
        let serverProtocol = codeParts[3]
        TAKLogger.debug("[ConnectionOptions]: QR Code complete! \(serverName) at \(serverURL):\(serverPort) (\(serverProtocol))")
        
        guard let _ = URL(string: String(serverURL)), let _ = Int(serverPort) else {
            shouldShowQRCodeFailureAlert = true
            return
        }
        
        formServerURL = String(serverURL)
        formServerPort = String(serverPort)
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
                                SecureField("Password", text: $formPassword)
                            }
                        }
                    }
                    
                    Section(header:
                                Text("Advanced Options")
                        .font(.system(size: 14, weight: .medium))
                    ) {
                        VStack {
                            HStack {
                                Text("Streaming Port")
                                    .foregroundColor(.secondary)
                                TextField("Streaming Port", text: $formServerPort)
                                    .keyboardType(.numberPad)
                            }
                        }
                        
                        VStack {
                            HStack {
                                Text("CSR Port")
                                    .foregroundColor(.secondary)
                                TextField("CSR Port", text: $formCSRPort)
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
                        .buttonStyle(.borderedProminent)
                    } else {
                        Button("Start Enrollment", role: .none) {
                            settingsStore.takServerUrl = formServerURL
                            settingsStore.takServerPort = formServerPort
                            settingsStore.takServerUsername = formUsername
                            settingsStore.takServerPassword = formPassword
                            settingsStore.takServerCSRPort = formCSRPort
                            settingsStore.takServerSecureAPIPort = formSecureAPIPort
                            csrRequest.beginEnrollment()
                        }
                        .buttonStyle(.borderedProminent)
                        Button("Scan QR", role: .none) {
                            setUpCaptureSession()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                
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
