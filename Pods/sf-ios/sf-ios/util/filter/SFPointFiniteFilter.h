//
//  SFPointFiniteFilter.h
//  sf-ios
//
//  Created by Brian Osborn on 7/21/20.
//  Copyright © 2020 NGA. All rights reserved.
//

#import "SFGeometryFilter.h"
#import "SFFiniteFilterTypes.h"

/**
 * Point filter for finite checks on x and y properties, optionally filter on z
 * and m properties and non finite values (NaN or infinity)
 */
@interface SFPointFiniteFilter : NSObject<SFGeometryFilter>

/**
 * Finite Filter type
 */
@property (nonatomic) enum SFFiniteFilterType type;

/**
 * Include z values in filtering
 */
@property (nonatomic) BOOL filterZ;

/**
 * Include m values in filtering
 */
@property (nonatomic) BOOL filterM;

/**
 *  Initialize, filter on x and y, allowing only finite values
 *
 *  @return new point finite filter
 */
-(instancetype) init;

/**
 *  Initialize, filter on x and y
 *
 *  @param type finite filter type
 *
 *  @return new point finite filter
 */
-(instancetype) initWithType: (enum SFFiniteFilterType) type;

/**
 *  Initialize, filter on x, y, and optionally z
 *
 *  @param type finite filter type
 *  @param filterZ filter z values mode
 *
 *  @return new point finite filter
 */
-(instancetype) initWithType: (enum SFFiniteFilterType) type andZ: (BOOL) filterZ;

/**
 *  Initialize, filter on x, y, and optionally m
 *
 *  @param type finite filter type
 *  @param filterM filter m values mode
 *
 *  @return new point finite filter
 */
-(instancetype) initWithType: (enum SFFiniteFilterType) type andM: (BOOL) filterM;

/**
 *  Initialize, filter on x, y, and optionally z and m
 *
 *  @param type finite filter type
 *  @param filterZ filter z values mode
 *  @param filterM filter m values mode
 *
 *  @return new point finite filter
 */
-(instancetype) initWithType: (enum SFFiniteFilterType) type andZ: (BOOL) filterZ andM: (BOOL) filterM;

/**
 *  Initialize, filter on x, y, and optionally z
 *
 *  @param filterZ filter z values mode
 *
 *  @return new point finite filter
 */
-(instancetype) initWithZ: (BOOL) filterZ;

/**
 *  Initialize, filter on x, y, and optionally m
 *
 *  @param filterM filter m values mode
 *
 *  @return new point finite filter
 */
-(instancetype) initWithM: (BOOL) filterM;

/**
 *  Initialize, filter on x, y, and optionally z and m
 *
 *  @param filterZ filter z values mode
 *  @param filterM filter m values mode
 *
 *  @return new point finite filter
 */
-(instancetype) initWithZ: (BOOL) filterZ andM: (BOOL) filterM;

@end
