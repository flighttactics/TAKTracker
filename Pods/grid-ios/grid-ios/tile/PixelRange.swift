//
//  PixelRange.swift
//  grid-ios
//
//  Created by Brian Osborn on 8/3/22.
//

import Foundation

/**
 * Pixel Range
 */
public class PixelRange {
    
    /**
     * Top left pixel
     */
    public var topLeft: Pixel

    /**
     * Bottom right pixel
     */
    public var bottomRight: Pixel
    
    /**
     * Get the minimum x pixel
     *
     * @return minimum x pixel
     */
    public var minX: Float {
        get {
            return topLeft.x
        }
    }

    /**
     * Get the minimum y pixel
     *
     * @return minimum y pixel
     */
    public var minY: Float {
        get {
            return topLeft.y
        }
    }

    /**
     * Get the maximum x pixel
     *
     * @return maximum x pixel
     */
    public var maxX: Float {
        get {
            return bottomRight.x
        }
    }

    /**
     * Get the maximum y pixel
     *
     * @return maximum y pixel
     */
    public var maxY: Float {
        get {
            return bottomRight.y
        }
    }

    /**
     * Get the left pixel
     *
     * @return left pixel
     */
    public var left: Float {
        get {
            return minX
        }
    }

    /**
     * Get the top pixel
     *
     * @return top pixel
     */
    public var top: Float {
        get {
            return minY
        }
    }

    /**
     * Get the right pixel
     *
     * @return right pixel
     */
    public var right: Float {
        get {
            return maxX
        }
    }

    /**
     * Get the bottom pixel
     *
     * @return bottom pixel
     */
    public var bottom: Float {
        get {
            return maxY
        }
    }

    /**
     * Get the pixel width
     *
     * @return pixel width
     */
    public var width: Float {
        get {
            return maxX - minX
        }
    }

    /**
     * Get the pixel height
     *
     * @return pixel height
     */
    public var height: Float {
        get {
            return maxY - minY
        }
    }
    
    /**
     * Initialize
     *
     * @param topLeft
     *            top left pixel
     * @param bottomRight
     *            bottom right pixel
     */
    public init(_ topLeft: Pixel, _ bottomRight: Pixel) {
        self.topLeft = topLeft
        self.bottomRight = bottomRight
    }
    
}
