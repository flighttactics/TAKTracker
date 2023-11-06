//
//  SFSurface.h
//  sf-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "SFGeometry.h"

/**
 * The base type for all 2-dimensional geometry types. A 2-dimensional geometry
 * is a geometry that has an area.
 */
@interface SFSurface : SFGeometry

/**
 *  Initialize
 *
 *  @param geometryType geometry type
 *  @param hasZ         has z values
 *  @param hasM         has m values
 *
 *  @return new surface
 */
-(instancetype) initWithType: (enum SFGeometryType) geometryType andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

@end
