//
//  SFEventQueue.h
//  sf-ios
//
//  Created by Brian Osborn on 1/12/18.
//  Copyright © 2018 NGA. All rights reserved.
//

#import "SFLineString.h"
#import "SFEvent.h"

/**
 * Event queue for processing events
 */
@interface SFEventQueue : NSObject

/**
 * Initialize
 *
 * @param ring
 *            polygon ring
 * @return event queue
 */
-(instancetype) initWithRing: (SFLineString *) ring;

/**
 * Initialize
 *
 * @param rings
 *            polygon rings
 * @return event queue
 */
-(instancetype) initWithRings: (NSArray<SFLineString *> *) rings;

/**
 * Get the events
 *
 * @return events
 */
-(NSArray<SFEvent *> *) events;

@end
