//
//  MGRSUtils.swift
//  mgrs-ios
//
//  Created by Brian Osborn on 8/23/22.
//

import Foundation
import grid_ios

/**
 * Military Grid Reference System utilities
 */
public class MGRSUtils {
    
    /**
     * Validate the zone number
     *
     * @param number
     *            zone number
     */
    public static func validateZoneNumber(_ number: Int) {
        if number < MGRSConstants.MIN_ZONE_NUMBER
                || number > MGRSConstants.MAX_ZONE_NUMBER {
            preconditionFailure("Illegal zone number (expected \(MGRSConstants.MIN_ZONE_NUMBER) - \(MGRSConstants.MAX_ZONE_NUMBER)): \(number)")
        }
    }

    /**
     * Validate the band letter
     *
     * @param letter
     *            band letter
     */
    public static func validateBandLetter(_ letter: Character) {
        if letter < MGRSConstants.MIN_BAND_LETTER
                || letter > MGRSConstants.MAX_BAND_LETTER
                || GridUtils.isOmittedBandLetter(letter) {
            preconditionFailure("Illegal band letter (CDEFGHJKLMNPQRSTUVWX): \(letter)")
        }
    }
    
    /**
     * Get the next band letter
     *
     * @param letter
     *            band letter
     * @return next band letter, 'Y' (MGRSConstants.MAX_BAND_LETTER + 1)
     *         if no next bands
     */
    public static func nextBandLetter(_ letter: Character) -> Character {
        validateBandLetter(letter)
        var letterValue = GridUtils.incrementCharacter(letter)
        if GridUtils.isOmittedBandLetter(letterValue) {
            letterValue = GridUtils.incrementCharacter(letterValue)
        }
        return letterValue
    }
    
    /**
     * Get the previous band letter
     *
     * @param letter
     *            band letter
     * @return previous band letter, 'B' (MGRSConstants.MIN_BAND_LETTER
     *         - 1) if no previous bands
     */
    public static func previousBandLetter(_ letter: Character) -> Character {
        validateBandLetter(letter)
        var letterValue = GridUtils.decrementCharacter(letter)
        if GridUtils.isOmittedBandLetter(letterValue) {
            letterValue = GridUtils.decrementCharacter(letterValue)
        }
        return letterValue
    }
    
    /**
     * Get the label name
     *
     * @param zoneNumber
     *            zone number
     * @param bandLetter
     *            band letter
     * @return name
     */
    public static func labelName(_ zoneNumber: Int, _ bandLetter: Character) -> String {
        return String(zoneNumber) + String(bandLetter)
    }

    /**
     * Get the hemisphere from the band letter
     *
     * @param bandLetter
     *            band letter
     * @return hemisphere
     */
    public static func hemisphere(_ bandLetter: Character) -> Hemisphere {
        return bandLetter < MGRSConstants.BAND_LETTER_NORTH ? Hemisphere.SOUTH
                : Hemisphere.NORTH
    }
    
}
