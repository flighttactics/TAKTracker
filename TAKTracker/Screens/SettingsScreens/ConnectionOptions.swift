//
//  ConnectionOptions.swift
//  TAKTracker
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation
import SwiftTAK
import SwiftUI

struct CertificateEnrollmentParameters: View {
    @StateObject var settingsStore: SettingsStore = SettingsStore.global
    
    @State var requiresIntermediateCertificate: Bool = false
    @State var isShowingFilePicker: Bool = false
    @State var certFileName: String = ""
    
    var body: some View {
        List {
            ServerInformation()
            Group {
                VStack {
                    HStack {
                        Text("Username")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    TextField("Username", text: $settingsStore.takServerUsername)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.asciiCapable)
                }
                .padding(.top, 20)
            }
            
            Group {
                VStack {
                    HStack {
                        Text("Password")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    SecureField("Password", text: $settingsStore.takServerPassword)
                }
                .padding(.top, 20)
            }
            
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

struct CertificateEnrollment: View {
    @StateObject var settingsStore: SettingsStore = SettingsStore.global
    @StateObject var csrRequest: CSRRequestor = CSRRequestor()

    @State var isShowingEnrollment = false
    
    var body: some View {
        Group {
            VStack {
                HStack {
                    Text("Enroll for Certificate")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.secondary)
                    Spacer()
                }
                Button("Enroll Now", role: .none) {
                    isShowingEnrollment.toggle()
                }
                .buttonStyle(.bordered)
                .sheet(isPresented: $isShowingEnrollment, onDismiss: didDismissCertEnrollment) {
                    CertificateEnrollmentParameters()
                    Text("Let's Enroll")
                        .font(.headline)
                        .padding()
                    if(csrRequest.enrollmentStatus == .Succeeded) {
                        Button("Close", role: .none) {
                            isShowingEnrollment.toggle()
                        }
                        .buttonStyle(.borderedProminent)
                    } else {
                        Button("Begin", role: .none) {
                            csrRequest.beginEnrollment()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    Text("Status: " + csrRequest.enrollmentStatus.description)
                    Text("For Server \(SettingsStore.global.takServerUrl)")
                }
            }
            .padding(.top, 20)
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
    @StateObject var settingsStore: SettingsStore = SettingsStore.global

    @State var isShowingFilePicker = false
    
    var body: some View {
        Group {
            VStack {
                HStack {
                    Text("Data Package")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.secondary)
                    Spacer()
                }
                Button("Data Package", role: .none) {
                    isShowingFilePicker.toggle()
                }
                .buttonStyle(.bordered)
                .fileImporter(isPresented: $isShowingFilePicker, allowedContentTypes: [.zip], allowsMultipleSelection: false, onCompletion: { results in
                    
                    switch results {
                    case .success(let fileurls):
                        for fileurl in fileurls {
                            if(fileurl.startAccessingSecurityScopedResource()) {
                                TAKLogger.debug("Processing Package at \(String(describing: fileurl))")
                                let tdpp = TAKDataPackageParser(
                                    fileLocation: fileurl
                                )
                                tdpp.parse()
                                fileurl.stopAccessingSecurityScopedResource()
                            } else {
                                TAKLogger.error("Unable to securely access  \(String(describing: fileurl))")
                            }
                        }
                    case .failure(let error):
                        TAKLogger.debug(String(describing: error))
                    }
                    
                })
            }
            .padding(.top, 20)
        }
    }
}

struct ConnectionOptions: View {
    var body: some View {
        CertificateEnrollment()
        DataPackageEnrollment()
    }
}
