//
//  LongitudinalStrip.swift
//  mgrs-ios
//
//  Created by Brian Osborn on 8/23/22.
//

import Foundation

/**
 * Longitudinal (vertical) strip
 */
public class LongitudinalStrip {
    
    /**
     * Zone number
     */
    public var number: Int

    /**
     * Western longitude
     */
    public var west: Double

    /**
     * Eastern longitude
     */
    public var east: Double

    /**
     * Expansion for range iterations over neighboring strips
     */
    public var expand: Int
    
    /**
     * Initialize
     *
     * @param number
     *            zone number
     * @param west
     *            western longitude
     * @param east
     *            eastern longitude
     */
    public convenience init(_ number: Int, _ west: Double, _ east: Double) {
        self.init(number, west, east, 0)
    }
    
    /**
     * Initialize
     *
     * @param number
     *            zone number
     * @param west
     *            western longitude
     * @param east
     *            eastern longitude
     * @param expand
     *            expansion for range iterations over neighboring strips
     */
    public init(_ number: Int, _ west: Double, _ east: Double, _ expand: Int) {
        self.number = number
        self.west = west
        self.east = east
        self.expand = expand
    }
    
}
