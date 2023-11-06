//
//  SFSweepLine.h
//  sf-ios
//
//  Created by Brian Osborn on 1/12/18.
//  Copyright © 2018 NGA. All rights reserved.
//

#import "SFSegment.h"
#import "SFEvent.h"
#import "SFLineString.h"

/**
 * Sweep Line algorithm
 */
@interface SFSweepLine : NSObject

/**
 * Initialize
 *
 * @param rings
 *            polygon rings
 * @return sweep line
 */
-(instancetype) initWithRings: (NSArray<SFLineString *> *) rings;

/**
 * Add the event to the sweep line
 *
 * @param event
 *            event
 * @return added segment
 */
-(SFSegment *) addEvent: (SFEvent *) event;

/**
 * Find the existing event segment
 *
 * @param event
 *            event
 * @return segment
 */
-(SFSegment *) findEvent: (SFEvent *) event;

/**
 * Determine if the two segments intersect
 *
 * @param segment1
 *            segment 1
 * @param segment2
 *            segment 2
 * @return true if intersection, false if not
 */
-(BOOL) intersectWithSegment: (SFSegment *) segment1 andSegment: (SFSegment *) segment2;

/**
 * Remove the segment from the sweep line
 *
 * @param segment
 *            segment
 */
-(void) removeSegment: (SFSegment *) segment;

/**
 * XY order of two points
 *
 * @param point1
 *            point 1
 * @param point2
 *            point 2
 * @return NSOrderedDescending if p1 &gt; p2, NSOrderedAscending if p1 &lt; p2, NSOrderedSame if equal
 */
+(NSComparisonResult) xyOrderWithPoint: (SFPoint *) point1 andPoint: (SFPoint *) point2;

@end
