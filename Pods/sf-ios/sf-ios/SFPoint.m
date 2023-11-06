//
//  SFPoint.m
//  sf-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "SFPoint.h"

@implementation SFPoint

+(SFPoint *) point{
    return [[SFPoint alloc] init];
}

+(SFPoint *) pointWithXValue: (double) x andYValue: (double) y{
    return [[SFPoint alloc] initWithXValue:x andYValue:y];
}

+(SFPoint *) pointWithX: (NSDecimalNumber *) x andY: (NSDecimalNumber *) y{
    return [[SFPoint alloc] initWithX:x andY:y];
}

+(SFPoint *) pointWithX: (NSDecimalNumber *) x andY: (NSDecimalNumber *) y andZ: (NSDecimalNumber *) z{
    return [[SFPoint alloc] initWithX:x andY:y andZ:z];
}

+(SFPoint *) pointWithXValue: (double) x andYValue: (double) y andZ: (NSDecimalNumber *) z{
    return [[SFPoint alloc] initWithXValue:x andYValue:y andZ:z];
}

+(SFPoint *) pointWithXValue: (double) x andYValue: (double) y andZValue: (double) z{
    return [[SFPoint alloc] initWithXValue:x andYValue:y andZValue:z];
}

+(SFPoint *) pointWithX: (NSDecimalNumber *) x andY: (NSDecimalNumber *) y andZ: (NSDecimalNumber *) z andM: (NSDecimalNumber *) m{
    return [[SFPoint alloc] initWithX:x andY:y andZ:z andM:m];
}

+(SFPoint *) pointWithXValue: (double) x andYValue: (double) y andZ: (NSDecimalNumber *) z andM: (NSDecimalNumber *) m{
    return [[SFPoint alloc] initWithXValue:x andYValue:y andZ:z andM:m];
}

+(SFPoint *) pointWithXValue: (double) x andYValue: (double) y andZValue: (double) z andMValue: (double) m{
    return [[SFPoint alloc] initWithXValue:x andYValue:y andZValue:z andMValue:m];
}

+(SFPoint *) pointWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM andX: (NSDecimalNumber *) x andY: (NSDecimalNumber *) y{
    return [[SFPoint alloc] initWithHasZ:hasZ andHasM:hasM andX:x andY:y];
}

+(SFPoint *) pointWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM andXValue: (double) x andYValue: (double) y{
    return [[SFPoint alloc] initWithHasZ:hasZ andHasM:hasM andXValue:x andYValue:y];
}

+(SFPoint *) pointWithPoint: (SFPoint *) point{
    return [[SFPoint alloc] initWithPoint:point];
}

-(instancetype) init{
    return [self initWithXValue:0.0 andYValue:0.0];
}

-(instancetype) initWithXValue: (double) x andYValue: (double) y{
    return [self initWithX:[[NSDecimalNumber alloc] initWithDouble:x] andY:[[NSDecimalNumber alloc] initWithDouble:y]];
}

-(instancetype) initWithX: (NSDecimalNumber *) x andY: (NSDecimalNumber *) y{
    return [self initWithHasZ:false andHasM:false andX:x andY:y];
}

-(instancetype) initWithX: (NSDecimalNumber *) x andY: (NSDecimalNumber *) y andZ: (NSDecimalNumber *) z{
    return [self initWithX:x andY:y andZ:z andM:nil];
}

-(instancetype) initWithXValue: (double) x andYValue: (double) y andZ: (NSDecimalNumber *) z{
    return [self initWithXValue:x andYValue:y andZ:z andM:nil];
}

-(instancetype) initWithXValue: (double) x andYValue: (double) y andZValue: (double) z{
    return [self initWithXValue:x andYValue:y andZ:[[NSDecimalNumber alloc] initWithDouble:z]];
}

-(instancetype) initWithX: (NSDecimalNumber *) x andY: (NSDecimalNumber *) y andZ: (NSDecimalNumber *) z andM: (NSDecimalNumber *) m{
    self = [super initWithType:SF_POINT andHasZ:z != nil andHasM:m != nil];
    if(self != nil){
        self.x = x;
        self.y = y;
        self.z = z;
        self.m = m;
    }
    return self;
}

-(instancetype) initWithXValue: (double) x andYValue: (double) y andZ: (NSDecimalNumber *) z andM: (NSDecimalNumber *) m{
    return [self initWithX:[[NSDecimalNumber alloc] initWithDouble:x] andY:[[NSDecimalNumber alloc] initWithDouble:y] andZ:z andM:m];
}

-(instancetype) initWithXValue: (double) x andYValue: (double) y andZValue: (double) z andMValue: (double) m{
    return [self initWithXValue:x andYValue:y andZ:[[NSDecimalNumber alloc] initWithDouble:z] andM:[[NSDecimalNumber alloc] initWithDouble:m]];
}

-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM andX: (NSDecimalNumber *) x andY: (NSDecimalNumber *) y{
    self = [super initWithType:SF_POINT andHasZ:hasZ andHasM:hasM];
    if(self != nil){
        self.x = x;
        self.y = y;
    }
    return self;
}

-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM andXValue: (double) x andYValue: (double) y{
    return [self initWithHasZ:hasZ andHasM:hasM andX:[[NSDecimalNumber alloc] initWithDouble:x] andY:[[NSDecimalNumber alloc] initWithDouble:y]];
}

-(instancetype) initWithPoint: (SFPoint *) point{
    self = [self initWithHasZ:point.hasZ andHasM:point.hasM andX:point.x andY:point.y];
    if(self != nil){
        _z = point.z;
        _m = point.m;
    }
    return self;
}

-(void) setZ: (NSDecimalNumber *) z{
    _z = z;
    [self setHasZ:z != nil];
}

-(void) setM: (NSDecimalNumber *) m{
    _m = m;
    [self setHasM:m != nil];
}

-(void) setXValue: (double) x{
    self.x = [[NSDecimalNumber alloc] initWithDouble:x];
}

-(void) setYValue: (double) y{
    self.y = [[NSDecimalNumber alloc] initWithDouble:y];
}

-(void) setZValue: (double) z{
    self.z = [[NSDecimalNumber alloc] initWithDouble:z];
}

-(void) setMValue: (double) m{
    self.m = [[NSDecimalNumber alloc] initWithDouble:m];
}

-(BOOL) isEqualXToPoint: (SFPoint *) point{
    BOOL equal;
    if(self.x == nil){
        equal = point.x == nil;
    }else{
        equal = [self.x isEqual:point.x];
    }
    return equal;
}

-(BOOL) isEqualYToPoint: (SFPoint *) point{
    BOOL equal;
    if(self.y == nil){
        equal = point.y == nil;
    }else{
        equal = [self.y isEqual:point.y];
    }
    return equal;
}

-(BOOL) isEqualXYToPoint: (SFPoint *) point{
    return [self isEqualXToPoint:point] && [self isEqualYToPoint:point];
}

-(BOOL) isEmpty{
    return NO;
}

-(BOOL) isSimple{
    return YES;
}

-(id) mutableCopyWithZone: (NSZone *) zone{
    return [SFPoint pointWithPoint:self];
}

+ (BOOL) supportsSecureCoding {
    return YES;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    [super encodeWithCoder:encoder];
    
    [encoder encodeObject:self.x forKey:@"x"];
    [encoder encodeObject:self.y forKey:@"y"];
    [encoder encodeObject:self.z forKey:@"z"];
    [encoder encodeObject:self.m forKey:@"m"];
}

- (id) initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        _x = [decoder decodeObjectOfClass:[NSDecimalNumber class] forKey:@"x"];
        _y = [decoder decodeObjectOfClass:[NSDecimalNumber class] forKey:@"y"];
        _z = [decoder decodeObjectOfClass:[NSDecimalNumber class] forKey:@"z"];
        _m = [decoder decodeObjectOfClass:[NSDecimalNumber class] forKey:@"m"];
    }
    return self;
}

- (BOOL)isEqualToPoint:(SFPoint *)point {
    if (self == point)
        return YES;
    if (point == nil)
        return NO;
    if (![super isEqual:point])
        return NO;
    if(self.m == nil){
        if(point.m != nil)
            return NO;
    }else if(![self.m isEqual:point.m]){
        return NO;
    }
    if(![self isEqualXYToPoint:point]){
        return NO;
    }
    if(self.z == nil){
        if(point.z != nil)
            return NO;
    }else if(![self.z isEqual:point.z]){
        return NO;
    }
    return YES;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[SFPoint class]]) {
        return NO;
    }
    
    return [self isEqualToPoint:(SFPoint *)object];
}

- (NSUInteger)hash {
    NSUInteger prime = 31;
    NSUInteger result = [super hash];
    result = prime * result + ((self.m == nil) ? 0 : [self.m hash]);
    result = prime * result + ((self.x == nil) ? 0 : [self.x hash]);
    result = prime * result + ((self.y == nil) ? 0 : [self.y hash]);
    result = prime * result + ((self.z == nil) ? 0 : [self.z hash]);
    return result;
}

@end
