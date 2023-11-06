//
//  SFMultiSurface.h
//  sf-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "SFGeometryCollection.h"
#import "SFSurface.h"

/**
 * A restricted form of GeometryCollection where each Geometry in the collection
 * must be of type Surface.
 */
@interface SFMultiSurface : SFGeometryCollection

/**
 *  Initialize
 *
 *  @param geometryType geometry type
 *  @param hasZ         has z values
 *  @param hasM         has m values
 *
 *  @return new multi surface
 */
-(instancetype) initWithType: (enum SFGeometryType) geometryType andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Get the surfaces
 *
 *  @return surfaces
 */
-(NSMutableArray<SFSurface *> *) surfaces;

/**
 *  Set the surfaces
 *
 *  @param surfaces surfaces
 */
-(void) setSurfaces: (NSMutableArray<SFSurface *> *) surfaces;

/**
 *  Add a surface
 *
 *  @param surface surface
 */
-(void) addSurface: (SFSurface *) surface;

/**
 * Add surfaces
 *
 * @param surfaces
 *            surfaces
 */
-(void) addSurfaces: (NSArray<SFSurface *> *) surfaces;

/**
 *  Get the number of surfaces
 *
 *  @return surface count
 */
-(int) numSurfaces;

/**
 * Returns the Nth surface
 *
 * @param n
 *            nth surface to return
 * @return surface
 */
-(SFSurface *) surfaceAtIndex: (int) n;

@end
