//
//  GZDLabeler.swift
//  mgrs-ios
//
//  Created by Brian Osborn on 9/2/22.
//

import Foundation
import grid_ios

/**
 * Grid Zone Designator labeler
 */
public class GZDLabeler: GridLabeler {
    
    public override func labels(_ tileBounds: Bounds, _ gridType: GridType, _ zone: GridZone) -> [GridLabel]? {
        var labels = [GridLabel]()
        let bounds = zone.bounds
        let center = bounds.centroid()
        labels.append(GridLabel(zone.name(), center, bounds, gridType, MGRS.from(center)))
        return labels
    }
    
}
