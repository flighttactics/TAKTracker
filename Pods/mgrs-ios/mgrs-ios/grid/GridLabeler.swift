//
//  GridLabeler.swift
//  mgrs-ios
//
//  Created by Brian Osborn on 9/2/22.
//

import Foundation
import grid_ios
import color_ios

/**
 * Grid labeler
 */
public class GridLabeler: Labeler {
    
    /**
     * Default text size
     */
    public static let DEFAULT_TEXT_SIZE = MGRSProperties.instance.doubleValue(PropertyConstants.LABELER, PropertyConstants.TEXT_SIZE)
    
    /**
     * Default buffer size
     */
    public static let DEFAULT_BUFFER = MGRSProperties.instance.doubleValue(PropertyConstants.LABELER, PropertyConstants.BUFFER)
    
    /**
     * Initialize
     */
    public init() {
        super.init(true, 0, nil, UIColor.black, GridLabeler.DEFAULT_TEXT_SIZE, GridLabeler.DEFAULT_BUFFER)
    }
    
    /**
     * Initialize
     *
     * @param minZoom
     *            minimum zoom
     * @param color
     *            label color
     */
    public convenience init(_ minZoom: Int, _ color: UIColor) {
        self.init(minZoom, color, GridLabeler.DEFAULT_TEXT_SIZE)
    }
    
    /**
     * Initialize
     *
     * @param minZoom
     *            minimum zoom
     * @param color
     *            label color
     * @param textSize
     *            label text size
     */
    public convenience init(_ minZoom: Int, _ color: UIColor, _ textSize: Double) {
        self.init(minZoom, color, textSize, GridLabeler.DEFAULT_BUFFER)
    }
        
    /**
     * Initialize
     *
     * @param minZoom
     *            minimum zoom
     * @param color
     *            label color
     * @param textSize
     *            label text size
     * @param buffer
     *            grid edge buffer (greater than or equal to 0.0 and less than
     *            0.5)
     */
    public init(_ minZoom: Int, _ color: UIColor, _ textSize: Double, _ buffer: Double) {
        super.init(true, minZoom, nil, color, textSize, buffer)
    }
    
    /**
     * Initialize
     *
     * @param minZoom
     *            minimum zoom
     * @param maxZoom
     *            maximum zoom
     * @param color
     *            label color
     */
    public convenience init(_ minZoom: Int, _ maxZoom: Int?, _ color: UIColor) {
        self.init(minZoom, maxZoom, color, GridLabeler.DEFAULT_TEXT_SIZE)
    }
    
    /**
     * Initialize
     *
     * @param minZoom
     *            minimum zoom
     * @param maxZoom
     *            maximum zoom
     * @param color
     *            label color
     * @param textSize
     *            label text size
     */
    public convenience init(_ minZoom: Int, _ maxZoom: Int?, _ color: UIColor, _ textSize: Double) {
        self.init(minZoom, maxZoom, color, textSize, GridLabeler.DEFAULT_BUFFER)
    }
    
    /**
     * Initialize
     *
     * @param minZoom
     *            minimum zoom
     * @param maxZoom
     *            maximum zoom
     * @param color
     *            label color
     * @param textSize
     *            label text size
     * @param buffer
     *            grid edge buffer (greater than or equal to 0.0 and less than
     *            0.5)
     */
    public init(_ minZoom: Int, _ maxZoom: Int?, _ color: UIColor, _ textSize: Double, _ buffer: Double) {
        super.init(true, minZoom, maxZoom, color, textSize, buffer)
    }
    
    /**
     * Initialize
     *
     * @param enabled
     *            enabled labeler
     * @param minZoom
     *            minimum zoom
     * @param maxZoom
     *            maximum zoom
     * @param color
     *            label color
     */
    public convenience init(_ enabled: Bool, _ minZoom: Int, _ maxZoom: Int?, _ color: UIColor) {
        self.init(enabled, minZoom, maxZoom, color, GridLabeler.DEFAULT_TEXT_SIZE)
    }

    /**
     * Initialize
     *
     * @param enabled
     *            enabled labeler
     * @param minZoom
     *            minimum zoom
     * @param maxZoom
     *            maximum zoom
     * @param color
     *            label color
     * @param textSize
     *            label text size
     */
    public convenience init(_ enabled: Bool, _ minZoom: Int, _ maxZoom: Int?, _ color: UIColor, _ textSize: Double) {
        self.init(enabled, minZoom, maxZoom, color, textSize, GridLabeler.DEFAULT_BUFFER)
    }

    /**
     * Initialize
     *
     * @param enabled
     *            enabled labeler
     * @param minZoom
     *            minimum zoom
     * @param maxZoom
     *            maximum zoom
     * @param color
     *            label color
     * @param textSize
     *            label text size
     * @param buffer
     *            grid edge buffer (greater than or equal to 0.0 and less than
     *            0.5)
     */
    public init(_ enabled: Bool, _ minZoom: Int, _ maxZoom: Int?, _ color: UIColor, _ textSize: Double, _ buffer: Double) {
        super.init(enabled, minZoom, maxZoom, color, textSize, buffer)
    }
    
    /**
     * Get labels for the bounds
     *
     * @param tileBounds
     *            tile bounds
     * @param gridType
     *            grid type
     * @param zone
     *            grid zone
     * @return labels
     */
    public func labels(_ tileBounds: Bounds, _ gridType: GridType, _ zone: GridZone) -> [GridLabel]? {
        preconditionFailure("This method must be overridden")
    }
    
}
