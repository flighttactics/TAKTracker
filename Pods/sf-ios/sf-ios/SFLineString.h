//
//  SFLineString.h
//  sf-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "SFCurve.h"

/**
 * A Curve that connects two or more points in space.
 */
@interface SFLineString : SFCurve

/**
 *  Array of points
 */
@property (nonatomic, strong) NSMutableArray<SFPoint *> *points;

/**
 *  Create
 *
 *  @return new line string
 */
+(SFLineString *) lineString;

/**
 *  Create
 *
 *  @param hasZ has z values
 *  @param hasM has m values
 *
 *  @return new line string
 */
+(SFLineString *) lineStringWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 * Create
 *
 * @param points
 *            list of points
 *
 *  @return new line string
 */
+(SFLineString *) lineStringWithPoints: (NSMutableArray<SFPoint *> *) points;

/**
 * Create
 *
 * @param lineString
 *            line string
 *
 *  @return new line string
 */
+(SFLineString *) lineStringWithLineString: (SFLineString *) lineString;

/**
 *  Initialize
 *
 *  @return new line string
 */
-(instancetype) init;

/**
 *  Initialize
 *
 *  @param hasZ has z values
 *  @param hasM has m values
 *
 *  @return new line string
 */
-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 * Initialize
 *
 * @param points
 *            list of points
 *
 *  @return new line string
 */
-(instancetype) initWithPoints: (NSMutableArray<SFPoint *> *) points;

/**
 *  Initialize
 *
 *  @param geometryType geometry type
 *  @param hasZ         has z values
 *  @param hasM         has m values
 *
 *  @return new line string
 */
-(instancetype) initWithType: (enum SFGeometryType) geometryType andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 * Initialize
 *
 * @param lineString
 *            line string
 *
 *  @return new line string
 */
-(instancetype) initWithLineString: (SFLineString *) lineString;

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
