//
//  ConnectionOptions.swift
//  TAKTracker
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation
import SwiftTAK
import SwiftUI

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
                .popover(isPresented: $isShowingEnrollment) {
                    Text("Let's Enroll")
                        .font(.headline)
                        .padding()
                    if(csrRequest.enrollmentStatus == .Succeeded) {
                        Button("Close", role: .none) {
                            isShowingEnrollment.toggle()
                        }
                        .buttonStyle(.bordered)
                    } else {
                        Button("Begin", role: .none) {
                            csrRequest.beginEnrollment()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    Text(csrRequest.enrollmentStatus.description)
                    Text("For Server \(SettingsStore.global.takServerUrl)")
                }
            }
            .padding(.top, 20)
        }
    }
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
