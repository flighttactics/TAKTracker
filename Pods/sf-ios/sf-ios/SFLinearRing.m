//
//  SFLinearRing.m
//  sf-ios
//
//  Created by Brian Osborn on 4/25/18.
//  Copyright © 2018 NGA. All rights reserved.
//

#import "SFLinearRing.h"
#import "SFGeometryUtils.h"

@implementation SFLinearRing

+(SFLinearRing *) linearRing{
    return [[SFLinearRing alloc] init];
}

+(SFLinearRing *) linearRingWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [[SFLinearRing alloc] initWithHasZ:hasZ andHasM:hasM];
}

+(SFLinearRing *) linearRingWithPoints: (NSMutableArray<SFPoint *> *) points{
    return [[SFLinearRing alloc] initWithPoints:points];
}

+(SFLinearRing *) linearRingWithLinearRing: (SFLinearRing *) linearRing{
    return [[SFLinearRing alloc] initWithLinearRing:linearRing];
}

-(instancetype) init{
    self = [self initWithHasZ:false andHasM:false];
    return self;
}

-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [super initWithHasZ:hasZ andHasM:hasM];
}

-(instancetype) initWithPoints: (NSMutableArray<SFPoint *> *) points{
    self = [self initWithHasZ:[SFGeometryUtils hasZ:points] andHasM:[SFGeometryUtils hasM:points]];
    if(self != nil){
        [self setPoints:points];
    }
    return self;
}

-(instancetype) initWithLinearRing: (SFLinearRing *) linearRing{
    self = [self initWithHasZ:linearRing.hasZ andHasM:linearRing.hasM];
    if(self != nil){
        for(SFPoint *point in linearRing.points){
            [self addPoint:[point mutableCopy]];
        }
    }
    return self;
}

-(void) setPoints:(NSMutableArray<SFPoint *> *)points{
    [super setPoints:points];
    if(![self isEmpty]){
        if(![self isClosed]){
            [self addPoint:[points objectAtIndex:0]];
        }
        if([self numPoints] < 4){
            [NSException raise:@"Invalid Linear Ring" format:@"A closed linear ring must have at least four points."];
        }
    }
}

-(id) mutableCopyWithZone: (NSZone *) zone{
    return [SFLinearRing linearRingWithLinearRing:self];
}

@end
