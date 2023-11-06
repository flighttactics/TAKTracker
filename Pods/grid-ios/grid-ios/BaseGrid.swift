//
//  BaseGrid.swift
//  grid-ios
//
//  Created by Brian Osborn on 8/8/22.
//

import Foundation
import color_ios

/**
 * Base Grid
 */
open class BaseGrid: Hashable, Comparable {
    
    /**
     * Enabled grid
     */
    public var enabled: Bool = true
    
    /**
     * Minimum zoom level
     */
    public var minZoom: Int = 0
    
    /**
     * Maximum zoom level
     */
    public var maxZoom: Int?
    
    /**
     * Minimum zoom level override for drawing grid lines
     */
    private var _linesMinZoom: Int?
    
    /**
     * Minimum zoom level override for drawing grid lines
     */
    public var linesMinZoom: Int? {
        get {
            return _linesMinZoom != nil ? _linesMinZoom : minZoom
        }
        set {
            _linesMinZoom = newValue
        }
    }
    
    /**
     * Maximum zoom level override for drawing grid lines
     */
    private var _linesMaxZoom: Int?
    
    /**
     * Maximum zoom level override for drawing grid lines
     */
    public var linesMaxZoom: Int? {
        get {
            return _linesMaxZoom != nil ? _linesMaxZoom : maxZoom
        }
        set {
            _linesMaxZoom = newValue
        }
    }
    
    /**
     * Grid line style
     */
    public var style: GridStyle = GridStyle()
    
    /**
     * Grid labeler
     */
    open var labeler: Labeler?
    
    /**
     * The grid line color
     */
    public var color: UIColor? {
        get {
            return style.color
        }
        set {
            style.color = newValue
        }
    }

    /**
     * The grid line width
     */
    public var width: Double {
        get {
            return style.width
        }
        set {
            style.width = newValue
        }
    }
    
    /**
     * Initialize
     */
    public init() {
        
    }
    
    /**
     * Has a maximum zoom level
     *
     * @return true if has a maximum, false if unbounded
     */
    public func hasMaxZoom() -> Bool {
        return maxZoom != nil
    }
    
    /**
     * Is the zoom level within the grid zoom range
     *
     * @param zoom
     *            zoom level
     * @return true if within range
     */
    public func isWithin(_ zoom: Int) -> Bool {
        return zoom >= minZoom && (maxZoom == nil || zoom <= maxZoom!)
    }
    
    /**
     * Has a minimum zoom level override for drawing grid lines
     *
     * @return true if has a minimum, false if not overridden
     */
    public func hasLinesMinZoom() -> Bool {
        return _linesMinZoom != nil
    }
    
    /**
     * Has a maximum zoom level override for drawing grid lines
     *
     * @return true if has a maximum, false if not overridden
     */
    public func hasLinesMaxZoom() -> Bool {
        return _linesMaxZoom != nil
    }
    
    /**
     * Is the zoom level within the grid lines zoom range
     *
     * @param zoom
     *            zoom level
     * @return true if within range
     */
    public func isLinesWithin(_ zoom: Int) -> Bool {
        return (_linesMinZoom == nil || zoom >= _linesMinZoom!)
                        && (_linesMaxZoom == nil || zoom <= _linesMaxZoom!)
    }
    
    /**
     * Has a grid labeler
     *
     * @return true if has a grid labeler
     */
    public func hasLabeler() -> Bool {
        return labeler != nil
    }
    
    /**
     * Is labeler zoom level within the grid zoom range
     *
     * @param zoom
     *            zoom level
     * @return true if within range
     */
    public func isLabelerWithin(_ zoom: Int) -> Bool {
        return hasLabeler() && labeler!.enabled && labeler!.isWithin(zoom)
    }
    
    /**
     * Get the label grid edge buffer
     *
     * @return label buffer (greater than or equal to 0.0 and less than 0.5)
     */
    public func labelBuffer() -> Double {
        return hasLabeler() ? labeler!.buffer : 0.0
    }
    
    public static func == (lhs: BaseGrid, rhs: BaseGrid) -> Bool {
        return lhs.equals(rhs)
    }
    
    open func equals(_ grid: BaseGrid) -> Bool {
        preconditionFailure("This method must be overridden")
    }
    
    open func hash(into hasher: inout Hasher) {

    }
    
    public static func < (lhs: BaseGrid, rhs: BaseGrid) -> Bool {
        return lhs.compare(rhs)
    }
    
    open func compare(_ grid: BaseGrid) -> Bool {
        preconditionFailure("This method must be overridden")
    }
    
}
