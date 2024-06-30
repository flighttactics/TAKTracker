//
//  AwarenessView.swift
//  TAKTracker
//
//  Created by Cory Foy on 6/22/24.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    @Binding var mapType: UInt

    let mapView = MKMapView()

    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.setRegion(region, animated: true)
        mapView.setCenter(region.center, animated: true)
        mapView.showsUserLocation = true
        mapView.showsCompass = true
        mapView.userTrackingMode = .followWithHeading
        mapView.pointOfInterestFilter = .excludingAll
        mapView.mapType = MKMapType(rawValue: UInt(mapType))!
        mapView.layer.borderColor = UIColor.black.cgColor
        mapView.layer.borderWidth = 1.0
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        view.mapType = MKMapType(rawValue: UInt(mapType))!
        view.isHidden = view.frame.height < 150
    }
    
    func resetMap() {
        mapView.showsCompass = true
        mapView.userTrackingMode = .followWithHeading
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate, UIGestureRecognizerDelegate {
        var parent: MapView

        var gRecognizer = UITapGestureRecognizer()

        init(_ parent: MapView) {
            self.parent = parent
            super.init()
            self.gRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
            self.gRecognizer.delegate = self
            self.parent.mapView.addGestureRecognizer(gRecognizer)
        }

        @objc func tapHandler(_ gesture: UITapGestureRecognizer) {
            // position on the screen, CGPoint
            let location = gRecognizer.location(in: self.parent.mapView)
            // position on the map, CLLocationCoordinate2D
            let coordinate = self.parent.mapView.convert(location, toCoordinateFrom: self.parent.mapView)
            TAKLogger.debug("Map Tapped! \(String(describing: coordinate))")
            parent.resetMap()
        }
    }
}

struct AwarenessView: View {
    @EnvironmentObject var settingsStore: SettingsStore
    @EnvironmentObject var manager: LocationManager
    
    @Binding var displayUIState: DisplayUIState
    //@State private var displayUIState = DisplayUIState()
    @State private var tracking:MapUserTrackingMode = .none
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
            ZStack(alignment: .top) {
                trackerStatus
                HStack {
                    Text("TAK Tracker").font(.headline)
                    Spacer()
                        Button(action: { sheet = .emergencySettings }) {
                            Image(systemName: "exclamationmark.triangle")
                                .imageScale(.large)
                                .foregroundColor(settingsStore.isAlertActivated ? .red : .yellow)
                        }
                            Button(action: { sheet = .chat }) {
                                Image(systemName: "bubble.left")
                                    .imageScale(.large)
                                    .foregroundColor(.yellow)
                            }
                    
                    Button(action: { sheet = .settings }) {
                        Image(systemName: "gear")
                            .imageScale(.large)
                            .foregroundColor(.yellow)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                .foregroundColor(.yellow)
            }
        }
        .fullScreenCover(item: $sheet, content: { Sheet(type: $0) })
        .background(Color.baseMediumGray)
        .ignoresSafeArea()
        .overlay(alignment: .bottomTrailing, content: {
            serverAndUserInfo
                .padding(.horizontal)
        })
    }
    
    var trackerStatus: some View {
        VStack(spacing: 10) {
            if(settingsStore.enableAdvancedMode) {
                MapView(
                    region: $manager.region,
                    mapType: $settingsStore.mapTypeDisplay
                )
                .ignoresSafeArea(edges: .all)
            } else {
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
    }
    
    var serverAndUserInfo: some View {
        VStack(alignment: .leading) {
            HStack {
                if(settingsStore.isConnectedToServer) {
                    Text("CONNECTED")
                        .foregroundColor(.green)
                } else {
                    Text("\(settingsStore.connectionStatus)")
                        .textCase(.uppercase)
                        .foregroundColor(.red)
                }
            }
            
            Text(settingsStore.callSign)
            
            ForEach(displayUIState.coordinateValue(location: manager.lastLocation).lines, id: \.id) { line in
                HStack {
                    if(line.hasLineTitle()) {
                        Text(line.lineTitle)
                    }
                    Text(line.lineContents)
                }
            }
            
            HStack {
                Text(displayUIState.headingValue(
                    unit: displayUIState.currentHeadingUnit,
                    heading: manager.lastHeading))
                Spacer()
                HStack {
                    Text(displayUIState.speedValue(
                        location: manager.lastLocation))
                    Text("\(displayUIState.speedText())")
                }.multilineTextAlignment(.trailing)
            }
        }
        .font(.system(size: 10, weight: .bold))
        .padding(.all, 5)
        .background(
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .fill(Color.black)
                .opacity(0.7)
        )
        .frame(width: 150)
        .onTapGesture {
            displayUIState.nextLocationUnit()
        }
    }
}
