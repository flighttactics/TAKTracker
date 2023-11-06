//
//  ZoomGrids.swift
//  mgrs-ios
//
//  Created by Brian Osborn on 9/2/22.
//

import Foundation
import grid_ios

/**
 * Zoom Level Matching Grids
 */
public class ZoomGrids: BaseZoomGrids, Sequence {
    
    /**
     * Get the grid type precision
     *
     * @return grid type precision
     */
    public func precision() -> GridType? {
        var type: GridType? = nil
        if hasGrids() {
            type = (grids.first as! Grid).type
        }
        return type
    }
    
    public func makeIterator() -> IndexingIterator<[Grid]> {
        let value: [Grid] = grids.map { $0 as! Grid }
        return value.makeIterator()
    }
    
}
