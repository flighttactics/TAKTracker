//
//  Bounds.swift
//  grid-ios
//
//  Created by Brian Osborn on 8/3/22.
//

import Foundation
import sf_ios

/**
 * Grid Bounds
 */
public class Bounds: SFGeometryEnvelope {
    
    /**
     * Create bounds in degrees
     *
     * @param minLongitude
     *            min longitude
     * @param minLatitude
     *            min latitude
     * @param maxLongitude
     *            max longitude
     * @param maxLatitude
     *            max latitude
     * @return bounds
     */
    public static func degrees(_ minLongitude: Double, _ minLatitude: Double, _ maxLongitude: Double, _ maxLatitude: Double) -> Bounds {
        return Bounds(minLongitude, minLatitude, maxLongitude, maxLatitude, Unit.DEGREE)
    }
    
    /**
     * Create bounds in meters
     *
     * @param minLongitude
     *            min longitude
     * @param minLatitude
     *            min latitude
     * @param maxLongitude
     *            max longitude
     * @param maxLatitude
     *            max latitude
     * @return bounds
     */
    public static func meters(_ minLongitude: Double, _ minLatitude: Double, _ maxLongitude: Double, _ maxLatitude: Double) -> Bounds {
        return Bounds(minLongitude, minLatitude, maxLongitude, maxLatitude, Unit.METER)
    }
    
    /**
     * Unit
     */
    public var unit: Unit
    
    /**
     * The min longitude
     */
    public var minLongitude: Double {
        get {
            return minX.doubleValue
        }
        set(minLongitude) {
            setMinXValue(minLongitude)
        }
    }
    
    /**
     * The min latitude
     */
    public var minLatitude: Double {
        get {
            return minY.doubleValue
        }
        set(minLatitude) {
            setMinYValue(minLatitude)
        }
    }
    
    /**
     * The max longitude
     */
    public var maxLongitude: Double {
        get {
            return maxX.doubleValue
        }
        set(maxLongitude) {
            setMaxXValue(maxLongitude)
        }
    }
    
    /**
     * The max latitude
     */
    public var maxLatitude: Double {
        get {
            return maxY.doubleValue
        }
        set(maxLatitude) {
            setMaxYValue(maxLatitude)
        }
    }
    
    /**
     * The western longitude
     *
     * @return western longitude
     */
    public var west: Double {
        get {
            return minLongitude
        }
        set(west) {
            minLongitude = west
        }
    }
    
    /**
     * The southern longitude
     *
     * @return southern longitude
     */
    public var south: Double {
        get {
            return minLatitude
        }
        set(south) {
            minLatitude = south
        }
    }
    
    /**
     * The eastern longitude
     *
     * @return eastern longitude
     */
    public var east: Double {
        get {
            return maxLongitude
        }
        set(east) {
            maxLongitude = east
        }
    }
    
    /**
     * The northern longitude
     *
     * @return northern longitude
     */
    public var north: Double {
        get {
            return maxLatitude
        }
        set(north) {
            maxLatitude = north
        }
    }
    
    /**
     * The width
     */
    public var width: Double {
        get {
            return xRange()
        }
    }
    
    /**
     * The height
     */
    public var height: Double {
        get {
            return yRange()
        }
    }
    
    /**
     * The southwest coordinate
     *
     * @return southwest coordinate
     */
    public var southwest: GridPoint {
        get {
            return GridPoint(minLongitude, minLatitude, unit)
        }
    }
    
    /**
     * The northwest coordinate
     *
     * @return northwest coordinate
     */
    public var northwest: GridPoint {
        get {
            return GridPoint(minLongitude, maxLatitude, unit)
        }
    }
    
    /**
     * The southeast coordinate
     *
     * @return southeast coordinate
     */
    public var southeast: GridPoint {
        get {
            return GridPoint(maxLongitude, minLatitude, unit)
        }
    }
    
    /**
     * The northeast coordinate
     *
     * @return northeast coordinate
     */
    public var northeast: GridPoint {
        get {
            return GridPoint(maxLongitude, maxLatitude, unit)
        }
    }
    
    /**
     * Initialize
     *
     * @param minLongitude
     *            min longitude
     * @param minLatitude
     *            min latitude
     * @param maxLongitude
     *            max longitude
     * @param maxLatitude
     *            max latitude
     */
    public convenience init(_ minLongitude: Double, _ minLatitude: Double, _ maxLongitude: Double, _ maxLatitude: Double) {
        self.init(minLongitude, minLatitude, maxLongitude, maxLatitude, Unit.DEGREE)
    }
    
    /**
     * Initialize
     *
     * @param minLongitude
     *            min longitude
     * @param minLatitude
     *            min latitude
     * @param maxLongitude
     *            max longitude
     * @param maxLatitude
     *            max latitude
     * @param unit
     *            unit
     */
    public init(_ minLongitude: Double, _ minLatitude: Double, _ maxLongitude: Double, _ maxLatitude: Double, _ unit: Unit) {
        self.unit = unit
        super.init(minX: NSDecimalNumber.init(value: minLongitude), andMinY: NSDecimalNumber.init(value: minLatitude), andMinZ: nil, andMinM: nil, andMaxX: NSDecimalNumber.init(value: maxLongitude), andMaxY: NSDecimalNumber.init(value: maxLatitude), andMaxZ: nil, andMaxM: nil)
    }
    
    /**
     * Initialize
     *
     * @param southwest
     *            southwest corner
     * @param northeast
     *            northeast corner
     */
    public convenience init(_ southwest: GridPoint, _ northeast: GridPoint) {
        self.init(southwest.longitude, southwest.latitude, northeast.longitude, northeast.latitude, southwest.unit)
        
        if !isUnit(northeast.unit) {
            preconditionFailure("Points are in different units. southwest: \(String(describing: unit)), northeast: \(String(describing: northeast.unit))")
        }
    }
    
    /**
     * Initialize
     *
     * @param point
     *            point to copy
     */
    public convenience init(_ bounds: Bounds) {
        self.init(bounds, bounds.unit)
    }
    
    /**
     * Initialize
     *
     * @param envelope
     *            geometry envelope
     * @param unit
     *            unit
     */
    public init(_ envelope: SFGeometryEnvelope, _ unit: Unit) {
        self.unit = unit
        super.init(minX: envelope.minX, andMinY: envelope.minY, andMinZ: envelope.minZ, andMinM: envelope.minM, andMaxX: envelope.maxX, andMaxY: envelope.maxY, andMaxZ: envelope.maxZ, andMaxM: envelope.maxM)
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
     * Are bounds in degrees
     *
     * @return true if degrees
     */
    public func isDegrees() -> Bool {
        return isUnit(Unit.DEGREE)
    }
    
    /**
     * Are bounds in meters
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
     * @return bounds in units, same bounds if equal units
     */
    public func toUnit(_ unit: Unit) -> Bounds {
        var bounds: Bounds
        if isUnit(unit) {
            bounds = self
        } else {
            let sw: GridPoint = southwest.toUnit(unit)
            let ne: GridPoint = northeast.toUnit(unit)
            bounds = Bounds(sw, ne)
        }
        return bounds
    }
    
    /**
     * Convert to degrees
     *
     * @return bounds in degrees, same bounds if already in degrees
     */
    public func toDegrees() -> Bounds {
        return toUnit(Unit.DEGREE)
    }
    
    /**
     * Convert to meters
     *
     * @return bounds in meters, same bounds if already in meters
     */
    public func toMeters() -> Bounds {
        return toUnit(Unit.METER)
    }
    
    /**
     * Get the centroid longitude
     *
     * @return centroid longitude
     */
    public func centroidLongitude() -> Double {
        return midX()
    }
    
    /**
     * Get the centroid latitude
     *
     * @return centroid latitude
     */
    public func centroidLatitude() -> Double {
        var centerLatitude: Double
        if unit == Unit.DEGREE {
            centerLatitude = centroid().latitude
        } else {
            centerLatitude = midY()
        }
        return centerLatitude
    }
    
    public override func centroid() -> GridPoint {
        var point: GridPoint
        if unit == Unit.DEGREE {
            point = toMeters().centroid().toDegrees()
        } else {
            point = GridPoint(super.centroid(), unit)
        }
        return point
    }
    
    /**
     * Create a new bounds as the overlapping between this bounds and the
     * provided
     *
     * @param bounds
     *            bounds
     * @return overlap bounds
     */
    public func overlap(_ bounds: Bounds) -> Bounds? {
        
        var overlap: Bounds?

        let overlapEnvelope: SFGeometryEnvelope? = super.overlap(with: bounds.toUnit(unit), withAllowEmpty: true)
        if overlapEnvelope != nil {
            overlap = Bounds(overlapEnvelope!, unit)
        }

        return overlap
    }
    
    /**
     * Create a new bounds as the union between this bounds and the provided
     *
     * @param bounds
     *            bounds
     * @return union bounds
     */
    public func union(_ bounds: Bounds) -> Bounds? {
        
        var union: Bounds?

        let unionEnvelope: SFGeometryEnvelope? = super.union(with: bounds.toUnit(unit))
        if unionEnvelope != nil {
            union = Bounds(unionEnvelope!, unit)
        }

        return union
    }
    
    /**
     * Get the western line
     *
     * @return west line
     */
    public func westLine() -> Line {
        return grid_ios.Line(northwest, southwest)
    }

    /**
     * Get the southern line
     *
     * @return south line
     */
    public func southLine() -> Line {
        return grid_ios.Line(southwest, southeast)
    }

    /**
     * Get the eastern line
     *
     * @return east line
     */
    public func eastLine() -> Line {
        return grid_ios.Line(southeast, northeast)
    }

    /**
     * Get the northern line
     *
     * @return north line
     */
    public func northLine() -> Line {
        return grid_ios.Line(northeast, northwest)
    }
    
    /**
     * Convert the bounds to be precision accurate minimally containing the
     * bounds. Each bound is equal to or larger by the precision degree amount.
     *
     * @param precision
     *            precision in degrees
     * @return precision bounds
     */
    public func toPrecision(_ precision: Double) -> Bounds {
        
        let boundsDegrees = toDegrees()

        let minLon = GridUtils.precisionBefore(boundsDegrees.minLongitude, precision)
        let minLat = GridUtils.precisionBefore(boundsDegrees.minLatitude, precision)
        let maxLon = GridUtils.precisionAfter(boundsDegrees.maxLongitude, precision)
        let maxLat = GridUtils.precisionAfter(boundsDegrees.maxLatitude, precision)

        return Bounds.degrees(minLon, minLat, maxLon, maxLat)
    }
    
    /**
     * Get the pixel range where the bounds fit into the tile
     *
     * @param tile
     *            tile
     * @return pixel range
     */
    public func pixelRange(_ tile: GridTile) -> PixelRange {
        return pixelRange(tile.width, tile.height, tile.bounds)
    }
    
    /**
     * Get the pixel range where the bounds fit into the provided bounds
     *
     * @param width
     *            width
     * @param height
     *            height
     * @param bounds
     *            bounds
     * @return pixel range
     */
    public func pixelRange(_ width: Int, _ height: Int, _ bounds: Bounds) -> PixelRange {
        let boundsMeters = bounds.toMeters()
        let topLeft = GridUtils.pixel(width, height, boundsMeters, northwest)
        let bottomRight = GridUtils.pixel(width, height, boundsMeters, southeast)
        return PixelRange(topLeft, bottomRight)
    }
    
    /**
     * Get the four line bounds in meters
     *
     * @return lines
     */
    public func lines() -> [Line] {
        
        let southwest = southwest
        let northwest = northwest
        let northeast = northeast
        let southeast = southeast
        
        var lines: [Line] = []
        lines.append(Line(southwest, northwest))
        lines.append(Line(northwest, northeast))
        lines.append(Line(northeast, southeast))
        lines.append(Line(southeast, southwest))
        
        return lines
    }
    
    public override func mutableCopy(with zone: NSZone? = nil) -> Any {
        return Bounds(self)
    }
    
    public override func encode(with coder: NSCoder) {
        coder.encode(unit.rawValue, forKey: "unit")
        super.encode(with: coder)
    }
    
    public required init?(coder: NSCoder) {
        unit = Unit.init(rawValue: coder.decodeInteger(forKey: "unit"))!
        super.init(coder: coder)
    }
    
    public func isEqual(_ bounds: Bounds?) -> Bool {
        if self == bounds {
            return true
        }
        if bounds == nil {
            return false
        }
        if !super.isEqual(bounds) {
            return false
        }
        if unit != bounds?.unit {
            return false
        }
        return true
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
        
        if !(object is Bounds) {
            return false
        }
        
        return isEqual(object as? Bounds)
    }

    public override var hash: Int {
        let prime = 31
        var result = super.hash
        result = prime * result + unit.rawValue
        return result
    }
    
}
