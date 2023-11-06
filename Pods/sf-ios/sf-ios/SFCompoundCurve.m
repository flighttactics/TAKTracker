//
//  SFCompoundCurve.m
//  sf-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "SFCompoundCurve.h"
#import "SFShamosHoey.h"
#import "SFGeometryUtils.h"

@implementation SFCompoundCurve

+(SFCompoundCurve *) compoundCurve{
    return [[SFCompoundCurve alloc] init];
}

+(SFCompoundCurve *) compoundCurveWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [[SFCompoundCurve alloc] initWithHasZ:hasZ andHasM:hasM];
}

+(SFCompoundCurve *) compoundCurveWithLineStrings: (NSMutableArray<SFLineString *> *) lineStrings{
    return [[SFCompoundCurve alloc] initWithLineStrings:lineStrings];
}

+(SFCompoundCurve *) compoundCurveWithLineString: (SFLineString *) lineString{
    return [[SFCompoundCurve alloc] initWithLineString:lineString];
}

+(SFCompoundCurve *) compoundCurveWithCompoundCurve: (SFCompoundCurve *) compoundCurve{
    return [[SFCompoundCurve alloc] initWithCompoundCurve:compoundCurve];
}

-(instancetype) init{
    self = [self initWithHasZ:false andHasM:false];
    return self;
}

-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    self = [super initWithType:SF_COMPOUNDCURVE andHasZ:hasZ andHasM:hasM];
    if(self != nil){
        self.lineStrings = [NSMutableArray array];
    }
    return self;
}

-(instancetype) initWithLineStrings: (NSMutableArray<SFLineString *> *) lineStrings{
    self = [self initWithHasZ:[SFGeometryUtils hasZ:lineStrings] andHasM:[SFGeometryUtils hasM:lineStrings]];
    if(self != nil){
        [self setLineStrings:lineStrings];
    }
    return self;
}

-(instancetype) initWithLineString: (SFLineString *) lineString{
    self = [self initWithHasZ:lineString.hasZ andHasM:lineString.hasM];
    if(self != nil){
        [self addLineString:lineString];
    }
    return self;
}

-(instancetype) initWithCompoundCurve: (SFCompoundCurve *) compoundCurve{
    self = [self initWithHasZ:compoundCurve.hasZ andHasM:compoundCurve.hasM];
    if(self != nil){
        for(SFLineString *lineString in compoundCurve.lineStrings){
            [self addLineString:[lineString mutableCopy]];
        }
    }
    return self;
}

-(void) addLineString: (SFLineString *) lineString{
    [self.lineStrings addObject:lineString];
    [self updateZM:lineString];
}

-(void) addLineStrings: (NSArray<SFLineString *> *) lineStrings{
    for(SFLineString *lineString in lineStrings){
        [self addLineString:lineString];
    }
}

-(int) numLineStrings{
    return (int)self.lineStrings.count;
}

-(SFLineString *) lineStringAtIndex: (int) n{
    return [self.lineStrings objectAtIndex:n];
}

-(SFPoint *) startPoint{
    SFPoint *startPoint = nil;
    if (![self isEmpty]) {
        for (SFLineString *lineString in self.lineStrings) {
            if (![lineString isEmpty]) {
                startPoint = [lineString startPoint];
                break;
            }
        }
    }
    return startPoint;
}

-(SFPoint *) endPoint{
    SFPoint *endPoint = nil;
    if (![self isEmpty]) {
        for (int i = (int)self.lineStrings.count - 1; i >= 0; i--) {
            SFLineString *lineString = [self.lineStrings objectAtIndex:i];
            if (![lineString isEmpty]) {
                endPoint = [lineString endPoint];
                break;
            }
        }
    }
    return endPoint;
}

-(BOOL) isEmpty{
    return self.lineStrings.count == 0;
}

-(BOOL) isSimple{
    return [SFShamosHoey simplePolygonRings:self.lineStrings];
}

-(id) mutableCopyWithZone: (NSZone *) zone{
    return [SFCompoundCurve compoundCurveWithCompoundCurve:self];
}

+ (BOOL) supportsSecureCoding {
    return YES;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    [super encodeWithCoder:encoder];
    
    [encoder encodeObject:self.lineStrings forKey:@"lineStrings"];
}

- (id) initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        _lineStrings = [decoder decodeObjectOfClasses:[NSSet setWithObjects:[NSMutableArray class], [SFLineString class], nil] forKey:@"lineStrings"];
    }
    return self;
}

- (BOOL)isEqualToCompoundCurve:(SFCompoundCurve *)compoundCurve {
    if (self == compoundCurve)
        return YES;
    if (compoundCurve == nil)
        return NO;
    if (![super isEqual:compoundCurve])
        return NO;
    if (self.lineStrings == nil) {
        if (compoundCurve.lineStrings != nil)
            return NO;
    } else if (![self.lineStrings isEqual:compoundCurve.lineStrings])
        return NO;
    return YES;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[SFCompoundCurve class]]) {
        return NO;
    }
    
    return [self isEqualToCompoundCurve:(SFCompoundCurve *)object];
}

- (NSUInteger)hash {
    NSUInteger prime = 31;
    NSUInteger result = [super hash];
    result = prime * result
        + ((self.lineStrings == nil) ? 0 : [self.lineStrings hash]);
    return result;
}

@end
