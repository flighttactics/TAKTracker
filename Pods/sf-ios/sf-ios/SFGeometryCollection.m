//
//  SFGeometryCollection.m
//  sf-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "SFGeometryUtils.h"
#import "SFMultiLineString.h"
#import "SFMultiPolygon.h"

@implementation SFGeometryCollection

+(SFGeometryCollection *) geometryCollection{
    return [[SFGeometryCollection alloc] init];
}

+(SFGeometryCollection *) geometryCollectionWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [[SFGeometryCollection alloc] initWithHasZ:hasZ andHasM:hasM];
}

+(SFGeometryCollection *) geometryCollectionWithGeometries: (NSMutableArray<SFGeometry *> *) geometries{
    return [[SFGeometryCollection alloc] initWithGeometries:geometries];
}

+(SFGeometryCollection *) geometryCollectionWithGeometry: (SFGeometry *) geometry{
    return [[SFGeometryCollection alloc] initWithGeometry:geometry];
}

+(SFGeometryCollection *) geometryCollectionWithGeometryCollection: (SFGeometryCollection *) geometryCollection{
    return [[SFGeometryCollection alloc] initWithGeometryCollection:geometryCollection];
}

-(instancetype) init{
    self = [self initWithHasZ:false andHasM:false];
    return self;
}

-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self initWithType:SF_GEOMETRYCOLLECTION andHasZ:hasZ andHasM:hasM];
}

-(instancetype) initWithGeometries: (NSMutableArray<SFGeometry *> *) geometries{
    self = [self initWithHasZ:[SFGeometryUtils hasZ:geometries] andHasM:[SFGeometryUtils hasM:geometries]];
    if(self != nil){
        [self setGeometries:geometries];
    }
    return self;
}

-(instancetype) initWithGeometry: (SFGeometry *) geometry{
    self = [self initWithHasZ:geometry.hasZ andHasM:geometry.hasM];
    if(self != nil){
        [self addGeometry:geometry];
    }
    return self;
}

-(instancetype) initWithType: (enum SFGeometryType) geometryType andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    self = [super initWithType:geometryType andHasZ:hasZ andHasM:hasM];
    if(self != nil){
        self.geometries = [NSMutableArray array];
    }
    return self;
}

-(instancetype) initWithGeometryCollection: (SFGeometryCollection *) geometryCollection{
    self = [self initWithHasZ:geometryCollection.hasZ andHasM:geometryCollection.hasM];
    if(self != nil){
        for(SFGeometry *geometry in geometryCollection.geometries){
            [self addGeometry:[geometry mutableCopy]];
        }
    }
    return self;
}

-(void) addGeometry: (SFGeometry *) geometry{
    [self.geometries addObject:geometry];
    [self updateZM:geometry];
}

-(void) addGeometries: (NSArray<SFGeometry *> *) geometries{
    for(SFGeometry *geometry in geometries){
        [self addGeometry:geometry];
    }
}

-(int) numGeometries{
    return (int)self.geometries.count;
}

-(SFGeometry *) geometryAtIndex: (int)  n{
    return [self.geometries objectAtIndex:n];
}

-(enum SFGeometryType) collectionType{
    
    enum SFGeometryType geometryType = [self geometryType];
    
    switch (geometryType) {
        case SF_MULTIPOINT:
        case SF_MULTILINESTRING:
        case SF_MULTIPOLYGON:
            break;
        case SF_GEOMETRYCOLLECTION:
        case SF_MULTICURVE:
        case SF_MULTISURFACE:
            if([self isMultiPoint]){
                geometryType = SF_MULTIPOINT;
            }else if([self isMultiLineString]){
                geometryType = SF_MULTILINESTRING;
            }else if([self isMultiPolygon]){
                geometryType = SF_MULTIPOLYGON;
            }else if([self isMultiCurve]){
                geometryType = SF_MULTICURVE;
            }else if([self isMultiSurface]){
                geometryType = SF_MULTISURFACE;
            }
            break;
        default:
            [NSException raise:@"Unexpected" format:@"Unexpected Geometry Collection Type: %u", geometryType];
    }
    
    return geometryType;
}

-(BOOL) isMultiPoint{
    BOOL isMultiPoint = [self isKindOfClass:[SFMultiPoint class]];
    if (!isMultiPoint) {
        isMultiPoint = [self isCollectionOfType:[SFPoint class]];
    }
    return isMultiPoint;
}

-(SFMultiPoint *) asMultiPoint{
    SFMultiPoint *multiPoint;
    if([self isKindOfClass:[SFMultiPoint class]]){
        multiPoint = (SFMultiPoint *) self;
    }else{
        multiPoint = [SFMultiPoint multiPointWithPoints:(NSMutableArray<SFPoint *> *)self.geometries];
    }
    return multiPoint;
}

-(BOOL) isMultiLineString{
    BOOL isMultiLineString = [self isKindOfClass:[SFMultiLineString class]];
    if (!isMultiLineString) {
        isMultiLineString = [self isCollectionOfType:[SFLineString class]];
    }
    return isMultiLineString;
}

-(SFMultiLineString *) asMultiLineString{
    SFMultiLineString *multiLineString;
    if([self isKindOfClass:[SFMultiLineString class]]){
        multiLineString = (SFMultiLineString*) self;
    }else{
        multiLineString = [SFMultiLineString multiLineStringWithLineStrings:(NSMutableArray<SFLineString *> *)self.geometries];
    }
    return multiLineString;
}

-(BOOL) isMultiPolygon{
    BOOL isMultiPolygon = [self isKindOfClass:[SFMultiPolygon class]];
    if (!isMultiPolygon) {
        isMultiPolygon = [self isCollectionOfType:[SFPolygon class]];
    }
    return isMultiPolygon;
}

-(SFMultiPolygon *) asMultiPolygon{
    SFMultiPolygon *multiPolygon;
    if([self isKindOfClass:[SFMultiPolygon class]]){
        multiPolygon = (SFMultiPolygon*) self;
    }else{
        multiPolygon = [SFMultiPolygon multiPolygonWithPolygons:(NSMutableArray<SFPolygon *> *)self.geometries];
    }
    return multiPolygon;
}

-(BOOL) isMultiCurve{
    BOOL isMultiCurve = [self isKindOfClass:[SFMultiLineString class]];
    if (!isMultiCurve) {
        isMultiCurve = [self isCollectionOfType:[SFCurve class]];
    }
    return isMultiCurve;
}

-(SFGeometryCollection *) asMultiCurve{
    SFGeometryCollection *multiCurve;
    if ([self isKindOfClass:[SFMultiLineString class]]) {
        multiCurve = [SFGeometryCollection geometryCollectionWithGeometries:self.geometries];
    } else {
        multiCurve = self;
    }
    return multiCurve;
}

-(BOOL) isMultiSurface{
    BOOL isMultiSurface = [self isKindOfClass:[SFMultiPolygon class]];
    if (!isMultiSurface) {
        isMultiSurface = [self isCollectionOfType:[SFSurface class]];
    }
    return isMultiSurface;
}

-(SFGeometryCollection *) asMultiSurface{
    SFGeometryCollection *multiSurface;
    if ([self isKindOfClass:[SFMultiPolygon class]]) {
        multiSurface = [SFGeometryCollection geometryCollectionWithGeometries:self.geometries];
    } else {
        multiSurface = self;
    }
    return multiSurface;
}

-(SFGeometryCollection *) asGeometryCollection{
    SFGeometryCollection *geometryCollection;
    if([[self class] isMemberOfClass:[SFGeometryCollection class]]){
        geometryCollection = self;
    } else {
        geometryCollection = [SFGeometryCollection geometryCollectionWithGeometries:self.geometries];
    }
    return geometryCollection;
}

-(BOOL) isCollectionOfType: (Class) type{
    
    BOOL isType = YES;
    
    for(SFGeometry *geometry in self.geometries){
        if(![geometry isKindOfClass:type]){
            isType = NO;
            break;
        }
    }
    
    return isType;
}

-(BOOL) isEmpty{
    return self.geometries.count == 0;
}

-(BOOL) isSimple{
    [NSException raise:@"Unsupported" format:@"Is Simple not implemented for Geometry Collection"];
    return NO;
}

-(id) mutableCopyWithZone: (NSZone *) zone{
    return [SFGeometryCollection geometryCollectionWithGeometryCollection:self];
}

+ (BOOL) supportsSecureCoding {
    return YES;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    [super encodeWithCoder:encoder];
    
    [encoder encodeObject:self.geometries forKey:@"geometries"];
}

- (id) initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        _geometries = [decoder decodeObjectOfClasses:[NSSet setWithObjects:[NSMutableArray class], [SFGeometry class], nil] forKey:@"geometries"];
    }
    return self;
}

- (BOOL)isEqualToGeometryCollection:(SFGeometryCollection *)geometryCollection {
    if (self == geometryCollection)
        return YES;
    if (geometryCollection == nil)
        return NO;
    if (![super isEqual:geometryCollection])
        return NO;
    if (self.geometries == nil) {
        if (geometryCollection.geometries != nil)
            return NO;
    } else if (![self.geometries isEqual:geometryCollection.geometries])
        return NO;
    return YES;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[SFGeometryCollection class]]) {
        return NO;
    }
    
    return [self isEqualToGeometryCollection:(SFGeometryCollection *)object];
}

- (NSUInteger)hash {
    NSUInteger prime = 31;
    NSUInteger result = [super hash];
    result = prime * result
        + ((self.geometries == nil) ? 0 : [self.geometries hash]);
    return result;
}

@end
