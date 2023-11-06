//
//  GridZones.swift
//  mgrs-ios
//
//  Created by Brian Osborn on 8/24/22.
//

import Foundation
import grid_ios

/**
 * Grid Zones, Longitudinal Strips, and Latitude Bands
 */
public class GridZones {
    
    /**
     * Longitudinal Strips
     */
    public static var strips: [Int: LongitudinalStrip] = [:]
    
    /**
     * Latitude Bands
     */
    public static var bands: [Character: LatitudeBand] = [:]
    
    /**
     * Grid Zones
     */
    public static var gridZones: [Int: [Character: GridZone]] = [:]
    
    private static var initialized = false
    
    private static let lock = NSLock()
    
    private static func initGridZones() {
        lock.lock()
        if !initialized {
            initialize()
            initialized = true
        }
        lock.unlock()
    }
    
    private static func initialize() {
        
        // Create longitudinal strips
        let numberRange = ZoneNumberRange()
        for zoneNumber in numberRange {
            let longitude = MGRSConstants.MIN_LON
                    + (Double(zoneNumber - 1) * MGRSConstants.ZONE_WIDTH)
            let strip = LongitudinalStrip(zoneNumber,
                    longitude, longitude + MGRSConstants.ZONE_WIDTH)
            strips[strip.number] = strip
        }

        // Create latitude bands
        var latitude = MGRSConstants.MIN_LAT
        let letterRange = BandLetterRange()
        for bandLetter in letterRange {
            let min = latitude
            if bandLetter == MGRSConstants.MAX_BAND_LETTER {
                latitude += MGRSConstants.MAX_BAND_HEIGHT
            } else {
                latitude += MGRSConstants.BAND_HEIGHT
            }
            bands[bandLetter] = LatitudeBand(bandLetter, min, latitude)
        }

        // Create grid zones
        for strip in strips.values {

            let zoneNumber = strip.number

            var stripGridZones: [Character: GridZone] = [:]
            for band in bands.values {

                let bandLetter = band.letter

                var gridZoneStrip: LongitudinalStrip? = strip

                if isSvalbard(zoneNumber, bandLetter) {
                    gridZoneStrip = svalbardStrip(strip)
                } else if isNorway(zoneNumber, bandLetter) {
                    gridZoneStrip = norwayStrip(strip)
                }

                if gridZoneStrip != nil {
                    stripGridZones[bandLetter] = GridZone(gridZoneStrip!, band)
                }

            }
            gridZones[zoneNumber] = stripGridZones
        }
        
    }
    
    /**
     * Get the longitudinal strip by zone number
     *
     * @param zoneNumber
     *            zone number
     * @return longitudinal strip
     */
    public static func longitudinalStrip(_ zoneNumber: Int) -> LongitudinalStrip {
        MGRSUtils.validateZoneNumber(zoneNumber)
        if !initialized {
            initGridZones()
        }
        return strips[zoneNumber]!
    }
    
    /**
     * Get the west longitude in degrees of the zone number
     *
     * @param zoneNumber
     *            zone number
     * @return longitude in degrees
     */
    public static func westLongitude(_ zoneNumber: Int) -> Double {
        return longitudinalStrip(zoneNumber).west
    }

    /**
     * Get the east longitude in degrees of the zone number
     *
     * @param zoneNumber
     *            zone number
     * @return longitude in degrees
     */
    public static func eastLongitude(_ zoneNumber: Int) -> Double {
        return longitudinalStrip(zoneNumber).east
    }
    
    /**
     * Get the latitude band by band letter
     *
     * @param bandLetter
     *            band letter
     * @return latitude band
     */
    public static func latitudeBand(_ bandLetter: Character) -> LatitudeBand {
        MGRSUtils.validateBandLetter(bandLetter)
        if !initialized {
            initGridZones()
        }
        return bands[bandLetter]!
    }
    
    /**
     * Get the south latitude in degrees of the band letter
     *
     * @param bandLetter
     *            band letter
     * @return latitude in degrees
     */
    public static func southLatitude(_ bandLetter: Character) -> Double {
        return latitudeBand(bandLetter).south
    }

    /**
     * Get the north latitude in degrees of the band letter
     *
     * @param bandLetter
     *            band letter
     * @return latitude in degrees
     */
    public static func northLatitude(_ bandLetter: Character) -> Double {
        return latitudeBand(bandLetter).north
    }
    
    /**
     * Get the zones within the bounds
     *
     * @param bounds
     *            bounds
     * @return grid zones
     */
    public static func zones(_ bounds: Bounds) -> [GridZone] {

        var zones: [GridZone] = []

        let range = gridRange(bounds)
        for zone in range {
            zones.append(zone)
        }

        return zones
    }
    
    /**
     * Get the grid zone by zone number and band letter
     *
     * @param zoneNumber
     *            zone number
     * @param bandLetter
     *            band letter
     * @return grid zone
     */
    public static func gridZone(_ zoneNumber: Int, _ bandLetter: Character) -> GridZone? {
        MGRSUtils.validateZoneNumber(zoneNumber)
        MGRSUtils.validateBandLetter(bandLetter)
        if !initialized {
            initGridZones()
        }
        return gridZones[zoneNumber]![bandLetter]
    }
    
    /**
     * Get the grid zone by MGRS
     *
     * @param mgrs
     *            mgrs coordinate
     * @return grid zone
     */
    public static func gridZone(_ mgrs: MGRS) -> GridZone? {
        return gridZone(mgrs.zone, mgrs.band)
    }
    
    /**
     * Get a grid range from the bounds
     *
     * @param bounds
     *            bounds
     * @return grid range
     */
    public static func gridRange(_ bounds: Bounds) -> GridRange {
        let boundsDegrees = bounds.toDegrees()
        let zoneRange = zoneNumberRange(boundsDegrees)
        let bandRange = bandLetterRange(boundsDegrees)
        return GridRange(zoneRange, bandRange)
    }
    
    /**
     * Get a zone number range between the western and eastern bounds
     *
     * @param bounds
     *            bounds
     * @return zone number range
     */
    public static func zoneNumberRange(_ bounds: Bounds) -> ZoneNumberRange {
        let boundsDegrees = bounds.toDegrees()
        return zoneNumberRange(boundsDegrees.west, boundsDegrees.east)
    }
    
    /**
     * Get a zone number range between the western and eastern longitudes
     *
     * @param west
     *            western longitude in degrees
     * @param east
     *            eastern longitude in degrees
     * @return zone number range
     */
    public static func zoneNumberRange(_ west: Double, _ east: Double) -> ZoneNumberRange {
        let westZone = zoneNumber(west, false)
        let eastZone = zoneNumber(east, true)
        return ZoneNumberRange(westZone, eastZone)
    }
    
    /**
     * Get the zone number of the point
     *
     * @param point
     *            point
     * @return zone number
     */
    public static func zoneNumber(_ point: GridPoint) -> Int {
        let pointDegrees = point.toDegrees()
        return zoneNumber(pointDegrees.longitude, pointDegrees.latitude)
    }
    
    /**
     * Get the zone number of the longitude and latitude
     *
     * @param longitude
     *            longitude
     * @param latitude
     *            latitude
     * @return zone number
     */
    public static func zoneNumber(_ longitude: Double, _ latitude: Double) -> Int {
        var zoneNum = zoneNumber(longitude)
        let svalbardZone = isSvalbardZone(zoneNum)
        let norwayZone = isNorwayZone(zoneNum)
        if svalbardZone || norwayZone {
            let bandLetter = bandLetter(latitude)
            if svalbardZone && isSvalbardLetter(bandLetter) {
                zoneNum = self.svalbardZone(longitude)
            } else if norwayZone && isNorwayLetter(bandLetter) {
                zoneNum = self.norwayZone(longitude)
            }
        }
        return zoneNum
    }
    
    /**
     * Get the zone number of the longitude (degrees between
     * MGRSConstants.MIN_LON and MGRSConstants.MAX_LON). Eastern
     * zone number on borders.
     *
     * @param longitude
     *            longitude in degrees
     * @return zone number
     */
    public static func zoneNumber(_ longitude: Double) -> Int {
        return zoneNumber(longitude, true)
    }

    /**
     * Get the zone number of the longitude (degrees between
     * MGRSConstants.MIN_LON and MGRSConstants.MAX_LON)
     *
     * @param longitude
     *            longitude in degrees
     * @param eastern
     *            true for eastern number on edges, false for western
     * @return zone number
     */
    public static func zoneNumber(_ longitude: Double, _ eastern: Bool) -> Int {

        var longitudeValue = longitude
        
        // Normalize the longitude if needed
        if longitudeValue < MGRSConstants.MIN_LON
                || longitudeValue > MGRSConstants.MAX_LON {
            longitudeValue = (longitudeValue - MGRSConstants.MIN_LON)
                .truncatingRemainder(dividingBy: 2 * MGRSConstants.MAX_LON)
                + MGRSConstants.MIN_LON
        }

        // Determine the zone
        let zoneValue = (longitudeValue - MGRSConstants.MIN_LON)
                / MGRSConstants.ZONE_WIDTH
        var zoneNumber = 1 + Int(zoneValue)

        // Handle western edge cases and 180.0
        if !eastern {
            if zoneNumber > 1 && zoneValue.truncatingRemainder(dividingBy: 1.0) == 0.0 {
                zoneNumber -= 1
            }
        } else if zoneNumber > MGRSConstants.MAX_ZONE_NUMBER {
            zoneNumber -= 1
        }

        return zoneNumber
    }
    
    /**
     * Get a band letter range between the southern and northern bounds
     *
     * @param bounds
     *            bounds
     * @return band letter range
     */
    public static func bandLetterRange(_ bounds: Bounds) -> BandLetterRange {
        let boundsDegrees = bounds.toDegrees()
        return bandLetterRange(boundsDegrees.south, boundsDegrees.north)
    }

    /**
     * Get a band letter range between the southern and northern latitudes in
     * degrees
     *
     * @param south
     *            southern latitude in degrees
     * @param north
     *            northern latitude in degrees
     * @return band letter range
     */
    public static func bandLetterRange(_ south: Double, _ north: Double) -> BandLetterRange {
        let southLetter = bandLetter(south, false)
        let northLetter = bandLetter(north, true)
        return BandLetterRange(southLetter, northLetter)
    }
    
    /**
     * Get the band letter of the latitude (degrees between
     * MGRSConstants.MIN_LAT and MGRSConstants.MAX_LAT).
     * Northern band letter on borders.
     *
     * @param latitude
     *            latitude in degrees
     * @return band letter
     */
    public static func bandLetter(_ latitude: Double) -> Character {
        return bandLetter(latitude, true)
    }

    /**
     * Get the band letter of the latitude (degrees between
     * MGRSConstants.MIN_LAT and MGRSConstants.MAX_LAT)
     *
     * @param latitude
     *            latitude in degrees
     * @param northern
     *            true for northern band on edges, false for southern
     * @return band letter
     */
    public static func bandLetter(_ latitude: Double, _ northern: Bool) -> Character {

        var latitudeValue = latitude
        
        // Bound the latitude if needed
        if latitudeValue < MGRSConstants.MIN_LAT {
            latitudeValue = MGRSConstants.MIN_LAT
        } else if latitudeValue > MGRSConstants.MAX_LAT {
            latitudeValue = MGRSConstants.MAX_LAT
        }

        let bandValue = (latitudeValue - MGRSConstants.MIN_LAT)
                / MGRSConstants.BAND_HEIGHT
        var bands = Int(bandValue)

        // Handle 80.0 to 84.0 and southern edge cases
        if bands >= MGRSConstants.NUM_BANDS {
            bands -= 1
        } else if !northern && bands > 0 && bandValue.truncatingRemainder(dividingBy: 1.0) == 0.0 {
            bands -= 1
        }

        // Handle skipped 'I' and 'O' letters
        if bands > 10 {
            bands += 2
        } else if bands > 5 {
            bands += 1
        }

        return GridUtils.incrementCharacter(MGRSConstants.MIN_BAND_LETTER, bands)
    }
    
    /**
     * Is the zone number and band letter a Svalbard GZD (31X - 37X)
     *
     * @param zoneNumber
     *            zone number
     * @param bandLetter
     *            band letter
     * @return true if a Svalbard GZD
     */
    public static func isSvalbard(_ zoneNumber: Int, _ bandLetter: Character) -> Bool {
        return isSvalbardLetter(bandLetter) && isSvalbardZone(zoneNumber)
    }

    /**
     * Is the band letter a Svalbard GZD (X)
     *
     * @param bandLetter
     *            band letter
     * @return true if a Svalbard GZD
     */
    public static func isSvalbardLetter(_ bandLetter: Character) -> Bool {
        return bandLetter == MGRSConstants.SVALBARD_BAND_LETTER
    }

    /**
     * Is the zone number a Svalbard GZD (31 - 37)
     *
     * @param zoneNumber
     *            zone number
     * @return true if a Svalbard GZD
     */
    public static func isSvalbardZone(_ zoneNumber: Int) -> Bool {
        return zoneNumber >= MGRSConstants.MIN_SVALBARD_ZONE_NUMBER
                && zoneNumber <= MGRSConstants.MAX_SVALBARD_ZONE_NUMBER
    }

    /**
     * Get the Svalbard longitudinal strip from the strip
     *
     * @param strip
     *            longitudinal strip
     * @return Svalbard strip or null for empty strips
     */
    private static func svalbardStrip(_ strip: LongitudinalStrip) -> LongitudinalStrip? {

        var svalbardStrip: LongitudinalStrip? = nil

        let number = strip.number
        if number % 2 == 1 {
            var west = strip.west
            var east = strip.east
            let halfWidth = (east - west) / 2.0
            if number > 31 {
                west -= halfWidth
            }
            if number < 37 {
                east += halfWidth
            }
            svalbardStrip = LongitudinalStrip(number, west, east)
        }

        return svalbardStrip
    }

    /**
     * Get the Svalbard zone number from the longitude
     *
     * @param longitude
     *            longitude
     * @return zone number
     */
    private static func svalbardZone(_ longitude: Double) -> Int {
        let minimumLongitude = westLongitude(
                MGRSConstants.MIN_SVALBARD_ZONE_NUMBER)
        let zoneValue = Double(MGRSConstants.MIN_SVALBARD_ZONE_NUMBER)
                + ((longitude - minimumLongitude) / MGRSConstants.ZONE_WIDTH)
        var zone = Int(round(zoneValue))
        if zone % 2 == 0 {
            zone -= 1
        }
        return zone
    }

    /**
     * Is the zone number and band letter a Norway GZD (31V or 32V)
     *
     * @param zoneNumber
     *            zone number
     * @param bandLetter
     *            band letter
     * @return true if a Norway GZD
     */
    private static func isNorway(_ zoneNumber: Int, _ bandLetter: Character) -> Bool {
        return isNorwayLetter(bandLetter) && isNorwayZone(zoneNumber)
    }

    /**
     * Is the band letter a Norway GZD (V)
     *
     * @param bandLetter
     *            band letter
     * @return true if a Norway GZD band letter
     */
    private static func isNorwayLetter(_ bandLetter: Character) -> Bool {
        return bandLetter == MGRSConstants.NORWAY_BAND_LETTER
    }

    /**
     * Is the zone number a Norway GZD (31 or 32)
     *
     * @param zoneNumber
     *            zone number
     * @return true if a Norway GZD zone number
     */
    private static func isNorwayZone(_ zoneNumber: Int) -> Bool {
        return zoneNumber >= MGRSConstants.MIN_NORWAY_ZONE_NUMBER
                && zoneNumber <= MGRSConstants.MAX_NORWAY_ZONE_NUMBER
    }

    /**
     * Get the Norway longitudinal strip from the strip
     *
     * @param strip
     *            longitudinal strip
     * @return Norway strip
     */
    private static func norwayStrip(_ strip: LongitudinalStrip) -> LongitudinalStrip {

        let number = strip.number
        var west = strip.west
        var east = strip.east
        let halfWidth = (east - west) / 2.0

        var expand = 0
        if number == MGRSConstants.MIN_NORWAY_ZONE_NUMBER {
            east -= halfWidth
            expand += 1
        } else if number == MGRSConstants.MAX_NORWAY_ZONE_NUMBER {
            west -= halfWidth
        }

        return LongitudinalStrip(number, west, east, expand)
    }

    /**
     * Get the Norway zone number from the longitude
     *
     * @param longitude
     *            longitude
     * @return zone number
     */
    private static func norwayZone(_ longitude: Double) -> Int {
        let minimumLongitude = westLongitude(
                MGRSConstants.MIN_NORWAY_ZONE_NUMBER)
        var zone = MGRSConstants.MIN_NORWAY_ZONE_NUMBER
        if longitude >= minimumLongitude + (MGRSConstants.ZONE_WIDTH / 2.0) {
            zone += 1
        }
        return zone
    }
    
}
