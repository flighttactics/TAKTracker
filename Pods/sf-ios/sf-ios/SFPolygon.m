//
//  SFPolygon.m
//  sf-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "SFPolygon.h"
#import "SFShamosHoey.h"
#import "SFGeometryUtils.h"

@implementation SFPolygon

+(SFPolygon *) polygon{
    return [[SFPolygon alloc] init];
}

+(SFPolygon *) polygonWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [[SFPolygon alloc] initWithHasZ:hasZ andHasM:hasM];
}

+(SFPolygon *) polygonWithRings: (NSMutableArray<SFLineString *> *) rings{
    return [[SFPolygon alloc] initWithRings:rings];
}

+(SFPolygon *) polygonWithRing: (SFLineString *) ring{
    return [[SFPolygon alloc] initWithRing:ring];
}

+(SFPolygon *) polygonWithPolygon: (SFPolygon *) polygon{
    return [[SFPolygon alloc] initWithPolygon:polygon];
}

-(instancetype) init{
    self = [self initWithHasZ:false andHasM:false];
    return self;
}

-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self initWithType:SF_POLYGON andHasZ:hasZ andHasM:hasM];
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

-(instancetype) initWithType: (enum SFGeometryType) geometryType andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    self = [super initWithType:geometryType andHasZ:hasZ andHasM:hasM];
    return self;
}

-(instancetype) initWithPolygon: (SFPolygon *) polygon{
    self = [self initWithHasZ:polygon.hasZ andHasM:polygon.hasM];
    if(self != nil){
        for(SFLineString *ring in polygon.rings){
            [self addRing:[ring mutableCopy]];
        }
    }
    return self;
}

-(NSMutableArray<SFLineString *> *) lineStrings{
    return (NSMutableArray<SFLineString *> *) self.rings;
}

-(void) setRings: (NSMutableArray<SFLineString *> *) rings{
    [super setRings:(NSMutableArray<SFCurve *> *)rings];
}

-(SFLineString *) ringAtIndex: (int) n{
    return (SFLineString *)[super ringAtIndex:n];
}

-(SFLineString *) exteriorRing{
    return (SFLineString *)[super exteriorRing];
}

-(SFLineString *) interiorRingAtIndex: (int) n{
    return (SFLineString *)[super interiorRingAtIndex:n];
}

-(BOOL) isSimple{
    return [SFShamosHoey simplePolygon:self];
}

-(id) mutableCopyWithZone: (NSZone *) zone{
    return [SFPolygon polygonWithPolygon:self];
}

@end
