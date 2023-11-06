//
//  SFCurvePolygon.h
//  sf-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "SFSurface.h"
#import "SFCurve.h"

/**
 * A planar surface defined by an exterior ring and zero or more interior ring.
 * Each ring is defined by a Curve instance.
 */
@interface SFCurvePolygon : SFSurface

/**
 *  Array of rings
 */
@property (nonatomic, strong) NSMutableArray<SFCurve *> *rings;

/**
 *  Create
 *
 *  @return new curve polygon
 */
+(SFCurvePolygon *) curvePolygon;

/**
 *  Create
 *
 *  @param hasZ has z values
 *  @param hasM has m values
 *
 *  @return new curve polygon
 */
+(SFCurvePolygon *) curvePolygonWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 * Create
 *
 * @param rings
 *            list of rings
 *
 *  @return new curve polygon
 */
+(SFCurvePolygon *) curvePolygonWithRings: (NSMutableArray<SFCurve *> *) rings;

/**
 * Create
 *
 * @param ring
 *            ring
 *
 *  @return new curve polygon
 */
+(SFCurvePolygon *) curvePolygonWithRing: (SFCurve *) ring;

/**
 * Create
 *
 * @param curvePolygon
 *            curve polygon
 *
 *  @return new curve polygon
 */
+(SFCurvePolygon *) curvePolygonWithCurvePolygon: (SFCurvePolygon *) curvePolygon;

/**
 *  Initialize
 *
 *  @return new curve polygon
 */
-(instancetype) init;

/**
 *  Initialize
 *
 *  @param hasZ has z values
 *  @param hasM has m values
 *
 *  @return new curve polygon
 */
-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 * Initialize
 *
 * @param rings
 *            list of rings
 *
 *  @return new curve polygon
 */
-(instancetype) initWithRings: (NSMutableArray<SFCurve *> *) rings;

/**
 * Initialize
 *
 * @param ring
 *            ring
 *
 *  @return new curve polygon
 */
-(instancetype) initWithRing: (SFCurve *) ring;

/**
 *  Initialize
 *
 *  @param geometryType geometry type
 *  @param hasZ         has z values
 *  @param hasM         has m values
 *
 *  @return new curve polygon
 */
-(instancetype) initWithType: (enum SFGeometryType) geometryType andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 * Initialize
 *
 * @param curvePolygon
 *            curve polygon
 *
 *  @return new curve polygon
 */
-(instancetype) initWithCurvePolygon: (SFCurvePolygon *) curvePolygon;

/**
 *  Add a ring
 *
 *  @param ring curve ring
 */
-(void) addRing: (SFCurve *) ring;

/**
 * Add rings
 *
 * @param rings
 *            rings
 */
-(void) addRings: (NSArray<SFCurve *> *) rings;

/**
 *  Get the number of rings
 *
 *  @return ring count
 */
-(int) numRings;

/**
 * Returns the Nth ring where the exterior ring is at 0, interior rings
 * begin at 1
 *
 * @param n
 *            nth ring to return
 * @return ring
 */
-(SFCurve *) ringAtIndex: (int) n;

/**
 * Get the exterior ring
 *
 * @return exterior ring
 */
-(SFCurve *) exteriorRing;

/**
 * Get the number of interior rings
 *
 * @return number of interior rings
 */
-(int) numInteriorRings;

/**
 * Returns the Nth interior ring for this Polygon
 *
 * @param n
 *            interior ring number
 * @return interior ring
 */
-(SFCurve *) interiorRingAtIndex: (int) n;

@end
