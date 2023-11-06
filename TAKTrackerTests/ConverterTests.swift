//
//  ConverterTests.swift
//  TAKTrackerTests
//
//  Created by Cory Foy on 9/13/23.
//

import MapKit
import XCTest

final class ConverterTests: TAKTrackerTestCase {
    
    // Location converstions: Lat Long in MGRS, DMS
    // Heading Conversions: True North, Magnetic North - These are both provided automatically by LocationServices
    // Compass Conversions: Magnetic North, True North - These are both provided automatically by LocationServices
    // Speed Conversions: m/s, kph, fps, mph  - This comes from iOS as m/s
    
    func mockLocationCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: CLLocationDegrees(38.8856), longitude: CLLocationDegrees(-76.9953))
    }
    
    func mockLocation() -> CLLocation {
        let mockLocationCoordinate = mockLocationCoordinate()
        let mockDistance = CLLocationDistance(0)
        let mockSpeedMetersPerSecond = CLLocationSpeed(30)
        let mockAccuracy = CLLocationAccuracy(0)
        let mockDirection = CLLocationDirection(0)
        return CLLocation(coordinate: mockLocationCoordinate, altitude: mockDistance, horizontalAccuracy: mockAccuracy, verticalAccuracy: mockAccuracy, course: mockDirection, speed: mockSpeedMetersPerSecond, timestamp: Date())
    }
    
    func testLatLongToMGRS() {
        let expected = "18S UJ 26938 05973"
        let coordinate = mockLocationCoordinate()
        let latitude = coordinate.latitude as Double
        let longitude = coordinate.longitude as Double
        XCTAssertEqual(expected, Converter.LatLongToMGRS(latitude: latitude, longitude: longitude))
    }
    
    func testLatitudeToDMS() {
        let latitude = mockLocationCoordinate().latitude as Double
        XCTAssertEqual("N  38° 53' 08.160\"", Converter.LatLonToDMS(latitude: latitude))
    }
    
    func testLongitudeToDMS() {
        let longitude = mockLocationCoordinate().longitude as Double
        XCTAssertEqual("W  76° 59' 43.080\"", Converter.LatLonToDMS(longitude: longitude))
    }
    
    func testSpeedToMetersPerSecond() {
        let location = mockLocation()
        XCTAssertEqual("30", Converter.convertToSpeedUnit(unit: SpeedUnit.MetersPerSecond, location: location))
    }
    
    func testSpeedToKilomtersPerHour() {
        let location = mockLocation()
        XCTAssertEqual("108", Converter.convertToSpeedUnit(unit: SpeedUnit.KmPerHour, location: location))
    }
    
    func testSpeedToFeetPerSecond() {
        let location = mockLocation()
        XCTAssertEqual("98", Converter.convertToSpeedUnit(unit: SpeedUnit.FeetPerSecond, location: location))
    }
    
    func testSpeedToMilesPerHour() {
        let location = mockLocation()
        XCTAssertEqual("67", Converter.convertToSpeedUnit(unit: SpeedUnit.MilesPerHour, location: location))
    }
    
    //DMS -> MGRS -> Decimal
    
    func testTogglingDMStoMGRS() {
        XCTAssertEqual(LocationUnit.MGRS, UnitOrder.nextLocationUnit(unit: LocationUnit.DMS))
    }
    
    func testTogglingMGRStoDecimal() {
        XCTAssertEqual(LocationUnit.Decimal, UnitOrder.nextLocationUnit(unit: LocationUnit.MGRS))
    }
    
    func testTogglingDecimaltoDMS() {
        XCTAssertEqual(LocationUnit.DMS, UnitOrder.nextLocationUnit(unit: LocationUnit.Decimal))
    }
    
    func testTogglingMNtoTN() {
        XCTAssertEqual(DirectionUnit.TN, UnitOrder.nextDirectionUnit(unit: DirectionUnit.MN))
    }
    
    func testTogglingTNtoMN() {
        XCTAssertEqual(DirectionUnit.MN, UnitOrder.nextDirectionUnit(unit: DirectionUnit.TN))
    }
    
    func testTogglingSpeedUnitMStoKPH() {
        XCTAssertEqual(SpeedUnit.KmPerHour, UnitOrder.nextSpeedUnit(unit: SpeedUnit.MetersPerSecond))
    }
    
    func testTogglingSpeedUnitKPHtoFPS() {
        XCTAssertEqual(SpeedUnit.FeetPerSecond, UnitOrder.nextSpeedUnit(unit: SpeedUnit.KmPerHour))
    }
    
    func testTogglingSpeedUnitFPStoMPH() {
        XCTAssertEqual(SpeedUnit.MilesPerHour, UnitOrder.nextSpeedUnit(unit: SpeedUnit.FeetPerSecond))
    }
    
    func testTogglingSpeedUnitMPHtoMS() {
        XCTAssertEqual(SpeedUnit.MetersPerSecond, UnitOrder.nextSpeedUnit(unit: SpeedUnit.MilesPerHour))
    }
}
