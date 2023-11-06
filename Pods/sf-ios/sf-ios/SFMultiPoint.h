//
//  SFMultiPoint.h
//  sf-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "SFGeometryCollection.h"

/**
 * A restricted form of GeometryCollection where each Geometry in the collection
 * must be of type Point.
 */
@interface SFMultiPoint : SFGeometryCollection

/**
 *  Create
 *
 *  @return new multi point
 */
+(SFMultiPoint *) multiPoint;

/**
 *  Create
 *
 *  @param hasZ has z values
 *  @param hasM has m values
 *
 *  @return new multi point
 */
+(SFMultiPoint *) multiPointWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 * Create
 *
 * @param points
 *            list of points
 *
 *  @return new multi point
 */
+(SFMultiPoint *) multiPointWithPoints: (NSMutableArray<SFPoint *> *) points;

/**
 * Create
 *
 * @param point
 *            point
 *
 *  @return new multi point
 */
+(SFMultiPoint *) multiPointWithPoint: (SFPoint *) point;

/**
 * Create
 *
 * @param multiPoint
 *            multi point
 *
 *  @return new multi point
 */
+(SFMultiPoint *) multiPointWithMultiPoint: (SFMultiPoint *) multiPoint;

/**
 *  Initialize
 *
 *  @return new multi point
 */
-(instancetype) init;

/**
 *  Initialize
 *
 *  @param hasZ has z values
 *  @param hasM has m values
 *
 *  @return new multi point
 */
-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 * Initialize
 *
 * @param points
 *            list of points
 *
 *  @return new multi point
 */
-(instancetype) initWithPoints: (NSMutableArray<SFPoint *> *) points;

/**
 * Initialize
 *
 * @param point
 *            point
 *
 *  @return new multi point
 */
-(instancetype) initWithPoint: (SFPoint *) point;

/**
 * Initialize
 *
 * @param multiPoint
 *            multi point
 *
 *  @return new multi point
 */
-(instancetype) initWithMultiPoint: (SFMultiPoint *) multiPoint;

/**
 *  Get the points
 *
 *  @return points
 */
-(NSMutableArray<SFPoint *> *) points;

/**
 *  Set the points
 *
 *  @param points points
 */
-(void) setPoints: (NSMutableArray<SFPoint *> *) points;

/**
 *  Add a point
 *
 *  @param point point
 */
-(void) addPoint: (SFPoint *) point;

/**
 * Add points
 *
 * @param points
 *            points
 */
-(void) addPoints: (NSArray<SFPoint *> *) points;

/**
 *  Get the number of points
 *
 *  @return point count
 */
-(int) numPoints;

/**
 * Returns the Nth point
 *
 * @param n
 *            nth point to return
 * @return point
 */
-(SFPoint *) pointAtIndex: (int) n;

@end
