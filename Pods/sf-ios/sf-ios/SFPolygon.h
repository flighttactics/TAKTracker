//
//  SFPolygon.h
//  sf-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "SFCurvePolygon.h"
#import "SFLineString.h"

/**
 * A restricted form of CurvePolygon where each ring is defined as a simple,
 * closed LineString.
 */
@interface SFPolygon : SFCurvePolygon

/**
 *  Create
 *
 *  @return new polygon
 */
+(SFPolygon *) polygon;

/**
 *  Create
 *
 *  @param hasZ has z values
 *  @param hasM has m values
 *
 *  @return new polygon
 */
+(SFPolygon *) polygonWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 * Create
 *
 * @param rings
 *            list of rings
 *
 *  @return new polygon
 */
+(SFPolygon *) polygonWithRings: (NSMutableArray<SFLineString *> *) rings;

/**
 * Create
 *
 * @param ring
 *            ring
 *
 *  @return new polygon
 */
+(SFPolygon *) polygonWithRing: (SFLineString *) ring;

/**
 * Create
 *
 * @param polygon
 *            polygon
 *
 *  @return new polygon
 */
+(SFPolygon *) polygonWithPolygon: (SFPolygon *) polygon;

/**
 *  Initialize
 *
 *  @return new polygon
 */
-(instancetype) init;

/**
 *  Initialize
 *
 *  @param hasZ has z values
 *  @param hasM has m values
 *
 *  @return new polygon
 */
-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 * Initialize
 *
 * @param rings
 *            list of rings
 *
 *  @return new polygon
 */
-(instancetype) initWithRings: (NSMutableArray<SFLineString *> *) rings;

/**
 * Initialize
 *
 * @param ring
 *            ring
 *
 *  @return new polygon
 */
-(instancetype) initWithRing: (SFLineString *) ring;

/**
 *  Initialize
 *
 *  @param geometryType geometry type
 *  @param hasZ         has z values
 *  @param hasM         has m values
 *
 *  @return new polygon
 */
-(instancetype) initWithType: (enum SFGeometryType) geometryType andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 * Initialize
 *
 * @param polygon
 *            polygon
 *
 *  @return new polygon
 */
-(instancetype) initWithPolygon: (SFPolygon *) polygon;

/**
 * Get the line string rings
 *
 * @return line string rings
 */
-(NSMutableArray<SFLineString *> *) lineStrings;

/**
 * Set the line string rings
 *
 * @param rings
 *            line string rings
 */
-(void) setRings: (NSMutableArray<SFLineString *> *) rings;

/**
 * Returns the Nth ring where the exterior ring is at 0, interior rings
 * begin at 1
 *
 * @param n
 *            nth ring to return
 * @return ring
 */
-(SFLineString *) ringAtIndex: (int) n;

/**
 * Get the exterior ring
 *
 * @return exterior ring
 */
-(SFLineString *) exteriorRing;

/**
 * Returns the Nth interior ring for this Polygon
 *
 * @param n
 *            interior ring number
 * @return interior ring
 */
-(SFLineString *) interiorRingAtIndex: (int) n;

@end
