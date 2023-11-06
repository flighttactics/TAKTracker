//
//  SFEventQueue.m
//  sf-ios
//
//  Created by Brian Osborn on 1/12/18.
//  Copyright © 2018 NGA. All rights reserved.
//

#import "SFEventQueue.h"
#import "SFSweepLine.h"

@interface SFEventQueue()

@property (nonatomic, strong) NSArray<SFEvent *> *events;

@end

@implementation SFEventQueue

-(instancetype) initWithRing: (SFLineString *) ring{
    return [self initWithRings:[NSArray arrayWithObjects:ring, nil]];
}

-(instancetype) initWithRings: (NSArray<SFLineString *> *) rings{
    self = [super init];
    if(self != nil){
        NSMutableArray<SFEvent *> *buildEvents = [NSMutableArray array];
        for(int i = 0; i < rings.count; i++){
            SFLineString *ring = [rings objectAtIndex:i];
            [self addRing:ring withIndex:i toEvents:buildEvents];
        }
        self.events = [SFEvent sort:buildEvents];
    }
    return self;
}

-(void) addRing: (SFLineString *) ring withIndex: (int) ringIndex toEvents: (NSMutableArray<SFEvent *> *) events{
    
    NSArray *points = ring.points;
    
    for (int i = 0; i < points.count; i++) {
        
        SFPoint *point1 = [points objectAtIndex:i];
        SFPoint *point2 = [points objectAtIndex:(i + 1) % points.count];
        
        enum SFEventType type1 = SF_ET_RIGHT;
        enum SFEventType type2 = SF_ET_LEFT;
        if([SFSweepLine xyOrderWithPoint:point1 andPoint:point2] == NSOrderedAscending){
            type1 = SF_ET_LEFT;
            type2 = SF_ET_RIGHT;
        }
        
        SFEvent *endpoint1 =  [[SFEvent alloc] initWithEdge:i andRing:ringIndex andPoint:point1 andType:type1];
        SFEvent *endpoint2 =  [[SFEvent alloc] initWithEdge:i andRing:ringIndex andPoint:point2 andType:type2];
        
        [events addObject:endpoint1];
        [events addObject:endpoint2];

    }
    
}

-(NSArray<SFEvent *> *) events{
    return _events;
}

@end
