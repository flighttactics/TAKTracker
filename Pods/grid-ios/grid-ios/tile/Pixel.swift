//
//  Pixel.swift
//  grid-ios
//
//  Created by Brian Osborn on 8/3/22.
//

import Foundation

/**
 * Tile Pixel
 */
public class Pixel {

    /**
     * X pixel
     */
    public var x: Float

    /**
     * Y pixel
     */
    public var y: Float

    /**
     * Initialize
     *
     * @param x
     *            x pixel
     * @param y
     *            y pixel
     */
    public init(_ x: Float, _ y: Float) {
        self.x = x
        self.y = y
    }
    
}
