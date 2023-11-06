//
//  SFExtendedGeometryCollection.m
//  sf-ios
//
//  Created by Brian Osborn on 4/25/18.
//  Copyright © 2018 NGA. All rights reserved.
//

#import "SFExtendedGeometryCollection.h"

@interface SFExtendedGeometryCollection()

/**
 * Extended geometry collection geometry type
 */
@property (nonatomic) enum SFGeometryType extendedGeometryType;

@end

@implementation SFExtendedGeometryCollection

+(SFExtendedGeometryCollection *) extendedGeometryCollectionWithGeometryCollection: (SFGeometryCollection *) geometryCollection{
    return [[SFExtendedGeometryCollection alloc] initWithGeometryCollection:geometryCollection];
}

+(SFExtendedGeometryCollection *) extendedGeometryCollectionWithExtendedGeometryCollection: (SFExtendedGeometryCollection *) extendedGeometryCollection{
    return [[SFExtendedGeometryCollection alloc] initWithExtendedGeometryCollection:extendedGeometryCollection];
}

-(instancetype) initWithGeometryCollection: (SFGeometryCollection *) geometryCollection{
    self = [super initWithType:SF_GEOMETRYCOLLECTION andHasZ:geometryCollection.hasZ andHasM:geometryCollection.hasM];
    if(self != nil){
        [self setGeometries:geometryCollection.geometries];
        self.extendedGeometryType = SF_GEOMETRYCOLLECTION;
        [self updateGeometryType];
    }
    return self;
}

-(instancetype) initWithExtendedGeometryCollection: (SFExtendedGeometryCollection *) extendedGeometryCollection{
    SFGeometryCollection *geometryCollection = [SFGeometryCollection geometryCollectionWithHasZ:extendedGeometryCollection.hasZ andHasM:extendedGeometryCollection.hasM];
    for(SFGeometry *geometry in extendedGeometryCollection.geometries){
        [geometryCollection addGeometry:[geometry mutableCopy]];
    }
    self = [self initWithGeometryCollection:geometryCollection];
    return self;
}

-(void) updateGeometryType{
    enum SFGeometryType geometryType = [self collectionType];
    switch (geometryType) {
        case SF_GEOMETRYCOLLECTION:
        case SF_MULTICURVE:
        case SF_MULTISURFACE:
            break;
        case SF_MULTIPOINT:
            geometryType = SF_GEOMETRYCOLLECTION;
            break;
        case SF_MULTILINESTRING:
            geometryType = SF_MULTICURVE;
            break;
        case SF_MULTIPOLYGON:
            geometryType = SF_MULTISURFACE;
            break;
        default:
            [NSException raise:@"Unsupported" format:@"Unsupported extended geometry collection geometry type: %u", geometryType];
    }
    self.extendedGeometryType = geometryType;
}

-(enum SFGeometryType) geometryType{
    return self.extendedGeometryType;
}

-(id) mutableCopyWithZone: (NSZone *) zone{
    return [SFExtendedGeometryCollection extendedGeometryCollectionWithExtendedGeometryCollection:self];
}

+ (BOOL) supportsSecureCoding {
    return YES;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    [super encodeWithCoder:encoder];
    
    [encoder encodeInt:(int)self.extendedGeometryType forKey:@"extendedGeometryType"];
}

- (id) initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        _extendedGeometryType = (enum SFGeometryType)[decoder decodeIntForKey:@"extendedGeometryType"];
    }
    return self;
}

- (BOOL)isEqualToExtendedGeometryCollection:(SFExtendedGeometryCollection *)extendedGeometryCollection {
    if (self == extendedGeometryCollection)
        return YES;
    if (extendedGeometryCollection == nil)
        return NO;
    if (![super isEqual:extendedGeometryCollection])
        return NO;
    if (self.extendedGeometryType != extendedGeometryCollection.extendedGeometryType)
        return NO;
    return YES;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[SFExtendedGeometryCollection class]]) {
        return NO;
    }
    
    return [self isEqualToExtendedGeometryCollection:(SFExtendedGeometryCollection *)object];
}

- (NSUInteger)hash {
    NSUInteger prime = 31;
    NSUInteger result = [super hash];
    result = prime * result + (int)self.extendedGeometryType;
    return result;
}

@end
