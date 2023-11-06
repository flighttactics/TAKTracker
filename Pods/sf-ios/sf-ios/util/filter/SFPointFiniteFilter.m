//
//  SFPointFiniteFilter.m
//  sf-ios
//
//  Created by Brian Osborn on 7/21/20.
//  Copyright © 2020 NGA. All rights reserved.
//

#import "SFPointFiniteFilter.h"
#import "SFPoint.h"

@implementation SFPointFiniteFilter

-(instancetype) init{
    self = [self initWithType:SF_FF_FINITE];
    return self;
}

-(instancetype) initWithType: (enum SFFiniteFilterType) type{
    self = [self initWithType:type andZ:NO andM:NO];
    return self;
}

-(instancetype) initWithType: (enum SFFiniteFilterType) type andZ: (BOOL) filterZ{
    self = [self initWithType:type andZ:filterZ andM:NO];
    return self;
}

-(instancetype) initWithType: (enum SFFiniteFilterType) type andM: (BOOL) filterM{
    self = [self initWithType:type andZ:NO andM:filterM];
    return self;
}

-(instancetype) initWithType: (enum SFFiniteFilterType) type andZ: (BOOL) filterZ andM: (BOOL) filterM{
    self = [super self];
    if(self){
        _type = type;
        _filterZ = filterZ;
        _filterM = filterM;
    }
    return self;
}

-(instancetype) initWithZ: (BOOL) filterZ{
    self = [self initWithZ:filterZ andM:NO];
    return self;
}

-(instancetype) initWithM: (BOOL) filterM{
    self = [self initWithZ:NO andM:filterM];
    return self;
}

-(instancetype) initWithZ: (BOOL) filterZ andM: (BOOL) filterM{
    self = [self initWithType:SF_FF_FINITE andZ:filterZ andM:filterM];
    return self;
}

-(BOOL) filterGeometry: (SFGeometry *) geometry inType: (enum SFGeometryType) containingType{
    return geometry.geometryType != SF_POINT || ![geometry isKindOfClass:[SFPoint class]] || [self filterPoint:(SFPoint *)geometry];
}

/**
 * Filter the point
 *
 * @param point
 *            point
 * @return true if passes filter and point should be included
 */
-(BOOL) filterPoint: (SFPoint *) point{
    return [self filterNumber:point.x] && [self filterNumber:point.y] && [self filterZWithPoint:point] && [self filterMWithPoint:point];
}

/**
 * Filter the double value
 *
 * @param value
 *            double value
 * @return true if passes
 */
-(BOOL) filterDouble: (double) value{
    BOOL passes = NO;
    switch (_type) {
        case SF_FF_FINITE:
            passes = isfinite(value);
            break;
        case SF_FF_FINITE_AND_INFINITE:
            passes = !isnan(value);
            break;
        case SF_FF_FINITE_AND_NAN:
            passes = !isinf(value);
            break;
        default:
            [NSException raise:@"Unsupported" format:@"Unsupported filter type: %u", _type];
    }
    return passes;
}

/**
 * Filter the Z value
 *
 * @param point
 *            point
 * @return true if passes
 */
-(BOOL) filterZWithPoint: (SFPoint *) point{
    return !_filterZ || !point.hasZ || [self filterNumber:point.z];
}

/**
 * Filter the M value
 *
 * @param point
 *            point
 * @return true if passes
 */
-(BOOL) filterMWithPoint: (SFPoint *) point{
    return !_filterM || !point.hasM || [self filterNumber:point.m];
}

/**
 * Filter the number value
 *
 * @param value
 *            number value
 * @return true if passes
 */
-(BOOL) filterNumber: (NSDecimalNumber *) value{
    return value == nil || [self filterDouble:[value doubleValue]];
}

@end
