//
//  SFTriangle.h
//  sf-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "SFPolygon.h"

/**
 * Triangle
 */
@interface SFTriangle : SFPolygon

/**
 *  Create
 *
 *  @return new triangle
 */
+(SFTriangle *) triangle;

/**
 *  Create
 *
 *  @param hasZ has z values
 *  @param hasM has m values
 *
 *  @return new triangle
 */
+(SFTriangle *) triangleWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 * Create
 *
 * @param rings
 *            list of rings
 *
 *  @return new triangle
 */
+(SFTriangle *) triangleWithRings: (NSMutableArray<SFLineString *> *) rings;

/**
 * Create
 *
 * @param ring
 *            ring
 *
 *  @return new triangle
 */
+(SFTriangle *) triangleWithRing: (SFLineString *) ring;

/**
 * Create
 *
 * @param triangle
 *            triangle
 *
 *  @return new triangle
 */
+(SFTriangle *) triangleWithTriangle: (SFTriangle *) triangle;

/**
 *  Initialize
 *
 *  @return new triangle
 */
-(instancetype) init;

/**
 *  Initialize
 *
 *  @param hasZ has z values
 *  @param hasM has m values
 *
 *  @return new triangle
 */
-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 * Initialize
 *
 * @param rings
 *            list of rings
 *
 *  @return new triangle
 */
-(instancetype) initWithRings: (NSMutableArray<SFLineString *> *) rings;

/**
 * Initialize
 *
 * @param ring
 *            ring
 *
 *  @return new triangle
 */
-(instancetype) initWithRing: (SFLineString *) ring;

/**
 * Initialize
 *
 * @param triangle
 *            triangle
 *
 *  @return new triangle
 */
-(instancetype) initWithTriangle: (SFTriangle *) triangle;

@end
