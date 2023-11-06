//
//  BandLetterRange.swift
//  mgrs-ios
//
//  Created by Brian Osborn on 8/23/22.
//

import Foundation

/**
 * Band Letter Range
 */
public class BandLetterRange: Sequence {
    
    /**
     * Southern band letter
     */
    public var south: Character
    
    /**
     * Northern band letter
     */
    public var north: Character
    
    /**
     * Initialize, full range
     */
    public convenience init() {
        self.init(MGRSConstants.MIN_BAND_LETTER, MGRSConstants.MAX_BAND_LETTER)
    }
    
    /**
     * Initialize
     *
     * @param south
     *            southern band letter
     * @param north
     *            northern band letter
     */
    public init(_ south: Character, _ north: Character) {
        self.south = south
        self.north = north
    }
    
    /**
     * Get the southern latitude
     *
     * @return latitude
     */
    public func southLatitude() -> Double {
        return GridZones.latitudeBand(south).south
    }
    
    /**
     * Get the northern latitude
     *
     * @return latitude
     */
    public func northLatitude() -> Double {
        return GridZones.latitudeBand(north).north
    }
    
    public func makeIterator() -> BandLetterRangeIterator {
        return BandLetterRangeIterator(self)
    }
    
}

public struct BandLetterRangeIterator: IteratorProtocol {
    
    var letter: Character
    let north: Character

    init(_ range: BandLetterRange) {
        self.letter = range.south
        self.north = range.north
    }

    public mutating func next() -> Character? {
        var value: Character? = nil
        if letter <= north {
            value = letter
            letter = MGRSUtils.nextBandLetter(letter)
        }
        return value
    }
    
}
