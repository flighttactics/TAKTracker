//
//  SFEvent.m
//  sf-ios
//
//  Created by Brian Osborn on 1/11/18.
//  Copyright © 2018 NGA. All rights reserved.
//

#import "SFEvent.h"
#import "SFSweepLine.h"

@interface SFEvent()

/**
 * Edge number
 */
@property (nonatomic) int edge;

/**
 * Polygon ring number
 */
@property (nonatomic) int ring;

/**
 * Polygon point
 */
@property (nonatomic, strong) SFPoint *point;

/**
 * Event type, left or right point
 */
@property (nonatomic) enum SFEventType type;

@end

@implementation SFEvent

-(instancetype) initWithEdge: (int) edge
                      andRing: (int) ring
                     andPoint: (SFPoint *) point
                      andType: (enum SFEventType) type{
    self = [super init];
    if(self != nil){
        self.edge = edge;
        self.ring = ring;
        self.point = point;
        self.type = type;
    }
    return self;
}

-(int) edge{
    return _edge;
}

-(int) ring{
    return _ring;
}

-(SFPoint *) point{
    return _point;
}

-(enum SFEventType) type{
    return _type;
}

- (NSComparisonResult) compare: (SFEvent *) event{
    return [SFSweepLine xyOrderWithPoint:self.point andPoint:event.point];
}

+(NSArray<SFEvent *> *) sort: (NSArray<SFEvent *> *) events{
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    NSArray *sorted = [events sortedArrayUsingDescriptors:@[sort]];
    return sorted;
}

@end
