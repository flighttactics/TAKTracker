//
//  SFDegreesCentroid.m
//  sf-ios
//
//  Created by Brian Osborn on 2/9/22.
//  Copyright © 2022 NGA. All rights reserved.
//

#import "SFDegreesCentroid.h"
#import "SFGeometryUtils.h"

@interface SFDegreesCentroid()

/**
 * Geometry
 */
@property (nonatomic, strong) SFGeometry *geometry;

/**
 * Number of points
 */
@property (nonatomic) int points;

/**
 * x sum
 */
@property (nonatomic) double x;

/**
 * y sum
 */
@property (nonatomic) double y;

/**
 * z sum
 */
@property (nonatomic) double z;

@end

@implementation SFDegreesCentroid

+(SFPoint *) centroidOfGeometry: (SFGeometry *) geometry{
    return [[SFDegreesCentroid alloc] initWithGeometry:geometry].centroid;
}

-(instancetype) initWithGeometry: (SFGeometry *) geometry{
    self = [super init];
    if(self != nil){
        self.geometry = geometry;
    }
    return self;
}

-(SFPoint *) centroid{

    SFPoint *centroid = nil;

    if(_geometry.geometryType == SF_POINT){
        centroid = (SFPoint *) _geometry;
    }else{
        
        [self calculate:_geometry];
        
        _x = _x / _points;
        _y = _y / _points;
        _z = _z / _points;

        double centroidLongitude = atan2(_y, _x);
        double centroidLatitude = atan2(_z, sqrt(_x * _x + _y * _y));

        centroid = [SFPoint pointWithXValue:[SFGeometryUtils radiansToDegrees:centroidLongitude] andYValue:[SFGeometryUtils radiansToDegrees:centroidLatitude]];
    }

    return centroid;
}

/**
 * Add to the centroid calculation for the Geometry
 *
 * @param geometry
 *            Geometry
 */
-(void) calculate: (SFGeometry *) geometry{

    enum SFGeometryType geometryType = geometry.geometryType;

    switch (geometryType) {
     
        case SF_GEOMETRY:
            [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type of %@ which is abstract", [SFGeometryTypes name:geometryType]];
        case SF_POINT:
            [self calculatePoint:(SFPoint *) geometry];
            break;
        case SF_LINESTRING:
        case SF_CIRCULARSTRING:
            [self calculateLineString:(SFLineString *) geometry];
            break;
        case SF_POLYGON:
        case SF_TRIANGLE:
            [self calculatePolygon:(SFPolygon *) geometry];
            break;
        case SF_GEOMETRYCOLLECTION:
        case SF_MULTIPOINT:
        case SF_MULTICURVE:
        case SF_MULTILINESTRING:
        case SF_MULTISURFACE:
        case SF_MULTIPOLYGON:
            [self calculateGeometryCollection:(SFGeometryCollection *) geometry];
            break;
        case SF_COMPOUNDCURVE:
            [self calculateCompoundCurve:(SFCompoundCurve *) geometry];
            break;
        case SF_CURVEPOLYGON:
            [self calculateCurvePolygon:(SFCurvePolygon *) geometry];
            break;
        case SF_CURVE:
            [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type of %@ which is abstract", [SFGeometryTypes name:geometryType]];
        case SF_SURFACE:
            [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type of %@ which is abstract", [SFGeometryTypes name:geometryType]];
        case SF_POLYHEDRALSURFACE:
        case SF_TIN:
            [self calculatePolyhedralSurface:(SFPolyhedralSurface *) geometry];
            break;
        default:
            [NSException raise:@"Geometry Type" format:@"Geometry Type not supported: %@", [SFGeometryTypes name:geometryType]];
            break;
            
    }
}

/**
 * Add to the centroid calculation for the Point
 *
 * @param point
 *            Point
 */
-(void) calculatePoint: (SFPoint *) point{
    double latitude = [SFGeometryUtils degreesToRadians:[point.y doubleValue]];
    double longitude = [SFGeometryUtils degreesToRadians:[point.x doubleValue]];
    double cosLatitude = cos(latitude);
    _x += cosLatitude * cos(longitude);
    _y += cosLatitude * sin(longitude);
    _z += sin(latitude);
    _points++;
}

/**
 * Add to the centroid calculation for the Line String
 *
 * @param lineString
 *            Line String
 */
-(void) calculateLineString: (SFLineString *) lineString{

    for(SFPoint *point in lineString.points){
        [self calculatePoint:point];
    }

}

/**
 * Add to the centroid calculation for the Polygon
 *
 * @param polygon
 *            Polygon
 */
-(void) calculatePolygon: (SFPolygon *) polygon{

    if([polygon numRings] > 0){
        SFLineString *exteriorRing = [polygon exteriorRing];
        int numPoints = [exteriorRing numPoints];
        if([SFGeometryUtils closedPolygonRing:exteriorRing]){
            numPoints--;
        }
        for(int i = 0; i < numPoints; i++){
            [self calculatePoint:[exteriorRing pointAtIndex:i]];
        }
    }

}

/**
 * Add to the centroid calculation for the Geometry Collection
 *
 * @param geometryCollection
 *            Geometry Collection
 */
-(void) calculateGeometryCollection: (SFGeometryCollection *) geometryCollection{

    for(SFGeometry *geometry in geometryCollection.geometries){
        [self calculate:geometry];
    }

}

/**
 * Add to the centroid calculation for the Compound Curve
 *
 * @param compoundCurve
 *            Compound Curve
 */
-(void) calculateCompoundCurve: (SFCompoundCurve *) compoundCurve{

    for(SFLineString *lineString in compoundCurve.lineStrings){
        [self calculateLineString:lineString];
    }

}

/**
 * Add to the centroid calculation for the Curve Polygon
 *
 * @param curvePolygon
 *            Curve Polygon
 */
-(void) calculateCurvePolygon: (SFCurvePolygon *) curvePolygon{

    for(SFCurve *ring in curvePolygon.rings){
        [self calculate:ring];
    }

}

/**
 * Add to the centroid calculation for the Polyhedral Surface
 *
 * @param polyhedralSurface
 *            Polyhedral Surface
 */
-(void) calculatePolyhedralSurface: (SFPolyhedralSurface *) polyhedralSurface{

    for(SFPolygon *polygon in polyhedralSurface.polygons){
        [self calculatePolygon:polygon];
    }

}

@end
