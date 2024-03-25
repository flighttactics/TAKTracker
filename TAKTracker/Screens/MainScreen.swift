//
//  ContentView.swift
//  TAK Spike
//
//  Created by Cory Foy on 7/3/23.
//

import SwiftUI
import MapKit

struct DisplayUIState {
    var currentLocationUnit = LocationUnit.DMS
    var currentSpeedUnit = SpeedUnit.MetersPerSecond
    var currentCompassUnit = DirectionUnit.MN
    var currentHeadingUnit = DirectionUnit.TN
    
    mutating func nextHeadingUnit() {
        currentHeadingUnit = UnitOrder.nextDirectionUnit(unit: currentHeadingUnit)
    }
    
    mutating func nextCompassUnit() {
        currentCompassUnit = UnitOrder.nextDirectionUnit(unit: currentCompassUnit)
    }
    
    mutating func nextSpeedUnit() {
        currentSpeedUnit = UnitOrder.nextSpeedUnit(unit: currentSpeedUnit)
    }
    
    mutating func nextLocationUnit() {
        currentLocationUnit = UnitOrder.nextLocationUnit(unit: currentLocationUnit)
    }
    
    func headingText(unit:DirectionUnit) -> String {
        if(unit == DirectionUnit.TN) {
            return "°" + "TN"
        } else {
            return "°" + "MN"
        }
    }
    
    func headingValue(unit:DirectionUnit, heading: CLHeading?) -> String {
        guard let locationHeading = heading else {
            return "--"
        }
        if(unit == DirectionUnit.TN) {
            return Converter.formatOrZero(item: locationHeading.trueHeading) + "°"
        } else {
            return Converter.formatOrZero(item: locationHeading.magneticHeading) + "°"
        }
    }
    
    func speedText() -> String {
        switch(currentSpeedUnit) {
            case .MetersPerSecond: return "m/s"
            case .KmPerHour: return "kph"
            case .FeetPerSecond: return "fps"
            case .MilesPerHour: return "mph"
        }
    }
    
    func speedValue(location: CLLocation?) -> String {
        guard let location = location else {
            return "--"
        }
        return Converter.convertToSpeedUnit(unit: currentSpeedUnit, location: location)
    }
    
    func coordinateText() -> String {
        switch(currentLocationUnit) {
            case .DMS: return "DMS"
            case .Decimal: return "Decimal"
            case .MGRS: return "MGRS"
        }
    }
    
    func coordinateValue(location: CLLocation?) -> CoordinateDisplay {
        var display = CoordinateDisplay()
        guard let location = location else {
            display.addLine(line: CoordinateDisplayLine(
                lineContents: "---"
            ))
            return display
        }
        
        switch(currentLocationUnit) {
        case .DMS:
            let latDMS = Converter.LatLonToDMS(latitude: location.coordinate.latitude).components(separatedBy: "  ")
            let longDMS = Converter.LatLonToDMS(longitude: location.coordinate.longitude).components(separatedBy: "  ")
            display.addLine(line: CoordinateDisplayLine(
                lineTitle: latDMS.first!,
                lineContents: latDMS.last!
            ))
            display.addLine(line: CoordinateDisplayLine(
                lineTitle: longDMS.first!,
                lineContents: longDMS.last!
            ))
        case .Decimal:
            display.addLine(line: CoordinateDisplayLine(
                lineTitle: "Lat",
                lineContents: Converter.LatLonToDecimal(latitude: location.coordinate.latitude)
            ))
            display.addLine(line: CoordinateDisplayLine(
                lineTitle: "Lon",
                lineContents: Converter.LatLonToDecimal(latitude: location.coordinate.longitude)
            ))
        case .MGRS:
            let mgrsString = Converter.LatLongToMGRS(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            display.addLine(line: CoordinateDisplayLine(
                lineContents: mgrsString
            ))

        }
        
        return display
    }
}

struct CoordinateDisplay {
    var lines:[CoordinateDisplayLine] = []
    
    mutating func addLine(line:CoordinateDisplayLine) {
        lines.append(line)
    }
}

struct CoordinateDisplayLine {
    var id = UUID()
    var lineTitle:String = ""
    var lineContents:String = ""
    
    func hasLineTitle() -> Bool {
        !lineTitle.isEmpty
    }
}

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

// Our custom view modifier to track rotation and
// call our action
struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
                
            }
    }
}

// A View wrapper to make the modifier easier to use
extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}
let navBarAppearence = UINavigationBarAppearance()

struct MainScreen: View {
    @EnvironmentObject var settingsStore: SettingsStore
    @EnvironmentObject var takManager: TAKManager
    @EnvironmentObject var manager: LocationManager
    
    @State private var displayUIState = DisplayUIState()
    @State private var tracking:MapUserTrackingMode = .none
    @State private var sheet: Sheet.SheetType?
    
    func formatOrZero(item: Double?, formatter: String = "%.0f") -> String {
        guard let item = item else {
            return "0"
        }
        return String(format: formatter, item)
    }
    
    init() {
        navBarAppearence.configureWithOpaqueBackground()
        navBarAppearence.backgroundColor = UIColor.baseDarkGray
        navBarAppearence.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearence.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = navBarAppearence
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearence
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
        .fullScreenCover(item: $sheet, content: { Sheet(type: $0) })
        .background(Color.baseMediumGray)
        .ignoresSafeArea(edges: .bottom)
        .overlay(alignment: .bottomTrailing, content: {
            serverStatus
        })
        .onAppear {
            broadcastLocation()
            Timer.scheduledTimer(withTimeInterval: settingsStore.broadcastIntervalSeconds, repeats: true) { timer in
                broadcastLocation()
            }
        }
        .onRotate { newOrientation in
            manager.deviceUpdatedOrientation(orientation: newOrientation)
        }
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
            
            if(settingsStore.enableAdvancedMode) {
                MapView(
                    region: $manager.region,
                    mapType: $settingsStore.mapTypeDisplay
                )
                .ignoresSafeArea(edges: .all)
            } else {
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
        .padding(.horizontal)
    }
    
    func broadcastLocation() {
        takManager.broadcastLocation(locationManager: manager)
    }
}
