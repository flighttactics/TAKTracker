//
//  SFExtendedGeometryCollection.h
//  sf-ios
//
//  Created by Brian Osborn on 4/25/18.
//  Copyright © 2018 NGA. All rights reserved.
//

#import "SFGeometryCollection.h"

/**
 * Extended Geometry Collection providing abstract geometry collection type
 * support
 */
@interface SFExtendedGeometryCollection : SFGeometryCollection

/**
 * Create
 *
 * @param geometryCollection
 *            geometry collection
 *
 *  @return new extended geometry collection
 */
+(SFExtendedGeometryCollection *) extendedGeometryCollectionWithGeometryCollection: (SFGeometryCollection *) geometryCollection;

/**
 * Create
 *
 * @param extendedGeometryCollection
 *            extended geometry collection
 *
 *  @return new extended geometry collection
 */
+(SFExtendedGeometryCollection *) extendedGeometryCollectionWithExtendedGeometryCollection: (SFExtendedGeometryCollection *) extendedGeometryCollection;

/**
 * Initialize
 *
 * @param geometryCollection
 *            geometry collection
 *
 *  @return new extended geometry collection
 */
-(instancetype) initWithGeometryCollection: (SFGeometryCollection *) geometryCollection;

/**
 * Initialize
 *
 * @param extendedGeometryCollection
 *            extended geometry collection
 *
 *  @return new extended geometry collection
 */
-(instancetype) initWithExtendedGeometryCollection: (SFExtendedGeometryCollection *) extendedGeometryCollection;

/**
 * Update the extended geometry type based upon the contained geometries
 */
-(void) updateGeometryType;

@end
