//
//  SFTriangle.m
//  sf-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "SFTriangle.h"
#import "SFGeometryUtils.h"

@implementation SFTriangle

+(SFTriangle *) triangle{
    return [[SFTriangle alloc] init];
}

+(SFTriangle *) triangleWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [[SFTriangle alloc] initWithHasZ:hasZ andHasM:hasM];
}

+(SFTriangle *) triangleWithRings: (NSMutableArray<SFLineString *> *) rings{
    return [[SFTriangle alloc] initWithRings:rings];
}

+(SFTriangle *) triangleWithRing: (SFLineString *) ring{
    return [[SFTriangle alloc] initWithRing:ring];
}

+(SFTriangle *) triangleWithTriangle: (SFTriangle *) triangle{
    return [[SFTriangle alloc] initWithTriangle:triangle];
}

-(instancetype) init{
    self = [self initWithHasZ:false andHasM:false];
    return self;
}

-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    self = [super initWithType:SF_TRIANGLE andHasZ:hasZ andHasM:hasM];
    return self;
}

-(instancetype) initWithRings: (NSMutableArray<SFLineString *> *) rings{
    self = [self initWithHasZ:[SFGeometryUtils hasZ:rings] andHasM:[SFGeometryUtils hasM:rings]];
    if(self != nil){
        [self setRings:rings];
    }
    return self;
}

-(instancetype) initWithRing: (SFLineString *) ring{
    self = [self initWithHasZ:ring.hasZ andHasM:ring.hasM];
    if(self != nil){
        [self addRing:ring];
    }
    return self;
}

-(instancetype) initWithTriangle: (SFTriangle *) triangle{
    self = [self initWithHasZ:triangle.hasZ andHasM:triangle.hasM];
    if(self != nil){
        for(SFLineString *ring in triangle.rings){
            [self addRing:[ring mutableCopy]];
        }
    }
    return self;
}

-(id) mutableCopyWithZone: (NSZone *) zone{
    return [SFTriangle triangleWithTriangle:self];
}

@end
