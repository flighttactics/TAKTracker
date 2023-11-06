//
//  GridStyle.swift
//  grid-ios
//
//  Created by Brian Osborn on 8/5/22.
//

import Foundation
import color_ios

/**
 * Grid Line Style
 */
public class GridStyle {
    
    /**
     * Grid line color
     */
    public var color: UIColor?
    
    /**
     * Grid line width
     */
    public var width: Double = 0
    
    /**
     * Initialize
     */
    public init() {
        
    }
    
    /**
     * Initialize
     *
     * @param color
     *            color
     * @param width
     *            width
     */
    public init(_ color: UIColor?, _ width: Double) {
        self.color = color
        self.width = width
    }

}
