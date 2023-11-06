//
//  SFDegreesCentroid.h
//  sf-ios
//
//  Created by Brian Osborn on 2/9/22.
//  Copyright © 2022 NGA. All rights reserved.
//

#import "SFPoint.h"

/**
 * Centroid calculations for geometries in degrees
 */
@interface SFDegreesCentroid : NSObject

/**
 * Get the degree geometry centroid
 *
 * @param geometry
 *            geometry
 * @return centroid point
 */
+(SFPoint *) centroidOfGeometry: (SFGeometry *) geometry;

/**
 * Initialize
 *
 * @param geometry
 *            geometry
 * @return new instance
 */
-(instancetype) initWithGeometry: (SFGeometry *) geometry;

/**
 * Get the centroid point
 *
 * @return centroid point
 */
-(SFPoint *) centroid;

@end
