//
//  SFMultiPoint.m
//  sf-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "SFMultiPoint.h"
#import "SFGeometryUtils.h"

@implementation SFMultiPoint

+(SFMultiPoint *) multiPoint{
    return [[SFMultiPoint alloc] init];
}

+(SFMultiPoint *) multiPointWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [[SFMultiPoint alloc] initWithHasZ:hasZ andHasM:hasM];
}

+(SFMultiPoint *) multiPointWithPoints: (NSMutableArray<SFPoint *> *) points{
    return [[SFMultiPoint alloc] initWithPoints:points];
}

+(SFMultiPoint *) multiPointWithPoint: (SFPoint *) point{
    return [[SFMultiPoint alloc] initWithPoint:point];
}

+(SFMultiPoint *) multiPointWithMultiPoint: (SFMultiPoint *) multiPoint{
    return [[SFMultiPoint alloc] initWithMultiPoint:multiPoint];
}

-(instancetype) init{
    self = [self initWithHasZ:false andHasM:false];
    return self;
}

-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    self = [super initWithType:SF_MULTIPOINT andHasZ:hasZ andHasM:hasM];
    return self;
}

-(instancetype) initWithPoints: (NSMutableArray<SFPoint *> *) points{
    self = [self initWithHasZ:[SFGeometryUtils hasZ:points] andHasM:[SFGeometryUtils hasM:points]];
    if(self != nil){
        [self setPoints:points];
    }
    return self;
}

-(instancetype) initWithPoint: (SFPoint *) point{
    self = [self initWithHasZ:point.hasZ andHasM:point.hasM];
    if(self != nil){
        [self addPoint:point];
    }
    return self;
}

-(instancetype) initWithMultiPoint: (SFMultiPoint *) multiPoint{
    self = [self initWithHasZ:multiPoint.hasZ andHasM:multiPoint.hasM];
    if(self != nil){
        for(SFPoint *point in multiPoint.geometries){
            [self addPoint:[point mutableCopy]];
        }
    }
    return self;
}

-(NSMutableArray<SFPoint *> *) points{
    return (NSMutableArray<SFPoint *> *)[self geometries];
}

-(void) setPoints: (NSMutableArray<SFPoint *> *) points{
    [self setGeometries:(NSMutableArray<SFGeometry *> *)points];
}

-(void) addPoint: (SFPoint *) point{
    [self addGeometry:point];
}

-(void) addPoints: (NSArray<SFPoint *> *) points{
    [self addGeometries:points];
}

-(int) numPoints{
    return [self numGeometries];
}

-(SFPoint *) pointAtIndex: (int) n{
    return (SFPoint *)[self geometryAtIndex:n];
}

-(BOOL) isSimple{
    NSSet<SFPoint *> *points = [NSSet setWithArray:[self points]];
    return points.count == [self numPoints];
}

-(id) mutableCopyWithZone: (NSZone *) zone{
    return [SFMultiPoint multiPointWithMultiPoint:self];
}

@end
