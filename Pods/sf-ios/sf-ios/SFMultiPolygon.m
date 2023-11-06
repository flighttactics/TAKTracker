//
//  SFMultiPolygon.m
//  sf-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "SFMultiPolygon.h"
#import "SFGeometryUtils.h"

@implementation SFMultiPolygon

+(SFMultiPolygon *) multiPolygon{
    return [[SFMultiPolygon alloc] init];
}

+(SFMultiPolygon *) multiPolygonWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [[SFMultiPolygon alloc] initWithHasZ:hasZ andHasM:hasM];
}

+(SFMultiPolygon *) multiPolygonWithPolygons: (NSMutableArray<SFPolygon *> *) polygons{
    return [[SFMultiPolygon alloc] initWithPolygons:polygons];
}

+(SFMultiPolygon *) multiPolygonWithPolygon: (SFPolygon *) polygon{
    return [[SFMultiPolygon alloc] initWithPolygon:polygon];
}

+(SFMultiPolygon *) multiPolygonWithMultiPolygon: (SFMultiPolygon *) multiPolygon{
    return [[SFMultiPolygon alloc] initWithMultiPolygon:multiPolygon];
}

-(instancetype) init{
    self = [self initWithHasZ:false andHasM:false];
    return self;
}

-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    self = [super initWithType:SF_MULTIPOLYGON andHasZ:hasZ andHasM:hasM];
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

-(instancetype) initWithMultiPolygon: (SFMultiPolygon *) multiPolygon{
    self = [self initWithHasZ:multiPolygon.hasZ andHasM:multiPolygon.hasM];
    if(self != nil){
        for(SFPolygon *polygon in multiPolygon.geometries){
            [multiPolygon addPolygon:[polygon mutableCopy]];
        }
    }
    return self;
}

-(NSMutableArray<SFPolygon *> *) polygons{
    return (NSMutableArray<SFPolygon *> *)[self surfaces];
}

-(void) setPolygons: (NSMutableArray<SFPolygon *> *) polygons{
    [self setSurfaces:(NSMutableArray<SFSurface *> *)polygons];
}

-(void) addPolygon: (SFPolygon *) polygon{
    [self addSurface:polygon];
}

-(void) addPolygons: (NSArray<SFPolygon *> *) polygons{
    [self addSurfaces:polygons];
}

-(int) numPolygons{
    return [self numSurfaces];
}

-(SFPolygon *) polygonAtIndex: (int) n{
    return (SFPolygon *)[self surfaceAtIndex:n];
}

-(id) mutableCopyWithZone: (NSZone *) zone{
    return [SFMultiPolygon multiPolygonWithMultiPolygon:self];
}

@end
