//
//  LatitudeBand.swift
//  mgrs-ios
//
//  Created by Brian Osborn on 8/23/22.
//

import Foundation
import grid_ios

/**
 * Latitude (horizontal) band
 */
public class LatitudeBand {
    
    private var _letter: Character
    
    /**
     * Band letter
     */
    public var letter: Character {
        get {
            return _letter
        }
        set {
            _letter = newValue
            hemisphere = MGRSUtils.hemisphere(letter)
        }
    }

    /**
     * Southern latitude
     */
    public var south: Double

    /**
     * Northern latitude
     */
    public var north: Double

    /**
     * Hemisphere
     */
    public var hemisphere: Hemisphere
    
    /**
     * Initialize
     *
     * @param letter
     *            band letter
     * @param south
     *            southern latitude
     * @param north
     *            northern latitude
     */
    public init(_ letter: Character, _ south: Double, _ north: Double) {
        _letter = letter
        self.south = south
        self.north = north
        hemisphere = MGRSUtils.hemisphere(letter)
    }
    
}
