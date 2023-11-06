//
//  SFGeometryPrinter.m
//  sf-ios
//
//  Created by Brian Osborn on 6/1/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "SFGeometryPrinter.h"
#import "SFMultiPoint.h"
#import "SFMultiLineString.h"
#import "SFMultiPolygon.h"
#import "SFCircularString.h"
#import "SFCompoundCurve.h"
#import "SFTIN.h"
#import "SFTriangle.h"

@implementation SFGeometryPrinter

+(NSString *) geometryString: (SFGeometry *) geometry{
    
    NSMutableString *message = [NSMutableString string];
    
    enum SFGeometryType geometryType = geometry.geometryType;
    switch (geometryType) {
        case SF_POINT:
            [self addPoint:(SFPoint *)geometry toMessage:message];
            break;
        case SF_LINESTRING:
            [self addLineString:(SFLineString *)geometry toMessage:message];
            break;
        case SF_POLYGON:
            [self addPolygon:(SFPolygon *)geometry toMessage:message];
            break;
        case SF_MULTIPOINT:
            [self addMultiPoint:(SFMultiPoint *)geometry toMessage:message];
            break;
        case SF_MULTILINESTRING:
            [self addMultiLineString:(SFMultiLineString *)geometry toMessage:message];
            break;
        case SF_MULTIPOLYGON:
            [self addMultiPolygon:(SFMultiPolygon *)geometry toMessage:message];
            break;
        case SF_CIRCULARSTRING:
            [self addLineString:(SFCircularString *)geometry toMessage:message];
            break;
        case SF_COMPOUNDCURVE:
            [self addCompoundCurve:(SFCompoundCurve *)geometry toMessage:message];
            break;
        case SF_CURVEPOLYGON:
            [self addCurvePolygon:(SFCurvePolygon *)geometry toMessage:message];
            break;
        case SF_POLYHEDRALSURFACE:
            [self addPolyhedralSurface:(SFPolyhedralSurface *)geometry toMessage:message];
            break;
        case SF_TIN:
            [self addPolyhedralSurface:(SFTIN *)geometry toMessage:message];
            break;
        case SF_TRIANGLE:
            [self addPolygon:(SFTriangle *)geometry toMessage:message];
            break;
        case SF_GEOMETRYCOLLECTION:
        case SF_MULTICURVE:
        case SF_MULTISURFACE:
            {
                SFGeometryCollection *geomCollection = (SFGeometryCollection *) geometry;
                [message appendFormat:@"Geometries: %d", [geomCollection numGeometries]];
                NSArray *geometries = geomCollection.geometries;
                for(int i = 0; i < geometries.count; i++){
                    SFGeometry *subGeometry = [geometries objectAtIndex:i];
                    [message appendString:@"\n\n"];
                    [message appendFormat:@"Geometry %d", (i+1)];
                    [message appendString:@"\n"];
                    [message appendFormat:@"%@", [SFGeometryTypes name:subGeometry.geometryType]];
                    [message appendString:@"\n"];
                    [message appendString:[self geometryString:subGeometry]];
                }
            }
            break;
        default:
            break;
            
    }
    
    return message;
}

+(void) addPoint: (SFPoint *) point toMessage: (NSMutableString *) message{
    [message appendFormat:@"Latitude: %@", point.y];
    [message appendFormat:@"\nLongitude: %@", point.x];
}

+(void) addMultiPoint: (SFMultiPoint *) multiPoint toMessage: (NSMutableString *) message{
    [message appendFormat:@"Points: %d", [multiPoint numPoints]];
    NSArray *points = [multiPoint points];
    for(int i = 0; i < points.count; i++){
        SFPoint *point = [points objectAtIndex:i];
        [message appendString:@"\n\n"];
        [message appendFormat:@"Point %d", (i+1)];
        [message appendString:@"\n"];
        [self addPoint:point toMessage:message];
    }
}

+(void) addLineString: (SFLineString *) lineString toMessage: (NSMutableString *) message{
    [message appendFormat:@"Points: %d", [lineString numPoints]];
    for(SFPoint *point in lineString.points){
        [message appendString:@"\n\n"];
        [self addPoint:point toMessage:message];
    }
}

+(void) addMultiLineString: (SFMultiLineString *) multiLineString toMessage: (NSMutableString *) message{
    [message appendFormat:@"LineStrings: %d", [multiLineString numLineStrings]];
    NSArray *lineStrings = [multiLineString lineStrings];
    for(int i = 0; i < lineStrings.count; i++){
        SFLineString *lineString = [lineStrings objectAtIndex:i];
        [message appendString:@"\n\n"];
        [message appendFormat:@"LineString %d", (i+1)];
        [message appendString:@"\n"];
        [self addLineString:lineString toMessage:message];
    }
}

+(void) addPolygon: (SFPolygon *) polygon toMessage: (NSMutableString *) message{
    [message appendFormat:@"Rings: %d", [polygon numRings]];
    for(int i = 0; i < polygon.rings.count; i++){
        SFLineString *ring = [polygon ringAtIndex:i];
        [message appendString:@"\n\n"];
        if(i > 0){
            [message appendFormat:@"Hole %d", i];
            [message appendString:@"\n"];
        }
        [self addLineString:ring toMessage:message];
    }
}

+(void) addMultiPolygon: (SFMultiPolygon *) multiPolygon toMessage: (NSMutableString *) message{
    [message appendFormat:@"Polygons: %d", [multiPolygon numPolygons]];
    NSArray *polygons = [multiPolygon polygons];
    for(int i = 0; i < polygons.count; i++){
        SFPolygon *polygon = [polygons objectAtIndex:i];
        [message appendString:@"\n\n"];
        [message appendFormat:@"Polygon %d", (i+1)];
        [message appendString:@"\n"];
        [self addPolygon:polygon toMessage:message];
    }
}

+(void) addCompoundCurve: (SFCompoundCurve *) compoundCurve toMessage: (NSMutableString *) message{
    [message appendFormat:@"LineStrings: %d", [compoundCurve numLineStrings]];
    for(int i = 0; i < compoundCurve.lineStrings.count; i++){
        SFLineString *lineString = [compoundCurve.lineStrings objectAtIndex:i];
        [message appendString:@"\n\n"];
        [message appendFormat:@"LineString %d", (i+1)];
        [message appendString:@"\n"];
        [self addLineString:lineString toMessage:message];
    }
}

+(void) addCurvePolygon: (SFCurvePolygon *) curvePolygon toMessage: (NSMutableString *) message{
    [message appendFormat:@"Rings: %d", [curvePolygon numRings]];
    for(int i = 0; i < curvePolygon.rings.count; i++){
        SFCurve *ring = [curvePolygon.rings objectAtIndex:i];
        [message appendString:@"\n\n"];
        if(i > 0){
            [message appendFormat:@"Hole %d", i];
            [message appendString:@"\n"];
        }
        [message appendString:[self geometryString:ring]];
    }
}

+(void) addPolyhedralSurface: (SFPolyhedralSurface *) polyhedralSurface toMessage: (NSMutableString *) message{
    [message appendFormat:@"Polygons: %d", [polyhedralSurface numPolygons]];
    for(int i = 0; i < polyhedralSurface.polygons.count; i++){
        SFPolygon *polygon = [polyhedralSurface.polygons objectAtIndex:i];
        [message appendString:@"\n\n"];
        [message appendFormat:@"Polygon %d", (i+1)];
        [message appendString:@"\n"];
        [self addPolygon:polygon toMessage:message];
    }
}

@end
