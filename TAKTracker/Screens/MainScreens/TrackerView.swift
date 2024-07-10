//
//  TrackerView.swift
//  TAKTracker
//
//  Created by Cory Foy on 6/22/24.
//

import SwiftUI
import MapKit

struct TrackerView: View {
    @EnvironmentObject var settingsStore: SettingsStore
    @EnvironmentObject var manager: LocationManager

    @Binding var displayUIState: DisplayUIState
    //@State private var displayUIState = DisplayUIState()
    @State private var sheet: Sheet.SheetType?
    
    func formatOrZero(item: Double?, formatter: String = "%.0f") -> String {
        guard let item = item else {
            return "0"
        }
        return String(format: formatter, item)
    }
    
    init(displayUIState: Binding<DisplayUIState>) {
        navBarAppearence.configureWithOpaqueBackground()
        navBarAppearence.backgroundColor = UIColor.baseDarkGray
        navBarAppearence.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearence.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = navBarAppearence
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearence
        
        _displayUIState = displayUIState
    }
    
    var body: some View {
        NavigationView {
            trackerStatus
            .background(Color.baseMediumGray)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .principal) {
                    HStack {
                        Text("TAK Tracker").font(.headline)
                        Spacer()
                        Button(action: { sheet = .emergencySettings }) {
                            Image(systemName: "exclamationmark.triangle")
                                .imageScale(.large)
                                .foregroundColor(settingsStore.isAlertActivated ? .red : .white)
                        }
//                        Button(action: { sheet = .chat }) {
//                            Image(systemName: "bubble.left")
//                                .imageScale(.large)
//                                .foregroundColor(.white)
//                        }
                        
                        Button(action: { sheet = .settings }) {
                            Image(systemName: "gear")
                                .imageScale(.large)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
        .fullScreenCover(item: $sheet, content: { Sheet(type: $0) })
        .background(Color.baseMediumGray)
        .ignoresSafeArea(edges: .bottom)
        .overlay(alignment: .bottomTrailing, content: {
            serverStatus
        })
    }
    
    var trackerStatus: some View {
        VStack(spacing: 10) {
            Text(settingsStore.callSign)
                .foregroundColor(.white)
                .bold()
                .padding(.top, 10)
            
            VStack(alignment: .leading) {
                Text("Location (\(displayUIState.coordinateText()))").padding(.leading, 5)
                ForEach(displayUIState.coordinateValue(location: manager.lastLocation).lines, id: \.id) { line in
                    HStack {
                        if(line.hasLineTitle()) {
                            Text(line.lineTitle).padding(.leading, 5)
                            Spacer()
                            Text(line.lineContents)
                        } else {
                            Spacer()
                            Text(line.lineContents).padding(.leading, 5)
                        }
                        Spacer()
                    }.font(.system(size: 30))
                }
            }
            .border(.blue)
            .foregroundColor(.white)
            .background(.black)
            .padding(10)
            .onTapGesture {
                displayUIState.nextLocationUnit()
            }
            
            HStack(alignment: .center) {
                VStack {
                    Text("Heading")
                        .frame(maxWidth: .infinity)
                    Text("(\(displayUIState.headingText(unit: displayUIState.currentHeadingUnit)))")
                        .frame(maxWidth: .infinity)
                    Text(displayUIState.headingValue(
                        unit: displayUIState.currentHeadingUnit,
                        heading: manager.lastHeading)).font(.system(size: 30))
                }
                .background(.black)
                .border(.blue)
                .onTapGesture {
                    displayUIState.nextHeadingUnit()
                }
                VStack {
                    Text("Compass")
                        .frame(maxWidth: .infinity)
                    Text("(\(displayUIState.headingText(unit: displayUIState.currentCompassUnit)))")
                        .frame(maxWidth: .infinity)
                    Text(displayUIState.headingValue(
                        unit: displayUIState.currentCompassUnit,
                        heading: manager.lastHeading)).font(.system(size: 30))
                }
                .background(.black)
                .border(.blue)
                .onTapGesture {
                    displayUIState.nextCompassUnit()
                }
                
                VStack {
                    Text("Speed")
                        .frame(maxWidth: .infinity)
                    Text("(\(displayUIState.speedText()))")
                        .frame(maxWidth: .infinity)
                    Text(displayUIState.speedValue(
                        location: manager.lastLocation)).font(.system(size: 30))
                }
                .background(.black)
                .border(.blue)
                .onTapGesture {
                    displayUIState.nextSpeedUnit()
                }
            }
            .foregroundColor(.white)
            .padding(10)
            Spacer()
        }
    }
    var toolbarItemsLeft: some View {
        Group {
            Button(action: { sheet = .emergencySettings }) {
                Image(systemName: "exclamationmark.triangle")
                    .imageScale(.large)
                    .foregroundColor(settingsStore.isAlertActivated ? .red : .white)
            }
            
            Button(action: { sheet = .chat }) {
                Image(systemName: "bubble.left")
                    .imageScale(.large)
                    .foregroundColor(.white)
            }
        }
    }
    var toolbarItems: some View {
        Group {
            Button(action: { sheet = .emergencySettings }) {
                Image(systemName: "exclamationmark.triangle")
                    .imageScale(.large)
                    .foregroundColor(settingsStore.isAlertActivated ? .red : .white)
            }
            
            Button(action: { sheet = .chat }) {
                Image(systemName: "bubble.left")
                    .imageScale(.large)
                    .foregroundColor(.white)
            }
            
            Button(action: { sheet = .settings }) {
                Image(systemName: "gear")
                    .imageScale(.large)
                    .foregroundColor(.white)
            }
        }
    }
    
    var serverStatus: some View {
        VStack {
            HStack {
                if(settingsStore.isConnectedToServer) {
                    Text("Server: Connected")
                        .foregroundColor(.green)
                        .font(.system(size: 15))
                        .padding(.all, 5)
                        .background(
                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(Color.black)
                        )
                } else {
                    Text("Server: \(settingsStore.connectionStatus)")
                        .foregroundColor(.red)
                        .font(.system(size: 15))
                        .padding(.all, 5)
                        .background(
                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(Color.black)
                        )
                }
            }
        }
        .padding(.horizontal)
    }
}
