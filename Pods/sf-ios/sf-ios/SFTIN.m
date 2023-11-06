//
//  SFTIN.m
//  sf-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "SFTIN.h"
#import "SFGeometryUtils.h"

@implementation SFTIN

+(SFTIN *) tin{
    return [[SFTIN alloc] init];
}

+(SFTIN *) tinWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [[SFTIN alloc] initWithHasZ:hasZ andHasM:hasM];
}

+(SFTIN *) tinWithPolygons: (NSMutableArray<SFPolygon *> *) polygons{
    return [[SFTIN alloc] initWithPolygons:polygons];
}

+(SFTIN *) tinWithPolygon: (SFPolygon *) polygon{
    return [[SFTIN alloc] initWithPolygon:polygon];
}

+(SFTIN *) tinWithTIN: (SFTIN *) tin{
    return [[SFTIN alloc] initWithTIN:tin];
}

-(instancetype) init{
    self = [self initWithHasZ:false andHasM:false];
    return self;
}

-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    self = [super initWithType:SF_TIN andHasZ:hasZ andHasM:hasM];
    return self;
}

-(instancetype) initWithPolygons: (NSMutableArray<SFPolygon *> *) polygons{
    self = [self initWithHasZ:[SFGeometryUtils hasZ:polygons] andHasM:[SFGeometryUtils hasM:polygons]];
    if(self != nil){
        [self setPolygons:polygons];
    }
    return self;
}

-(instancetype) initWithPolygon: (SFPolygon *) polygon{
    self = [self initWithHasZ:polygon.hasZ andHasM:polygon.hasM];
    if(self != nil){
        [self addPolygon:polygon];
    }
    return self;
}

-(instancetype) initWithTIN: (SFTIN *) tin{
    self = [self initWithHasZ:tin.hasZ andHasM:tin.hasM];
    if(self != nil){
        for(SFPolygon *polygon in tin.polygons){
            [self addPolygon:[polygon mutableCopy]];
        }
    }
    return self;
}

-(id) mutableCopyWithZone: (NSZone *) zone{
    return [SFTIN tinWithTIN:self];
}

@end
