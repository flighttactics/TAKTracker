//
//  SFGeometryTypes.h
//  sf-ios
//
//  Created by Brian Osborn on 5/26/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Geometry Type enumeration
 */
enum SFGeometryType{
    SF_GEOMETRY = 0,
    SF_POINT,
    SF_LINESTRING,
    SF_POLYGON,
    SF_MULTIPOINT,
    SF_MULTILINESTRING,
    SF_MULTIPOLYGON,
    SF_GEOMETRYCOLLECTION,
    SF_CIRCULARSTRING,
    SF_COMPOUNDCURVE,
    SF_CURVEPOLYGON,
    SF_MULTICURVE,
    SF_MULTISURFACE,
    SF_CURVE,
    SF_SURFACE,
    SF_POLYHEDRALSURFACE,
    SF_TIN,
    SF_TRIANGLE,
    SF_NONE
};

/**
 *  Geometry type names
 */
extern NSString * const SF_GEOMETRY_NAME;
extern NSString * const SF_POINT_NAME;
extern NSString * const SF_LINESTRING_NAME;
extern NSString * const SF_POLYGON_NAME;
extern NSString * const SF_MULTIPOINT_NAME;
extern NSString * const SF_MULTILINESTRING_NAME;
extern NSString * const SF_MULTIPOLYGON_NAME;
extern NSString * const SF_GEOMETRYCOLLECTION_NAME;
extern NSString * const SF_CIRCULARSTRING_NAME;
extern NSString * const SF_COMPOUNDCURVE_NAME;
extern NSString * const SF_CURVEPOLYGON_NAME;
extern NSString * const SF_MULTICURVE_NAME;
extern NSString * const SF_MULTISURFACE_NAME;
extern NSString * const SF_CURVE_NAME;
extern NSString * const SF_SURFACE_NAME;
extern NSString * const SF_POLYHEDRALSURFACE_NAME;
extern NSString * const SF_TIN_NAME;
extern NSString * const SF_TRIANGLE_NAME;
extern NSString * const SF_NONE_NAME;

@interface SFGeometryTypes : NSObject

/**
 *  Get the name of the geometry type
 *
 *  @param geometryType geometry type enum
 *
 *  @return geometry type name
 */
+(NSString *) name: (enum SFGeometryType) geometryType;

/**
 *  Get the geometry type of the name
 *
 *  @param name geometry type name
 *
 *  @return geometry type
 */
+(enum SFGeometryType) fromName: (NSString *) name;

@end
