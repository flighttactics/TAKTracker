//
//  Components.swift
//  TAKTracker
//
//  Created by Cory Foy on 6/22/24.
//

import SwiftUI
import MapKit

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
            #if targetEnvironment(simulator)
            if(unit == DirectionUnit.TN) {
                return "24"
            } else {
                return "18"
            }
            #else
            return "--"
            #endif
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
