//
//  GridZone.swift
//  mgrs-ios
//
//  Created by Brian Osborn on 8/23/22.
//

import Foundation
import grid_ios

/**
 * Grid Zone
 */
public class GridZone {
    
    /**
     * Longitudinal strip
     */
    public let strip: LongitudinalStrip
    
    /**
     * Latitude band
     */
    public let band: LatitudeBand
    
    /**
     * Bounds
     */
    public let bounds: Bounds
    
    /**
     * Constructor
     *
     * @param strip
     *            longitudinal strip
     * @param band
     *            latitude band
     */
    public init(_ strip: LongitudinalStrip, _ band: LatitudeBand) {
        self.strip = strip
        self.band = band
        self.bounds = Bounds.degrees(strip.west, band.south, strip.east, band.north)
    }
    
    /**
     * Get the zone number
     *
     * @return zone number
     */
    public func number() -> Int {
        return strip.number
    }

    /**
     * Get the band letter
     *
     * @return band letter
     */
    public func letter() -> Character {
        return band.letter
    }

    /**
     * Get the hemisphere
     *
     * @return hemisphere
     */
    public func hemisphere() -> Hemisphere {
        return band.hemisphere
    }
    
    /**
     * Get the label name
     *
     * @return name
     */
    public func name() -> String {
        return MGRSUtils.labelName(number(), letter())
    }
    
    /**
     * Is the provided bounds within the zone bounds
     *
     * @param bounds
     *            bounds
     * @return true if within bounds
     */
    public func isWithin(_ bounds: Bounds) -> Bool {
        let boundsUnit = bounds.toUnit(self.bounds.unit)
        return self.bounds.south <= boundsUnit.north
                && self.bounds.north >= boundsUnit.south
                && self.bounds.west <= boundsUnit.east
                && self.bounds.east >= boundsUnit.west
    }
    
    /**
     * Get the longitudinal strip expansion, number of additional neighbors to
     * iterate over in combination with this strip
     *
     * @return longitudinal strip neighbor iteration expansion
     */
    public func stripExpand() -> Int {
        return strip.expand
    }
    
    /**
     * Get the grid zone lines
     *
     * @param gridType
     *            grid type
     * @return lines
     */
    public func lines(_ gridType: GridType) -> [MGRSLine]? {
        return lines(bounds, gridType)
    }

    /**
     * Get the grid zone lines
     *
     * @param tileBounds
     *            tile bounds
     * @param gridType
     *            grid type
     * @return lines
     */
    public func lines(_ tileBounds: Bounds, _ gridType: GridType) -> [MGRSLine]? {

        var lines: [MGRSLine]? = nil

        if gridType == GridType.GZD {
            // if precision is 0, draw the zone bounds
            lines = []
            for line in bounds.lines() {
                lines?.append(MGRSLine(line, GridType.GZD))
            }
        } else {

            let drawBounds = drawBounds(tileBounds, gridType)

            if drawBounds != nil {

                lines = []

                let precision = Double(gridType.precision())
                let zoneNumber = number()
                let hemisphere = hemisphere()
                let minLon = bounds.minLongitude
                let maxLon = bounds.maxLongitude

                var easting = drawBounds!.minLongitude
                while easting < drawBounds!.maxLongitude {

                    let eastingPrecision = GridType.precision(easting)

                    var northing = drawBounds!.minLatitude
                    while northing < drawBounds!.maxLatitude {

                        let northingPrecision = GridType.precision(northing)

                        var southwest = UTM.point(zoneNumber, hemisphere,
                                easting, northing)
                        let northwest = UTM.point(zoneNumber, hemisphere,
                                easting, northing + precision)
                        var southeast = UTM.point(zoneNumber, hemisphere,
                                easting + precision, northing)

                        // For points outside the tile grid longitude bounds,
                        // get a bound just outside the bounds
                        if precision > 1 {
                            if southwest.longitude < minLon {
                                southwest = westBoundsPoint(easting,
                                        northing, southwest, southeast)
                            } else if southeast.longitude > maxLon {
                                southeast = eastBoundsPoint(easting,
                                        northing, southwest, southeast)
                            }
                        }

                        // Vertical line
                        lines?.append(MGRSLine(southwest, northwest, eastingPrecision))

                        // Horizontal line
                        lines?.append(MGRSLine(southwest, southeast, northingPrecision))

                        northing += precision
                    }
                    
                    easting += precision
                }

            }

        }

        return lines
    }
    
    /**
     * Get a point west of the horizontal bounds at one meter precision
     *
     * @param easting
     *            easting value
     * @param northing
     *            northing value
     * @param west
     *            west point
     * @param east
     *            east point
     * @return higher precision point
     */
    private func westBoundsPoint(_ easting: Double, _ northing: Double,
                                 _ west: GridPoint, _ east: GridPoint) -> GridPoint {
        return boundsPoint(easting, northing, west, east, false)
    }

    /**
     * Get a point east of the horizontal bounds at one meter precision
     *
     * @param easting
     *            easting value
     * @param northing
     *            northing value
     * @param west
     *            west point
     * @param east
     *            east point
     * @return higher precision point
     */
    private func eastBoundsPoint(_ easting: Double, _ northing: Double,
                                 _ west: GridPoint, _ east: GridPoint) -> GridPoint {
        return boundsPoint(easting, northing, west, east, true)
    }

    /**
     * Get a point outside of the horizontal bounds at one meter precision
     *
     * @param easting
     *            easting value
     * @param northing
     *            northing value
     * @param west
     *            west point
     * @param east
     *            east point
     * @param eastern
     *            true if east of the eastern bounds, false if west of the
     *            western bounds
     * @return higher precision point
     */
    private func boundsPoint(_ easting: Double, _ northing: Double, _ west: GridPoint,
                             _ east: GridPoint, _ eastern: Bool) -> GridPoint {

        let line = Line(west, east)

        let boundsLine = eastern ? bounds.eastLine() : bounds.westLine()

        let zoneNumber = number()
        let hemisphere = hemisphere()

        // Intersection between the horizontal line and vertical bounds line
        let intersection = line.intersection(boundsLine)

        // Intersection easting
        let intersectionUTM = UTM.from(intersection!, zoneNumber, hemisphere)
        let intersectionEasting = intersectionUTM.easting

        // One meter precision just outside the bounds
        var boundsEasting = intersectionEasting - easting
        if eastern {
            boundsEasting = ceil(boundsEasting)
        } else {
            boundsEasting = floor(boundsEasting)
        }

        // Higher precision point just outside of the bounds
        let boundsPoint = UTM.point(zoneNumber, hemisphere,
                easting + boundsEasting, northing)

        return boundsPoint
    }
    
    /**
     * Get the draw bounds of easting and northing in meters
     *
     * @param tileBounds
     *            tile bounds
     * @param gridType
     *            grid type
     * @return draw bounds or null
     */
    public func drawBounds(_ tileBounds: Bounds, _ gridType: GridType) -> Bounds? {

        var drawBounds: Bounds? = nil

        let tileBoundsOverlap = tileBounds.toDegrees().overlap(bounds)

        if tileBoundsOverlap != nil && !tileBoundsOverlap!.isEmpty() {

            let zoneNumber = number()
            let hemisphere = hemisphere()

            let upperLeftUTM = UTM.from(tileBoundsOverlap!.northwest, zoneNumber,
                    hemisphere)
            let lowerLeftUTM = UTM.from(tileBoundsOverlap!.southwest, zoneNumber,
                    hemisphere)
            let lowerRightUTM = UTM.from(tileBoundsOverlap!.southeast, zoneNumber,
                    hemisphere)
            let upperRightUTM = UTM.from(tileBoundsOverlap!.northeast, zoneNumber,
                    hemisphere)

            let precision = Double(gridType.precision())
            let leftEasting = floor(min(upperLeftUTM.easting, lowerLeftUTM.easting)
                                    / precision) * precision
            let lowerNorthing = floor(min(lowerLeftUTM.northing, lowerRightUTM.northing)
                                    / precision) * precision
            let rightEasting = ceil(max(lowerRightUTM.easting, upperRightUTM.easting)
                                    / precision) * precision
            let upperNorthing = ceil(max(upperRightUTM.northing, upperLeftUTM.northing)
                                    / precision) * precision

            drawBounds = Bounds.meters(leftEasting, lowerNorthing, rightEasting,
                    upperNorthing)

        }

        return drawBounds
    }
    
}
