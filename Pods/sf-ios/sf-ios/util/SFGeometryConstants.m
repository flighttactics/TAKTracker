//
//  SFGeometryConstants.m
//  sf-ios
//
//  Created by Brian Osborn on 7/25/22.
//  Copyright © 2022 NGA. All rights reserved.
//

#import "SFGeometryConstants.h"

double const SF_DEFAULT_LINE_EPSILON = 0.000000000000001;
double const SF_DEFAULT_EQUAL_EPSILON = 0.00000001;
double const SF_WEB_MERCATOR_MAX_LAT_RANGE = 85.0511287798066;
double const SF_WEB_MERCATOR_MIN_LAT_RANGE = -85.05112877980659;
double const SF_WEB_MERCATOR_HALF_WORLD_WIDTH = 20037508.342789244;
double const SF_WGS84_HALF_WORLD_LON_WIDTH = 180.0;
double const SF_WGS84_HALF_WORLD_LAT_HEIGHT = 90.0;
double const SF_DEGREES_TO_METERS_MIN_LAT = -89.99999999999999;
double const SF_BEARING_NORTH = 0.0;
double const SF_BEARING_EAST = 90.0;
double const SF_BEARING_SOUTH = 180.0;
double const SF_BEARING_WEST = 270.0;
double const SF_RADIANS_TO_DEGREES = 180.0 / M_PI;
double const SF_DEGREES_TO_RADIANS = M_PI / 180.0;

@implementation SFGeometryConstants

@end
