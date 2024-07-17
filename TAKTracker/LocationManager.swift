//
//  LocationManager.swift
//  TAK Spike
//
//  Created by Cory Foy on 7/3/23.
//

import UIKit
import MapKit
import CoreLocation

class LocationManager: NSObject,CLLocationManagerDelegate, ObservableObject {
    @Published var region = MKCoordinateRegion()
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var lastLocation: CLLocation?
    @Published var lastHeading: CLHeading?
    
    var shouldUpdateCoordinateRegion = true

    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.allowsBackgroundLocationUpdates = true
        manager.showsBackgroundLocationIndicator = true
        manager.pausesLocationUpdatesAutomatically = false
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
    }
    
    func requestAlwaysAuthorization() {
        TAKLogger.debug("[LocationManager]: Request Location Authorization")
        manager.requestWhenInUseAuthorization()
        manager.requestAlwaysAuthorization()
    }
    
    func isLocationAuthorized() -> Bool {
        return manager.authorizationStatus == .authorizedWhenInUse
            || manager.authorizationStatus == .authorizedAlways
    }
    
    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        
        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
        TAKLogger.debug("[LocationManager]: Location Authorization Changed to \(statusString)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { TAKLogger.debug("No Locations!"); return }
        lastLocation = location
        
        if(shouldUpdateCoordinateRegion) {
            locations.last.map {
                region = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude),
                    span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
                )
            }
        }
        
        guard let heading = manager.heading else { TAKLogger.debug("No heading!"); return }
        lastHeading = heading
    }
    
    func deviceUpdatedOrientation(orientation: UIDeviceOrientation) {
        let START_UP = 0
        let PORTRAIT = 1
        let LANDSCAPE = 3
        
        TAKLogger.debug("[LocationManager]: Device Rotated \(orientation.rawValue)")
        
        switch(orientation.rawValue) {
        case START_UP, PORTRAIT:
            manager.headingOrientation = .portrait
        case LANDSCAPE:
            // It is worth noting that we only allow
            // Portrait and Landscape Right as the orientations
            // However the *heading* orientation appears to
            // need to be told the opposite of the device orientation
            manager.headingOrientation = .landscapeLeft
        default:
            // Ignore since it's an unsupported orientation
            TAKLogger.debug("[LocationManager]: Received an unsupported device rotation. Ignoring.")
        }
        
        // Let the manager know something is up
        manager.startUpdatingHeading()
    }
}
