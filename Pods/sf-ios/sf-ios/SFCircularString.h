//
//  SFCircularString.h
//  sf-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "SFLineString.h"

/**
 * Circular String, Curve sub type
 */
@interface SFCircularString : SFLineString

/**
 *  Create
 *
 *  @return new circular string
 */
+(SFCircularString *) circularString;

/**
 *  Create
 *
 *  @param hasZ has z values
 *  @param hasM has m values
 *
 *  @return new circular string
 */
+(SFCircularString *) circularStringWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 * Create
 *
 * @param points
 *            list of points
 *
 *  @return new circular string
 */
+(SFCircularString *) circularStringWithPoints: (NSMutableArray<SFPoint *> *) points;

/**
 *  Create
 *
 *  @param circularString circular string
 *
 *  @return new circular string
 */
+(SFCircularString *) circularStringWithCircularString: (SFCircularString *) circularString;

/**
 *  Initialize
 *
 *  @return new circular string
 */
-(instancetype) init;

/**
 *  Initialize
 *
 *  @param hasZ has z values
 *  @param hasM has m values
 *
 *  @return new circular string
 */
-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 * Initialize
 *
 * @param points
 *            list of points
 *
 *  @return new circular string
 */
-(instancetype) initWithPoints: (NSMutableArray<SFPoint *> *) points;

/**
 *  Initialize
 *
 *  @param circularString circular string
 *
 *  @return new circular string
 */
-(instancetype) initWithCircularString: (SFCircularString *) circularString;

@end
