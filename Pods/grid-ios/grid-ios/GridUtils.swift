//
//  GridUtils.swift
//  grid-ios
//
//  Created by Brian Osborn on 8/4/22.
//

import Foundation
import sf_ios

/**
 * Grid utilities
 */
public class GridUtils {

    /**
     * Get the pixel where the point fits into the bounds
     *
     * @param width
     *            width
     * @param height
     *            height
     * @param bounds
     *            bounds
     * @param point
     *            point
     * @return pixel
     */
    public static func pixel(_ width: Int, _ height: Int, _ bounds: Bounds, _ point: GridPoint) -> Pixel {
        
        let pointMeters = point.toMeters()
        let boundsMeters = bounds.toMeters()
        
        let x = xPixel(width, boundsMeters, pointMeters.longitude)
        let y = yPixel(height, boundsMeters, pointMeters.latitude)
        return Pixel(x, y)
    }
    
    /**
     * Get the X pixel for where the longitude in meters fits into the bounds
     *
     * @param width
     *            width
     * @param bounds
     *            bounds
     * @param longitude
     *            longitude in meters
     * @return x pixel
     */
    public static func xPixel(_ width: Int, _ bounds: Bounds, _ longitude: Double) -> Float {
        
        let boundsMeters = bounds.toMeters()
        
        let boxWidth = boundsMeters.maxLongitude - boundsMeters.minLongitude
        let offset = longitude - boundsMeters.minLongitude
        let percentage = offset / boxWidth
        let pixel = Float(percentage * Double(width))

        return pixel
    }
    
    /**
     * Get the Y pixel for where the latitude in meters fits into the bounds
     *
     * @param height
     *            height
     * @param bounds
     *            bounds
     * @param latitude
     *            latitude
     * @return y pixel
     */
    public static func yPixel(_ height: Int, _ bounds: Bounds, _ latitude: Double) -> Float {
        
        let boundsMeters = bounds.toMeters()
        
        let boxHeight = boundsMeters.maxLatitude - boundsMeters.minLatitude
        let offset = boundsMeters.maxLatitude - latitude
        let percentage = offset / boxHeight
        let pixel = Float(percentage * Double(height))

        return pixel
    }
    
    /**
     * Get the tile bounds from the XYZ tile coordinates and zoom level
     *
     * @param x
     *            x coordinate
     * @param y
     *            y coordinate
     * @param zoom
     *            zoom level
     * @return bounds
     */
    public static func bounds(_ x: Int, _ y: Int, _ zoom: Int) -> Bounds {
        
        let tilesPerSide = tilesPerSide(zoom)
        let tileSize = tileSize(tilesPerSide)

        let minLon = (-1 * SF_WEB_MERCATOR_HALF_WORLD_WIDTH) + (Double(x) * tileSize)
        let minLat = SF_WEB_MERCATOR_HALF_WORLD_WIDTH - (Double(y + 1) * tileSize)
        let maxLon = (-1 * SF_WEB_MERCATOR_HALF_WORLD_WIDTH) + (Double(x + 1) * tileSize)
        let maxLat = SF_WEB_MERCATOR_HALF_WORLD_WIDTH - (Double(y) * tileSize)

        return Bounds.meters(minLon, minLat, maxLon, maxLat)
    }
    
    /**
     * Get the tiles per side, width and height, at the zoom level
     *
     * @param zoom
     *            zoom level
     * @return tiles per side
     */
    public static func tilesPerSide(_ zoom: Int) -> Int {
        return Int(pow(2, Double(zoom)))
    }
    
    /**
     * Get the tile size in meters
     *
     * @param tilesPerSide
     *            tiles per side
     * @return tile size
     */
    public static func tileSize(_ tilesPerSide: Int) -> Double {
        return (2 * SF_WEB_MERCATOR_HALF_WORLD_WIDTH) / Double(tilesPerSide)
    }
    
    /**
     * Get the zoom level of the bounds using the shortest bounds side length
     *
     * @param bounds
     *            bounds
     * @return zoom level
     */
    public static func zoomLevel(_ bounds: Bounds) -> Double {
        let boundsMeters = bounds.toMeters()
        let tileSize = min(boundsMeters.width, boundsMeters.height)
        let tilesPerSide = 2 * SF_WEB_MERCATOR_HALF_WORLD_WIDTH / tileSize
        return log(tilesPerSide) / log(2)
    }
    
    /**
     * Convert a coordinate from a unit to another unit
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
        var point: GridPoint
        if fromUnit == toUnit {
            point = GridPoint(longitude, latitude, toUnit)
        } else {
            point = self.toUnit(longitude, latitude, toUnit)
        }
        return point
    }
    
    /**
     * Convert a coordinate to the unit, assumes the coordinate is in the
     * opposite unit
     *
     * @param longitude
     *            longitude
     * @param latitude
     *            latitude
     * @param unit
     *            desired unit
     * @return point in unit
     */
    public static func toUnit(_ longitude: Double, _ latitude: Double,
                              _ unit: Unit) -> GridPoint {
        var point: SFPoint
        switch unit {
        case .DEGREE:
            point = SFGeometryUtils.metersToDegreesWith(x: longitude, andY: latitude)
        case .METER:
            point = SFGeometryUtils.degreesToMetersWith(x: longitude, andY: latitude)
        }
        return GridPoint(point, unit)
    }
    
    /**
     * Is the band letter an omitted letter
     * GridConstants.BAND_LETTER_OMIT_I or
     * GridConstants.BAND_LETTER_OMIT_O
     *
     * @param letter
     *            band letter
     * @return true if omitted
     */
    public static func isOmittedBandLetter(_ letter: Character) -> Bool {
        return letter == GridConstants.BAND_LETTER_OMIT_I || letter == GridConstants.BAND_LETTER_OMIT_O
    }
    
    /**
     * Get the precision value before the value
     *
     * @param value
     *            value
     * @param precision
     *            precision
     * @return precision value
     */
    public static func precisionBefore(_ value: Double, _ precision: Double) -> Double {
        var before = 0.0
        if abs(value) >= precision {
            before = value - ((value.truncatingRemainder(dividingBy: precision) + precision).truncatingRemainder(dividingBy: precision))
        } else if value < 0.0 {
            before = -precision
        }
        return before
    }

    /**
     * Get the precision value after the value
     *
     * @param value
     *            value
     * @param precision
     *            precision
     * @return precision value
     */
    public static func precisionAfter(_ value: Double, _ precision: Double) -> Double {
        return precisionBefore(value + precision, precision)
    }
    
    /**
     * Get the point intersection between two lines
     *
     * @param line1
     *            first line
     * @param line2
     *            second line
     * @return intersection point or null if no intersection
     */
    public static func intersection(_ line1: Line, _ line2: Line) -> GridPoint? {
        return intersection(line1.point1, line1.point2, line2.point1, line2.point2)
    }

    /**
     * Get the point intersection between end points of two lines
     *
     * @param line1Point1
     *            first point of the first line
     * @param line1Point2
     *            second point of the first line
     * @param line2Point1
     *            first point of the second line
     * @param line2Point2
     *            second point of the second line
     * @return intersection point or null if no intersection
     */
    public static func intersection(_ line1Point1: GridPoint, _ line1Point2: GridPoint, _ line2Point1: GridPoint, _ line2Point2: GridPoint) -> GridPoint? {
        
        var intersection: GridPoint? = nil
        
        let point: SFPoint? = SFGeometryUtils.intersectionBetweenLine1Point1(line1Point1.toMeters(), andLine1Point2: line1Point2.toMeters(), andLine2Point1: line2Point1.toMeters(), andLine2Point2: line2Point2.toMeters())
        
        if point != nil {
            intersection = GridPoint(point!, Unit.METER).toUnit(line1Point1.unit)
        }
        
        return intersection
    }
    
    /**
     * Increment the ASCII character by one
     *
     * @param character
     *            starting character
     * @return next character
     */
    public static func incrementCharacter(_ character: Character) -> Character {
        return incrementCharacter(character, 1)
    }
    
    /**
     * Decrement the ASCII character by one
     *
     * @param character
     *            starting character
     * @return previous character
     */
    public static func decrementCharacter(_ character: Character) -> Character {
        return incrementCharacter(character, -1)
    }
    
    /**
     * Increment the ASCII character
     *
     * @param character
     *            starting character
     * @param increment
     *            ASCII increment, positive or negative for decrement
     * @return incremented character
     */
    public static func incrementCharacter(_ character: Character, _ increment: Int) -> Character {
        var characterValue = Int(character.asciiValue!)
        characterValue += increment
        return Character(UnicodeScalar(characterValue)!)
    }
    
    /**
     * Get the character at the index in a string
     *
     * @param value
     *            string value
     * @param index
     *            character index
     * @return character at index
     */
    public static func charAt(_ value: String, _ index: Int) -> Character {
        return value[value.index(value.startIndex, offsetBy: index)]
    }
    
    /**
     * Get the first index of the character in the string, or -1 if not contained
     *
     * @param value
     *            string value
     * @param char
     *            character
     * @return index of character or -1
     */
    public static func indexOf(_ value: String, _ char: Character) -> Int {
        var index = -1
        let firstIndex = value.firstIndex(of: char)
        if firstIndex != nil {
            index = firstIndex!.utf16Offset(in: value)
        }
        return index
    }
    
    /**
     * Get a substring of the string value from the inclusive begin index to the exclusive end index
     *
     * @param value
     *            string value
     * @param beginIndex
     *            begin index, inclusive
     * @param endIndex
     *            end index, exclusive
     * @return substring as a string
     */
    public static func substring(_ value: String, _ beginIndex: Int, _ endIndex: Int) -> String {
        let start = value.index(value.startIndex, offsetBy: beginIndex)
        let end = value.index(value.startIndex, offsetBy: endIndex)
        let range = start..<end
        return String(value[range])
    }
    
    /**
     * Get a substring of the string value from the inclusive begin index to the end
     *
     * @param value
     *            string value
     * @param beginIndex
     *            begin index, inclusive
     * @return substring as a string
     */
    public static func substring(_ value: String, _ beginIndex: Int) -> String {
        return substring(value, beginIndex, value.count)
    }
    
}
