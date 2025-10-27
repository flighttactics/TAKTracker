//
//  DataPackageEnrollment.swift
//  TAKTracker
//
//  Created by Craig Clayton on 10/9/25.
//
import SwiftUI

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
