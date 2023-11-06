//
//  ZoneNumberRange.swift
//  mgrs-ios
//
//  Created by Brian Osborn on 8/23/22.
//

import Foundation

/**
 * Zone Number Range
 */
public class ZoneNumberRange: Sequence {
    
    /**
     * Western zone number
     */
    public var west: Int
    
    /**
     * Eastern zone number
     */
    public var east: Int
    
    /**
     * Initialize, full range
     */
    public convenience init() {
        self.init(MGRSConstants.MIN_ZONE_NUMBER, MGRSConstants.MAX_ZONE_NUMBER)
    }
    
    /**
     * Initialize
     *
     * @param west
     *            western zone number
     * @param east
     *            eastern zone number
     */
    public init(_ west: Int, _ east: Int) {
        self.west = west
        self.east = east
    }
    
    /**
     * Get the western longitude
     *
     * @return longitude
     */
    public func westLongitude() -> Double {
        return GridZones.longitudinalStrip(west).west
    }
    
    /**
     * Get the eastern longitude
     *
     * @return longitude
     */
    public func eastLongitude() -> Double {
        return GridZones.longitudinalStrip(east).east
    }
    
    public func makeIterator() -> ZoneNumberRangeIterator {
        return ZoneNumberRangeIterator(self)
    }
    
}

public struct ZoneNumberRangeIterator: IteratorProtocol {
    
    var number: Int
    var east: Int

    init(_ range: ZoneNumberRange) {
        self.number = range.west
        self.east = range.east
    }

    public mutating func next() -> Int? {
        var value: Int? = nil
        if number <= east {
            value = number
            number += 1
        }
        return value
    }
    
}
