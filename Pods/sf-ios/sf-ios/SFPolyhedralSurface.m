//
//  SFPolyhedralSurface.m
//  sf-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "SFPolyhedralSurface.h"
#import "SFGeometryUtils.h"

@implementation SFPolyhedralSurface

+(SFPolyhedralSurface *) polyhedralSurface{
    return [[SFPolyhedralSurface alloc] init];
}

+(SFPolyhedralSurface *) polyhedralSurfaceWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [[SFPolyhedralSurface alloc] initWithHasZ:hasZ andHasM:hasM];
}

+(SFPolyhedralSurface *) polyhedralSurfaceWithPolygons: (NSMutableArray<SFPolygon *> *) polygons{
    return [[SFPolyhedralSurface alloc] initWithPolygons:polygons];
}

+(SFPolyhedralSurface *) polyhedralSurfaceWithPolygon: (SFPolygon *) polygon{
    return [[SFPolyhedralSurface alloc] initWithPolygon:polygon];
}

+(SFPolyhedralSurface *) polyhedralSurfaceWithPolyhedralSurface: (SFPolyhedralSurface *) polyhedralSurface{
    return [[SFPolyhedralSurface alloc] initWithPolyhedralSurface:polyhedralSurface];
}

-(instancetype) init{
    self = [self initWithHasZ:false andHasM:false];
    return self;
}

-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self initWithType:SF_POLYHEDRALSURFACE andHasZ:hasZ andHasM:hasM];
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

-(instancetype) initWithType: (enum SFGeometryType) geometryType andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    self = [super initWithType:geometryType andHasZ:hasZ andHasM:hasM];
    if(self != nil){
        self.polygons = [NSMutableArray array];
    }
    return self;
}

-(instancetype) initWithPolyhedralSurface: (SFPolyhedralSurface *) polyhedralSurface{
    self = [self initWithHasZ:polyhedralSurface.hasZ andHasM:polyhedralSurface.hasM];
    if(self != nil){
        for(SFPolygon *polygon in polyhedralSurface.polygons){
            [self addPolygon:[polygon mutableCopy]];
        }
    }
    return self;
}

-(NSMutableArray<SFPolygon *> *) patches{
    return [self polygons];
}

-(void) setPatches: (NSMutableArray<SFPolygon *> *) patches{
    [self setPolygons:patches];
}

-(void) addPolygon: (SFPolygon *) polygon{
    [self.polygons addObject:polygon];
    [self updateZM:polygon];
}

-(void) addPatch: (SFPolygon *) patch{
    [self addPolygon:patch];
}

-(void) addPolygons: (NSArray<SFPolygon *> *) polygons{
    for(SFPolygon *polygon in polygons){
        [self addPolygon:polygon];
    }
}

-(void) addPatches: (NSArray<SFPolygon *> *) patches{
    [self addPolygons:patches];
}

-(int) numPolygons{
    return (int)self.polygons.count;
}

-(int) numPatches{
    return [self numPolygons];
}

-(SFPolygon *) polygonAtIndex: (int) n{
    return [self.polygons objectAtIndex:n];
}

-(SFPolygon *) patchAtIndex: (int) n{
    return [self polygonAtIndex:n];
}

-(BOOL) isEmpty{
    return self.polygons.count == 0;
}

-(BOOL) isSimple{
    [NSException raise:@"Unsupported" format:@"Is Simple not implemented for Polyhedral Surface"];
    return NO;
}

-(id) mutableCopyWithZone: (NSZone *) zone{
    return [SFPolyhedralSurface polyhedralSurfaceWithPolyhedralSurface:self];
}

+ (BOOL) supportsSecureCoding {
    return YES;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    [super encodeWithCoder:encoder];
    
    [encoder encodeObject:self.polygons forKey:@"polygons"];
}

- (id) initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        _polygons = [decoder decodeObjectOfClasses:[NSSet setWithObjects:[NSMutableArray class], [SFPolygon class], nil] forKey:@"polygons"];
    }
    return self;
}

- (BOOL)isEqualToPolyhedralSurface:(SFPolyhedralSurface *)polyhedralSurface {
    if (self == polyhedralSurface)
        return YES;
    if (polyhedralSurface == nil)
        return NO;
    if (![super isEqual:polyhedralSurface])
        return NO;
    if (self.polygons == nil) {
        if (polyhedralSurface.polygons != nil)
            return NO;
    } else if (![self.polygons isEqual:polyhedralSurface.polygons])
        return NO;
    return YES;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[SFPolyhedralSurface class]]) {
        return NO;
    }
    
    return [self isEqualToPolyhedralSurface:(SFPolyhedralSurface *)object];
}

- (NSUInteger)hash {
    NSUInteger prime = 31;
    NSUInteger result = [super hash];
    result = prime * result
        + ((self.polygons == nil) ? 0 : [self.polygons hash]);
    return result;
}

@end
