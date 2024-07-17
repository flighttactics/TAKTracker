//
//  AwarenessView.swift
//  TAKTracker
//
//  Created by Cory Foy on 6/22/24.
//

import CoreData
import SwiftUI
import MapKit

final class MapPointAnnotation: NSObject, MKAnnotation {
    var id: String
    dynamic var title: String?
    dynamic var coordinate: CLLocationCoordinate2D
    dynamic var icon: String?
    dynamic var cotType: String?
    dynamic var image: UIImage? = UIImage.init(systemName: "circle.fill")
    dynamic var color: UIColor?
    dynamic var remarks: String?
    
    var annotationIdentifier: String {
        return icon ?? cotType ?? "pli"
    }
    
    init(mapPoint: COTData) {
        self.id = mapPoint.id?.uuidString ?? UUID().uuidString
        self.title = mapPoint.callsign ?? "NO CALLSIGN"
        self.icon = mapPoint.icon ?? ""
        self.cotType = mapPoint.cotType ?? "a-U-G"
        self.coordinate = CLLocationCoordinate2D(latitude: mapPoint.latitude, longitude: mapPoint.longitude)
        if mapPoint.iconColor != nil && mapPoint.iconColor!.isNotEmpty {
            self.color = IconData.colorFromArgb(argbVal: Int(mapPoint.iconColor!)!)
        }
        self.remarks = mapPoint.remarks
    }
}

struct MapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    @Binding var mapType: UInt
    @Binding var isAcquiringBloodhoundTarget: Bool
    
    @FetchRequest(sortDescriptors: []) var mapPointsData: FetchedResults<COTData>

    @State var mapView: MKMapView = MKMapView()
    @State var activeBloodhound: MKGeodesicPolyline?

    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.setRegion(region, animated: true)
        mapView.setCenter(region.center, animated: true)
        mapView.showsUserLocation = true
        mapView.showsCompass = false
        mapView.userTrackingMode = .followWithHeading
        mapView.pointOfInterestFilter = .excludingAll
        mapView.mapType = MKMapType(rawValue: UInt(mapType))!
        mapView.layer.borderColor = UIColor.black.cgColor
        mapView.layer.borderWidth = 1.0
        mapView.isHidden = false
        
        let compassBtn = MKCompassButton(mapView: mapView)
        compassBtn.frame.origin = CGPoint(x: 24.0, y: 54.0)
        compassBtn.compassVisibility = .visible
        mapView.addSubview(compassBtn)
        
//        let locateBtn = MKUserTrackingButton(mapView: mapView)
//        locateBtn.frame.origin = CGPoint(x: 27.0, y: 114.0)
//        locateBtn.tintColor = .yellow
//        locateBtn.backgroundColor = .clear
//        mapView.addSubview(locateBtn)

        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        view.mapType = MKMapType(rawValue: UInt(mapType))!
        updateAnnotations(from: view)
    }
    
    private func updateAnnotations(from mapView: MKMapView) {
        
        if(!isAcquiringBloodhoundTarget && activeBloodhound != nil) {
            mapView.removeOverlay(activeBloodhound!)
            activeBloodhound = nil
        }
        
        let incomingData = mapPointsData
        
        let existingAnnotations = mapView.annotations.filter { $0 is MapPointAnnotation }
        let current = Set(existingAnnotations.map { ($0 as! MapPointAnnotation).id })
        let new = Set(incomingData.map { $0.id!.uuidString })
        let toRemove = Array(current.symmetricDifference(new))
        let toAdd = Array(new.symmetricDifference(current))

        if !toRemove.isEmpty {
            let removableAnnotations = existingAnnotations.filter {
                toRemove.contains(($0 as! MapPointAnnotation).id)
            }
            mapView.removeAnnotations(removableAnnotations)
        }
        
        for annotation in mapView.annotations.filter({ $0 is MapPointAnnotation }) {
            guard let mpAnnotation = annotation as? MapPointAnnotation else { continue }
            guard let node = incomingData.first(where: {$0.id?.uuidString == mpAnnotation.id}) else { continue }
            let updatedMp = MapPointAnnotation(mapPoint: node)
            mpAnnotation.title = updatedMp.title
            mpAnnotation.color = updatedMp.color
            mpAnnotation.icon = updatedMp.icon
            mpAnnotation.cotType = updatedMp.cotType
            mpAnnotation.coordinate = updatedMp.coordinate
            mpAnnotation.remarks = updatedMp.remarks
        }

        if !toAdd.isEmpty {
            let insertingAnnotations = incomingData.filter { toAdd.contains($0.id!.uuidString)}
            let newAnnotations = insertingAnnotations.map { MapPointAnnotation(mapPoint: $0) }
            mapView.addAnnotations(newAnnotations)
        }
    }
    
    func resetMap() {
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
        }
        
        func mapView(_ mapView: MKMapView, didSelect annotation: any MKAnnotation) {
            guard let mpAnnotation = annotation as? MapPointAnnotation? else {
                TAKLogger.debug("[MapView] Unknown annotation type selected")
                return
            }
            TAKLogger.debug("[MapView] annotation selected")
            let userLocation = mapView.userLocation.coordinate
            let endPointLocation = mpAnnotation!.coordinate
            
            let mapReadyForBloodhoundTarget = parent.activeBloodhound == nil ||
                !mapView.overlays.contains(where: { $0.isEqual(parent.activeBloodhound) })
            
            if(parent.isAcquiringBloodhoundTarget &&
               mapReadyForBloodhoundTarget) {
                TAKLogger.debug("[MapView] Adding Bloodhound line")
                parent.activeBloodhound = MKGeodesicPolyline(coordinates: [userLocation, endPointLocation], count: 2)
                
                mapView.addOverlay(parent.activeBloodhound!)
                mapView.deselectAnnotation(annotation, animated: false)
            } else {
                TAKLogger.debug("[MapView] Parent is acquiring bloodhount and ab is \(mapView.overlays.contains(where: { $0.isEqual(parent.activeBloodhound) }))")
            }
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            guard let polyline = overlay as? MKPolyline else {
                return MKOverlayRenderer()
            }
            
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.lineWidth = 3.0
            renderer.alpha = 0.5
            renderer.strokeColor = UIColor.blue
            
            return renderer
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard !annotation.isKind(of: MKUserLocation.self) else {
                // Make a fast exit if the annotation is the `MKUserLocation`, as it's not an annotation view we wish to customize.
                return nil
            }
            
            guard let mpAnnotation = annotation as? MapPointAnnotation? else { return nil }
            
            let identifier = mpAnnotation!.annotationIdentifier
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true
                let detailView = UIView()
                let remarksView = UITextView()
                remarksView.text = mpAnnotation?.remarks ?? ""

                let widthConstraint = NSLayoutConstraint(item: detailView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
                detailView.addConstraint(widthConstraint)

                let heightConstraint = NSLayoutConstraint(item: detailView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20)
                detailView.addConstraint(heightConstraint)
                annotationView!.detailCalloutAccessoryView = detailView
                let icon = IconData.iconFor(type2525: mpAnnotation!.cotType ?? "", iconsetPath: mpAnnotation!.icon ?? "")
                var pointIcon: UIImage = icon.icon
                
                if let pointColor = mpAnnotation!.color {
                    pointIcon = pointIcon.mask(with: pointColor)
                    //pointIcon = pointIcon.withTintColor(pointColor, renderingMode: .alwaysTemplate)
                }
                annotationView!.image = pointIcon
            }
            return annotationView
        }
    }
}

struct AwarenessView: View {
    @EnvironmentObject var settingsStore: SettingsStore
    @EnvironmentObject var manager: LocationManager
    @Environment(\.managedObjectContext) var dataContext
    
    @Binding var displayUIState: DisplayUIState
    
    @FetchRequest(sortDescriptors: []) var mapPointsData: FetchedResults<COTData>
    
    @State private var tracking:MapUserTrackingMode = .none
    @State private var sheet: Sheet.SheetType?
    @State private var isAcquiringBloodhoundTarget: Bool = false
    
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
                toolbarItemsRight
//                HStack {
//                    Spacer()
//                    Button(action: { sheet = .emergencySettings }) {
//                        Image(systemName: "exclamationmark.triangle")
//                            .foregroundColor(settingsStore.isAlertActivated ? .red : .yellow)
//                    }
//                    Button(action: { sheet = .chat }) {
//                        Image(systemName: "bubble.left")
//                    }
//                    Button(action: { sheet = .settings }) {
//                        Image(systemName: "line.3.horizontal")
//                    }
//                }
//                .padding(.horizontal)
//                .padding(.top)
//                .foregroundColor(.yellow)
//                .imageScale(.large)
//                .fontWeight(.bold)
            }
        }
        .navigationViewStyle(.stack)
        .sheet(item: $sheet, content: {
            Sheet(type: $0)
                //.presentationCompactAdaptation(.none)
        })
        .background(Color.baseMediumGray)
        .ignoresSafeArea()
        .overlay(alignment: .bottomTrailing, content: {
            serverAndUserInfo
                .padding(.horizontal)
        })
    }
    
    var trackerStatus: some View {
        MapView(
            region: $manager.region,
            mapType: $settingsStore.mapTypeDisplay,
            isAcquiringBloodhoundTarget: $isAcquiringBloodhoundTarget
        )
        .ignoresSafeArea(edges: .all)
    }

    var toolbarItemsRight: some View {
        HStack {
            Spacer()

//            Button(action: {
//                print("Clearing...")
//                mapPointsData.forEach { row in
//                    dataContext.delete(row)
//                }
//                do {
//                    try dataContext.save()
//                    print("All Clear")
//                } catch {
//                    print("ERROR saving deletes: \(error)")
//                }
//            }) {
//                Image(systemName: "clear.fill")
//            }
//
//            Button(action: {
//                print("Adding...")
//                let mapPointData = COTData(context: dataContext)
//                mapPointData.id = UUID()
//                mapPointData.callsign = "Point \(Int.random(in: 1...1000))"
//                mapPointData.latitude = Double.random(in: 37.5...37.9)
//                mapPointData.longitude = -Double.random(in: 122.1...122.5)
//                try? dataContext.save()
//            }) {
//                Image(systemName: "plus")
//            }

            Button(action: { isAcquiringBloodhoundTarget.toggle() }) {
                Image("bloodhound")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .colorMultiply((isAcquiringBloodhoundTarget ? .red : .yellow))
                    .frame(width: 20.0)
            }
            
            Button(action: { sheet = .emergencySettings }) {
                Image(systemName: "exclamationmark.triangle")
                    .foregroundColor(settingsStore.isAlertActivated ? .red : .yellow)
            }
            
            Button(action: { sheet = .chat }) {
                Image(systemName: "bubble.left")
            }
            
            Button(action: { sheet = .settings }) {
                Image(systemName: "line.3.horizontal")
            }
        }
        .padding(.horizontal)
        .padding(.top)
        .foregroundColor(.yellow)
        .imageScale(.large)
        .fontWeight(.bold)
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
