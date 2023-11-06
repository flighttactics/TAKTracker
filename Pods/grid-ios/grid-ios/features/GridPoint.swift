//
//  GridPoint.swift
//  grid-ios
//
//  Created by Brian Osborn on 8/3/22.
//

import Foundation
import sf_ios
import MapKit

/**
 * Point
 */
public class GridPoint: SFPoint {
    
    /**
     * Create a point in degrees
     *
     * @param longitude
     *            longitude in degrees
     * @param latitude
     *            latitude in degrees
     * @return point in degrees
     */
    public static func degrees(_ longitude: Double, _ latitude: Double) -> GridPoint {
        return GridPoint(longitude, latitude, Unit.DEGREE)
    }

    /**
     * Create a point in meters
     *
     * @param longitude
     *            longitude in meters
     * @param latitude
     *            latitude in meters
     * @return point in meters
     */
    public static func meters(_ longitude: Double, _ latitude: Double) -> GridPoint {
        return GridPoint(longitude, latitude, Unit.METER)
    }

    /**
     * Create a point from a coordinate in a unit to another unit
     *
     * @param fromUnit
     *            unit of provided coordinate
     * @param longitude
     *            longitude
     * @param latitude
     *            latitude
     * @param toUnit
     *            desired unit
     * @return point in unit
     */
    public static func toUnit(_ fromUnit: Unit, _ longitude: Double, _ latitude: Double, _ toUnit: Unit) -> GridPoint {
        return GridUtils.toUnit(fromUnit, longitude, latitude, toUnit)
    }

    /**
     * Create a point from a coordinate in an opposite unit to another unit
     *
     * @param longitude
     *            longitude
     * @param latitude
     *            latitude
     * @param unit
     *            desired unit
     * @return point in unit
     */
    public static func toUnit(_ longitude: Double, _ latitude: Double, _ unit: Unit) -> GridPoint {
        return GridUtils.toUnit(longitude, latitude, unit)
    }

    /**
     * Create a point converting the degrees coordinate to meters
     *
     * @param longitude
     *            longitude in degrees
     * @param latitude
     *            latitude in degrees
     * @return point in meters
     */
    public static func degreesToMeters(_ longitude: Double, _ latitude: Double) -> GridPoint {
        return toUnit(Unit.DEGREE, longitude, latitude, Unit.METER)
    }

    /**
     * Create a point converting the meters coordinate to degrees
     *
     * @param longitude
     *            longitude in meters
     * @param latitude
     *            latitude in meters
     * @return point in degrees
     */
    public static func metersToDegrees(_ longitude: Double, _ latitude: Double) -> GridPoint {
        return toUnit(Unit.METER, longitude, latitude, Unit.DEGREE)
    }
    
    /**
     * Unit
     */
    public var unit: Unit
    
    /**
     * The longitude
     */
    public var longitude: Double {
        get {
            return x.doubleValue
        }
        set(longitude) {
            setXValue(longitude)
        }
    }
    
    /**
     * The latitude
     */
    public var latitude: Double {
        get {
            return y.doubleValue
        }
        set(latitude) {
            setYValue(latitude)
        }
    }
    
    /**
     * Initialize, in DEGREE units
     *
     * @param longitude
     *            longitude
     * @param latitude
     *            latitude
     */
    public convenience init(_ longitude: Double, _ latitude: Double) {
        self.init(longitude, latitude, Unit.DEGREE)
    }
    
    /**
     * Initialize
     *
     * @param longitude
     *            longitude
     * @param latitude
     *            latitude
     * @param unit
     *            unit
     */
    public init(_ longitude: Double, _ latitude: Double, _ unit: Unit) {
        self.unit = unit
        super.init(hasZ: false, andHasM: false, andX: NSDecimalNumber.init(value: longitude), andY: NSDecimalNumber.init(value: latitude))
    }
    
    /**
     * Initialize
     *
     * @param point
     *            point to copy
     */
    public convenience init(_ point: GridPoint) {
        self.init(point, point.unit)
    }
    
    /**
     * Initialize
     *
     * @param point
     *            point to copy
     * @param unit
     *            unit
     */
    public init(_ point: SFPoint, _ unit: Unit) {
        self.unit = unit
        super.init(hasZ: point.hasZ, andHasM: point.hasM, andX: point.x, andY: point.y)
        z = point.z
        m = point.m
    }
    
    /**
     * Is in the provided unit type
     *
     * @param unit
     *            unit
     * @return true if in the unit
     */
    public func isUnit(_ unit: Unit) -> Bool {
        return self.unit == unit
    }
    
    /**
     * Is this point in degrees
     *
     * @return true if degrees
     */
    public func isDegrees() -> Bool {
        return isUnit(Unit.DEGREE)
    }
    
    /**
     * Is this point in meters
     *
     * @return true if meters
     */
    public func isMeters() -> Bool {
        return isUnit(Unit.METER)
    }
    
    /**
     * Convert to the unit
     *
     * @param unit
     *            unit
     * @return point in units, same point if equal units
     */
    public func toUnit(_ unit: Unit) -> GridPoint {
        var point: GridPoint
        if isUnit(unit) {
            point = self
        } else {
            point = GridUtils.toUnit(self.unit, longitude, latitude, unit)
        }
        return point
    }
    
    /**
     * Convert to degrees
     *
     * @return point in degrees, same point if already in degrees
     */
    public func toDegrees() -> GridPoint {
        return toUnit(Unit.DEGREE)
    }
    
    /**
     * Convert to meters
     *
     * @return point in meters, same point if already in meters
     */
    public func toMeters() -> GridPoint {
        return toUnit(Unit.METER)
    }
    
    /**
     * Get the pixel where the point fits into tile
     *
     * @param tile
     *            tile
     * @return pixel
     */
    public func pixel(_ tile: GridTile) -> Pixel {
        return pixel(tile.width, tile.height, tile.bounds)
    }

    /**
     * Get the pixel where the point fits into the bounds
     *
     * @param width
     *            width
     * @param height
     *            height
     * @param bounds
     *            bounds
     * @return pixel
     */
    public func pixel(_ width: Int, _ height: Int, _ bounds: Bounds) -> Pixel {
        return GridUtils.pixel(width, height, bounds, self)
    }
    
    /**
     * Convert to a location coordinate
     *
     * @return coordinate
     */
    public func toCoordinate() -> CLLocationCoordinate2D {
        return TileUtils.toCoordinate(self)
    }
    
    public override func mutableCopy(with zone: NSZone? = nil) -> Any {
        return GridPoint(self)
    }
    
    public override func encode(with coder: NSCoder) {
        coder.encode(unit.rawValue, forKey: "unit")
        super.encode(with: coder)
    }
    
    public required init?(coder: NSCoder) {
        unit = Unit.init(rawValue: coder.decodeInteger(forKey: "unit"))!
        super.init(coder: coder)
    }
    
    public func isEqual(_ point: GridPoint?) -> Bool {
        if self == point {
            return true
        }
        if point == nil {
            return false
        }
        if !super.isEqual(point) {
            return false
        }
        if unit != point?.unit {
            return false
        }
        return true
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
        
        if !(object is GridPoint) {
            return false
        }
        
        return isEqual(object as? GridPoint)
    }

    public override var hash: Int {
        let prime = 31
        var result = super.hash
        result = prime * result + unit.rawValue
        return result
    }
    
}
