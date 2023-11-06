//
//  GridRange.swift
//  mgrs-ios
//
//  Created by Brian Osborn on 8/23/22.
//

import Foundation
import grid_ios

/**
 * Grid Range
 */
public class GridRange: Sequence {
    
    /**
     * Zone Number Range
     */
    public var zoneNumberRange: ZoneNumberRange
    
    /**
     * Band Letter Range
     */
    public var bandLetterRange: BandLetterRange
    
    /**
     * Initialize, full range
     */
    public init() {
        self.zoneNumberRange = ZoneNumberRange()
        self.bandLetterRange = BandLetterRange()
    }
    
    /**
     * Initialize
     *
     * @param bandNumberRange
     *            band number range
     * @param bandLettersRange
     *            band letters range
     */
    public init(_ zoneNumberRange: ZoneNumberRange, _ bandLetterRange: BandLetterRange) {
        self.zoneNumberRange = zoneNumberRange
        self.bandLetterRange = bandLetterRange
    }
    
    /**
     * Get the grid range bounds
     *
     * @return bounds
     */
    public func bounds() -> Bounds {

        let west = zoneNumberRange.westLongitude()
        let south = bandLetterRange.southLatitude()
        let east = zoneNumberRange.eastLongitude()
        let north = bandLetterRange.northLatitude()

        return Bounds.degrees(west, south, east, north)
    }
    
    public func makeIterator() -> GridRangeIterator {
        return GridRangeIterator(self)
    }
    
}

public struct GridRangeIterator: IteratorProtocol {
    
    let minZoneNumber: Int
    let maxZoneNumber: Int
    let minBandLetter: Character
    let maxBandLetter: Character
    var zoneNumber: Int
    var bandLetter: Character
    var gridZone: GridZone?
    var additional: [GridZone] = []

    init(_ range: GridRange) {
        minZoneNumber = range.zoneNumberRange.west
        maxZoneNumber = range.zoneNumberRange.east
        minBandLetter = range.bandLetterRange.south
        maxBandLetter = range.bandLetterRange.north
        zoneNumber = minZoneNumber
        bandLetter = minBandLetter
    }

    public mutating func next() -> GridZone? {
        var gridZone: GridZone? = nil

        while gridZone == nil && zoneNumber <= maxZoneNumber {
            
            gridZone = GridZones.gridZone(zoneNumber, bandLetter)

            // Handle special case grid gaps (Svalbard)
            if gridZone == nil {

                // Retrieve the western grid if on the left edge
                if zoneNumber == minZoneNumber {
                    additional.append(GridZones.gridZone(zoneNumber - 1, bandLetter)!)
                }

                // Expand to the eastern grid if on the right edge
                if zoneNumber == maxZoneNumber {
                    additional.append(GridZones.gridZone(zoneNumber + 1, bandLetter)!)
                }

            } else {

                // Handle special case grid zone expansions (Norway)
                let expand = gridZone!.stripExpand()
                if expand != 0 {
                    if expand > 0 {
                        for expandZone in stride(from: zoneNumber + expand, to: zoneNumber, by: -1) {
                            if expandZone > maxZoneNumber {
                                additional.append(GridZones.gridZone(expandZone, bandLetter)!)
                            } else {
                                break
                            }
                        }
                    } else {
                        for expandZone in zoneNumber + expand ..< zoneNumber {
                            if expandZone < minZoneNumber {
                                additional.append(GridZones.gridZone(expandZone, bandLetter)!)
                            } else {
                                break
                            }
                        }
                    }
                }

            }

            bandLetter = MGRSUtils.nextBandLetter(bandLetter)
            if bandLetter > maxBandLetter {
                zoneNumber += 1
                bandLetter = minBandLetter
            }
            
        }
        
        if gridZone == nil && additional.count > 0 {
            gridZone = additional.removeFirst()
        }
        
        return gridZone
    }
    
}
