//
//  BaseGrids.swift
//  grid-ios
//
//  Created by Brian Osborn on 8/8/22.
//

import Foundation
import color_ios

/**
 * Grids
 */
open class BaseGrids {
  
    /**
     * Grid properties
     */
    public let properties: GridProperties
    
    /**
     * Map between zoom levels and grids
     */
    private var zoomGrids: [Int: BaseZoomGrids] = [:]
    
    /**
     * Initialize
     *
     * @param properties
     *            grid properties
     */
    public init(_ properties: GridProperties) {
        self.properties = properties
    }
    
    /**
     * Get the default grid line width
     *
     * @return width
     */
    open func defaultWidth() -> Double {
        preconditionFailure("This method must be overridden")
    }

    /**
     * Get the grids
     *
     * @return grids
     */
    open func grids() -> [BaseGrid] {
        preconditionFailure("This method must be overridden")
    }

    /**
     * Create a new zoom grids
     *
     * @param zoom
     *            zoom level
     * @return zoom grids
     */
    open func newZoomGrids(_ zoom: Int) -> BaseZoomGrids {
        preconditionFailure("This method must be overridden")
    }
    
    /**
     * Load the grid
     *
     * @param grid
     *            name
     * @param gridKey
     *            grid name key
     * @param enabled
     *            enable created grids
     * @param labeler
     *            grid labeler
     */
    public func loadGrid(_ grid: BaseGrid, _ gridKey: String, _ enabled: Bool?, _ labeler: Labeler?) {
        
        let gridKeyProperty = properties.combine(PropertyConstants.GRIDS, gridKey)
        
        var enabledValue = enabled
        if enabledValue == nil {
            enabledValue = properties.boolValue(gridKeyProperty, PropertyConstants.ENABLED, false)
            if enabledValue == nil {
                enabledValue = true
            }
        }
        grid.enabled = enabledValue!
        
        var minZoom = properties.intValue(gridKeyProperty, PropertyConstants.MIN_ZOOM, false)
        if minZoom == nil {
            minZoom = 0
        }
        grid.minZoom = minZoom!
        
        let maxZoom = properties.intValue(gridKeyProperty, PropertyConstants.MAX_ZOOM, false)
        grid.maxZoom = maxZoom
        
        let linesProperty = properties.combine(gridKeyProperty, PropertyConstants.LINES)
        
        let linesMinZoom = properties.intValue(linesProperty, PropertyConstants.MIN_ZOOM, false)
        grid.linesMinZoom = linesMinZoom
        
        let linesMaxZoom = properties.intValue(linesProperty, PropertyConstants.MAX_ZOOM, false)
        grid.linesMaxZoom = linesMaxZoom
        
        let colorProperty = properties.value(gridKeyProperty, PropertyConstants.COLOR, false)
        let color = colorProperty != nil ? CLRColor(hex: colorProperty).uiColor() : UIColor.black
        grid.color = color
        
        var width = properties.doubleValue(gridKeyProperty, PropertyConstants.WIDTH, false)
        if width == nil {
            width = defaultWidth()
        }
        grid.width = width!
        
        if labeler != nil {
            loadLabeler(labeler!, gridKey)
        }
        grid.labeler = labeler
        
    }
    
    /**
     * Load the labeler
     *
     * @param labeler
     *            labeler
     * @param gridKey
     *            grid name key
     */
    public func loadLabeler(_ labeler: Labeler, _ gridKey: String) {
        
        let gridKeyProperty = properties.combine(PropertyConstants.GRIDS, gridKey)
        let labelerProperty = properties.combine(gridKeyProperty, PropertyConstants.LABELER)
        
        let enabled = properties.boolValue(labelerProperty, PropertyConstants.ENABLED, false)
        labeler.enabled = (enabled != nil) && enabled!
        
        let minZoom = properties.intValue(labelerProperty, PropertyConstants.MIN_ZOOM, false)
        if minZoom != nil {
            labeler.minZoom = minZoom!
        }
        
        let maxZoom = properties.intValue(labelerProperty, PropertyConstants.MAX_ZOOM, false)
        if maxZoom != nil {
            labeler.maxZoom = maxZoom!
        }
        
        let color = properties.value(labelerProperty, PropertyConstants.COLOR, false)
        if color != nil {
            labeler.color = CLRColor(hex: color).uiColor()
        }
        
        let textSize = properties.doubleValue(labelerProperty, PropertyConstants.TEXT_SIZE, false)
        if textSize != nil {
            labeler.textSize = textSize!
        }
        
        let buffer = properties.doubleValue(labelerProperty, PropertyConstants.BUFFER, false)
        if buffer != nil {
            labeler.buffer = buffer!
        }
        
    }
    
    /**
     * Load the grid style color
     *
     * @param gridKey
     *            grid name key
     * @param gridKey2
     *            second grid name key
     * @return color
     */
    public func loadGridStyleColor(_ gridKey: String, _ gridKey2: String) -> UIColor? {
        
        let gridKeyProperty = properties.combine(PropertyConstants.GRIDS, gridKey)
        let gridKey2Property = properties.combine(gridKeyProperty, gridKey2)
        
        let colorProperty = properties.value(gridKey2Property, PropertyConstants.COLOR, false)
        var color: UIColor?
        if colorProperty != nil {
            color = CLRColor(hex: colorProperty).uiColor()
        }
        return color
    }
    
    /**
     * Load the grid style width
     *
     * @param gridKey
     *            grid name key
     * @param gridKey2
     *            second grid name key
     * @return width
     */
    public func loadGridStyleWidth(_ gridKey: String, _ gridKey2: String) -> Double? {
        
        let gridKeyProperty = properties.combine(PropertyConstants.GRIDS, gridKey)
        let gridKey2Property = properties.combine(gridKeyProperty, gridKey2)
        
        return properties.doubleValue(gridKey2Property, PropertyConstants.WIDTH, false)
    }
    
    /**
     * Get a combined grid style from the provided color, width, and grid
     *
     * @param color
     *            color
     * @param width
     *            width
     * @param grid
     *            grid
     * @return grid style
     */
    public func gridStyle(_ color: UIColor?, _ width: Double?, _ grid: BaseGrid) -> GridStyle {
        
        var colorValue = color
        if colorValue == nil {
            colorValue = grid.color
        }
        
        var widthValue  = width
        if widthValue == nil || width == 0 {
            widthValue = grid.width
        }
        
        return GridStyle(colorValue, widthValue!)
    }
    
    /**
     * Create the zoom level grids
     */
    public func createZoomGrids() {
        for zoom in 0 ... GridConstants.MAX_MAP_ZOOM_LEVEL {
            _ = createZoomGrids(zoom)
        }
    }
    
    /**
     * Get the grids for the zoom level
     *
     * @param zoom
     *            zoom level
     * @return grids
     */
    open func grids(_ zoom: Int) -> BaseZoomGrids {
        var grids = zoomGrids[zoom]
        if grids == nil {
            grids = createZoomGrids(zoom)
        }
        return grids!
    }
    
    /**
     * Create grids for the zoom level
     *
     * @param zoom
     *            zoom level
     * @return grids
     */
    private func createZoomGrids(_ zoom: Int) -> BaseZoomGrids {
        let zoomLevelGrids = newZoomGrids(zoom)
        for grid in grids() {
            if grid.enabled && grid.isWithin(zoom) {
                _ = zoomLevelGrids.addGrid(grid)
            }
        }
        zoomGrids[zoom] = zoomLevelGrids
        return zoomLevelGrids
    }
    
    /**
     * Enable grids
     *
     * @param grids
     *            grids
     */
    public func enableGrids(_ grids: [BaseGrid]) {
        for grid in grids {
            enable(grid)
        }
    }
    
    /**
     * Disable grids
     *
     * @param grids
     *            grids
     */
    public func disableGrids(_ grids: [BaseGrid]) {
        for grid in grids {
            disable(grid)
        }
    }
    
    /**
     * Enable the grid
     *
     * @param grid
     *            grid
     */
    public func enable(_ grid: BaseGrid) {
        
        if !grid.enabled {
            
            grid.enabled = true
            
            let minZoom = grid.minZoom
            var maxZoom = grid.maxZoom
            if maxZoom == nil {
                maxZoom = maxZoomLevel()
            }
            
            for zoom in minZoom ... maxZoom! {
                addGrid(grid, zoom)
            }
            
        }
        
    }
    
    /**
     * Disable the grid
     *
     * @param grid
     *            grid
     */
    public func disable(_ grid: BaseGrid) {
        
        if grid.enabled {
            
            grid.enabled = false
            
            let minZoom = grid.minZoom
            var maxZoom = grid.maxZoom
            if maxZoom == nil {
                maxZoom = maxZoomLevel()
            }
            
            for zoom in minZoom ... maxZoom! {
                removeGrid(grid, zoom)
            }
            
        }
        
    }
    
    /**
     * Get the sorted zoom levels
     *
     * @return zoom levels
     */
    public func zoomLevels() -> [Int] {
        return zoomGrids.keys.sorted()
    }
    
    /**
     * Get the min zoom level
     *
     * @return min zoom level
     */
    public func minZoomLevel() -> Int {
        return zoomLevels().first!
    }
    
    /**
     * Get the min zoom level
     *
     * @return min zoom level
     */
    public func maxZoomLevel() -> Int {
        return zoomLevels().last!
    }
    
    /**
     * Set the grid minimum zoom
     *
     * @param grid
     *            grid
     * @param minZoom
     *            minimum zoom
     */
    public func setMinZoom(_ grid: BaseGrid, _ minZoom: Int) {
        var maxZoom = grid.maxZoom
        if maxZoom != nil && maxZoom! < minZoom {
            maxZoom = minZoom
        }
        setZoomRange(grid, minZoom, maxZoom)
    }
    
    /**
     * Set the grid maximum zoom
     *
     * @param grid
     *            grid
     * @param maxZoom
     *            maximum zoom
     */
    public func setMaxZoom(_ grid: BaseGrid, _ maxZoom: Int?) {
        var minZoom = grid.minZoom
        if maxZoom != nil && minZoom > maxZoom! {
            minZoom = maxZoom!
        }
        setZoomRange(grid, minZoom, maxZoom)
    }
    
    /**
     * Set the grid zoom range
     *
     * @param grid
     *            grid
     * @param minZoom
     *            minimum zoom
     * @param maxZoom
     *            maximum zoom
     */
    public func setZoomRange(_ grid: BaseGrid, _ minZoom: Int, _ maxZoom: Int?) {
        
        if maxZoom != nil && maxZoom! < minZoom {
            preconditionFailure("Min zoom '\(minZoom)' can not be larger than max zoom '\(String(describing: maxZoom))\'")
        }
        
        // All grids zoom range
        let allGridsMin = minZoomLevel()
        let allGridsMax = maxZoomLevel()
        
        // Existing grid zoom range
        let gridMinZoom = grid.minZoom
        let gridMaxZoom = grid.maxZoom == nil ? allGridsMax : min(grid.maxZoom!, allGridsMax)
        
        grid.minZoom = minZoom
        grid.maxZoom = maxZoom
        
        let minZoomValue = max(minZoom, allGridsMin)
        let maxZoomValue = maxZoom == nil ? allGridsMax : min(maxZoom!, allGridsMax)
        
        let minOverlap = max(minZoomValue, gridMinZoom)
        let maxOverlap = min(maxZoomValue, gridMaxZoom)
        
        let overlaps = minOverlap <= maxOverlap
        
        if overlaps {
            
            let min = min(minZoomValue, gridMinZoom)
            let max = max(maxZoomValue, gridMaxZoom)
            
            for zoom in min ... max {
                
                if zoom < minOverlap || zoom > maxOverlap {
                    
                    if zoom >= minZoomValue && zoom <= maxZoomValue {
                        addGrid(grid, zoom)
                    } else {
                        removeGrid(grid, zoom)
                    }
                    
                }
                
            }
        } else {
            
            for zoom in gridMinZoom ... gridMaxZoom {
                removeGrid(grid, zoom)
            }
            
            for zoom in minZoomValue ... maxZoomValue {
                addGrid(grid, zoom)
            }
            
        }
        
    }
    
    /**
     * Add a grid to the zoom level
     *
     * @param grid
     *            grid
     * @param zoom
     *            zoom level
     */
    private func addGrid(_ grid: BaseGrid, _ zoom: Int) {
        _ = zoomGrids[zoom]?.addGrid(grid)
    }
    
    /**
     * Remove a grid from the zoom level
     *
     * @param grid
     *            grid
     * @param zoom
     *            zoom level
     */
    private func removeGrid(_ grid: BaseGrid, _ zoom: Int) {
        _ = zoomGrids[zoom]?.removeGrid(grid)
    }
    
    /**
     * Enable all grid labelers
     */
    public func enableAllLabelers() {
        for grid in grids() {
            grid.labeler?.enabled = true
        }
    }
    
    /**
     * Set all label grid edge buffers
     *
     * @param buffer
     *            label buffer (greater than or equal to 0.0 and less than 0.5)
     */
    public func setAllLabelBuffers(_ buffer: Double) {
        for grid in grids() {
            grid.labeler?.buffer = buffer
        }
    }
    
}
