//
//  SFGeometryEnvelope.m
//  sf-ios
//
//  Created by Brian Osborn on 6/1/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "SFGeometryEnvelope.h"
#import "SFLine.h"
#import "SFGeometryEnvelopeBuilder.h"

@implementation SFGeometryEnvelope

+(SFGeometryEnvelope *) envelope{
    return [[SFGeometryEnvelope alloc] init];
}

+(SFGeometryEnvelope *) envelopeWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [[SFGeometryEnvelope alloc] initWithHasZ:hasZ andHasM:hasM];
}

+(SFGeometryEnvelope *) envelopeWithMinX: (NSDecimalNumber *) minX
                     andMinY: (NSDecimalNumber *) minY
                     andMaxX: (NSDecimalNumber *) maxX
                     andMaxY: (NSDecimalNumber *) maxY{
    return [[SFGeometryEnvelope alloc] initWithMinX:minX andMinY:minY andMaxX:maxX andMaxY:maxY];
}

+(SFGeometryEnvelope *) envelopeWithMinXValue: (double) minX
                     andMinYValue: (double) minY
                     andMaxXValue: (double) maxX
                     andMaxYValue: (double) maxY{
    return [[SFGeometryEnvelope alloc] initWithMinXValue:minX andMinYValue:minY andMaxXValue:maxX andMaxYValue:maxY];
}

+(SFGeometryEnvelope *) envelopeWithMinX: (NSDecimalNumber *) minX
                     andMinY: (NSDecimalNumber *) minY
                     andMinZ: (NSDecimalNumber *) minZ
                     andMaxX: (NSDecimalNumber *) maxX
                     andMaxY: (NSDecimalNumber *) maxY
                     andMaxZ: (NSDecimalNumber *) maxZ{
    return [[SFGeometryEnvelope alloc] initWithMinX:minX andMinY:minY andMinZ:minZ andMaxX:maxX andMaxY:maxY andMaxZ:maxZ];
}

+(SFGeometryEnvelope *) envelopeWithMinXValue: (double) minX
                     andMinYValue: (double) minY
                     andMinZValue: (double) minZ
                     andMaxXValue: (double) maxX
                     andMaxYValue: (double) maxY
                     andMaxZValue: (double) maxZ{
    return [[SFGeometryEnvelope alloc] initWithMinXValue:minX andMinYValue:minY andMinZValue:minZ andMaxXValue:maxX andMaxYValue:maxY andMaxZValue:maxZ];
}

+(SFGeometryEnvelope *) envelopeWithMinX: (NSDecimalNumber *) minX
                     andMinY: (NSDecimalNumber *) minY
                     andMinZ: (NSDecimalNumber *) minZ
                     andMinM: (NSDecimalNumber *) minM
                     andMaxX: (NSDecimalNumber *) maxX
                     andMaxY: (NSDecimalNumber *) maxY
                     andMaxZ: (NSDecimalNumber *) maxZ
                     andMaxM: (NSDecimalNumber *) maxM{
    return [[SFGeometryEnvelope alloc] initWithMinX:minX andMinY:minY andMinZ:minZ andMinM:minM andMaxX:maxX andMaxY:maxY andMaxZ:maxZ andMaxM:maxM];
}

+(SFGeometryEnvelope *) envelopeWithMinXValue: (double) minX
                     andMinYValue: (double) minY
                     andMinZValue: (double) minZ
                     andMinMValue: (double) minM
                     andMaxXValue: (double) maxX
                     andMaxYValue: (double) maxY
                     andMaxZValue: (double) maxZ
                                 andMaxMValue: (double) maxM{
    return [[SFGeometryEnvelope alloc] initWithMinXValue:minX andMinYValue:minY andMinZValue:minZ andMinMValue:minM andMaxXValue:maxX andMaxYValue:maxY andMaxZValue:maxZ andMaxMValue:maxM];
}

+(SFGeometryEnvelope *) geometryEnvelopeWithGeometryEnvelope: (SFGeometryEnvelope *) geometryEnvelope{
    return [[SFGeometryEnvelope alloc] initWithGeometryEnvelope:geometryEnvelope];
}

-(instancetype) init{
    return [self initWithHasZ:false andHasM:false];
}

-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    self = [super init];
    if(self != nil){
        self.hasZ = hasZ;
        self.hasM = hasM;
    }
    return self;
}

-(instancetype) initWithMinX: (NSDecimalNumber *) minX
                     andMinY: (NSDecimalNumber *) minY
                     andMaxX: (NSDecimalNumber *) maxX
                     andMaxY: (NSDecimalNumber *) maxY{
    return [self initWithMinX:minX andMinY:minY andMinZ:nil andMinM:nil andMaxX:maxX andMaxY:maxY andMaxZ:nil andMaxM:nil];
}

-(instancetype) initWithMinXValue: (double) minX
                     andMinYValue: (double) minY
                     andMaxXValue: (double) maxX
                     andMaxYValue: (double) maxY{
    return [self initWithMinX:[[NSDecimalNumber alloc] initWithDouble:minX]
                       andMinY:[[NSDecimalNumber alloc] initWithDouble:minY]
                      andMaxX:[[NSDecimalNumber alloc] initWithDouble:maxX]
                       andMaxY:[[NSDecimalNumber alloc] initWithDouble:maxY]];
}

-(instancetype) initWithMinX: (NSDecimalNumber *) minX
                     andMinY: (NSDecimalNumber *) minY
                     andMinZ: (NSDecimalNumber *) minZ
                     andMaxX: (NSDecimalNumber *) maxX
                     andMaxY: (NSDecimalNumber *) maxY
                     andMaxZ: (NSDecimalNumber *) maxZ{
    return [self initWithMinX:minX andMinY:minY andMinZ:minZ andMinM:nil andMaxX:maxX andMaxY:maxY andMaxZ:maxZ andMaxM:nil];
}

-(instancetype) initWithMinXValue: (double) minX
                     andMinYValue: (double) minY
                     andMinZValue: (double) minZ
                     andMaxXValue: (double) maxX
                     andMaxYValue: (double) maxY
                     andMaxZValue: (double) maxZ{
    return [self initWithMinX:[[NSDecimalNumber alloc] initWithDouble:minX]
                       andMinY:[[NSDecimalNumber alloc] initWithDouble:minY]
                      andMinZ:[[NSDecimalNumber alloc] initWithDouble:minZ]
                      andMaxX:[[NSDecimalNumber alloc] initWithDouble:maxX]
                       andMaxY:[[NSDecimalNumber alloc] initWithDouble:maxY]
                      andMaxZ:[[NSDecimalNumber alloc] initWithDouble:maxZ]];
}

-(instancetype) initWithMinX: (NSDecimalNumber *) minX
                     andMinY: (NSDecimalNumber *) minY
                     andMinZ: (NSDecimalNumber *) minZ
                     andMinM: (NSDecimalNumber *) minM
                     andMaxX: (NSDecimalNumber *) maxX
                     andMaxY: (NSDecimalNumber *) maxY
                     andMaxZ: (NSDecimalNumber *) maxZ
                     andMaxM: (NSDecimalNumber *) maxM{
    self = [super init];
    if(self != nil){
        self.minX = minX;
        self.minY = minY;
        self.minZ = minZ;
        self.minM = minM;
        self.maxX = maxX;
        self.maxY = maxY;
        self.maxZ = maxZ;
        self.maxM = maxM;
        self.hasZ = minZ != nil || maxZ != nil;
        self.hasM = minM != nil || maxM != nil;
    }
    return self;
}

-(instancetype) initWithMinXValue: (double) minX
                     andMinYValue: (double) minY
                     andMinZValue: (double) minZ
                     andMinMValue: (double) minM
                     andMaxXValue: (double) maxX
                     andMaxYValue: (double) maxY
                     andMaxZValue: (double) maxZ
                     andMaxMValue: (double) maxM{
    return [self initWithMinX:[[NSDecimalNumber alloc] initWithDouble:minX]
                       andMinY:[[NSDecimalNumber alloc] initWithDouble:minY]
                      andMinZ:[[NSDecimalNumber alloc] initWithDouble:minZ]
                      andMinM:[[NSDecimalNumber alloc] initWithDouble:minM]
                      andMaxX:[[NSDecimalNumber alloc] initWithDouble:maxX]
                       andMaxY:[[NSDecimalNumber alloc] initWithDouble:maxY]
                      andMaxZ:[[NSDecimalNumber alloc] initWithDouble:maxZ]
                      andMaxM:[[NSDecimalNumber alloc] initWithDouble:maxM]];
}

-(instancetype) initWithGeometryEnvelope: (SFGeometryEnvelope *) geometryEnvelope{
    self = [self initWithMinX:geometryEnvelope.minX andMinY:geometryEnvelope.minY andMinZ:geometryEnvelope.minZ andMinM:geometryEnvelope.minM andMaxX:geometryEnvelope.maxX andMaxY:geometryEnvelope.maxY andMaxZ:geometryEnvelope.maxZ andMaxM:geometryEnvelope.maxM];
    return self;
}

-(void) setMinXValue: (double) x{
    [self setMinX:[[NSDecimalNumber alloc] initWithDouble:x]];
}

-(void) setMaxXValue: (double) x{
    [self setMaxX:[[NSDecimalNumber alloc] initWithDouble:x]];
}

-(void) setMinYValue: (double) y{
    [self setMinY:[[NSDecimalNumber alloc] initWithDouble:y]];
}

-(void) setMaxYValue: (double) y{
    [self setMaxY:[[NSDecimalNumber alloc] initWithDouble:y]];
}

-(void) setMinZValue: (double) z{
    [self setMinZ:[[NSDecimalNumber alloc] initWithDouble:z]];
}

-(void) setMaxZValue: (double) z{
    [self setMaxZ:[[NSDecimalNumber alloc] initWithDouble:z]];
}

-(void) setMinMValue: (double) m{
    [self setMinM:[[NSDecimalNumber alloc] initWithDouble:m]];
}

-(void) setMaxMValue: (double) m{
    [self setMaxM:[[NSDecimalNumber alloc] initWithDouble:m]];
}

-(BOOL) is3D{
    return _hasZ;
}

-(BOOL) isMeasured{
    return _hasM;
}

-(double) xRange{
    return [_maxX doubleValue] - [_minX doubleValue];
}

-(double) yRange{
    return [_maxY doubleValue] - [_minY doubleValue];
}

-(NSDecimalNumber *) zRange{
    NSDecimalNumber *range = nil;
    if(_minZ != nil && _maxZ != nil){
        range = [_maxZ decimalNumberBySubtracting:_minZ];
    }
    return range;
}

-(NSDecimalNumber *) mRange{
    NSDecimalNumber *range = nil;
    if(_minM != nil && _maxM != nil){
        range = [_maxM decimalNumberBySubtracting:_minM];
    }
    return range;
}

-(BOOL) isPoint{
    return [_minX compare:_maxX] == NSOrderedSame && [_minY compare:_maxY] == NSOrderedSame;
}

-(SFPoint *) topLeft{
    return [SFPoint pointWithX:_minX andY:_maxY];
}

-(SFPoint *) bottomLeft{
    return [SFPoint pointWithX:_minX andY:_minY];
}

-(SFPoint *) bottomRight{
    return [SFPoint pointWithX:_maxX andY:_minY];
}

-(SFPoint *) topRight{
    return [SFPoint pointWithX:_maxX andY:_maxY];
}

-(SFLine *) left{
    return [SFLine lineWithPoint1:[self topLeft] andPoint2:[self bottomLeft]];
}

-(SFLine *) bottom{
    return [SFLine lineWithPoint1:[self bottomLeft] andPoint2:[self bottomRight]];
}

-(SFLine *) right{
    return [SFLine lineWithPoint1:[self bottomRight] andPoint2:[self topRight]];
}

-(SFLine *) top{
    return [SFLine lineWithPoint1:[self topRight] andPoint2:[self topLeft]];
}

-(double) midX{
    return ([_minX doubleValue] + [_maxX doubleValue]) / 2.0;
}

-(double) midY{
    return ([_minY doubleValue] + [_maxY doubleValue]) / 2.0;
}

-(SFPoint *) centroid{
    return [SFPoint pointWithXValue:[self midX] andYValue:[self midY]];
}

-(BOOL) isEmpty{
    return [self xRange] <= 0.0 || [self yRange] <= 0.0;
}
 
-(BOOL) intersectsWithEnvelope: (SFGeometryEnvelope *) envelope{
    return [self overlapWithEnvelope:envelope] != nil;
}

-(BOOL) intersectsWithEnvelope: (SFGeometryEnvelope *) envelope withAllowEmpty: (BOOL) allowEmpty{
    return [self overlapWithEnvelope:envelope withAllowEmpty:allowEmpty] != nil;
}

-(SFGeometryEnvelope *) overlapWithEnvelope: (SFGeometryEnvelope *) envelope{
    return [self overlapWithEnvelope:envelope withAllowEmpty:NO];
}

-(SFGeometryEnvelope *) overlapWithEnvelope: (SFGeometryEnvelope *) envelope withAllowEmpty: (BOOL) allowEmpty{
    
    double minX = MAX([self.minX doubleValue], [envelope.minX doubleValue]);
    double maxX = MIN([self.maxX doubleValue], [envelope.maxX doubleValue]);
    double minY = MAX([self.minY doubleValue], [envelope.minY doubleValue]);
    double maxY = MIN([self.maxY doubleValue], [envelope.maxY doubleValue]);
    
    SFGeometryEnvelope *overlap = nil;
    
    if((minX < maxX && minY < maxY) || (allowEmpty && minX <= maxX && minY <= maxY)){
        overlap = [SFGeometryEnvelope envelopeWithMinXValue:minX andMinYValue:minY andMaxXValue:maxX andMaxYValue:maxY];
    }
    
    return overlap;
}

-(SFGeometryEnvelope *) unionWithEnvelope: (SFGeometryEnvelope *) envelope{
    
    double minX = MIN([self.minX doubleValue], [envelope.minX doubleValue]);
    double maxX = MAX([self.maxX doubleValue], [envelope.maxX doubleValue]);
    double minY = MIN([self.minY doubleValue], [envelope.minY doubleValue]);
    double maxY = MAX([self.maxY doubleValue], [envelope.maxY doubleValue]);
    
    SFGeometryEnvelope *unionEnvelope = nil;
    
    if(minX < maxX && minY < maxY){
        unionEnvelope = [SFGeometryEnvelope envelopeWithMinXValue:minX andMinYValue:minY andMaxXValue:maxX andMaxYValue:maxY];
    }
    
    return unionEnvelope;
}

-(BOOL) containsPoint: (SFPoint *) point{
    return [self containsPoint:point withEpsilon:0.0];
}

-(BOOL) containsPoint: (SFPoint *) point withEpsilon: (double) epsilon{
    return [self containsX:[point.x doubleValue] andY:[point.y doubleValue] withEpsilon:epsilon];
}

-(BOOL) containsX: (double) x andY: (double) y{
    return [self containsX:x andY:y withEpsilon:0.0];
}

-(BOOL) containsX: (double) x andY: (double) y withEpsilon: (double) epsilon{
    return x >= [_minX doubleValue] - epsilon && x <= [_maxX doubleValue] + epsilon
        && y >= [_minY doubleValue] - epsilon && y <= [_maxY doubleValue] + epsilon;
}

-(BOOL) containsEnvelope: (SFGeometryEnvelope *) envelope{
    return [self containsEnvelope:envelope withEpsilon:0.0];
}

-(BOOL) containsEnvelope: (SFGeometryEnvelope *) envelope withEpsilon: (double) epsilon{
    return [_minX doubleValue] - epsilon <= [envelope.minX doubleValue]
        && [_maxX doubleValue] + epsilon >= [envelope.maxX doubleValue]
        && [_minY doubleValue] - epsilon <= [envelope.minY doubleValue]
        && [_maxY doubleValue] + epsilon >= [envelope.maxY doubleValue];
}

-(SFGeometry *) buildGeometry{
    return [SFGeometryEnvelopeBuilder buildGeometryWithEnvelope:self];
}

-(id) mutableCopyWithZone: (NSZone *) zone{
    return [SFGeometryEnvelope geometryEnvelopeWithGeometryEnvelope:self];
}

+ (BOOL) supportsSecureCoding {
    return YES;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.minX forKey:@"minX"];
    [encoder encodeObject:self.maxX forKey:@"maxX"];
    [encoder encodeObject:self.minY forKey:@"minY"];
    [encoder encodeObject:self.maxY forKey:@"maxY"];
    [encoder encodeObject:self.minZ forKey:@"minZ"];
    [encoder encodeObject:self.maxZ forKey:@"maxZ"];
    [encoder encodeObject:self.minM forKey:@"minM"];
    [encoder encodeObject:self.maxM forKey:@"maxM"];
}

- (id) initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        _minX = [decoder decodeObjectOfClass:[NSDecimalNumber class] forKey:@"minX"];
        _maxX = [decoder decodeObjectOfClass:[NSDecimalNumber class] forKey:@"maxX"];
        _minY = [decoder decodeObjectOfClass:[NSDecimalNumber class] forKey:@"minY"];
        _maxY = [decoder decodeObjectOfClass:[NSDecimalNumber class] forKey:@"maxY"];
        _minZ = [decoder decodeObjectOfClass:[NSDecimalNumber class] forKey:@"minZ"];
        _maxZ = [decoder decodeObjectOfClass:[NSDecimalNumber class] forKey:@"maxZ"];
        _minM = [decoder decodeObjectOfClass:[NSDecimalNumber class] forKey:@"minM"];
        _maxM = [decoder decodeObjectOfClass:[NSDecimalNumber class] forKey:@"maxM"];
    }
    return self;
}

- (BOOL)isEqualToGeometryEnvelope:(SFGeometryEnvelope *)geometryEnvelope {
    if (self == geometryEnvelope)
        return YES;
    if (geometryEnvelope == nil)
        return NO;
    if(self.maxM == nil){
        if(geometryEnvelope.maxM != nil)
            return NO;
    }else if(![self.maxM isEqual:geometryEnvelope.maxM]){
        return NO;
    }
    if(self.maxX == nil){
        if(geometryEnvelope.maxX != nil)
            return NO;
    }else if(![self.maxX isEqual:geometryEnvelope.maxX]){
        return NO;
    }
    if(self.maxY == nil){
        if(geometryEnvelope.maxY != nil)
            return NO;
    }else if(![self.maxY isEqual:geometryEnvelope.maxY]){
        return NO;
    }
    if(self.maxZ == nil){
        if(geometryEnvelope.maxZ != nil)
            return NO;
    }else if(![self.maxZ isEqual:geometryEnvelope.maxZ]){
        return NO;
    }
    if(self.minM == nil){
        if(geometryEnvelope.minM != nil)
            return NO;
    }else if(![self.minM isEqual:geometryEnvelope.minM]){
        return NO;
    }
    if(self.minX == nil){
        if(geometryEnvelope.minX != nil)
            return NO;
    }else if(![self.minX isEqual:geometryEnvelope.minX]){
        return NO;
    }
    if(self.minY == nil){
        if(geometryEnvelope.minY != nil)
            return NO;
    }else if(![self.minY isEqual:geometryEnvelope.minY]){
        return NO;
    }
    if(self.minZ == nil){
        if(geometryEnvelope.minZ != nil)
            return NO;
    }else if(![self.minZ isEqual:geometryEnvelope.minZ]){
        return NO;
    }
    return YES;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[SFGeometryEnvelope class]]) {
        return NO;
    }
    
    return [self isEqualToGeometryEnvelope:(SFGeometryEnvelope *)object];
}

- (NSUInteger)hash {
    NSUInteger prime = 31;
    NSUInteger result = 1;
    result = prime * result + (self.hasM ? 1231 : 1237);
    result = prime * result + (self.hasZ ? 1231 : 1237);
    result = prime * result + ((self.maxM == nil) ? 0 : [self.maxM hash]);
    result = prime * result + ((self.maxX == nil) ? 0 : [self.maxX hash]);
    result = prime * result + ((self.maxY == nil) ? 0 : [self.maxY hash]);
    result = prime * result + ((self.maxZ == nil) ? 0 : [self.maxZ hash]);
    result = prime * result + ((self.minM == nil) ? 0 : [self.minM hash]);
    result = prime * result + ((self.minX == nil) ? 0 : [self.minX hash]);
    result = prime * result + ((self.minY == nil) ? 0 : [self.minY hash]);
    result = prime * result + ((self.minZ == nil) ? 0 : [self.minZ hash]);
    return result;
}

@end
