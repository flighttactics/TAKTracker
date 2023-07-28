//
//  SettingsView.swift
//  TAKTracker
//
//  Created by Cory Foy on 7/13/23.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsStore: SettingsStore
    
    @State private var numberFormatter: NumberFormatter = {
        var nf = NumberFormatter()
        nf.numberStyle = .decimal
        return nf
    }()
    
    @State var isShowingFilePicker = false

    var body: some View {
        ScrollView {
            VStack {
                Group {
                    VStack {
                        HStack {
                            Text("Call Sign")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        TextField("Call Sign", text: $settingsStore.callSign)
                    }
                    .padding(.top, 20)
                    Divider()
                }

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
                    Divider()
                }

                Group {
                    VStack {
                        HStack {
                            Text("Server Address")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        TextField("Server Address", text: $settingsStore.takServerUrl)
                    }
                    .padding(.top, 20)
                    Divider()
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
                    }
                    .padding(.top, 20)
                    Divider()
                }
                
                Group {
                    VStack {
                        HStack {
                            Text("Data Package")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        Button {
                            isShowingFilePicker.toggle()
                        } label: {
                            Text("Data Package")
                        }
                        .fileImporter(isPresented: $isShowingFilePicker, allowedContentTypes: [.zip], allowsMultipleSelection: false, onCompletion: { results in
                            
                            switch results {
                            case .success(let fileurls):
                                for fileurl in fileurls {
                                    NSLog("Processing Package")
                                    let tdpp = TAKDataPackageParser(fileLocation: fileurl)
                                    tdpp.parse()
                                }
                                
                            case .failure(let error):
                                NSLog(String(describing: error))
                            }
                            
                        })
                    }
                    .padding(.top, 20)
                    Divider()
                }

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
                
                if(settingsStore.enableAdvancedMode) {
                    Divider()
                    Group {
                        VStack {
                            HStack {
                                Text("CoT Type")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            TextField("CoT Type", text: $settingsStore.cotType)
                        }
                        .padding(.top, 20)
                        Divider()
                    }

                    Group {
                        VStack {
                            HStack {
                                Text("CoT How")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            TextField("CoT How", text: $settingsStore.cotHow)
                        }
                        .padding(.top, 20)
                        Divider()
                    }
                    
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
                        Divider()
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
                        Divider()
                    }
                }
                
                Spacer()
            }
            .padding([.leading, .trailing], 12)
        }
    }
}
