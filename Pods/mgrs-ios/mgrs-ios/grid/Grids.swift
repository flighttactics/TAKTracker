//
//  Grids.swift
//  mgrs-ios
//
//  Created by Brian Osborn on 9/2/22.
//

import Foundation
import grid_ios

/**
 * Grids
 */
public class Grids: BaseGrids {
    
    /**
     * Grid zoom display offset from XYZ tile zoom levels, defaulted to MGRSConstants.ZOOM_OFFSET
     */
    public var zoomOffset = MGRSConstants.ZOOM_OFFSET
    
    /**
     * Grids
     */
    private var typeGrids: [GridType: Grid] = [:]
    
    /**
     * Create only Grid Zone Designator grids
     *
     * @return grids
     */
    public static func createGZD() -> Grids {
        return Grids([GridType.GZD])
    }
    
    /**
     * Initialize, all grid types enabled per property configurations
     */
    public init() {
        super.init(MGRSProperties.instance)
        createGrids()
        createZoomGrids()
    }

    /**
     * Initialize
     *
     * @param types
     *            grid types to enable
     */
    public init(_ types: [GridType]) {
        super.init(MGRSProperties.instance)

        createGrids(false)

        for type in types {
            grid(type).enabled = true
        }

        createZoomGrids()
    }
    
    /**
     * Get the default grid line width
     *
     * @return width
     */
    public override func defaultWidth() -> Double {
        return Grid.DEFAULT_WIDTH
    }

    /**
     * Get the grids
     *
     * @return grids
     */
    public override func grids() -> [BaseGrid] {
        return Array(typeGrids.values)
    }

    /**
     * Create a new grid, override to create a specialized grid
     *
     * @param type
     *            grid type
     * @return grid
     */
    public func newGrid(_ type: GridType) -> Grid {
        return Grid(type)
    }
    
    /**
     * Create a new zoom grids
     *
     * @param zoom
     *            zoom level
     * @return zoom grids
     */
    public override func newZoomGrids(_ zoom: Int) -> BaseZoomGrids {
        return ZoomGrids(zoom)
    }
    
    public override func grids(_ zoom: Int) -> ZoomGrids {
        return super.grids(zoom) as! ZoomGrids
    }
    
    /**
     * Create the grids
     */
    private func createGrids() {
        createGrids(nil)
    }
    
    /**
     * Create the grids
     *
     * @param enabled
     *            enable created grids
     */
    private func createGrids(_ enabled: Bool?) {
        
        let propagate = properties.boolValue(PropertyConstants.GRIDS, PropertyConstants.PROPAGATE, false)
        var styles: [GridType: GridStyle]? = nil
        if propagate != nil && propagate! {
            styles = [:]
        }
        
        createGrid(GridType.GZD, &styles, enabled, GZDLabeler())
        createGrid(GridType.HUNDRED_KILOMETER, &styles, enabled, MGRSLabeler())
        createGrid(GridType.TEN_KILOMETER, &styles, enabled, MGRSLabeler())
        createGrid(GridType.KILOMETER, &styles, enabled, MGRSLabeler())
        createGrid(GridType.HUNDRED_METER, &styles, enabled, MGRSLabeler())
        createGrid(GridType.TEN_METER, &styles, enabled, MGRSLabeler())
        createGrid(GridType.METER, &styles, enabled, MGRSLabeler())
        
    }
    
    /**
     * Create the grid
     *
     * @param type
     *            grid type
     * @param styles
     *            propagate grid styles
     * @param enabled
     *            enable created grids
     * @param labeler
     *            grid labeler
     */
    private func createGrid(_ type: GridType, _ styles: inout [GridType: GridStyle]?, _ enabled: Bool?, _ labeler: GridLabeler?) {
        
        let grid = newGrid(type)
        
        let gridKey = type.name.lowercased()
        
        loadGrid(grid, gridKey, enabled, labeler)
        
        if styles != nil {
            styles![type] = GridStyle(grid.color, grid.width)
        }
        
        loadGridStyles(grid, &styles, gridKey)
        
        typeGrids[type] = grid
    }
    
    /**
     * Load grid styles within a higher precision grid
     *
     * @param grid
     *            grid
     * @param styles
     *            propagate grid styles
     * @param gridKey
     *            grid key
     */
    private func loadGridStyles(_ grid: Grid, _ styles: inout [GridType: GridStyle]?, _ gridKey: String) {
        
        let precision = grid.precision()
        if precision < GridType.HUNDRED_KILOMETER.precision() {
            loadGridStyle(grid, &styles, gridKey, GridType.HUNDRED_KILOMETER)
        }
        if precision < GridType.TEN_KILOMETER.precision() {
            loadGridStyle(grid, &styles, gridKey, GridType.TEN_KILOMETER)
        }
        if precision < GridType.KILOMETER.precision() {
            loadGridStyle(grid, &styles, gridKey, GridType.KILOMETER)
        }
        if precision < GridType.HUNDRED_METER.precision() {
            loadGridStyle(grid, &styles, gridKey, GridType.HUNDRED_METER)
        }
        if precision < GridType.TEN_METER.precision() {
            loadGridStyle(grid, &styles, gridKey, GridType.TEN_METER)
        }
        
    }
    
    /**
     * Load a grid style within a higher precision grid
     *
     * @param grid
     *            grid
     * @param styles
     *            propagate grid styles
     * @param gridKey
     *            grid key
     * @param gridType
     *            style grid type
     */
    private func loadGridStyle(_ grid: Grid, _ styles: inout [GridType: GridStyle]?, _ gridKey: String, _ gridType: GridType) {
        
        let gridKey2 = gridType.name.lowercased()

        var color = loadGridStyleColor(gridKey, gridKey2)
        var width = loadGridStyleWidth(gridKey, gridKey2)

        if (color == nil || width == nil) && styles != nil {
            let style = styles![gridType]
            if style != nil {
                if color == nil {
                    let styleColor = style!.color
                    if styleColor != nil {
                        color = styleColor!.copy() as? UIColor
                    }
                }
                if width == nil {
                    width = style?.width
                }
            }
        }

        if color != nil || width != nil {

            let style = gridStyle(color, width, grid)
            grid.setStyle(gridType, style)

            if styles != nil {
                styles![gridType] = style
            }
        }
        
    }
    
    /**
     * Get the grid
     *
     * @param type
     *            grid type
     * @return grid
     */
    public func grid(_ type: GridType) -> Grid {
        return typeGrids[type]!
    }
    
    /**
     * Get the grid precision for the zoom level
     *
     * @param zoom
     *            zoom level
     * @return grid type precision
     */
    
    public func precision(_ zoom: Int) -> GridType? {
        return grids(zoom).precision()
    }

    /**
     * Set the active grid types
     *
     * @param types
     *            grid types
     */
    public func setGrids(_ types: [GridType]) {
        var disable = Set(GridType.allCases)
        for gridType in types {
            enable(gridType)
            disable.remove(gridType)
        }
        disableTypes(Array(disable))
    }

    /**
     * Set the active grids
     *
     * @param grids
     *            grids
     */
    public func setGrids(_ grids: [Grid]) {
        var disable = Set(GridType.allCases)
        for grid in grids {
            enable(grid)
            disable.remove(grid.type)
        }
        disableTypes(Array(disable))
    }
    
    /**
     * Enable grid types
     *
     * @param types
     *            grid types
     */
    public func enableTypes(_ types: [GridType]) {
        for type in types {
            enable(type)
        }
    }
    
    /**
     * Disable grid types
     *
     * @param types
     *            grid types
     */
    public func disableTypes(_ types: [GridType]) {
        for type in types {
            disable(type)
        }
    }
    
    /**
     * Is the grid type enabled
     *
     * @param type
     *            grid type
     * @return true if enabled
     */
    public func isEnabled(_ type: GridType) -> Bool {
        return grid(type).enabled
    }

    /**
     * Enable the grid type
     *
     * @param type
     *            grid type
     */
    public func enable(_ type: GridType) {
        enable(grid(type))
    }

    /**
     * Disable the grid type
     *
     * @param type
     *            grid type
     */
    public func disable(_ type: GridType) {
        disable(grid(type))
    }
    
    /**
     * Set the grid minimum zoom
     *
     * @param type
     *            grid type
     * @param minZoom
     *            minimum zoom
     */
    public func setMinZoom(_ type: GridType, _ minZoom: Int) {
        setMinZoom(grid(type), minZoom)
    }

    /**
     * Set the grid maximum zoom
     *
     * @param type
     *            grid type
     * @param maxZoom
     *            maximum zoom
     */
    public func setMaxZoom(_ type: GridType, _ maxZoom: Int?) {
        setMaxZoom(grid(type), maxZoom)
    }
    
    /**
     * Set the grid zoom range
     *
     * @param type
     *            grid type
     * @param minZoom
     *            minimum zoom
     * @param maxZoom
     *            maximum zoom
     */
    public func setZoomRange(_ type: GridType, _ minZoom: Int, _ maxZoom: Int?) {
        setZoomRange(grid(type), minZoom, maxZoom)
    }
    
    /**
     * Set the grid minimum level override for drawing grid lines
     *
     * @param type
     *            grid type
     * @param minZoom
     *            minimum zoom level or null to remove
     */
    public func setLinesMinZoom(_ type: GridType, _ minZoom: Int?) {
        grid(type).linesMinZoom = minZoom
    }

    /**
     * Set the grid maximum level override for drawing grid lines
     *
     * @param type
     *            grid type
     * @param maxZoom
     *            maximum zoom level or null to remove
     */
    public func setLinesMaxZoom(_ type: GridType, _ maxZoom: Int?) {
        grid(type).linesMaxZoom = maxZoom
    }
    
    /**
     * Set all grid line colors
     *
     * @param color
     *            grid line color
     */
    public func setAllColors(_ color: UIColor) {
        setColor(GridType.allCases, color)
    }

    /**
     * Set the grid line color for the grid types
     *
     * @param types
     *            grid types
     * @param color
     *            grid line color
     */
    public func setColor(_ types: [GridType], _ color: UIColor) {
        for type in types {
            setColor(type, color)
        }
    }
    
    /**
     * Set the grid line color for the grid type
     *
     * @param type
     *            grid type
     * @param color
     *            grid line color
     */
    public func setColor(_ type: GridType, _ color: UIColor) {
        grid(type).color = color
    }
    
    /**
     * Set all grid line widths
     *
     * @param width
     *            grid line width
     */
    public func setAllWidths(_ width: Double) {
        setWidth(GridType.allCases, width)
    }

    /**
     * Set the grid line width for the grid types
     *
     * @param types
     *            grid types
     * @param width
     *            grid line width
     */
    public func setWidth(_ types: [GridType], _ width: Double) {
        for type in types {
            setWidth(type, width)
        }
    }

    /**
     * Set the grid line width for the grid type
     *
     * @param type
     *            grid type
     * @param width
     *            grid line width
     */
    public func setWidth(_ type: GridType, _ width: Double) {
        grid(type).width = width
    }
    
    /**
     * Delete propagated styles
     */
    public func deletePropagatedStyles() {
        deletePropagatedStyles(GridType.allCases)
    }

    /**
     * Delete propagated styles for the grid types
     *
     * @param types
     *            grid types
     */
    public func deletePropagatedStyles(_ types: [GridType]) {
        for type in types {
            deletePropagatedStyles(type)
        }
    }

    /**
     * Delete propagated styles for the grid type
     *
     * @param type
     *            grid type
     */
    public func deletePropagatedStyles(_ type: GridType) {
        grid(type).clearPrecisionStyles()
    }
    
    /**
     * Set the grid type precision line color for the grid types
     *
     * @param types
     *            grid types
     * @param precisionType
     *            precision grid type
     * @param color
     *            grid line color
     */
    public func setColor(_ types: [GridType], _ precisionType: GridType, _ color: UIColor) {
        for type in types {
            setColor(type, precisionType, color)
        }
    }

    /**
     * Set the grid type precision line colors for the grid type
     *
     * @param type
     *            grid type
     * @param precisionTypes
     *            precision grid types
     * @param color
     *            grid line color
     */
    public func setColor(_ type: GridType, _ precisionTypes: [GridType], _ color: UIColor) {
        for precisionType in precisionTypes {
            setColor(type, precisionType, color)
        }
    }

    /**
     * Set the grid type precision line color for the grid type
     *
     * @param type
     *            grid type
     * @param precisionType
     *            precision grid type
     * @param color
     *            grid line color
     */
    public func setColor(_ type: GridType, _ precisionType: GridType, _ color: UIColor) {
        grid(type).setColor(precisionType, color)
    }
    
    /**
     * Set the grid type precision line width for the grid types
     *
     * @param types
     *            grid types
     * @param precisionType
     *            precision grid type
     * @param width
     *            grid line width
     */
    public func setWidth(_ types: [GridType], _ precisionType: GridType, _ width: Double) {
        for type in types {
            setWidth(type, precisionType, width)
        }
    }

    /**
     * Set the grid type precision line widths for the grid type
     *
     * @param type
     *            grid type
     * @param precisionTypes
     *            precision grid types
     * @param width
     *            grid line width
     */
    public func setWidth(_ type: GridType, _ precisionTypes: [GridType], _ width: Double) {
        for precisionType in precisionTypes {
            setWidth(type, precisionType, width)
        }
    }

    /**
     * Set the grid type precision line width for the grid type
     *
     * @param type
     *            grid type
     * @param precisionType
     *            precision grid type
     * @param width
     *            grid line width
     */
    public func setWidth(_ type: GridType, _ precisionType: GridType, _ width: Double) {
        grid(type).setWidth(precisionType, width)
    }
    
    /**
     * Get the labeler for the grid type
     *
     * @param type
     *            grid type
     * @return labeler or null
     */
    public func labeler(_ type: GridType) -> GridLabeler? {
        return grid(type).labeler()
    }

    /**
     * Has a labeler for the grid type
     *
     * @param type
     *            grid type
     * @return true if has labeler
     */
    public func hasLabeler(_ type: GridType) -> Bool {
        return grid(type).hasLabeler()
    }

    /**
     * Set the labeler for the grid type
     *
     * @param type
     *            grid type
     * @param labeler
     *            labeler
     */
    public func setLabeler(_ type: GridType, _ labeler: GridLabeler) {
        grid(type).setLabeler(labeler)
    }
    
    /**
     * Disable all grid labelers
     */
    public func disableAllLabelers() {
        disableLabelers(GridType.allCases)
    }

    /**
     * Enable the labelers for the grid types
     *
     * @param types
     *            grid types
     */
    public func enableLabelers(_ types: [GridType]) {
        for type in types {
            enableLabeler(type)
        }
    }

    /**
     * Disable the labelers for the grid types
     *
     * @param types
     *            grid types
     */
    public func disableLabelers(_ types: [GridType]) {
        for type in types {
            disableLabeler(type)
        }
    }

    /**
     * Is a labeler enabled for the grid type
     *
     * @param type
     *            grid type
     * @return true if labeler enabled
     */
    public func isLabelerEnabled(_ type: GridType) -> Bool {
        let labeler = labeler(type)
        return labeler != nil && labeler!.enabled
    }

    /**
     * Enable the grid type labeler
     *
     * @param type
     *            grid type
     */
    public func enableLabeler(_ type: GridType) {
        requiredLabeler(type).enabled = true
    }

    /**
     * Disable the grid type labeler
     *
     * @param type
     *            grid type
     */
    public func disableLabeler(_ type: GridType) {
        let labeler = labeler(type)
        if labeler != nil {
            labeler!.enabled = false
        }
    }
    
    /**
     * Get the labeler for the grid type
     *
     * @param type
     *            grid type
     * @return labeler or null
     */
    private func requiredLabeler(_ type: GridType) -> GridLabeler {
        let labeler = labeler(type)
        if labeler == nil {
            preconditionFailure("Grid type does not have a labeler: \(type)")
        }
        return labeler!
    }
    
    /**
     * Set the grid minimum zoom
     *
     * @param type
     *            grid type
     * @param minZoom
     *            minimum zoom
     */
    public func setLabelMinZoom(_ type: GridType, _ minZoom: Int) {
        let labeler = requiredLabeler(type)
        labeler.minZoom = minZoom
        let maxZoom = labeler.maxZoom
        if maxZoom != nil && maxZoom! < minZoom {
            labeler.maxZoom = minZoom
        }
    }

    /**
     * Set the grid maximum zoom
     *
     * @param type
     *            grid type
     * @param maxZoom
     *            maximum zoom
     */
    public func setLabelMaxZoom(_ type: GridType, _ maxZoom: Int?) {
        let labeler = requiredLabeler(type)
        labeler.maxZoom = maxZoom
        if maxZoom != nil && labeler.minZoom > maxZoom! {
            labeler.minZoom = maxZoom!
        }
    }

    /**
     * Set the grid zoom range
     *
     * @param type
     *            grid type
     * @param minZoom
     *            minimum zoom
     * @param maxZoom
     *            maximum zoom
     */
    public func setLabelZoomRange(_ type: GridType, _ minZoom: Int, _ maxZoom: Int?) {
        let labeler = requiredLabeler(type)
        if maxZoom != nil && maxZoom! < minZoom {
            preconditionFailure("Min zoom '\(minZoom)' can not be larger than max zoom '\(maxZoom!)'")
        }
        labeler.minZoom = minZoom
        labeler.maxZoom = maxZoom
    }

    /**
     * Set the label grid edge buffer for the grid types
     *
     * @param types
     *            grid types
     * @param buffer
     *            label buffer (greater than or equal to 0.0 and less than 0.5)
     */
    public func setLabelBuffer(_ types: [GridType], _ buffer: Double) {
        for type in types {
            setLabelBuffer(type, buffer)
        }
    }

    /**
     * Get the label grid edge buffer
     *
     * @param type
     *            grid type
     * @return label buffer (greater than or equal to 0.0 and less than 0.5)
     */
    public func getLabelBuffer(_ type: GridType) -> Double {
        return grid(type).labelBuffer()
    }

    /**
     * Set the label grid edge buffer
     *
     * @param type
     *            grid type
     * @param buffer
     *            label buffer (greater than or equal to 0.0 and less than 0.5)
     */
    public func setLabelBuffer(_ type: GridType, _ buffer: Double) {
        requiredLabeler(type).buffer = buffer
    }
    
    /**
     * Set all label colors
     *
     * @param color
     *            label color
     */
    public func setAllLabelColors(_ color: UIColor) {
        for grid in typeGrids.values {
            if grid.hasLabeler() {
                setLabelColor(grid.type, color)
            }
        }
    }

    /**
     * Set the label color for the grid types
     *
     * @param types
     *            grid types
     * @param color
     *            label color
     */
    public func setLabelColor(_ types: [GridType], _ color: UIColor) {
        for type in types {
            setLabelColor(type, color)
        }
    }

    /**
     * Set the label color
     *
     * @param type
     *            grid type
     * @param color
     *            label color
     */
    public func setLabelColor(_ type: GridType, _ color: UIColor) {
        requiredLabeler(type).color = color
    }
    
    /**
     * Set all label text sizes
     *
     * @param textSize
     *            label text size
     */
    public func setAllLabelTextSizes(_ textSize: Double) {
        for grid in typeGrids.values {
            if grid.hasLabeler() {
                setLabelTextSize(grid.type, textSize)
            }
        }
    }

    /**
     * Set the label text size for the grid types
     *
     * @param types
     *            grid types
     * @param textSize
     *            label text size
     */
    public func setLabelTextSize(_ types: [GridType], _ textSize: Double) {
        for type in types {
            setLabelTextSize(type, textSize)
        }
    }

    /**
     * Set the label text size
     *
     * @param type
     *            grid type
     * @param textSize
     *            label text size
     */
    public func setLabelTextSize(_ type: GridType, _ textSize: Double) {
        requiredLabeler(type).textSize = textSize
    }
    
    /**
     * Draw a tile with the dimensions and XYZ coordinate
     *
     * @param tileWidth  tile width
     * @param tileHeight tile height
     * @param x          x coordinate
     * @param y          y coordinate
     * @param zoom       zoom level
     * @return image tile
     */
    public func drawTile(_ tileWidth: Int, _ tileHeight: Int, _ x: Int, _ y: Int, _ zoom: Int) -> UIImage? {
        var image: UIImage? = nil
        let gridZoom = zoom + zoomOffset
        let zoomGrids = grids(gridZoom)
        if zoomGrids.hasGrids() {
            image = drawTile(GridTile(tileWidth, tileHeight, x, y, zoom, gridZoom), zoomGrids)
        }
        return image
    }

    /**
     * Draw a tile with the dimensions and bounds
     *
     * @param tileWidth  tile width
     * @param tileHeight tile height
     * @param bounds     bounds
     * @return image tile
     */
    public func drawTile(_ tileWidth: Int, _ tileHeight: Int, _ bounds: Bounds) -> UIImage? {
        return drawTile(GridTile(tileWidth, tileHeight, bounds))
    }

    /**
     * Draw the tile
     *
     * @param gridTile tile
     * @return image tile
     */
    public func drawTile(_ gridTile: GridTile) -> UIImage? {
        var image: UIImage? = nil
        let zoomGrids = grids(gridTile.zoom)
        if zoomGrids.hasGrids() {
            image = drawTile(gridTile, zoomGrids)
        }
        return image
    }

    /**
     * Draw the tile
     *
     * @param gridTile  tile
     * @param zoomGrids zoom grids
     * @return image tile
     */
    private func drawTile(_ gridTile: GridTile, _ zoomGrids: ZoomGrids) -> UIImage? {

        UIGraphicsBeginImageContext(CGSize(width: CGFloat(gridTile.width), height: CGFloat(gridTile.height)))
        let context = UIGraphicsGetCurrentContext()!

        let gridRange = GridZones.gridRange(gridTile.bounds)
        
        for grid in zoomGrids {
            
            // draw this grid for each zone
            for zone in gridRange {
            
                let lines = grid.lines(gridTile, zone)
                if lines != nil {
                    Grids.drawLines(lines!, gridTile, grid, zone, context)
                }
                
                let labels = grid.labels(gridTile, zone)
                if labels != nil {
                    TileDraw.drawLabels(labels!, grid.labelBuffer(), gridTile, grid)
                }

            }
        }

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /**
     * Draw the lines on the tile
     *
     * @param lines  lines to draw
     * @param tile   tile
     * @param grid   grid
     * @param zone   grid zone
     * @param context graphics context
     */
    public static func drawLines(_ lines: [MGRSLine], _ tile: GridTile, _ grid: Grid, _ zone: GridZone, _ context: CGContext) {
        
        let pixelRange = zone.bounds.pixelRange(tile)
        
        context.saveGState()
        context.clip(to: CGRect(x: CGFloat(pixelRange.left), y: CGFloat(pixelRange.top), width: CGFloat(pixelRange.width), height: CGFloat(pixelRange.height)))
        
        for line in lines {

            let gridType = line.gridType != nil ? line.gridType! : grid.type
            let width = grid.width(gridType)
            let color = grid.color(gridType)
            
            TileDraw.drawLine(line, tile, width, color, context)

        }

        context.restoreGState()
    }
    
}
