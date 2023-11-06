//
//  MGRSLine.swift
//  mgrs-ios
//
//  Created by Brian Osborn on 8/23/22.
//

import Foundation
import grid_ios

/**
 * Line between two points
 */
public class MGRSLine: Line {
    
    /**
     * Grid type the line represents if any
     */
    public var gridType: GridType?
    
    /**
     * Initialize
     *
     * @param point1
     *            first point
     * @param point2
     *            second point
     */
    public override init(_ point1: GridPoint, _ point2: GridPoint) {
        super.init(point1, point2)
    }
    
    /**
     * Initialize
     *
     * @param point1
     *            first point
     * @param point2
     *            second point
     * @param gridType
     *            line grid type
     */
    public convenience init(_ point1: GridPoint, _ point2: GridPoint, _ gridType: GridType?) {
        self.init(point1, point2)
        self.gridType = gridType
    }
    
    /**
     * Initialize
     *
     * @param line
     *            line to copy
     */
    public override init(_ line: Line) {
        super.init(line)
    }
    
    /**
     * Initialize
     *
     * @param line
     *            line to copy
     * @param gridType
     *            line grid type
     */
    public convenience init(_ line: Line, _ gridType: GridType?) {
        self.init(line)
        self.gridType = gridType
    }
    
    /**
     * Initialize
     *
     * @param gridLine
     *            line to copy
     */
    public convenience init(_ gridLine: MGRSLine) {
        self.init(gridLine, gridLine.gridType)
    }
    
    /**
     * Check if the line has a grid type
     *
     * @return true if has grid type
     */
    public func hasGridType() -> Bool {
        return gridType != nil
    }
    
    public override func mutableCopy(with zone: NSZone? = nil) -> Any {
        return MGRSLine(self)
    }
    
    public override func encode(with coder: NSCoder) {
        let gridValue = gridType != nil ? gridType?.rawValue : -1
        coder.encode(gridValue, forKey: "gridType")
        super.encode(with: coder)
    }
    
    public required init?(coder: NSCoder) {
        let gridValue = coder.decodeInteger(forKey: "gridType")
        if gridValue >= 0 {
            gridType = GridType.init(rawValue: gridValue)
        }
        super.init(coder: coder)
    }
    
    public func isEqual(_ gridLine: MGRSLine?) -> Bool {
        if self == gridLine {
            return true
        }
        if gridLine == nil {
            return false
        }
        if !super.isEqual(gridLine) {
            return false
        }
        return true
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
        
        if !(object is MGRSLine) {
            return false
        }
        
        return isEqual(object as? MGRSLine)
    }

    public override var hash: Int {
        let prime = 31
        var result = super.hash
        result = prime * result + ((gridType == nil) ? -1 : gridType!.rawValue)
        return result
    }
    
}
