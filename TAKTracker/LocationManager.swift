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

    private let manager = CLLocationManager()
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
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
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { TAKLogger.debug("No Locations!"); return }
        lastLocation = location
        locations.last.map {
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            )
        }
        
        guard let heading = manager.heading else { TAKLogger.debug("No heading!"); return }
        lastHeading = heading
    }
    
//    func latlon2DMS(latitude: Double) -> String {
//        var latitudeSeconds = latitude * 3600
//        let latitudeDegrees = latitudeSeconds / 3600
//        latitudeSeconds = latitudeSeconds.truncatingRemainder(dividingBy: 3600)
//        let latitudeMinutes = latitudeSeconds / 60
//        latitudeSeconds = latitudeSeconds.truncatingRemainder(dividingBy: 60)
//        let latitudeCardinalDirection = latitudeDegrees >= 0 ? "N" : "S"
//        let latitudeDescription = String(format: "%.2f° %.2f' %.2f\" %@",
//                                         abs(latitudeDegrees), abs(latitudeMinutes),
//                                         abs(latitudeSeconds), latitudeCardinalDirection)
//        return latitudeDescription
//    }
//
//    func latlon2DMS(longitude: Double) -> String {
//        var longitudeSeconds = longitude * 3600
//        let longitudeDegrees = longitudeSeconds / 3600
//        longitudeSeconds = longitudeSeconds.truncatingRemainder(dividingBy: 3600)
//        let longitudeMinutes = longitudeSeconds / 60
//        longitudeSeconds = longitudeSeconds.truncatingRemainder(dividingBy: 60)
//        let longitudeCardinalDirection = longitudeDegrees >= 0 ? "E" : "W"
//        let longitudeDescription = String(format: "%.2f° %.2f' %.2f\" %@",
//                                          abs(longitudeDegrees), abs(longitudeMinutes),
//                                          abs(longitudeSeconds), longitudeCardinalDirection)
//        return longitudeDescription
//    }

}
