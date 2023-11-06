//
//  SFFiniteFilterTypes.h
//  sf-ios
//
//  Created by Brian Osborn on 7/21/20.
//  Copyright © 2020 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Finite Filter Type, including finite values and optionally one of either
 * infinite or NaN values
 */
enum SFFiniteFilterType{
    SF_FF_FINITE = 0,
    SF_FF_FINITE_AND_INFINITE,
    SF_FF_FINITE_AND_NAN
};

@interface SFFiniteFilterTypes : NSObject

@end
