//
//  SFGeometryConstants.h
//  sf-ios
//
//  Created by Brian Osborn on 7/25/22.
//  Copyright © 2022 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Default epsilon for point in or on line tolerance
 */
extern double const SF_DEFAULT_LINE_EPSILON;

/**
 * Default epsilon for point equality
 */
extern double const SF_DEFAULT_EQUAL_EPSILON;

/**
 * Web Mercator Latitude Range
 */
extern double const SF_WEB_MERCATOR_MAX_LAT_RANGE;

/**
 * Web Mercator Latitude Range
 */
extern double const SF_WEB_MERCATOR_MIN_LAT_RANGE;

/**
 * Half the world distance in either direction
 */
extern double const SF_WEB_MERCATOR_HALF_WORLD_WIDTH;

/**
 * Half the world longitude width for WGS84
 */
extern double const SF_WGS84_HALF_WORLD_LON_WIDTH;

/**
 * Half the world latitude height for WGS84
 */
extern double const SF_WGS84_HALF_WORLD_LAT_HEIGHT;

/**
 * Minimum latitude degrees value convertible to meters
 */
extern double const SF_DEGREES_TO_METERS_MIN_LAT;

/**
 * Absolute north bearing in degrees
 */
extern double const SF_BEARING_NORTH;

/**
 * Absolute east bearing in degrees
 */
extern double const SF_BEARING_EAST;

/**
 * Absolute south bearing in degrees
 */
extern double const SF_BEARING_SOUTH;

/**
 * Absolute west bearing degrees
 */
extern double const SF_BEARING_WEST;

/**
 * Radians to Degrees conversion
 */
extern double const SF_RADIANS_TO_DEGREES;

/**
 * Degrees to Radians conversion
 */
extern double const SF_DEGREES_TO_RADIANS;

@interface SFGeometryConstants : NSObject

@end
