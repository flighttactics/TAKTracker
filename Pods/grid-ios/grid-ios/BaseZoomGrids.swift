//
//  BaseZoomGrids.swift
//  grid-ios
//
//  Created by Brian Osborn on 8/8/22.
//

import Foundation

/**
 * Zoom Level Matching Grids
 */
open class BaseZoomGrids {
    
    /**
     * Zoom level
     */
    public let zoom: Int
    
    /**
     * Grids
     */
    private var _grids: Set<BaseGrid> = Set()
    
    /**
     * Get the grids within the zoom level
     *
     * @return grids
     */
    public var grids: [BaseGrid] {
        get {
            return _grids.sorted()
        }
    }
    
    /**
     * Initialize
     *
     * @param zoom
     *            zoom level
     */
    public init(_ zoom: Int) {
        self.zoom = zoom
    }
    
    /**
     * Get the number of grids
     *
     * @return number of grids
     */
    public func numGrids() -> Int {
        return _grids.count
    }

    /**
     * Determine if the zoom level has grids
     *
     * @return true if has grids
     */
    public func hasGrids() -> Bool {
        return !_grids.isEmpty
    }

    /**
     * Add a grid
     *
     * @param grid
     *            grid
     * @return true if added
     */
    public func addGrid(_ grid: BaseGrid) -> Bool {
        return _grids.insert(grid).inserted
    }

    /**
     * Remove the grid
     *
     * @param grid
     *            grid
     * @return true if removed
     */
    public func removeGrid(_ grid: BaseGrid) -> Bool {
        return _grids.remove(grid) != nil
    }
    
}
