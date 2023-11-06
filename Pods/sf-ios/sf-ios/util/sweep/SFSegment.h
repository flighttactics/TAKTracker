//
//  SFSegment.h
//  sf-ios
//
//  Created by Brian Osborn on 1/12/18.
//  Copyright © 2018 NGA. All rights reserved.
//

#import "SFPoint.h"

/**
 * Line segment of an edge between two points
 */
@interface SFSegment : NSObject

/**
 * Segment above
 */
@property (nonatomic, strong) SFSegment *above;

/**
 * Segment below
 */
@property (nonatomic, strong) SFSegment *below;

/**
 * Initialize
 *
 * @param edge
 *            edge number
 * @param ring
 *            ring number
 * @param leftPoint
 *            left point
 * @param rightPoint
 *            right point
 * @return segment
 */
-(instancetype) initWithEdge: (int) edge
                     andRing: (int) ring
                    andLeftPoint: (SFPoint *) leftPoint
                     andRightPoint: (SFPoint *) rightPoint;

/**
 * Get the edge number
 *
 * @return edge number
 */
-(int) edge;

/**
 * Get the polygon ring number
 *
 * @return polygon ring number
 */
-(int) ring;

/**
 * Get the left point
 *
 * @return left point
 */
-(SFPoint *) leftPoint;

/**
 * Get the right point
 *
 * @return right point
 */
-(SFPoint *) rightPoint;

@end
