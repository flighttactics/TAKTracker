//
//  Hemisphere.swift
//  grid-ios
//
//  Created by Brian Osborn on 8/5/22.
//

import Foundation

/**
 * Hemisphere enumeration
 */
public enum Hemisphere: Int {
    
    /**
     * Northern hemisphere
     */
    case NORTH
    
    /**
     * Southern hemisphere
     */
    case SOUTH
    
    /**
     * Get the hemisphere for the latitude
     *
     * @param latitude
     *            latitude
     * @return hemisphere
     */
    public static func from(_ latitude: Double) -> Hemisphere {
        return latitude >= 0 ? Hemisphere.NORTH : Hemisphere.SOUTH
    }

    /**
     * Get the hemisphere for the point
     *
     * @param point
     *            point
     * @return hemisphere
     */
    public static func from(_ point: GridPoint) -> Hemisphere {
        return from(point.latitude)
    }
    
    var name: String {
        get { return String(describing: self) }
    }
    
}
