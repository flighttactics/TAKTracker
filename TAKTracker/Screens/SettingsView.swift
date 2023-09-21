//
//  SettingsView.swift
//  TAKTracker
//
//  Created by Cory Foy on 7/13/23.
//

import Foundation
import MapKit
import SwiftTAK
import SwiftUI

struct UserInformation: View {
    @StateObject var settingsStore: SettingsStore = SettingsStore.global
    
    var body: some View {
        Group {
            VStack {
                HStack {
                    Text("Call Sign")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.secondary)
                    Spacer()
                }
                TextField("Call Sign", text: $settingsStore.callSign)
                    .keyboardType(.asciiCapable)
            }
            .padding(.top, 20)
        }
        
        Group {
            VStack {
                HStack {
                    Text("Team")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.secondary)
                    Spacer()
                }
                Picker("Choose your team", selection: $settingsStore.team) {
                    ForEach(TAKConstants.TEAM_COLORS, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(.menu)
                HStack {
                    Text("Role")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.secondary)
                    Spacer()
                }
                Picker("Choose your role", selection: $settingsStore.role) {
                    ForEach(TAKConstants.TEAM_ROLES, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(.menu)
            }
            .padding(.top, 20)
        }
    }
}

struct ServerInformation: View {
    @StateObject var settingsStore: SettingsStore = SettingsStore.global
    
    var body: some View {
        Group {
            VStack {
                HStack {
                    Text("Server Address")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.secondary)
                    Spacer()
                }
                TextField("Server Address", text: $settingsStore.takServerUrl)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.URL)
                    .onSubmit {
                        SettingsStore.global.takServerChanged = true
                    }
            }
            .padding(.top, 20)
        }

        Group {
            VStack {
                HStack {
                    Text("Server Port")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.secondary)
                    Spacer()
                }
                TextField("Server Port", text: $settingsStore.takServerPort)
                    .keyboardType(.numberPad)
                    .onSubmit {
                        SettingsStore.global.takServerChanged = true
                    }
            }
            .padding(.top, 20)
        }
        
        Group {
            VStack {
                HStack {
                    Text("Server Username")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.secondary)
                    Spacer()
                }
                TextField("Server Username", text: $settingsStore.takServerUsername)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.asciiCapable)
                    .onSubmit {
                        SettingsStore.global.takServerChanged = true
                    }
            }
            .padding(.top, 20)
        }
        
        Group {
            VStack {
                HStack {
                    Text("Server Password")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.secondary)
                    Spacer()
                }
                SecureField("Server Password", text: $settingsStore.takServerPassword)
                    .onSubmit {
                        SettingsStore.global.takServerChanged = true
                    }
            }
            .padding(.top, 20)
        }
    }
}

struct ConnectionOptions: View {
    @StateObject var settingsStore: SettingsStore = SettingsStore.global
    @StateObject var csrRequest: CSRRequestor = CSRRequestor()
    
    @State var isShowingFilePicker = false
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

struct AdvancedModeToggle: View {
    @StateObject var settingsStore: SettingsStore = SettingsStore.global
    
    var body: some View {
        Group {
            VStack {
                HStack {
                    Text("Enable Advanced Mode")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.secondary)
                    Spacer()
                }

                Picker(selection: $settingsStore.enableAdvancedMode, label: Text("Advanced Mode"), content: {
                    Text("On").tag(true)
                    Text("Off").tag(false)
                })
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding(.top, 20)
        }
    }
}

struct DeviceOptions: View {
    @StateObject var settingsStore: SettingsStore = SettingsStore.global
    
    var body: some View {
        Group {
            VStack {
                HStack {
                    Text("Disable Screen Sleep")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.secondary)
                    Spacer()
                }

                Picker(selection: $settingsStore.disableScreenSleep, label: Text("Screen Sleep Disabled"), content: {
                    Text("Yes").tag(true)
                    Text("No").tag(false)
                })
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding(.top, 20)
        }
    }
}

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

struct MapOptions: View {
    @StateObject var settingsStore: SettingsStore = SettingsStore.global
    
    var body: some View {
        Group {
            VStack {
                HStack {
                    Text("Map Type")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.secondary)
                    Spacer()
                }
                Picker(selection: $settingsStore.mapTypeDisplay, label: Text("Map Type"), content: {
                    Text("Standard").tag(MKMapType.standard.rawValue)
                    Text("Hybrid").tag(MKMapType.hybrid.rawValue)
                    Text("Satellite").tag(MKMapType.satellite.rawValue)
                    Text("Flyover").tag(MKMapType.hybridFlyover.rawValue)
                })
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding(.top, 20)
        }
    }
}

struct SwiftTAK: View {
    var body: some View {
        Text("""
SwiftTAK Copyright 2023 Flight Tactics

https://github.com/flighttactics/SwiftTAK

Licensed under the Apache License, Version 2.0 (the 'License'); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an 'AS IS' BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
""")
    }
}

struct AboutInformation: View {
    var body: some View {
        Group {
            Text("TAK Tracker v\(AppConstants.getAppVersion())")
                .frame(maxWidth: .infinity, alignment: .center)
            Text("""
Copyright 2023, Flight Tactics
For support: \("opensource" + "@" + "flighttactics.com")
This app uses the following open-source libraries:
""")
            NavigationLink(destination: SwiftTAK()) {
                Text("SwiftTAK")
            }
        }
        .foregroundColor(.secondary)
    }
}

struct SettingsView: View {
    @StateObject var settingsStore: SettingsStore = SettingsStore.global

    var body: some View {
        List {
            UserInformation()
            ServerInformation()
            ConnectionOptions()
            DeviceOptions()
            AdvancedModeToggle()
            
            if(settingsStore.enableAdvancedMode) {
                MapOptions()
                TAKOptions()
            }
            AboutInformation()
        }
        .padding([.leading, .trailing], 12)
    }
}
