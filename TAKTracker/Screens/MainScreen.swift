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
            //case .MGRS: return "MGRS"
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

    let mapView = MKMapView()

    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.setRegion(region, animated: true)
        mapView.setCenter(region.center, animated: true)
        mapView.showsUserLocation = true
        mapView.showsCompass = true
        mapView.userTrackingMode = .followWithHeading
        mapView.pointOfInterestFilter = .excludingAll
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        //print(#function)
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

struct MainScreen: View {
    @StateObject var manager = LocationManager()
    @StateObject var settingsStore = SettingsStore.global
    @StateObject var takManager = TAKManager()
    
    @State var displayUIState = DisplayUIState()
    @State var tracking:MapUserTrackingMode = .none
    
    //background #5b5557
    let lightGray = Color(hue: 0.94, saturation: 0.03, brightness: 0.35)
    //header: #3d3739
    let darkGray = Color(hue: 0.94, saturation: 0.05, brightness: 0.23)
    
    func formatOrZero(item: Double?, formatter: String = "%.0f") -> String {
        guard let item = item else {
            return "0"
        }
        return String(format: formatter, item)
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                VStack(spacing: 10) {
                    HStack {
                        Spacer()
                        Text("TAK Tracker")
                            .bold()
                            .foregroundColor(.white)
                        Spacer()
                        NavigationLink(destination: AlertView()) {
                            Image(systemName: "exclamationmark.triangle")
                                .imageScale(.large)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        NavigationLink(destination: ChatView(chatMessage: ChatMessage())) {
                            Image(systemName: "bubble.left")
                                .imageScale(.large)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gear")
                                .imageScale(.large)
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }.background(darkGray)
                    
                    Text(settingsStore.callSign).foregroundColor(.white).bold()
                    
                    VStack(alignment: .leading) {
                        Text("Location (\(displayUIState.coordinateText()))").padding(.leading, 5)
                        ForEach(displayUIState.coordinateValue(location: manager.lastLocation).lines, id: \.id) { line in
                            HStack {
                                if(line.hasLineTitle()) {
                                    Text(line.lineTitle).padding(.leading, 5)
                                    Spacer()
                                    Text(line.lineContents)
                                } else {
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
                        MapView(region: $manager.region)
                        .border(.black)
                        
                    }
                    Spacer()
                    HStack {
                        if(settingsStore.isConnectedToServer) {
                            Text("Server: Connected").foregroundColor(.green)
                        } else {
                            Text("Server: \(settingsStore.connectionStatus)").foregroundColor(.red)
                        }
                    }
                    .font(.system(size: 15))
                }
                .background(lightGray)
                .padding()
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: settingsStore.broadcastIntervalSeconds, repeats: true) { timer in
                        broadcastLocation()
                   }
                }
              }
            }
        }
    
    func broadcastLocation() {
        guard let location = manager.lastLocation else {
            return
        }
        takManager.broadcastLocation(location: location)
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
