//
//  SFCentroidPoint.h
//  sf-ios
//
//  Created by Brian Osborn on 4/14/17.
//  Copyright © 2017 NGA. All rights reserved.
//

#import "SFPoint.h"

/**
 * Calculate the centroid from point based geometries. Implementation based on
 * the JTS (Java Topology Suite) CentroidPoint.
 */
@interface SFCentroidPoint : NSObject

/**
 *  Initialize
 *
 *  @return new instance
 */
-(instancetype) init;

/**
 *  Initialize
 *
 * @param geometry
 *            geometry to add
 *  @return new instance
 */
-(instancetype) initWithGeometry: (SFGeometry *) geometry;

/**
 * Add a point based dimension 0 geometry to the centroid total
 *
 * @param geometry
 *            geometry
 */
-(void) addGeometry: (SFGeometry *) geometry;

/**
 * Get the centroid point
 *
 * @return centroid point
 */
-(SFPoint *) centroid;

@end
