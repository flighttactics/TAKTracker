//
//  MGRSLabeler.swift
//  mgrs-ios
//
//  Created by Brian Osborn on 9/2/22.
//

import Foundation
import grid_ios

/**
 * MGRS grid labeler
 */
public class MGRSLabeler: GridLabeler {
    
    public override func labels(_ tileBounds: Bounds, _ gridType: GridType, _ zone: GridZone) -> [GridLabel]? {
        
        var labels: [GridLabel]? = nil
        
        let drawBounds = zone.drawBounds(tileBounds, gridType)
        
        if drawBounds != nil {
            
            labels = []
            
            let precision = Double(gridType.precision())
            
            for easting in stride(from: drawBounds!.minLongitude, through: drawBounds!.maxLongitude, by: precision) {
                for northing in stride(from: drawBounds!.minLatitude, through: drawBounds!.maxLatitude, by: precision) {
                    
                    let gridLabel = label(gridType, zone, easting, northing)
                    if gridLabel != nil {
                        labels!.append(gridLabel!)
                    }
                    
                }
            }
            
        }

        return labels
    }
    
    /**
     * Get the grid zone label
     *
     * @param gridType
     *            grid type
     * @param easting
     *            easting
     * @param northing
     *            northing
     * @return labels
     */
    private func label(_ gridType: GridType, _ zone: GridZone, _ easting: Double,
            _ northing: Double) -> GridLabel? {

        var label: GridLabel? = nil

        let precision = Double(gridType.precision())
        let bounds = zone.bounds
        let zoneNumber = zone.number()
        let hemisphere = zone.hemisphere()

        let northwest = UTM.point(zoneNumber, hemisphere, easting,
                northing + precision)
        let southwest = UTM.point(zoneNumber, hemisphere, easting, northing)
        let southeast = UTM.point(zoneNumber, hemisphere, easting + precision,
                northing)
        let northeast = UTM.point(zoneNumber, hemisphere, easting + precision,
                northing + precision)

        var minLatitude = max(southwest.latitude, southeast.latitude)
        minLatitude = max(minLatitude, bounds.minLatitude)
        var maxLatitude = min(northwest.latitude, northeast.latitude)
        maxLatitude = min(maxLatitude, bounds.maxLatitude)

        var minLongitude = max(southwest.longitude, northwest.longitude)
        minLongitude = max(minLongitude, bounds.minLongitude)
        var maxLongitude = min(southeast.longitude, northeast.longitude)
        maxLongitude = min(maxLongitude, bounds.maxLongitude)

        if minLongitude <= maxLongitude && minLatitude <= maxLatitude {

            let labelBounds = Bounds.degrees(minLongitude, minLatitude,
                    maxLongitude, maxLatitude)
            let center = labelBounds.centroid()

            let mgrs = MGRS.from(center)
            var id: String
            if gridType == GridType.HUNDRED_KILOMETER {
                id = mgrs.columnRowId()
            } else {
                id = mgrs.eastingAndNorthing(gridType)
            }

            label = GridLabel(id, center, labelBounds, gridType, mgrs)
        }

        return label
    }
    
}
