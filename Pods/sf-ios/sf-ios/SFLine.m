//
//  SFLine.m
//  sf-ios
//
//  Created by Brian Osborn on 4/25/18.
//  Copyright © 2018 NGA. All rights reserved.
//

#import "SFLine.h"
#import "SFGeometryUtils.h"

@implementation SFLine

+(SFLine *) line{
    return [[SFLine alloc] init];
}

+(SFLine *) lineWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [[SFLine alloc] initWithHasZ:hasZ andHasM:hasM];
}

+(SFLine *) lineWithPoints: (NSMutableArray<SFPoint *> *) points{
    return [[SFLine alloc] initWithPoints:points];
}

+(SFLine *) lineWithPoint1: (SFPoint *) point1 andPoint2: (SFPoint *) point2{
    return [[SFLine alloc] initWithPoint1:point1 andPoint2:point2];
}

+(SFLine *) lineWithLine: (SFLine *) line{
    return [[SFLine alloc] initWithLine:line];
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

-(instancetype) initWithPoint1: (SFPoint *) point1 andPoint2: (SFPoint *) point2{
    self = [self initWithHasZ:point1.hasZ || point2.hasZ andHasM:point1.hasM || point2.hasM];
    if(self != nil){
        [self addPoint:point1];
        [self addPoint:point2];
    }
    return self;
}

-(instancetype) initWithLine: (SFLine *) line{
    self = [self initWithHasZ:line.hasZ andHasM:line.hasM];
    if(self != nil){
        for(SFPoint *point in line.points){
            [self addPoint:[point mutableCopy]];
        }
    }
    return self;
}

-(void) setPoints:(NSMutableArray<SFPoint *> *)points{
    [super setPoints:points];
    if(![self isEmpty] && [self numPoints] != 2){
        [NSException raise:@"Invalid Line" format:@"A line must have exactly 2 points."];
    }
}

-(id) mutableCopyWithZone: (NSZone *) zone{
    return [SFLine lineWithLine:self];
}

@end
