//
//  GridTile.swift
//  grid-ios
//
//  Created by Brian Osborn on 8/3/22.
//

import Foundation

/**
 * Grid Tile
 */
public class GridTile {
    
    /**
     * Tile width
     */
    public var width: Int
    
    /**
     * Tile height
     */
    public var height: Int
    
    /**
     * Grid Zoom level
     */
    public var zoom: Int
    
    /**
     * Bounds
     */
    public var bounds: Bounds
    
    /**
     * Initialize
     *
     * @param width
     *            tile width
     * @param height
     *            tile height
     * @param x
     *            x coordinate
     * @param y
     *            y coordinate
     * @param zoom
     *            zoom level
     */
    public convenience init(_ width: Int, _ height: Int, _ x: Int, _ y: Int, _ zoom: Int) {
        self.init(width, height, x, y, zoom, zoom)
    }
    
    /**
     * Initialize
     *
     * @param width
     *            tile width
     * @param height
     *            tile height
     * @param x
     *            x coordinate
     * @param y
     *            y coordinate
     * @param zoom
     *            zoom level
     * @param gridZoom
     *            grid zoom level if different from the XYZ zoom level
     */
    public init(_ width: Int, _ height: Int, _ x: Int, _ y: Int, _ zoom: Int, _ gridZoom: Int) {
        self.width = width
        self.height = height
        self.zoom = gridZoom
        self.bounds = GridUtils.bounds(x, y, zoom)
    }
    
    /**
     * Initialize
     *
     * @param width
     *            tile width
     * @param height
     *            tile height
     * @param bounds
     *            tile bounds
     */
    public convenience init(_ width: Int, _ height: Int, _ bounds: Bounds) {
        self.init(width, height, bounds, 0)
    }
    
    /**
     * Initialize
     *
     * @param width
     *            tile width
     * @param height
     *            tile height
     * @param bounds
     *            tile bounds
     * @param gridZoomOffset
     *            grid zoom level offset from bounds determined zoom level
     */
    public init(_ width: Int, _ height: Int, _ bounds: Bounds, _ gridZoomOffset: Int) {
        self.width = width
        self.height = height
        self.bounds = bounds
        self.zoom = Int(round(GridUtils.zoomLevel(bounds))) + gridZoomOffset
    }
    
    /**
     * Get the bounds in the units
     *
     * @param unit
     *            units
     * @return bounds in units
     */
    public func bounds(_ unit: Unit) -> Bounds {
        return bounds.toUnit(unit)
    }
    
    /**
     * Get the bounds in degrees
     *
     * @return bounds in degrees
     */
    public func boundsDegrees() -> Bounds {
        return bounds(Unit.DEGREE)
    }
    
    /**
     * Get the bounds in meters
     *
     * @return bounds in meters
     */
    public func boundsMeters() -> Bounds {
        return bounds(Unit.METER)
    }
    
    /**
     * Get the point pixel location in the tile
     *
     * @param point
     *            point
     * @return pixel
     */
    public func pixel(_ point: GridPoint) -> Pixel {
        return GridUtils.pixel(width, height, bounds, point)
    }

    /**
     * Get the longitude in meters x pixel location in the tile
     *
     * @param longitude
     *            longitude in meters
     * @return x pixel
     */
    public func xPixel(_ longitude: Double) -> Float {
        return GridUtils.xPixel(width, bounds, longitude)
    }

    /**
     * Get the latitude (in meters) y pixel location in the tile
     *
     * @param latitude
     *            latitude in meters
     * @return y pixel
     */
    public func yPixel(_ latitude: Double) -> Float {
        return GridUtils.yPixel(height, bounds, latitude)
    }
    
}
