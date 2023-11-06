//
//  Unit.swift
//  grid-ios
//
//  Created by Brian Osborn on 8/3/22.
//

import Foundation

/**
 * Unit
 */
public enum Unit: Int {
    
    /**
     * Degrees
     */
    case DEGREE
    
    /**
     * Meters
     */
    case METER
    
    var name: String {
        get { return String(describing: self) }
    }
    
}
