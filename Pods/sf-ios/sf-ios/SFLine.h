//
//  SFLine.h
//  sf-ios
//
//  Created by Brian Osborn on 4/25/18.
//  Copyright © 2018 NGA. All rights reserved.
//

#import "SFLineString.h"

/**
 * A LineString with exactly 2 Points.
 */
@interface SFLine : SFLineString

/**
 *  Create
 *
 *  @return new line
 */
+(SFLine *) line;

/**
 *  Create
 *
 *  @param hasZ has z values
 *  @param hasM has m values
 *
 *  @return new line
 */
+(SFLine *) lineWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 * Create
 *
 * @param points
 *            list of points
 *
 *  @return new line
 */
+(SFLine *) lineWithPoints: (NSMutableArray<SFPoint *> *) points;

/**
 *  Create
 *
 *  @param point1 first point
 *  @param point2 second point
 *
 *  @return new line
 */
+(SFLine *) lineWithPoint1: (SFPoint *) point1 andPoint2: (SFPoint *) point2;

/**
 *  Create
 *
 *  @param line line
 *
 *  @return new line
 */
+(SFLine *) lineWithLine: (SFLine *) line;

/**
 *  Initialize
 *
 *  @return new line
 */
-(instancetype) init;

/**
 *  Initialize
 *
 *  @param hasZ has z values
 *  @param hasM has m values
 *
 *  @return new line
 */
-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 * Initialize
 *
 * @param points
 *            list of points
 *
 *  @return new line
 */
-(instancetype) initWithPoints: (NSMutableArray<SFPoint *> *) points;

/**
 *  Initialize
 *
 *  @param point1 first point
 *  @param point2 second point
 *
 *  @return new line
 */
-(instancetype) initWithPoint1: (SFPoint *) point1 andPoint2: (SFPoint *) point2;

/**
 *  Initialize
 *
 *  @param line line
 *
 *  @return new line
 */
-(instancetype) initWithLine: (SFLine *) line;

@end
