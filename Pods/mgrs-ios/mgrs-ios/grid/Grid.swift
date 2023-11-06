//
//  Grid.swift
//  mgrs-ios
//
//  Created by Brian Osborn on 9/2/22.
//

import Foundation
import grid_ios
import color_ios

/**
 * Grid
 */
public class Grid: BaseGrid {
    
    /**
     * Default line width
     */
    public static let DEFAULT_WIDTH = MGRSProperties.instance.doubleValue(PropertyConstants.GRID, PropertyConstants.WIDTH)
    
    /**
     * Grid type
     */
    public let type: GridType
    
    /**
     * Grid line styles
     */
    private var styles: [GridType: GridStyle] = [:]
    
    /**
     * Initialize
     *
     * @param type
     *            grid type
     */
    public init(_ type: GridType) {
        self.type = type
    }
    
    /**
     * Is the provided grid type
     *
     * @param type
     *            grid type
     * @return true if the type
     */
    public func isType(_ type: GridType) -> Bool {
        return self.type == type
    }
    
    /**
     * Get the precision in meters
     *
     * @return precision meters
     */
    public func precision() -> Int {
        return type.precision()
    }
    
    /**
     * Get the grid type precision line style for the grid type
     *
     * @param gridType
     *            grid type
     * @return grid type line style
     */
    public func style(_ gridType: GridType) -> GridStyle? {
        let style: GridStyle?
        if gridType == type {
            style = self.style
        } else {
            style = styles[gridType]
        }
        return style
    }
    
    /**
     * Get the grid type line style for the grid type or create it
     *
     * @param gridType
     *            grid type
     * @return grid type line style
     */
    private func getOrCreateStyle(_ gridType: GridType) -> GridStyle {
        var style = style(gridType)
        if style == nil {
            style = GridStyle()
            setStyle(gridType, style!)
        }
        return style!
    }
    
    /**
     * Set the grid type precision line style
     *
     * @param gridType
     *            grid type
     * @param style
     *            grid line style
     */
    public func setStyle(_ gridType: GridType, _ style: GridStyle?) {
        if gridType.precision() < precision() {
            preconditionFailure("Grid can not define a style for a higher precision grid type. Type: \(type), Style Type: \(gridType)")
        }
        let gridStyle = style != nil ? style! : GridStyle()
        if gridType == type {
            self.style = gridStyle
        } else {
            styles[gridType] = gridStyle
        }
    }
    
    /**
     * Clear the propagated grid type precision styles
     */
    public func clearPrecisionStyles() {
        styles.removeAll()
    }
    
    /**
     * Get the grid type precision line color
     *
     * @param gridType
     *            grid type
     * @return grid type line color
     */
    public func color(_ gridType: GridType) -> UIColor? {
        var color: UIColor? = nil
        let style = style(gridType)
        if style != nil {
            color = style!.color
        }
        if color == nil {
            color = self.color
        }
        return color
    }
    
    /**
     * Set the grid type precision line color
     *
     * @param gridType
     *            grid type
     * @param color
     *            grid line color
     */
    public func setColor(_ gridType: GridType, _ color: UIColor) {
        getOrCreateStyle(gridType).color = color
    }
    
    /**
     * Get the grid type precision line width
     *
     * @param gridType
     *            grid type
     * @return grid type line width
     */
    public func width(_ gridType: GridType) -> Double {
        var width = 0.0
        let style = style(gridType)
        if style != nil {
            width = style!.width
        }
        if width == 0 {
            width = self.width
        }
        return width
    }
    
    /**
     * Set the grid type precision line width
     *
     * @param gridType
     *            grid type
     * @param width
     *            grid line width
     */
    public func setWidth(_ gridType: GridType, _ width: Double) {
        getOrCreateStyle(gridType).width = width
    }
    
    /**
     * Get the grid labeler
     *
     * @return grid labeler
     */
    public func labeler() -> GridLabeler? {
        return labeler as? GridLabeler
    }
    
    /**
     * Set the grid labeler
     *
     * @param labeler
     *            grid labeler
     */
    public func setLabeler(_ labeler: GridLabeler?) {
        self.labeler = labeler
    }
    
    /**
     * Get the lines for the tile and zone
     *
     * @param tile
     *            tile
     * @param zone
     *            grid zone
     * @return lines
     */
    public func lines(_ tile: GridTile, _ zone: GridZone) -> [MGRSLine]? {
        return lines(tile.zoom, tile.bounds, zone)
    }
    
    /**
     * Get the lines for the zoom, tile bounds, and zone
     *
     * @param zoom
     *            zoom level
     * @param tileBounds
     *            tile bounds
     * @param zone
     *            grid zone
     * @return lines
     */
    public func lines(_ zoom: Int, _ tileBounds: Bounds, _ zone: GridZone) -> [MGRSLine]? {
        var gridLines: [MGRSLine]? = nil
        if isLinesWithin(zoom) {
            gridLines = lines(tileBounds, zone)
        }
        return gridLines
    }
    
    /**
     * Get the lines for the tile bounds and zone
     *
     * @param tileBounds
     *            tile bounds
     * @param zone
     *            grid zone
     * @return lines
     */
    public func lines(_ tileBounds: Bounds, _ zone: GridZone) -> [MGRSLine]? {
        return zone.lines(tileBounds, type)
    }
    
    /**
     * Get the labels for the tile and zone
     *
     * @param tile
     *            tile
     * @param zone
     *            grid zone
     * @return labels
     */
    public func labels(_ tile: GridTile, _ zone: GridZone) -> [GridLabel]? {
        return labels(tile.zoom, tile.bounds, zone)
    }

    /**
     * Get the labels for the zoom, tile bounds, and zone
     *
     * @param zoom
     *            zoom level
     * @param tileBounds
     *            tile bounds
     * @param zone
     *            grid zone
     * @return labels
     */
    public func labels(_ zoom: Int, _ tileBounds: Bounds, _ zone: GridZone) -> [GridLabel]? {
        var labels: [GridLabel]? = nil
        if isLabelerWithin(zoom) {
            labels = labeler()!.labels(tileBounds, type, zone)
        }
        return labels
    }
    
    public override func equals(_ grid: BaseGrid) -> Bool {
        return type == (grid as! Grid).type
    }
    
    public override func hash(into hasher: inout Hasher) {
        hasher.combine(type)
    }
    
    public override func compare(_ grid: BaseGrid) -> Bool {
        return precisionCompare() <= (grid as! Grid).precisionCompare()
    }
    
    /**
     * Get the precision in meters
     *
     * @return precision meters
     */
    public func precisionCompare() -> Int {
        var precision = precision()
        if precision <= GridType.GZD.precision() {
            precision = Int.max
        }
        return precision
    }
    
}
