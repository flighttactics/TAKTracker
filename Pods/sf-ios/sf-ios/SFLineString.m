//
//  SFLineString.m
//  sf-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "SFLineString.h"
#import "SFShamosHoey.h"
#import "SFGeometryUtils.h"

@implementation SFLineString

+(SFLineString *) lineString{
    return [[SFLineString alloc] init];
}

+(SFLineString *) lineStringWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [[SFLineString alloc] initWithHasZ:hasZ andHasM:hasM];
}

+(SFLineString *) lineStringWithPoints: (NSMutableArray<SFPoint *> *) points{
    return [[SFLineString alloc] initWithPoints:points];
}

+(SFLineString *) lineStringWithLineString: (SFLineString *) lineString{
    return [[SFLineString alloc] initWithLineString:lineString];
}

-(instancetype) init{
    self = [self initWithHasZ:false andHasM:false];
    return self;
}

-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self initWithType:SF_LINESTRING andHasZ:hasZ andHasM:hasM];
}

-(instancetype) initWithPoints: (NSMutableArray<SFPoint *> *) points{
    self = [self initWithHasZ:[SFGeometryUtils hasZ:points] andHasM:[SFGeometryUtils hasM:points]];
    if(self != nil){
        [self setPoints:points];
    }
    return self;
}

-(instancetype) initWithType: (enum SFGeometryType) geometryType andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    self = [super initWithType:geometryType andHasZ:hasZ andHasM:hasM];
    if(self != nil){
        self.points = [NSMutableArray array];
    }
    return self;
}

-(instancetype) initWithLineString: (SFLineString *) lineString{
    self = [self initWithHasZ:lineString.hasZ andHasM:lineString.hasM];
    if(self != nil){
        for(SFPoint *point in lineString.points){
            [self addPoint:[point mutableCopy]];
        }
    }
    return self;
}

-(void) addPoint: (SFPoint *) point{
    [self.points addObject:point];
    [self updateZM:point];
}

-(void) addPoints: (NSArray<SFPoint *> *) points{
    for(SFPoint *point in points){
        [self addPoint:point];
    }
}

-(int) numPoints{
    return (int)self.points.count;
}

-(SFPoint *) pointAtIndex: (int) n{
    return [self.points objectAtIndex:n];
}

-(SFPoint *) startPoint{
    SFPoint *startPoint = nil;
    if (![self isEmpty]) {
        startPoint = [self.points objectAtIndex:0];
    }
    return startPoint;
}

-(SFPoint *) endPoint{
    SFPoint *endPoint = nil;
    if (![self isEmpty]) {
        endPoint = [self.points objectAtIndex:self.points.count - 1];
    }
    return endPoint;
}

-(BOOL) isEmpty{
    return self.points.count == 0;
}

-(BOOL) isSimple{
    return [SFShamosHoey simplePolygonPoints:self.points];
}

-(id) mutableCopyWithZone: (NSZone *) zone{
    return [SFLineString lineStringWithLineString:self];
}

+ (BOOL) supportsSecureCoding {
    return YES;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    [super encodeWithCoder:encoder];
    
    [encoder encodeObject:self.points forKey:@"points"];
}

- (id) initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        _points = [decoder decodeObjectOfClasses:[NSSet setWithObjects:[NSMutableArray class], [SFPoint class], nil] forKey:@"points"];
    }
    return self;
}

- (BOOL)isEqualToLineString:(SFLineString *)lineString {
    if (self == lineString)
        return YES;
    if (lineString == nil)
        return NO;
    if (![super isEqual:lineString])
        return NO;
    if (self.points == nil) {
        if (lineString.points != nil)
            return NO;
    } else if (![self.points isEqual:lineString.points])
        return NO;
    return YES;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[SFLineString class]]) {
        return NO;
    }
    
    return [self isEqualToLineString:(SFLineString *)object];
}

- (NSUInteger)hash {
    NSUInteger prime = 31;
    NSUInteger result = [super hash];
    result = prime * result
        + ((self.points == nil) ? 0 : [self.points hash]);
    return result;
}

@end
