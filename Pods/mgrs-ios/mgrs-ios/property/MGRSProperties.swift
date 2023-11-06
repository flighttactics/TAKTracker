//
//  MGRSProperties.swift
//  mgrs-ios
//
//  Created by Brian Osborn on 8/23/22.
//

import Foundation
import grid_ios

/**
 * MGRS property loader
 */
public class MGRSProperties: GridProperties {
    
    /**
     * Bundle Name
     */
    public static let BUNDLE_NAME = "mgrs-ios.bundle"
    
    /**
     * Properties Name
     */
    public static let PROPERTIES_NAME = "mgrs"
    
    /**
     * Singleton instance
     */
    private static let _instance = MGRSProperties(MGRSProperties.self, BUNDLE_NAME, PROPERTIES_NAME)
    
    public static var instance: MGRSProperties {
        get {
            return _instance
        }
    }

}
