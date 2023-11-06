//
//  SFCurvePolygon.m
//  sf-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "SFCurvePolygon.h"
#import "SFGeometryUtils.h"

@implementation SFCurvePolygon

+(SFCurvePolygon *) curvePolygon{
    return [[SFCurvePolygon alloc] init];
}

+(SFCurvePolygon *) curvePolygonWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [[SFCurvePolygon alloc] initWithHasZ:hasZ andHasM:hasM];
}

+(SFCurvePolygon *) curvePolygonWithRings: (NSMutableArray<SFCurve *> *) rings{
    return [[SFCurvePolygon alloc] initWithRings:rings];
}

+(SFCurvePolygon *) curvePolygonWithRing: (SFCurve *) ring{
    return [[SFCurvePolygon alloc] initWithRing:ring];
}

+(SFCurvePolygon *) curvePolygonWithCurvePolygon: (SFCurvePolygon *) curvePolygon{
    return [[SFCurvePolygon alloc] initWithCurvePolygon:curvePolygon];
}

-(instancetype) init{
    self = [self initWithHasZ:false andHasM:false];
    return self;
}

-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self initWithType:SF_CURVEPOLYGON andHasZ:hasZ andHasM:hasM];
}

-(instancetype) initWithRings: (NSMutableArray<SFCurve *> *) rings{
    self = [self initWithHasZ:[SFGeometryUtils hasZ:rings] andHasM:[SFGeometryUtils hasM:rings]];
    if(self != nil){
        [self setRings:rings];
    }
    return self;
}

-(instancetype) initWithRing: (SFCurve *) ring{
    self = [self initWithHasZ:ring.hasZ andHasM:ring.hasM];
    if(self != nil){
        [self addRing:ring];
    }
    return self;
}

-(instancetype) initWithType: (enum SFGeometryType) geometryType andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    self = [super initWithType:geometryType andHasZ:hasZ andHasM:hasM];
    if(self != nil){
        self.rings = [NSMutableArray array];
    }
    return self;
}

-(instancetype) initWithCurvePolygon: (SFCurvePolygon *) curvePolygon{
    self = [self initWithHasZ:curvePolygon.hasZ andHasM:curvePolygon.hasM];
    if(self != nil){
        for(SFCurve *ring in curvePolygon.rings){
            [self addRing:[ring mutableCopy]];
        }
    }
    return self;
}

-(void) addRing: (SFCurve *) ring{
    [self.rings addObject:ring];
    [self updateZM:ring];
}

-(void) addRings: (NSArray<SFCurve *> *) rings{
    for(SFCurve *ring in rings){
        [self addRing:ring];
    }
}

-(int) numRings{
    return (int) self.rings.count;
}

-(SFCurve *) ringAtIndex: (int) n{
    return [self.rings objectAtIndex:n];
}

-(SFCurve *) exteriorRing{
    return [self.rings objectAtIndex:0];
}

-(int) numInteriorRings{
    return (int)self.rings.count - 1;
}

-(SFCurve *) interiorRingAtIndex: (int) n{
    return [self.rings objectAtIndex:n + 1];
}

-(BOOL) isEmpty{
    return self.rings.count == 0;
}

-(BOOL) isSimple{
    [NSException raise:@"Unsupported" format:@"Is Simple not implemented for Curve Polygon"];
    return NO;
}

-(id) mutableCopyWithZone: (NSZone *) zone{
    return [SFCurvePolygon curvePolygonWithCurvePolygon:self];
}

+ (BOOL) supportsSecureCoding {
    return YES;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    [super encodeWithCoder:encoder];
    
    [encoder encodeObject:self.rings forKey:@"rings"];
}

- (id) initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        _rings = [decoder decodeObjectOfClasses:[NSSet setWithObjects:[NSMutableArray class], [SFCurve class], nil] forKey:@"rings"];
    }
    return self;
}

- (BOOL)isEqualToCurvePolygon:(SFCurvePolygon *)curvePolygon {
    if (self == curvePolygon)
        return YES;
    if (curvePolygon == nil)
        return NO;
    if (![super isEqual:curvePolygon])
        return NO;
    if (self.rings == nil) {
        if (curvePolygon.rings != nil)
            return NO;
    } else if (![self.rings isEqual:curvePolygon.rings])
        return NO;
    return YES;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[SFCurvePolygon class]]) {
        return NO;
    }
    
    return [self isEqualToCurvePolygon:(SFCurvePolygon *)object];
}

- (NSUInteger)hash {
    NSUInteger prime = 31;
    NSUInteger result = [super hash];
    result = prime * result
        + ((self.rings == nil) ? 0 : [self.rings hash]);
    return result;
}

@end
