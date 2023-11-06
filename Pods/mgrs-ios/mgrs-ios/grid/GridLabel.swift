//
//  GridLabel.swift
//  mgrs-ios
//
//  Created by Brian Osborn on 9/2/22.
//

import Foundation
import grid_ios

/**
 * MGRS Grid Label
 */
public class GridLabel: Label {
    
    /**
     * Grid type
     */
    public var gridType: GridType
    
    /**
     * MGRS coordinate
     */
    public var coordinate: MGRS
    
    /**
     * Initialize
     *
     * @param name
     *            name
     * @param center
     *            center point
     * @param bounds
     *            bounds
     * @param gridType
     *            grid type
     * @param coordinate
     *            MGRS coordinate
     */
    public init(_ name: String, _ center: GridPoint, _ bounds: Bounds, _ gridType: GridType, _ coordinate: MGRS) {
        self.gridType = gridType
        self.coordinate = coordinate
        super.init(name, center, bounds)
    }
    
}
