//
//  SFCentroidSurface.m
//  sf-ios
//
//  Created by Brian Osborn on 4/14/17.
//  Copyright © 2017 NGA. All rights reserved.
//

#import "SFCentroidSurface.h"
#import "SFMultiPolygon.h"
#import "SFGeometryUtils.h"

@interface SFCentroidSurface()

/**
 * Base point for triangles
 */
@property (nonatomic, strong) SFPoint *base;

/**
 * Area sum
 */
@property (nonatomic) double area;

/**
 * Sum of surface point locations
 */
@property (nonatomic, strong) SFPoint *sum;

@end

@implementation SFCentroidSurface

-(instancetype) init{
    return [self initWithGeometry:nil];
}

-(instancetype) initWithGeometry: (SFGeometry *) geometry{
    self = [super init];
    if(self != nil){
        self.area = 0;
        self.sum = [SFPoint point];
        [self addGeometry:geometry];
    }
    return self;
}

-(void) addGeometry: (SFGeometry *) geometry{
    enum SFGeometryType geometryType = geometry.geometryType;
    switch (geometryType) {
        case SF_POLYGON:
        case SF_TRIANGLE:
            [self addPolygon:(SFPolygon *) geometry];
            break;
        case SF_MULTIPOLYGON:
            [self addPolygons:[((SFMultiPolygon *)geometry) polygons]];
            break;
        case SF_CURVEPOLYGON:
            [self addCurvePolygon:(SFCurvePolygon *) geometry];
            break;
        case SF_POLYHEDRALSURFACE:
        case SF_TIN:
            [self addPolygons:((SFPolyhedralSurface *)geometry).polygons];
            break;
        case SF_GEOMETRYCOLLECTION:
        case SF_MULTICURVE:
        case SF_MULTISURFACE:
            {
                SFGeometryCollection *geomCollection = (SFGeometryCollection *) geometry;
                for (SFGeometry *subGeometry in geomCollection.geometries) {
                    [self addGeometry:subGeometry];
                }
            
            }
            break;
        case SF_POINT:
        case SF_MULTIPOINT:
        case SF_LINESTRING:
        case SF_CIRCULARSTRING:
        case SF_MULTILINESTRING:
        case SF_COMPOUNDCURVE:
            // Doesn't contribute to surface dimension
            break;
        default:
            [NSException raise:@"Geometry Not Supported" format:@"Unsupported Geometry Type: %d", geometryType];
    }
}

/**
 * Add polygons to the centroid total
 *
 * @param polygons
 *            polygons
 */
-(void) addPolygons: (NSArray *) polygons{
    for(SFPolygon *polygon in polygons){
        [self addPolygon:polygon];
    }
}

/**
 * Add a polygon to the centroid total
 *
 * @param polygon
 *            polygon
 */
-(void) addPolygon: (SFPolygon *) polygon{
    NSArray *rings = polygon.rings;
    [self addLineString:[rings objectAtIndex:0]];
    for(int i = 1; i < rings.count; i++){
        [self addHoleLineString: [rings objectAtIndex: i]];
    }
}

/**
 * Add a curve polygon to the centroid total
 *
 * @param curvePolygon
 *            curve polygon
 */
-(void) addCurvePolygon: (SFCurvePolygon *) curvePolygon{
    
    NSArray *rings = curvePolygon.rings;
    
    SFCurve *curve = [rings objectAtIndex:0];
    enum SFGeometryType curveGeometryType = curve.geometryType;
    switch(curveGeometryType){
        case SF_COMPOUNDCURVE:
            {
                SFCompoundCurve *compoundCurve = (SFCompoundCurve *) curve;
                for(SFLineString *lineString in compoundCurve.lineStrings){
                    [self addLineString:lineString];
                }
                break;
            }
        case SF_LINESTRING:
        case SF_CIRCULARSTRING:
            [self addLineString:(SFLineString *)curve];
            break;
        default:
            [NSException raise:@"Curve Type" format:@"Unexpected Curve Type: %d", curveGeometryType];
    }
    
    for(int i = 1; i < rings.count; i++){
        SFCurve *curveHole = [rings objectAtIndex:i];
        enum SFGeometryType curveHoleGeometryType = curveHole.geometryType;
        switch(curveHoleGeometryType){
            case SF_COMPOUNDCURVE:
                {
                    SFCompoundCurve *compoundCurveHole = (SFCompoundCurve *) curveHole;
                    for(SFLineString *lineStringHole in compoundCurveHole.lineStrings){
                        [self addHoleLineString:lineStringHole];
                    }
                    break;
                }
            case SF_LINESTRING:
            case SF_CIRCULARSTRING:
                [self addHoleLineString:(SFLineString *)curveHole];
                break;
            default:
                [NSException raise:@"Curve Type" format:@"Unexpected Curve Type: %d", curveHoleGeometryType];
        }
    }
}

/**
 * Add a line string to the centroid total
 *
 * @param lineString
 *            line string
 */
-(void) addLineString: (SFLineString *) lineString{
    [self addWithPositive:true andLineString:lineString];
}

/**
 * Add a line string hole to subtract from the centroid total
 *
 * @param lineString
 *            line string
 */
-(void) addHoleLineString: (SFLineString *) lineString{
    [self addWithPositive:false andLineString:lineString];
}

/**
 * Add or subtract a line string to or from the centroid total
 *
 * @param positive
 *            true if an addition, false if a subtraction
 * @param lineString
 *            line string
 */
-(void) addWithPositive: (BOOL) positive andLineString: (SFLineString *) lineString{
    NSArray *points = lineString.points;
    SFPoint *firstPoint = [points objectAtIndex:0];
    if(self.base == nil){
        self.base = firstPoint;
    }
    for(int i = 0; i < points.count - 1; i++){
        SFPoint *point = [points objectAtIndex:i];
        SFPoint *nextPoint = [points objectAtIndex:i + 1];
        [self addTriangleWithPositive:positive andPoint1:self.base andPoint2:point andPoint3:nextPoint];
    }
    SFPoint *lastPoint = [points objectAtIndex:points.count - 1];
    if([firstPoint.x doubleValue] != [lastPoint.x doubleValue] || [firstPoint.y doubleValue] != [lastPoint.y doubleValue]){
        [self addTriangleWithPositive:positive andPoint1:self.base andPoint2:lastPoint andPoint3:firstPoint];
    }
}

/**
 * Add or subtract a triangle of points to or from the centroid total
 *
 * @param positive
 *            true if an addition, false if a subtraction
 * @param point1
 *            point 1
 * @param point2
 *            point 2
 * @param point3
 *            point 3
 */
-(void) addTriangleWithPositive: (BOOL) positive andPoint1: (SFPoint *) point1 andPoint2: (SFPoint *) point2 andPoint3: (SFPoint *) point3{
    double sign = (positive) ? 1.0 : -1.0;
    SFPoint *triangleCenter3 = [self centroid3WithPoint1:point1 andPoint2:point2 andPoint3:point3];
    double area2 = [self area2WithPoint1:point1 andPoint2:point2 andPoint3:point3];
    [self.sum setX:[self.sum.x decimalNumberByAdding:[[NSDecimalNumber alloc] initWithDouble:sign * area2 * [triangleCenter3.x doubleValue]]]];
    [self.sum setY:[self.sum.y decimalNumberByAdding:[[NSDecimalNumber alloc] initWithDouble:sign * area2 * [triangleCenter3.y doubleValue]]]];
    self.area += sign * area2;
}

/**
 * Calculate three times the centroid of the point triangle
 *
 * @param point1
 *            point 1
 * @param point2
 *            point 2
 * @param point3
 *            point 3
 * @return 3 times centroid point
 */
-(SFPoint *) centroid3WithPoint1: (SFPoint *) point1 andPoint2: (SFPoint *) point2 andPoint3: (SFPoint *) point3{
    double x = [point1.x doubleValue] + [point2.x doubleValue] + [point3.x doubleValue];
    double y = [point1.y doubleValue] + [point2.y doubleValue] + [point3.y doubleValue];
    SFPoint *point = [SFPoint pointWithXValue:x andYValue:y];
    return point;
}

/**
 * Calculate twice the area of the point triangle
 *
 * @param point1
 *            point 1
 * @param point2
 *            point 2
 * @param point3
 *            point 3
 * @return 2 times triangle area
 */
-(double) area2WithPoint1: (SFPoint *) point1 andPoint2: (SFPoint *) point2 andPoint3: (SFPoint *) point3{
    return ([point2.x doubleValue] - [point1.x doubleValue])
				* ([point3.y doubleValue] - [point1.y doubleValue])
				- ([point3.x doubleValue] - [point1.x doubleValue])
				* ([point2.y doubleValue] - [point1.y doubleValue]);
}

-(SFPoint *) centroid{
    SFPoint *centroid = [SFPoint pointWithXValue:([self.sum.x doubleValue] / 3 / self.area) andYValue:([self.sum.y doubleValue] / 3 / self.area)];
    return centroid;
}

@end
