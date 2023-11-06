//
//  SFEvent.h
//  sf-ios
//
//  Created by Brian Osborn on 1/11/18.
//  Copyright © 2018 NGA. All rights reserved.
//

#import "SFPoint.h"
#import "SFEventTypes.h"

/**
 * Event element
 */
@interface SFEvent : NSObject

/**
 * Initialize
 *
 * @param edge
 *            edge number
 * @param ring
 *            ring number
 * @param point
 *            point
 * @param type
 *            event type
 * @return event
 */
-(instancetype) initWithEdge: (int) edge
                     andRing: (int) ring
                    andPoint: (SFPoint *) point
                     andType: (enum SFEventType) type;

/**
 * Get the edge
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
 * Get the polygon point
 *
 * @return polygon point
 */
-(SFPoint *) point;

/**
 * Get the event type
 *
 * @return event type
 */
-(enum SFEventType) type;

/**
 * Sort the events
 *
 * @return sorted events
 */
+(NSArray<SFEvent *> *) sort: (NSArray<SFEvent *> *) events;

@end
