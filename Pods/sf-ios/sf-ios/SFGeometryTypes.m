//
//  SFGeometryTypes.m
//  sf-ios
//
//  Created by Brian Osborn on 5/26/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "SFGeometryTypes.h"

NSString * const SF_GEOMETRY_NAME = @"GEOMETRY";
NSString * const SF_POINT_NAME = @"POINT";
NSString * const SF_LINESTRING_NAME = @"LINESTRING";
NSString * const SF_POLYGON_NAME = @"POLYGON";
NSString * const SF_MULTIPOINT_NAME = @"MULTIPOINT";
NSString * const SF_MULTILINESTRING_NAME = @"MULTILINESTRING";
NSString * const SF_MULTIPOLYGON_NAME = @"MULTIPOLYGON";
NSString * const SF_GEOMETRYCOLLECTION_NAME = @"GEOMETRYCOLLECTION";
NSString * const SF_CIRCULARSTRING_NAME = @"CIRCULARSTRING";
NSString * const SF_COMPOUNDCURVE_NAME = @"COMPOUNDCURVE";
NSString * const SF_CURVEPOLYGON_NAME = @"CURVEPOLYGON";
NSString * const SF_MULTICURVE_NAME = @"MULTICURVE";
NSString * const SF_MULTISURFACE_NAME = @"MULTISURFACE";
NSString * const SF_CURVE_NAME = @"CURVE";
NSString * const SF_SURFACE_NAME = @"SURFACE";
NSString * const SF_POLYHEDRALSURFACE_NAME = @"POLYHEDRALSURFACE";
NSString * const SF_TIN_NAME = @"TIN";
NSString * const SF_TRIANGLE_NAME = @"TRIANGLE";
NSString * const SF_NONE_NAME = @"NONE";

@implementation SFGeometryTypes

+(NSString *) name: (enum SFGeometryType) geometryType{
    NSString *name = nil;
    
    switch(geometryType){
        case SF_GEOMETRY:
            name = SF_GEOMETRY_NAME;
            break;
        case SF_POINT:
            name = SF_POINT_NAME;
            break;
        case SF_LINESTRING:
            name = SF_LINESTRING_NAME;
            break;
        case SF_POLYGON:
            name = SF_POLYGON_NAME;
            break;
        case SF_MULTIPOINT:
            name = SF_MULTIPOINT_NAME;
            break;
        case SF_MULTILINESTRING:
            name = SF_MULTILINESTRING_NAME;
            break;
        case SF_MULTIPOLYGON:
            name = SF_MULTIPOLYGON_NAME;
            break;
        case SF_GEOMETRYCOLLECTION:
            name = SF_GEOMETRYCOLLECTION_NAME;
            break;
        case SF_CIRCULARSTRING:
            name = SF_CIRCULARSTRING_NAME;
            break;
        case SF_COMPOUNDCURVE:
            name = SF_COMPOUNDCURVE_NAME;
            break;
        case SF_CURVEPOLYGON:
            name = SF_CURVEPOLYGON_NAME;
            break;
        case SF_MULTICURVE:
            name = SF_MULTICURVE_NAME;
            break;
        case SF_MULTISURFACE:
            name = SF_MULTISURFACE_NAME;
            break;
        case SF_CURVE:
            name = SF_CURVE_NAME;
            break;
        case SF_SURFACE:
            name = SF_SURFACE_NAME;
            break;
        case SF_POLYHEDRALSURFACE:
            name = SF_POLYHEDRALSURFACE_NAME;
            break;
        case SF_TIN:
            name = SF_TIN_NAME;
            break;
        case SF_TRIANGLE:
            name = SF_TRIANGLE_NAME;
            break;
        case SF_NONE:
            name = SF_NONE_NAME;
            break;
    }
    
    return name;
}

+(enum SFGeometryType) fromName: (NSString *) name{
    enum SFGeometryType value = SF_NONE;
    
    if(name != nil){
        name = [name uppercaseString];
        NSDictionary *types = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInteger:SF_GEOMETRY], SF_GEOMETRY_NAME,
                               [NSNumber numberWithInteger:SF_POINT], SF_POINT_NAME,
                               [NSNumber numberWithInteger:SF_LINESTRING], SF_LINESTRING_NAME,
                               [NSNumber numberWithInteger:SF_POLYGON], SF_POLYGON_NAME,
                               [NSNumber numberWithInteger:SF_MULTIPOINT], SF_MULTIPOINT_NAME,
                               [NSNumber numberWithInteger:SF_MULTILINESTRING], SF_MULTILINESTRING_NAME,
                               [NSNumber numberWithInteger:SF_MULTIPOLYGON], SF_MULTIPOLYGON_NAME,
                               [NSNumber numberWithInteger:SF_GEOMETRYCOLLECTION], SF_GEOMETRYCOLLECTION_NAME,
                               [NSNumber numberWithInteger:SF_CIRCULARSTRING], SF_CIRCULARSTRING_NAME,
                               [NSNumber numberWithInteger:SF_COMPOUNDCURVE], SF_COMPOUNDCURVE_NAME,
                               [NSNumber numberWithInteger:SF_CURVEPOLYGON], SF_CURVEPOLYGON_NAME,
                               [NSNumber numberWithInteger:SF_MULTICURVE], SF_MULTICURVE_NAME,
                               [NSNumber numberWithInteger:SF_MULTISURFACE], SF_MULTISURFACE_NAME,
                               [NSNumber numberWithInteger:SF_CURVE], SF_CURVE_NAME,
                               [NSNumber numberWithInteger:SF_SURFACE], SF_SURFACE_NAME,
                               [NSNumber numberWithInteger:SF_POLYHEDRALSURFACE], SF_POLYHEDRALSURFACE_NAME,
                               [NSNumber numberWithInteger:SF_TIN], SF_TIN_NAME,
                               [NSNumber numberWithInteger:SF_TRIANGLE], SF_TRIANGLE_NAME,
                               [NSNumber numberWithInteger:SF_NONE], SF_NONE_NAME,
                               nil
                               ];
        NSNumber *enumValue = [types objectForKey:name];
        if(enumValue != nil){
            value = (enum SFGeometryType)[enumValue intValue];
        }
    }
    
    return value;
}

@end
