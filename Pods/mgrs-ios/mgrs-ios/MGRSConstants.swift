//
//  MGRSConstants.swift
//  mgrs-ios
//
//  Created by Brian Osborn on 8/23/22.
//

import Foundation
import grid_ios

/**
 * Military Grid Reference System Constants
 */
public struct MGRSConstants {
    
    /**
     * Minimum longitude
     */
    public static let MIN_LON = GridConstants.MIN_LON
    
    /**
     * Maximum longitude
     */
    public static let MAX_LON = GridConstants.MAX_LON

    /**
     * Minimum latitude
     */
    public static let MIN_LAT = -80.0

    /**
     * Maximum latitude
     */
    public static let MAX_LAT = 84.0
    
    /**
     * Minimum grid zone number
     */
    public static let MIN_ZONE_NUMBER = 1
    
    /**
     * Maximum grid zone number
     */
    public static let MAX_ZONE_NUMBER = 60

    /**
     * Grid zone width
     */
    public static let ZONE_WIDTH = 6.0

    /**
     * Minimum grid band letter
     */
    public static let MIN_BAND_LETTER: Character = "C"

    /**
     * Maximum grid band letter
     */
    public static let MAX_BAND_LETTER: Character = "X"
    
    /**
     * Number of bands
     */
    public static let NUM_BANDS = 20
    
    /**
     * Grid band height for all by but the MAX_BAND_LETTER
     */
    public static let BAND_HEIGHT = 8.0

    /**
     * Grid band height for the MAX_BAND_LETTER
     */
    public static let MAX_BAND_HEIGHT = 12.0

    /**
     * Last southern hemisphere band letter
     */
    public static let BAND_LETTER_SOUTH: Character = "M"

    /**
     * First northern hemisphere band letter
     */
    public static let BAND_LETTER_NORTH: Character = "N"

    /**
     * Min zone number in Svalbard grid zones
     */
    public static let MIN_SVALBARD_ZONE_NUMBER = 31

    /**
     * Max zone number in Svalbard grid zones
     */
    public static let MAX_SVALBARD_ZONE_NUMBER = 37

    /**
     * Band letter in Svalbard grid zones
     */
    public static let SVALBARD_BAND_LETTER = MAX_BAND_LETTER

    /**
     * Min zone number in Norway grid zones
     */
    public static let MIN_NORWAY_ZONE_NUMBER = 31

    /**
     * Max zone number in Norway grid zones
     */
    public static let MAX_NORWAY_ZONE_NUMBER = 32

    /**
     * Band letter in Norway grid zones
     */
    public static let NORWAY_BAND_LETTER: Character = "V"
    
    /**
     * Grid zoom display offset from XYZ tile zoom levels
     */
    public static let ZOOM_OFFSET = -1
    
}
