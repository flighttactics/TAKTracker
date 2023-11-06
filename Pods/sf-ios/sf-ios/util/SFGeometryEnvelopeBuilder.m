//
//  SFGeometryEnvelopeBuilder.m
//  sf-ios
//
//  Created by Brian Osborn on 6/1/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "SFGeometryEnvelopeBuilder.h"
#import "SFMultiPoint.h"
#import "SFMultiLineString.h"
#import "SFMultiPolygon.h"
#import "SFCircularString.h"
#import "SFCompoundCurve.h"
#import "SFTIN.h"
#import "SFTriangle.h"

@implementation SFGeometryEnvelopeBuilder

+(SFGeometryEnvelope *) buildEnvelopeWithGeometry: (SFGeometry *) geometry{
    
    SFGeometryEnvelope *envelope = [SFGeometryEnvelope envelope];
    
    [self buildEnvelope:envelope andGeometry:geometry];
    
    if(envelope.minX == nil || envelope.maxX == nil
       || envelope.minY == nil || envelope.maxY == nil){
        envelope = nil;
    }
    
    return envelope;
}

+(void) buildEnvelope: (SFGeometryEnvelope *) envelope andGeometry: (SFGeometry *) geometry{
    
    enum SFGeometryType geometryType = geometry.geometryType;
    switch (geometryType) {
        case SF_POINT:
            [self addPoint:(SFPoint *)geometry andEnvelope:envelope];
            break;
        case SF_LINESTRING:
            [self addLineString:(SFLineString *)geometry andEnvelope:envelope];
            break;
        case SF_POLYGON:
            [self addPolygon:(SFPolygon *)geometry andEnvelope:envelope];
            break;
        case SF_MULTIPOINT:
            [self addMultiPoint:(SFMultiPoint *)geometry andEnvelope:envelope];
            break;
        case SF_MULTILINESTRING:
            [self addMultiLineString:(SFMultiLineString *)geometry andEnvelope:envelope];
            break;
        case SF_MULTIPOLYGON:
            [self addMultiPolygon:(SFMultiPolygon *)geometry andEnvelope:envelope];
            break;
        case SF_CIRCULARSTRING:
            [self addLineString:(SFCircularString *)geometry andEnvelope:envelope];
            break;
        case SF_COMPOUNDCURVE:
            [self addCompoundCurve:(SFCompoundCurve *)geometry andEnvelope:envelope];
            break;
        case SF_CURVEPOLYGON:
            [self addCurvePolygon:(SFCurvePolygon *)geometry andEnvelope:envelope];
            break;
        case SF_POLYHEDRALSURFACE:
            [self addPolyhedralSurface:(SFPolyhedralSurface *)geometry andEnvelope:envelope];
            break;
        case SF_TIN:
            [self addPolyhedralSurface:(SFTIN *)geometry andEnvelope:envelope];
            break;
        case SF_TRIANGLE:
            [self addPolygon:(SFTriangle *)geometry andEnvelope:envelope];
            break;
        case SF_GEOMETRYCOLLECTION:
        case SF_MULTICURVE:
        case SF_MULTISURFACE:
            {
                [self updateHasZandMWithEnvelope:envelope andGeometry:geometry];
                SFGeometryCollection *geomCollection = (SFGeometryCollection *) geometry;
                for (SFGeometry *subGeometry in geomCollection.geometries) {
                    [self buildEnvelope:envelope andGeometry:subGeometry];
                }
            }
            break;
        default:
            break;
            
    }
    
}

+(void) updateHasZandMWithEnvelope: (SFGeometryEnvelope *) envelope andGeometry: (SFGeometry *) geometry{
    if(!envelope.hasZ && geometry.hasZ){
        [envelope setHasZ:true];
    }
    if(!envelope.hasM && geometry.hasM){
        [envelope setHasM:true];
    }
}

+(void) addPoint: (SFPoint *) point andEnvelope: (SFGeometryEnvelope *) envelope{
    
    [self updateHasZandMWithEnvelope:envelope andGeometry:point];
    
    NSDecimalNumber *x = point.x;
    NSDecimalNumber *y = point.y;
    if(envelope.minX == nil || [x compare:envelope.minX] == NSOrderedAscending){
        [envelope setMinX:x];
    }
    if(envelope.maxX == nil || [x compare:envelope.maxX] == NSOrderedDescending){
        [envelope setMaxX:x];
    }
    if(envelope.minY == nil || [y compare:envelope.minY] == NSOrderedAscending){
        [envelope setMinY:y];
    }
    if(envelope.maxY == nil || [y compare:envelope.maxY] == NSOrderedDescending){
        [envelope setMaxY:y];
    }
    if (point.hasZ) {
        NSDecimalNumber *z = point.z;
        if (z != nil) {
            if (envelope.minZ == nil || [z compare:envelope.minZ] == NSOrderedAscending) {
                [envelope setMinZ:z];
            }
            if (envelope.maxZ == nil || [z compare:envelope.maxZ] == NSOrderedDescending) {
                [envelope setMaxZ:z];
            }
        }
    }
    if (point.hasM) {
        NSDecimalNumber *m = point.m;
        if (m != nil) {
            if (envelope.minM == nil || [m compare:envelope.minM] == NSOrderedAscending) {
                [envelope setMinM:m];
            }
            if (envelope.maxM == nil || [m compare:envelope.maxM] == NSOrderedDescending) {
                [envelope setMaxM:m];
            }
        }
    }
}

+(void) addMultiPoint: (SFMultiPoint *) multiPoint andEnvelope: (SFGeometryEnvelope *) envelope{
    
    [self updateHasZandMWithEnvelope:envelope andGeometry:multiPoint];
    
    NSArray *points = [multiPoint points];
    for(SFPoint *point in points){
        [self addPoint:point andEnvelope:envelope];
    }
}

+(void) addLineString: (SFLineString *) lineString andEnvelope: (SFGeometryEnvelope *) envelope{
    
    [self updateHasZandMWithEnvelope:envelope andGeometry:lineString];
    
    for(SFPoint *point in lineString.points){
        [self addPoint:point andEnvelope:envelope];
    }
}

+(void) addMultiLineString: (SFMultiLineString *) multiLineString andEnvelope: (SFGeometryEnvelope *) envelope{
    
    [self updateHasZandMWithEnvelope:envelope andGeometry:multiLineString];
    
    NSArray *lineStrings = [multiLineString lineStrings];
    for(SFLineString *lineString in lineStrings){
        [self addLineString:lineString andEnvelope:envelope];
    }
}

+(void) addPolygon: (SFPolygon *) polygon andEnvelope: (SFGeometryEnvelope *) envelope{
    
    [self updateHasZandMWithEnvelope:envelope andGeometry:polygon];
    
    for(SFLineString *ring in polygon.rings){
        [self addLineString:ring andEnvelope:envelope];
    }
}

+(void) addMultiPolygon: (SFMultiPolygon *) multiPolygon andEnvelope: (SFGeometryEnvelope *) envelope{
    
    [self updateHasZandMWithEnvelope:envelope andGeometry:multiPolygon];
    
    NSArray *polygons = [multiPolygon polygons];
    for(SFPolygon *polygon in polygons){
        [self addPolygon:polygon andEnvelope:envelope];
    }
}

+(void) addCompoundCurve: (SFCompoundCurve *) compoundCurve andEnvelope: (SFGeometryEnvelope *) envelope{
    
    [self updateHasZandMWithEnvelope:envelope andGeometry:compoundCurve];
    
    for(SFLineString *lineString in compoundCurve.lineStrings){
        [self addLineString:lineString andEnvelope:envelope];
    }
}

+(void) addCurvePolygon: (SFCurvePolygon *) curvePolygon andEnvelope: (SFGeometryEnvelope *) envelope{
 
    [self updateHasZandMWithEnvelope:envelope andGeometry:curvePolygon];
    
    for(SFCurve *ring in curvePolygon.rings){
        [self buildEnvelope:envelope andGeometry:ring];
    }
}

+(void) addPolyhedralSurface: (SFPolyhedralSurface *) polyhedralSurface andEnvelope: (SFGeometryEnvelope *) envelope{
    
    [self updateHasZandMWithEnvelope:envelope andGeometry:polyhedralSurface];
    
    for(SFPolygon *polygon in polyhedralSurface.polygons){
        [self addPolygon:polygon andEnvelope:envelope];
    }
}

+(SFGeometry *) buildGeometryWithEnvelope: (SFGeometryEnvelope *) envelope{
    SFGeometry *geometry = nil;
    if([envelope isPoint]){
        geometry = [SFPoint pointWithX:envelope.minX andY:envelope.minY];
    }else{
        SFPolygon *polygon = [SFPolygon polygon];
        SFLineString *ring = [SFLineString lineString];
        [ring addPoint:[SFPoint pointWithX:envelope.minX andY:envelope.minY]];
        [ring addPoint:[SFPoint pointWithX:envelope.maxX andY:envelope.minY]];
        [ring addPoint:[SFPoint pointWithX:envelope.maxX andY:envelope.maxY]];
        [ring addPoint:[SFPoint pointWithX:envelope.minX andY:envelope.maxY]];
        [polygon addRing:ring];
        geometry = polygon;
    }
    return geometry;
}

@end
