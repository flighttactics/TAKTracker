//
//  SFGeometryFilter.h
//  sf-ios
//
//  Created by Brian Osborn on 7/21/20.
//  Copyright © 2020 NGA. All rights reserved.
//

#ifndef sf_ios_SFGeometryFilter_h
#define sf_ios_SFGeometryFilter_h

#import "SFGeometry.h"

/**
 * Geometry Filter to filter included geometries and modify them during
 * construction
 */
@protocol SFGeometryFilter <NSObject>

/**
 * Filter the geometry
 *
 * @param geometry
 *            geometry, may be modified
 * @param containingType
 *            geometry type of the geometry containing this geometry
 *            element, null if geometry is top level
 * @return true if passes filter and geometry should be included
 */
-(BOOL) filterGeometry: (SFGeometry *) geometry inType: (enum SFGeometryType) containingType;

@end

#endif
