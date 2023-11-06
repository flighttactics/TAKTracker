//
//  SFGeometryUtils.m
//  sf-ios
//
//  Created by Brian Osborn on 4/14/17.
//  Copyright © 2017 NGA. All rights reserved.
//

#import "SFGeometryUtils.h"
#import "SFCentroidPoint.h"
#import "SFCentroidCurve.h"
#import "SFCentroidSurface.h"
#import "SFMultiLineString.h"
#import "SFMultiPolygon.h"
#import "SFDegreesCentroid.h"
#import "SFGeometryConstants.h"

@implementation SFGeometryUtils

+(int) dimensionOfGeometry: (SFGeometry *) geometry{
    
    int dimension = -1;
    
    enum SFGeometryType geometryType = geometry.geometryType;
    switch (geometryType) {
        case SF_POINT:
        case SF_MULTIPOINT:
            dimension = 0;
            break;
        case SF_LINESTRING:
        case SF_MULTILINESTRING:
        case SF_CIRCULARSTRING:
        case SF_COMPOUNDCURVE:
            dimension = 1;
            break;
        case SF_POLYGON:
        case SF_CURVEPOLYGON:
        case SF_MULTIPOLYGON:
        case SF_POLYHEDRALSURFACE:
        case SF_TIN:
        case SF_TRIANGLE:
            dimension = 2;
            break;
        case SF_GEOMETRYCOLLECTION:
        case SF_MULTICURVE:
        case SF_MULTISURFACE:
            {
                SFGeometryCollection *geomCollection = (SFGeometryCollection *) geometry;
                for (SFGeometry *subGeometry in geomCollection.geometries) {
                    dimension = MAX(dimension, [self dimensionOfGeometry:subGeometry]);
                }
            }
            break;
        default:
            [NSException raise:@"Geometry Not Supported" format:@"Unsupported Geometry Type: %d", geometryType];
    }
    
    return dimension;
}

+(double) distanceBetweenPoint1: (SFPoint *) point1 andPoint2: (SFPoint *) point2{
    double diffX = [point1.x doubleValue] - [point2.x doubleValue];
    double diffY = [point1.y doubleValue] - [point2.y doubleValue];
    return sqrt(diffX * diffX + diffY * diffY);
}

+(double) distanceOfLine: (SFLine *) line{
    return [self distanceBetweenPoint1:[line startPoint] andPoint2:[line endPoint]];
}

+(double) bearingBetweenPoint1: (SFPoint *) point1 andPoint2: (SFPoint *) point2{
    double y1 = [self degreesToRadians:[point1.y doubleValue]];
    double y2 = [self degreesToRadians:[point2.y doubleValue]];
    double xDiff = [self degreesToRadians:[point2.x doubleValue] - [point1.x doubleValue]];
    double y = sin(xDiff) * cos(y2);
    double x = cos(y1) * sin(y2) - sin(y1) * cos(y2) * cos(xDiff);
    return fmod([self radiansToDegrees:atan2(y, x)] + 360, 360);
}

+(double) bearingOfLine: (SFLine *) line{
    return [self bearingBetweenPoint1:[line startPoint] andPoint2:[line endPoint]];
}

+(BOOL) isNorthBearing: (double) bearing{
    bearing = fmod(bearing, 360.0);
    return bearing < SF_BEARING_EAST || bearing > SF_BEARING_WEST;
}

+(BOOL) isEastBearing: (double) bearing{
    bearing = fmod(bearing, 360.0);
    return bearing > SF_BEARING_NORTH && bearing < SF_BEARING_SOUTH;
}

+(BOOL) isSouthBearing: (double) bearing{
    bearing = fmod(bearing, 360.0);
    return bearing > SF_BEARING_EAST && bearing < SF_BEARING_WEST;
}

+(BOOL) isWestBearing: (double) bearing{
    return fmod(bearing, 360.0) > SF_BEARING_SOUTH;
}

+(double) degreesToRadians: (double) degrees{
    return degrees * SF_DEGREES_TO_RADIANS;
}

+(double) radiansToDegrees: (double) radians{
    return radians * SF_RADIANS_TO_DEGREES;
}

+(SFPoint *) centroidOfGeometry: (SFGeometry *) geometry{
    SFPoint *centroid = nil;
    int dimension = [self dimensionOfGeometry:geometry];
    switch (dimension) {
        case 0:
            {
                SFCentroidPoint *point = [[SFCentroidPoint alloc] initWithGeometry: geometry];
                centroid = [point centroid];
            }
            break;
        case 1:
            {
                SFCentroidCurve *curve = [[SFCentroidCurve alloc] initWithGeometry: geometry];
                centroid = [curve centroid];
            }
            break;
        case 2:
            {
                SFCentroidSurface *surface = [[SFCentroidSurface alloc] initWithGeometry: geometry];
                centroid = [surface centroid];
            }
            break;
    }
    return centroid;
}

+(SFPoint *) degreesCentroidOfGeometry: (SFGeometry *) geometry{
    return [SFDegreesCentroid centroidOfGeometry:geometry];
}

+(void) minimizeWGS84Geometry: (SFGeometry *) geometry{
    [self minimizeGeometry:geometry withMaxX:SF_WGS84_HALF_WORLD_LON_WIDTH];
}

+(void) minimizeWebMercatorGeometry: (SFGeometry *) geometry{
    [self minimizeGeometry:geometry withMaxX:SF_WEB_MERCATOR_HALF_WORLD_WIDTH];
}

+(void) minimizeGeometry: (SFGeometry *) geometry withMaxX: (double) maxX{
    
    enum SFGeometryType geometryType = geometry.geometryType;
    switch (geometryType) {
        case SF_LINESTRING:
            [self minimizeLineString:(SFLineString *)geometry withMaxX:maxX];
            break;
        case SF_POLYGON:
            [self minimizePolygon:(SFPolygon *)geometry withMaxX:maxX];
            break;
        case SF_MULTILINESTRING:
            [self minimizeMultiLineString:(SFMultiLineString *)geometry withMaxX:maxX];
            break;
        case SF_MULTIPOLYGON:
            [self minimizeMultiPolygon:(SFMultiPolygon *)geometry withMaxX:maxX];
            break;
        case SF_CIRCULARSTRING:
            [self minimizeLineString:(SFCircularString *)geometry withMaxX:maxX];
            break;
        case SF_COMPOUNDCURVE:
            [self minimizeCompoundCurve:(SFCompoundCurve *)geometry withMaxX:maxX];
            break;
        case SF_CURVEPOLYGON:
            [self minimizeCurvePolygon:(SFCurvePolygon *)geometry withMaxX:maxX];
            break;
        case SF_POLYHEDRALSURFACE:
            [self minimizePolyhedralSurface:(SFPolyhedralSurface *)geometry withMaxX:maxX];
            break;
        case SF_TIN:
            [self minimizePolyhedralSurface:(SFTIN *)geometry withMaxX:maxX];
            break;
        case SF_TRIANGLE:
            [self minimizePolygon:(SFTriangle *)geometry withMaxX:maxX];
            break;
        case SF_GEOMETRYCOLLECTION:
        case SF_MULTICURVE:
        case SF_MULTISURFACE:
            {
                SFGeometryCollection *geomCollection = (SFGeometryCollection *) geometry;
                for (SFGeometry *subGeometry in geomCollection.geometries) {
                    [self minimizeGeometry:subGeometry withMaxX:maxX];
                }
            }
            break;
        default:
            break;
            
    }
    
}

+(void) minimizeLineString: (SFLineString *) lineString withMaxX: (double) maxX{
    
    NSMutableArray *points = lineString.points;
    if(points.count > 1){
        SFPoint *point = [points objectAtIndex:0];
        for(int i = 1; i < points.count; i++){
            SFPoint *nextPoint = [points objectAtIndex:i];
            if([point.x doubleValue] < [nextPoint.x doubleValue]){
                if([nextPoint.x doubleValue] - [point.x doubleValue] > [point.x doubleValue] - [nextPoint.x doubleValue] + (maxX * 2.0)){
                    [nextPoint setX:[nextPoint.x decimalNumberBySubtracting:[[NSDecimalNumber alloc] initWithDouble: maxX * 2.0]]];
                }
            }else if([point.x doubleValue] > [nextPoint.x doubleValue]){
                if([point.x doubleValue] - [nextPoint.x doubleValue] > [nextPoint.x doubleValue] - [point.x doubleValue] + (maxX * 2.0)){
                    [nextPoint setX:[nextPoint.x decimalNumberByAdding:[[NSDecimalNumber alloc] initWithDouble: maxX * 2.0]]];
                }
            }
        }
    }
}

+(void) minimizeMultiLineString: (SFMultiLineString *) multiLineString withMaxX: (double) maxX{
    
    NSArray *lineStrings = [multiLineString lineStrings];
    for(SFLineString *lineString in lineStrings){
        [self minimizeLineString:lineString withMaxX:maxX];
    }
}

+(void) minimizePolygon: (SFPolygon *) polygon withMaxX: (double) maxX{
    
    for(SFLineString *ring in polygon.rings){
        [self minimizeLineString:ring withMaxX:maxX];
    }
}

+(void) minimizeMultiPolygon: (SFMultiPolygon *) multiPolygon withMaxX: (double) maxX{
    
    NSArray *polygons = [multiPolygon polygons];
    for(SFPolygon *polygon in polygons){
        [self minimizePolygon:polygon withMaxX:maxX];
    }
}

+(void) minimizeCompoundCurve: (SFCompoundCurve *) compoundCurve withMaxX: (double) maxX{
    
    for(SFLineString *lineString in compoundCurve.lineStrings){
        [self minimizeLineString:lineString withMaxX:maxX];
    }
}

+(void) minimizeCurvePolygon: (SFCurvePolygon *) curvePolygon withMaxX: (double) maxX{
    
    for(SFCurve *ring in curvePolygon.rings){
        [self minimizeGeometry:ring withMaxX:maxX];
    }
}

+(void) minimizePolyhedralSurface: (SFPolyhedralSurface *) polyhedralSurface withMaxX: (double) maxX{
    
    for(SFPolygon *polygon in polyhedralSurface.polygons){
        [self minimizePolygon:polygon withMaxX:maxX];
    }
}

+(void) normalizeWGS84Geometry: (SFGeometry *) geometry{
    [self normalizeGeometry:geometry withMaxX:SF_WGS84_HALF_WORLD_LON_WIDTH];
}

+(void) normalizeWebMercatorGeometry: (SFGeometry *) geometry{
    [self normalizeGeometry:geometry withMaxX:SF_WEB_MERCATOR_HALF_WORLD_WIDTH];
}

+(void) normalizeGeometry: (SFGeometry *) geometry withMaxX: (double) maxX{
    
    enum SFGeometryType geometryType = geometry.geometryType;
    switch (geometryType) {
        case SF_POINT:
            [self normalizePoint:(SFPoint *)geometry withMaxX:maxX];
            break;
        case SF_LINESTRING:
            [self normalizeLineString:(SFLineString *)geometry withMaxX:maxX];
            break;
        case SF_POLYGON:
            [self normalizePolygon:(SFPolygon *)geometry withMaxX:maxX];
            break;
        case SF_MULTIPOINT:
            [self normalizeMultiPoint:(SFMultiPoint *)geometry withMaxX:maxX];
            break;
        case SF_MULTILINESTRING:
            [self normalizeMultiLineString:(SFMultiLineString *)geometry withMaxX:maxX];
            break;
        case SF_MULTIPOLYGON:
            [self normalizeMultiPolygon:(SFMultiPolygon *)geometry withMaxX:maxX];
            break;
        case SF_CIRCULARSTRING:
            [self normalizeLineString:(SFCircularString *)geometry withMaxX:maxX];
            break;
        case SF_COMPOUNDCURVE:
            [self normalizeCompoundCurve:(SFCompoundCurve *)geometry withMaxX:maxX];
            break;
        case SF_CURVEPOLYGON:
            [self normalizeCurvePolygon:(SFCurvePolygon *)geometry withMaxX:maxX];
            break;
        case SF_POLYHEDRALSURFACE:
            [self normalizePolyhedralSurface:(SFPolyhedralSurface *)geometry withMaxX:maxX];
            break;
        case SF_TIN:
            [self normalizePolyhedralSurface:(SFTIN *)geometry withMaxX:maxX];
            break;
        case SF_TRIANGLE:
            [self normalizePolygon:(SFTriangle *)geometry withMaxX:maxX];
            break;
        case SF_GEOMETRYCOLLECTION:
        case SF_MULTICURVE:
        case SF_MULTISURFACE:
            {
                SFGeometryCollection *geomCollection = (SFGeometryCollection *) geometry;
                for (SFGeometry *subGeometry in geomCollection.geometries) {
                    [self normalizeGeometry:subGeometry withMaxX:maxX];
                }
            }
            break;
        default:
            break;
            
    }
    
}

+(void) normalizePoint: (SFPoint *) point withMaxX: (double) maxX{
    [point setX:[[NSDecimalNumber alloc] initWithDouble:[self normalizeX:[point.x doubleValue] withMaxX:maxX]]];
}

+(double) normalizeX: (double) x withMaxX: (double) maxX{
    if(x < -maxX){
        x = x + (maxX * 2.0);
    }else if (x > maxX){
        x = x - (maxX * 2.0);
    }
    return x;
}

+(void) normalizeMultiPoint: (SFMultiPoint *) multiPoint withMaxX: (double) maxX{
    
    NSArray *points = [multiPoint points];
    for(SFPoint *point in points){
        [self normalizePoint:point withMaxX:maxX];
    }
}

+(void) normalizeLineString: (SFLineString *) lineString withMaxX: (double) maxX{
    
    for(SFPoint *point in lineString.points){
        [self normalizePoint:point withMaxX:maxX];
    }
}

+(void) normalizeMultiLineString: (SFMultiLineString *) multiLineString withMaxX: (double) maxX{
    
    NSArray *lineStrings = [multiLineString lineStrings];
    for(SFLineString *lineString in lineStrings){
        [self normalizeLineString:lineString withMaxX:maxX];
    }
}

+(void) normalizePolygon: (SFPolygon *) polygon withMaxX: (double) maxX{
    
    for(SFLineString *ring in polygon.rings){
        [self normalizeLineString:ring withMaxX:maxX];
    }
}

+(void) normalizeMultiPolygon: (SFMultiPolygon *) multiPolygon withMaxX: (double) maxX{
    
    NSArray *polygons = [multiPolygon polygons];
    for(SFPolygon *polygon in polygons){
        [self normalizePolygon:polygon withMaxX:maxX];
    }
}

+(void) normalizeCompoundCurve: (SFCompoundCurve *) compoundCurve withMaxX: (double) maxX{
    
    for(SFLineString *lineString in compoundCurve.lineStrings){
        [self normalizeLineString:lineString withMaxX:maxX];
    }
}

+(void) normalizeCurvePolygon: (SFCurvePolygon *) curvePolygon withMaxX: (double) maxX{
    
    for(SFCurve *ring in curvePolygon.rings){
        [self normalizeGeometry:ring withMaxX:maxX];
    }
}

+(void) normalizePolyhedralSurface: (SFPolyhedralSurface *) polyhedralSurface withMaxX: (double) maxX{
    
    for(SFPolygon *polygon in polyhedralSurface.polygons){
        [self normalizePolygon:polygon withMaxX:maxX];
    }
}

+ (NSArray<SFPoint *> *) simplifyPoints: (NSArray<SFPoint *> *) points withTolerance : (double) tolerance{
    return [self simplifyPoints:points withTolerance:tolerance andStartIndex:0 andEndIndex:(int)[points count]-1];
}

+(NSArray<SFPoint *> *) simplifyPoints: (NSArray<SFPoint *> *) points withTolerance: (double) tolerance andStartIndex: (int) startIndex andEndIndex: (int) endIndex {
    
    NSArray *result = nil;
    
    double dmax = 0.0;
    int index = 0;
    
    SFPoint *startPoint = [points objectAtIndex:startIndex];
    SFPoint *endPoint = [points objectAtIndex:endIndex];
    
    for (int i = startIndex + 1; i < endIndex; i++) {
        SFPoint *point = [points objectAtIndex:i];
        
        double d = [SFGeometryUtils perpendicularDistanceBetweenPoint:point lineStart:startPoint lineEnd:endPoint];
        
        if (d > dmax) {
            index = i;
            dmax = d;
        }
    }
    
    if (dmax > tolerance) {
        
        NSArray *recResults1 = [self simplifyPoints:points withTolerance:tolerance andStartIndex:startIndex andEndIndex:index];
        NSArray *recResults2 = [self simplifyPoints:points withTolerance:tolerance andStartIndex:index andEndIndex:endIndex];
        
        result = [recResults1 subarrayWithRange:NSMakeRange(0, recResults1.count - 1)];
        result = [result arrayByAddingObjectsFromArray:recResults2];
        
    }else{
        result = [NSArray arrayWithObjects:startPoint, endPoint, nil];
    }
    
    return result;
}

+(double) perpendicularDistanceBetweenPoint: (SFPoint *) point lineStart: (SFPoint *) lineStart lineEnd: (SFPoint *) lineEnd {
    
    double x = [point.x doubleValue];
    double y = [point.y doubleValue];
    double startX = [lineStart.x doubleValue];
    double startY = [lineStart.y doubleValue];
    double endX = [lineEnd.x doubleValue];
    double endY = [lineEnd.y doubleValue];
    
    double vX = endX - startX;
    double vY = endY - startY;
    double wX = x - startX;
    double wY = y - startY;
    double c1 = wX * vX + wY * vY;
    double c2 = vX * vX + vY * vY;
    
    double x2;
    double y2;
    if(c1 <=0){
        x2 = startX;
        y2 = startY;
    }else if(c2 <= c1){
        x2 = endX;
        y2 = endY;
    }else{
        double b = c1 / c2;
        x2 = startX + b * vX;
        y2 = startY + b * vY;
    }
    
    double distance = sqrt(pow(x2 - x, 2) + pow(y2 - y, 2));
    
    return distance;
}

+(BOOL) point: (SFPoint *) point inPolygon: (SFPolygon *) polygon{
    return [self point:point inPolygon:polygon withEpsilon:SF_DEFAULT_LINE_EPSILON];
}

+(BOOL) point: (SFPoint *) point inPolygon: (SFPolygon *) polygon withEpsilon: (double) epsilon{
    
    BOOL contains = NO;
    NSArray *rings = polygon.rings;
    if(rings.count > 0){
        contains = [self point:point inPolygonRing:[rings objectAtIndex:0] withEpsilon:epsilon];
        if(contains){
            // Check the holes
            for(int i = 1; i < rings.count; i++){
                if([self point:point inPolygonRing:[rings objectAtIndex:i] withEpsilon:epsilon]){
                    contains = NO;
                    break;
                }
            }
        }
    }
    
    return contains;
}

+(BOOL) point: (SFPoint *) point inPolygonRing: (SFLineString *) ring{
    return [self point:point inPolygonRing:ring withEpsilon:SF_DEFAULT_LINE_EPSILON];
}

+(BOOL) point: (SFPoint *) point inPolygonRing: (SFLineString *) ring withEpsilon: (double) epsilon{
    return [self point:point inPolygonPoints:ring.points withEpsilon:epsilon];
}

+(BOOL) point: (SFPoint *) point inPolygonPoints: (NSArray<SFPoint *> *) points{
    return [self point:point inPolygonPoints:points withEpsilon:SF_DEFAULT_LINE_EPSILON];
}

+(BOOL) point: (SFPoint *) point inPolygonPoints: (NSArray<SFPoint *> *) points withEpsilon: (double) epsilon{
    
    BOOL contains = NO;
    
    int i = 0;
    int j = (int)points.count - 1;
    if([self closedPolygonPoints:points]){
        j = i++;
    }
    
    for(; i < points.count; j = i++){
        SFPoint *point1 = [points objectAtIndex:i];
        SFPoint *point2 = [points objectAtIndex:j];
        
        double px = [point.x doubleValue];
        double py = [point.y doubleValue];
        
        double p1x = [point1.x doubleValue];
        double p1y = [point1.y doubleValue];
        
        // Shortcut check if polygon contains the point within tolerance
        if(fabs(p1x - px) <= epsilon && fabs(p1y - py) <= epsilon){
            contains = YES;
            break;
        }
        
        double p2x = [point2.x doubleValue];
        double p2y = [point2.y doubleValue];
        
        if(((p1y > py) != (p2y > py))
           && (px < (p2x - p1x) * (py - p1y) / (p2y - p1y) + p1x)){
            contains = !contains;
        }
    }
    
    if(!contains){
        // Check the polygon edges
        contains = [self point:point onPolygonPointsEdge:points];
    }
    
    return contains;
}

+(BOOL) point: (SFPoint *) point onPolygonEdge: (SFPolygon *) polygon{
    return [self point:point onPolygonEdge:polygon withEpsilon:SF_DEFAULT_LINE_EPSILON];
}

+(BOOL) point: (SFPoint *) point onPolygonEdge: (SFPolygon *) polygon withEpsilon: (double) epsilon{
    return [polygon numRings] > 0 && [self point:point onPolygonRingEdge:[polygon ringAtIndex:0] withEpsilon:epsilon];
}

+(BOOL) point: (SFPoint *) point onPolygonRingEdge: (SFLineString *) ring{
    return [self point:point onPolygonRingEdge:ring withEpsilon:SF_DEFAULT_LINE_EPSILON];
}

+(BOOL) point: (SFPoint *) point onPolygonRingEdge: (SFLineString *) ring withEpsilon: (double) epsilon{
    return [self point:point onPolygonPointsEdge:ring.points withEpsilon:epsilon];
}

+(BOOL) point: (SFPoint *) point onPolygonPointsEdge: (NSArray<SFPoint *> *) points{
    return [self point:point onPolygonPointsEdge:points withEpsilon:SF_DEFAULT_LINE_EPSILON];
}

+(BOOL) point: (SFPoint *) point onPolygonPointsEdge: (NSArray<SFPoint *> *) points withEpsilon: (double) epsilon{
    return [self point:point onPath:points withEpsilon:epsilon andCircular:![self closedPolygonPoints:points]];
}

+(BOOL) closedPolygon: (SFPolygon *) polygon{
    return [polygon numRings] > 0 && [self closedPolygonRing:[polygon ringAtIndex:0]];
}

+(BOOL) closedPolygonRing: (SFLineString *) ring{
    return [self closedPolygonPoints:ring.points];
}

+(BOOL) closedPolygonPoints: (NSArray<SFPoint *> *) points{
    BOOL closed = NO;
    if(points.count > 0){
        SFPoint *first = [points objectAtIndex:0];
        SFPoint *last = [points objectAtIndex:points.count - 1];
        closed = [first.x compare:last.x] == NSOrderedSame && [first.y compare:last.y] == NSOrderedSame;
    }
    return closed;
}

+(BOOL) point: (SFPoint *) point onLine: (SFLineString *) line{
    return [self point:point onLine:line withEpsilon:SF_DEFAULT_LINE_EPSILON];
}

+(BOOL) point: (SFPoint *) point onLine: (SFLineString *) line withEpsilon: (double) epsilon{
    return [self point:point onLinePoints:line.points withEpsilon:epsilon];
}

+(BOOL) point: (SFPoint *) point onLinePoints: (NSArray<SFPoint *> *) points{
    return [self point:point onLinePoints:points withEpsilon:SF_DEFAULT_LINE_EPSILON];
}

+(BOOL) point: (SFPoint *) point onLinePoints: (NSArray<SFPoint *> *) points withEpsilon: (double) epsilon{
    return [self point:point onPath:points withEpsilon:epsilon andCircular:NO];
}

+(BOOL) point: (SFPoint *) point onPathPoint1: (SFPoint *) point1 andPoint2: (SFPoint *) point2{
    return [self point:point onPathPoint1:point1 andPoint2:point2 withEpsilon:SF_DEFAULT_LINE_EPSILON];
}

+(BOOL) point: (SFPoint *) point onPathPoint1: (SFPoint *) point1 andPoint2: (SFPoint *) point2 withEpsilon: (double) epsilon{
    
    BOOL contains = NO;
    
    double px = [point.x doubleValue];
    double py = [point.y doubleValue];
    double p1x = [point1.x doubleValue];
    double p1y = [point1.y doubleValue];
    double p2x = [point2.x doubleValue];
    double p2y = [point2.y doubleValue];
    
    double x21 = p2x - p1x;
    double y21 = p2y - p1y;
    double xP1 = px - p1x;
    double yP1 = py - p1y;
    
    double dp = xP1 * x21 + yP1 * y21;
    if(dp >= 0.0){
        
        double lengthP1 = xP1 * xP1 + yP1 * yP1;
        double length21 = x21 * x21 + y21 * y21;
        
        if(lengthP1 <= length21){
            contains = fabs(dp * dp - lengthP1 * length21) <= epsilon;
        }
    }
    
    return contains;
}

+(BOOL) point: (SFPoint *) point onPath: (NSArray<SFPoint *> *) points withEpsilon: (double) epsilon andCircular: (BOOL) circular{
    
    BOOL onPath = NO;
    
    int i = 0;
    int j = (int)points.count - 1;
    if(!circular){
        j = i++;
    }
    
    for(; i < points.count; j= i++){
        SFPoint *point1 = [points objectAtIndex:i];
        SFPoint *point2 = [points objectAtIndex:j];
        if([self point:point onPathPoint1:point1 andPoint2:point2 withEpsilon:epsilon]){
            onPath = YES;
            break;
        }
    }
    
    return onPath;
}

+(SFPoint *) intersectionBetweenLine1: (SFLine *) line1 andLine2: (SFLine *) line2{
    return [self intersectionBetweenLine1Point1:[line1 startPoint] andLine1Point2:[line1 endPoint] andLine2Point1:[line2 startPoint] andLine2Point2:[line2 endPoint]];
}

+(SFPoint *) intersectionBetweenLine1Point1: (SFPoint *) line1Point1 andLine1Point2: (SFPoint *) line1Point2 andLine2Point1: (SFPoint *) line2Point1 andLine2Point2: (SFPoint *) line2Point2{

    SFPoint *intersection = nil;

    double a1 = [line1Point2.y doubleValue] - [line1Point1.y doubleValue];
    double b1 = [line1Point1.x doubleValue] - [line1Point2.x doubleValue];
    double c1 = a1 * [line1Point1.x doubleValue] + b1 * [line1Point1.y doubleValue];

    double a2 = [line2Point2.y doubleValue] - [line2Point1.y doubleValue];
    double b2 = [line2Point1.x doubleValue] - [line2Point2.x doubleValue];
    double c2 = a2 * [line2Point1.x doubleValue] + b2 * [line2Point1.y doubleValue];

    double determinant = a1 * b2 - a2 * b1;

    if (determinant != 0) {
        double x = (b2 * c1 - b1 * c2) / determinant;
        double y = (a1 * c2 - a2 * c1) / determinant;
        intersection = [SFPoint pointWithXValue:x andYValue:y];
    }

    return intersection;
}

+(SFGeometry *) degreesToMetersWithGeometry: (SFGeometry *) geometry{
    
    SFGeometry *meters = nil;
    
    switch (geometry.geometryType) {
        case SF_POINT:
            meters = [self degreesToMetersWithPoint:(SFPoint *) geometry];
            break;
        case SF_LINESTRING:
            meters = [self degreesToMetersWithLineString:(SFLineString *) geometry];
            break;
        case SF_POLYGON:
            meters = [self degreesToMetersWithPolygon:(SFPolygon *) geometry];
            break;
        case SF_MULTIPOINT:
            meters = [self degreesToMetersWithMultiPoint:(SFMultiPoint *) geometry];
            break;
        case SF_MULTILINESTRING:
            meters = [self degreesToMetersWithMultiLineString:(SFMultiLineString *) geometry];
            break;
        case SF_MULTIPOLYGON:
            meters = [self degreesToMetersWithMultiPolygon:(SFMultiPolygon *) geometry];
            break;
        case SF_CIRCULARSTRING:
            meters = [self degreesToMetersWithCircularString:(SFCircularString *) geometry];
            break;
        case SF_COMPOUNDCURVE:
            meters = [self degreesToMetersWithCompoundCurve:(SFCompoundCurve *) geometry];
            break;
        case SF_CURVEPOLYGON:
            meters = [self degreesToMetersWithCurvePolygon:(SFCurvePolygon *) geometry];
            break;
        case SF_POLYHEDRALSURFACE:
            meters = [self degreesToMetersWithPolyhedralSurface:(SFPolyhedralSurface *) geometry];
            break;
        case SF_TIN:
            meters = [self degreesToMetersWithTIN:(SFTIN *) geometry];
            break;
        case SF_TRIANGLE:
            meters = [self degreesToMetersWithTriangle:(SFTriangle *) geometry];
            break;
        case SF_GEOMETRYCOLLECTION:
        case SF_MULTICURVE:
        case SF_MULTISURFACE:
            {
                SFGeometryCollection *metersCollection = [SFGeometryCollection geometryCollection];
                SFGeometryCollection *geomCollection = (SFGeometryCollection *) geometry;
                for (SFGeometry *subGeometry in geomCollection.geometries) {
                    [metersCollection addGeometry:[self degreesToMetersWithGeometry:subGeometry]];
                }
                meters = metersCollection;
            }
            break;
        default:
            break;
            
    }
    
    return meters;
}

+(SFPoint *) degreesToMetersWithPoint: (SFPoint *) point{
    SFPoint *value = [self degreesToMetersWithX:[point.x doubleValue] andY:[point.y doubleValue]];
    [value setZ:point.z];
    [value setM:point.m];
    return value;
}

+(SFPoint *) degreesToMetersWithX: (double) x andY: (double) y{
    x = [self normalizeX:x withMaxX:SF_WGS84_HALF_WORLD_LON_WIDTH];
    y = MIN(y, SF_WGS84_HALF_WORLD_LAT_HEIGHT);
    y = MAX(y, SF_DEGREES_TO_METERS_MIN_LAT);
    double xValue = x * SF_WEB_MERCATOR_HALF_WORLD_WIDTH
            / SF_WGS84_HALF_WORLD_LON_WIDTH;
    double yValue = log(tan(
            (SF_WGS84_HALF_WORLD_LAT_HEIGHT + y) * M_PI
                    / (2 * SF_WGS84_HALF_WORLD_LON_WIDTH)))
            / (M_PI / SF_WGS84_HALF_WORLD_LON_WIDTH);
    yValue = yValue * SF_WEB_MERCATOR_HALF_WORLD_WIDTH
            / SF_WGS84_HALF_WORLD_LON_WIDTH;
    return [SFPoint pointWithXValue:xValue andYValue:yValue];
}

+(SFMultiPoint *) degreesToMetersWithMultiPoint: (SFMultiPoint *) multiPoint{
    SFMultiPoint *meters = [SFMultiPoint multiPointWithHasZ:multiPoint.hasZ andHasM:multiPoint.hasM];
    for(SFPoint *point in [multiPoint points]){
        [meters addPoint:[self degreesToMetersWithPoint:point]];
    }
    return meters;
}

+(SFLineString *) degreesToMetersWithLineString: (SFLineString *) lineString{
    SFLineString *meters = [SFLineString lineStringWithHasZ:lineString.hasZ andHasM:lineString.hasM];
    for(SFPoint *point in [lineString points]){
        [meters addPoint:[self degreesToMetersWithPoint:point]];
    }
    return meters;
}

+(SFLine *) degreesToMetersWithLine: (SFLine *) line{
    SFLine *meters = [SFLine lineWithHasZ:line.hasZ andHasM:line.hasM];
    for(SFPoint *point in [line points]){
        [meters addPoint:[self degreesToMetersWithPoint:point]];
    }
    return meters;
}

+(SFMultiLineString *) degreesToMetersWithMultiLineString: (SFMultiLineString *) multiLineString{
    SFMultiLineString *meters = [SFMultiLineString multiLineStringWithHasZ:multiLineString.hasZ andHasM:multiLineString.hasM];
    for(SFLineString *lineString in [multiLineString lineStrings]){
        [meters addLineString:[self degreesToMetersWithLineString:lineString]];
    }
    return meters;
}

+(SFPolygon *) degreesToMetersWithPolygon: (SFPolygon *) polygon{
    SFPolygon *meters = [SFPolygon polygonWithHasZ:polygon.hasZ andHasM:polygon.hasM];
    for(SFLineString *ring in [polygon rings]){
        [meters addRing:[self degreesToMetersWithLineString:ring]];
    }
    return meters;
}

+(SFMultiPolygon *) degreesToMetersWithMultiPolygon: (SFMultiPolygon *) multiPolygon{
    SFMultiPolygon *meters = [SFMultiPolygon multiPolygonWithHasZ:multiPolygon.hasZ andHasM:multiPolygon.hasM];
    for(SFPolygon *polygon in [multiPolygon polygons]){
        [meters addPolygon:[self degreesToMetersWithPolygon:polygon]];
    }
    return meters;
}

+(SFCircularString *) degreesToMetersWithCircularString: (SFCircularString *) circularString{
    SFCircularString *meters = [SFCircularString circularStringWithHasZ:circularString.hasZ andHasM:circularString.hasM];
    for(SFPoint *point in [circularString points]){
        [meters addPoint:[self degreesToMetersWithPoint:point]];
    }
    return meters;
}

+(SFCompoundCurve *) degreesToMetersWithCompoundCurve: (SFCompoundCurve *) compoundCurve{
    SFCompoundCurve *meters = [SFCompoundCurve compoundCurveWithHasZ:compoundCurve.hasZ andHasM:compoundCurve.hasM];
    for(SFLineString *lineString in [compoundCurve lineStrings]){
        [meters addLineString:[self degreesToMetersWithLineString:lineString]];
    }
    return meters;
}

+(SFCurvePolygon *) degreesToMetersWithCurvePolygon: (SFCurvePolygon *) curvePolygon{
    SFCurvePolygon *meters = [SFCurvePolygon curvePolygonWithHasZ:curvePolygon.hasZ andHasM:curvePolygon.hasM];
    for(SFCurve *ring in [curvePolygon rings]){
        [meters addRing:(SFCurve *)[self degreesToMetersWithGeometry:ring]];
    }
    return meters;
}

+(SFPolyhedralSurface *) degreesToMetersWithPolyhedralSurface: (SFPolyhedralSurface *) polyhedralSurface{
    SFPolyhedralSurface *meters = [SFPolyhedralSurface polyhedralSurfaceWithHasZ:polyhedralSurface.hasZ andHasM:polyhedralSurface.hasM];
    for(SFPolygon *polygon in [polyhedralSurface polygons]){
        [meters addPolygon:[self degreesToMetersWithPolygon:polygon]];
    }
    return meters;
}

+(SFTIN *) degreesToMetersWithTIN: (SFTIN *) tin{
    SFTIN *meters = [SFTIN tinWithHasZ:tin.hasZ andHasM:tin.hasM];
    for(SFPolygon *polygon in [tin polygons]){
        [meters addPolygon:[self degreesToMetersWithPolygon:polygon]];
    }
    return meters;
}

+(SFTriangle *) degreesToMetersWithTriangle: (SFTriangle *) triangle{
    SFTriangle *meters = [SFTriangle triangleWithHasZ:triangle.hasZ andHasM:triangle.hasM];
    for(SFLineString *ring in [triangle rings]){
        [meters addRing:[self degreesToMetersWithLineString:ring]];
    }
    return meters;
}

+(SFGeometry *) metersToDegreesWithGeometry: (SFGeometry *) geometry{
    
    SFGeometry *degrees = nil;
    
    switch (geometry.geometryType) {
        case SF_POINT:
            degrees = [self metersToDegreesWithPoint:(SFPoint *) geometry];
            break;
        case SF_LINESTRING:
            degrees = [self metersToDegreesWithLineString:(SFLineString *) geometry];
            break;
        case SF_POLYGON:
            degrees = [self metersToDegreesWithPolygon:(SFPolygon *) geometry];
            break;
        case SF_MULTIPOINT:
            degrees = [self metersToDegreesWithMultiPoint:(SFMultiPoint *) geometry];
            break;
        case SF_MULTILINESTRING:
            degrees = [self metersToDegreesWithMultiLineString:(SFMultiLineString *) geometry];
            break;
        case SF_MULTIPOLYGON:
            degrees = [self metersToDegreesWithMultiPolygon:(SFMultiPolygon *) geometry];
            break;
        case SF_CIRCULARSTRING:
            degrees = [self metersToDegreesWithCircularString:(SFCircularString *) geometry];
            break;
        case SF_COMPOUNDCURVE:
            degrees = [self metersToDegreesWithCompoundCurve:(SFCompoundCurve *) geometry];
            break;
        case SF_CURVEPOLYGON:
            degrees = [self metersToDegreesWithCurvePolygon:(SFCurvePolygon *) geometry];
            break;
        case SF_POLYHEDRALSURFACE:
            degrees = [self metersToDegreesWithPolyhedralSurface:(SFPolyhedralSurface *) geometry];
            break;
        case SF_TIN:
            degrees = [self metersToDegreesWithTIN:(SFTIN *) geometry];
            break;
        case SF_TRIANGLE:
            degrees = [self metersToDegreesWithTriangle:(SFTriangle *) geometry];
            break;
        case SF_GEOMETRYCOLLECTION:
        case SF_MULTICURVE:
        case SF_MULTISURFACE:
            {
                SFGeometryCollection *degreesCollection = [SFGeometryCollection geometryCollection];
                SFGeometryCollection *geomCollection = (SFGeometryCollection *) geometry;
                for (SFGeometry *subGeometry in geomCollection.geometries) {
                    [degreesCollection addGeometry:[self metersToDegreesWithGeometry:subGeometry]];
                }
                degrees = degreesCollection;
            }
            break;
        default:
            break;
            
    }
    
    return degrees;
}

+(SFPoint *) metersToDegreesWithPoint: (SFPoint *) point{
    SFPoint *value = [self metersToDegreesWithX:[point.x doubleValue] andY:[point.y doubleValue]];
    [value setZ:point.z];
    [value setM:point.m];
    return value;
}

+(SFPoint *) metersToDegreesWithX: (double) x andY: (double) y{
    double xValue = x * SF_WGS84_HALF_WORLD_LON_WIDTH
            / SF_WEB_MERCATOR_HALF_WORLD_WIDTH;
    double yValue = y * SF_WGS84_HALF_WORLD_LON_WIDTH
            / SF_WEB_MERCATOR_HALF_WORLD_WIDTH;
    yValue = atan(exp(yValue
            * (M_PI / SF_WGS84_HALF_WORLD_LON_WIDTH)))
            / M_PI * (2 * SF_WGS84_HALF_WORLD_LON_WIDTH)
            - SF_WGS84_HALF_WORLD_LAT_HEIGHT;
    return [SFPoint pointWithXValue:xValue andYValue:yValue];
}

+(SFMultiPoint *) metersToDegreesWithMultiPoint: (SFMultiPoint *) multiPoint{
    SFMultiPoint *degrees = [SFMultiPoint multiPointWithHasZ:multiPoint.hasZ andHasM:multiPoint.hasM];
    for(SFPoint *point in [multiPoint points]){
        [degrees addPoint:[self metersToDegreesWithPoint:point]];
    }
    return degrees;
}

+(SFLineString *) metersToDegreesWithLineString: (SFLineString *) lineString{
    SFLineString *degrees = [SFLineString lineStringWithHasZ:lineString.hasZ andHasM:lineString.hasM];
    for(SFPoint *point in lineString.points){
        [degrees addPoint:[self metersToDegreesWithPoint:point]];
    }
    return degrees;
}

+(SFLine *) metersToDegreesWithLine: (SFLine *) line{
    SFLine *degrees = [SFLine lineWithHasZ:line.hasZ andHasM:line.hasM];
    for(SFPoint *point in line.points){
        [degrees addPoint:[self metersToDegreesWithPoint:point]];
    }
    return degrees;
}

+(SFMultiLineString *) metersToDegreesWithMultiLineString: (SFMultiLineString *) multiLineString{
    SFMultiLineString *degrees = [SFMultiLineString multiLineStringWithHasZ:multiLineString.hasZ andHasM:multiLineString.hasM];
    for(SFLineString *lineString in [multiLineString lineStrings]){
        [degrees addLineString:[self metersToDegreesWithLineString:lineString]];
    }
    return degrees;
}

+(SFPolygon *) metersToDegreesWithPolygon: (SFPolygon *) polygon{
    SFPolygon *degrees = [SFPolygon polygonWithHasZ:polygon.hasZ andHasM:polygon.hasM];
    for(SFLineString *ring in polygon.rings){
        [degrees addRing:[self metersToDegreesWithLineString:ring]];
    }
    return degrees;
}

+(SFMultiPolygon *) metersToDegreesWithMultiPolygon: (SFMultiPolygon *) multiPolygon{
    SFMultiPolygon *degrees = [SFMultiPolygon multiPolygonWithHasZ:multiPolygon.hasZ andHasM:multiPolygon.hasM];
    for(SFPolygon *polygon in [multiPolygon polygons]){
        [degrees addPolygon:[self metersToDegreesWithPolygon:polygon]];
    }
    return degrees;
}

+(SFCircularString *) metersToDegreesWithCircularString: (SFCircularString *) circularString{
    SFCircularString *degrees = [SFCircularString circularStringWithHasZ:circularString.hasZ andHasM:circularString.hasM];
    for(SFPoint *point in circularString.points){
        [degrees addPoint:[self metersToDegreesWithPoint:point]];
    }
    return degrees;
}

+(SFCompoundCurve *) metersToDegreesWithCompoundCurve: (SFCompoundCurve *) compoundCurve{
    SFCompoundCurve *degrees = [SFCompoundCurve compoundCurveWithHasZ:compoundCurve.hasZ andHasM:compoundCurve.hasM];
    for(SFLineString *lineString in compoundCurve.lineStrings){
        [degrees addLineString:[self metersToDegreesWithLineString:lineString]];
    }
    return degrees;
}

+(SFCurvePolygon *) metersToDegreesWithCurvePolygon: (SFCurvePolygon *) curvePolygon{
    SFCurvePolygon *degrees = [SFCurvePolygon curvePolygonWithHasZ:curvePolygon.hasZ andHasM:curvePolygon.hasM];
    for(SFCurve *ring in curvePolygon.rings){
        [degrees addRing:(SFCurve *) [self metersToDegreesWithGeometry:ring]];
    }
    return degrees;
}

+(SFPolyhedralSurface *) metersToDegreesWithPolyhedralSurface: (SFPolyhedralSurface *) polyhedralSurface{
    SFPolyhedralSurface *degrees = [SFPolyhedralSurface polyhedralSurfaceWithHasZ:polyhedralSurface.hasZ andHasM:polyhedralSurface.hasM];
    for(SFPolygon *polygon in polyhedralSurface.polygons){
        [degrees addPolygon:[self metersToDegreesWithPolygon:polygon]];
    }
    return degrees;
}

+(SFTIN *) metersToDegreesWithTIN: (SFTIN *) tin{
    SFTIN *degrees = [SFTIN tinWithHasZ:tin.hasZ andHasM:tin.hasM];
    for(SFPolygon *polygon in tin.polygons){
        [degrees addPolygon:[self metersToDegreesWithPolygon:polygon]];
    }
    return degrees;
}

+(SFTriangle *) metersToDegreesWithTriangle: (SFTriangle *) triangle{
    SFTriangle *degrees = [SFTriangle triangleWithHasZ:triangle.hasZ andHasM:triangle.hasM];
    for(SFLineString *ring in triangle.rings){
        [degrees addRing:[self metersToDegreesWithLineString:ring]];
    }
    return degrees;
}

+(SFGeometryEnvelope *) wgs84Envelope{
    return [SFGeometryEnvelope envelopeWithMinXValue:-SF_WGS84_HALF_WORLD_LON_WIDTH andMinYValue:-SF_WGS84_HALF_WORLD_LAT_HEIGHT andMaxXValue:SF_WGS84_HALF_WORLD_LON_WIDTH andMaxYValue:SF_WGS84_HALF_WORLD_LAT_HEIGHT];
}

+(SFGeometryEnvelope *) wgs84TransformableEnvelope{
    return [SFGeometryEnvelope envelopeWithMinXValue:-SF_WGS84_HALF_WORLD_LON_WIDTH andMinYValue:SF_DEGREES_TO_METERS_MIN_LAT andMaxXValue:SF_WGS84_HALF_WORLD_LON_WIDTH andMaxYValue:SF_WGS84_HALF_WORLD_LAT_HEIGHT];
}

+(SFGeometryEnvelope *) webMercatorEnvelope{
    return [SFGeometryEnvelope envelopeWithMinXValue:-SF_WEB_MERCATOR_HALF_WORLD_WIDTH andMinYValue:-SF_WEB_MERCATOR_HALF_WORLD_WIDTH andMaxXValue:SF_WEB_MERCATOR_HALF_WORLD_WIDTH andMaxYValue:SF_WEB_MERCATOR_HALF_WORLD_WIDTH];
}

+(SFGeometryEnvelope *) wgs84EnvelopeWithWebMercator{
    return [SFGeometryEnvelope envelopeWithMinXValue:-SF_WGS84_HALF_WORLD_LON_WIDTH andMinYValue:SF_WEB_MERCATOR_MIN_LAT_RANGE andMaxXValue:SF_WGS84_HALF_WORLD_LON_WIDTH andMaxYValue:SF_WEB_MERCATOR_MAX_LAT_RANGE];
}

+(SFGeometry *) cropWebMercatorGeometry: (SFGeometry *) geometry{
    return [self cropGeometry:geometry withEnvelope:[self webMercatorEnvelope]];
}

+(SFGeometry *) cropGeometry: (SFGeometry *) geometry withEnvelope: (SFGeometryEnvelope *) envelope{
    
    SFGeometry *crop = nil;
    
    if([self containsEnvelope:geometry.envelope withinEnvelope:envelope]){
        crop = geometry;
    }else{
    
        switch (geometry.geometryType) {
            case SF_POINT:
                crop = [self cropPoint:(SFPoint *) geometry withEnvelope:envelope];
                break;
            case SF_LINESTRING:
                crop = [self cropLineString:(SFLineString *) geometry withEnvelope:envelope];
                break;
            case SF_POLYGON:
                crop = [self cropPolygon:(SFPolygon *) geometry withEnvelope:envelope];
                break;
            case SF_MULTIPOINT:
                crop = [self cropMultiPoint:(SFMultiPoint *) geometry withEnvelope:envelope];
                break;
            case SF_MULTILINESTRING:
                crop = [self cropMultiLineString:(SFMultiLineString *) geometry withEnvelope:envelope];
                break;
            case SF_MULTIPOLYGON:
                crop = [self cropMultiPolygon:(SFMultiPolygon *) geometry withEnvelope:envelope];
                break;
            case SF_CIRCULARSTRING:
                crop = [self cropCircularString:(SFCircularString *) geometry withEnvelope:envelope];
                break;
            case SF_COMPOUNDCURVE:
                crop = [self cropCompoundCurve:(SFCompoundCurve *) geometry withEnvelope:envelope];
                break;
            case SF_CURVEPOLYGON:
                crop = [self cropCurvePolygon:(SFCurvePolygon *) geometry withEnvelope:envelope];
                break;
            case SF_POLYHEDRALSURFACE:
                crop = [self cropPolyhedralSurface:(SFPolyhedralSurface *) geometry withEnvelope:envelope];
                break;
            case SF_TIN:
                crop = [self cropTIN:(SFTIN *) geometry withEnvelope:envelope];
                break;
            case SF_TRIANGLE:
                crop = [self cropTriangle:(SFTriangle *) geometry withEnvelope:envelope];
                break;
            case SF_GEOMETRYCOLLECTION:
            case SF_MULTICURVE:
            case SF_MULTISURFACE:
                {
                    SFGeometryCollection *cropCollection = [SFGeometryCollection geometryCollection];
                    SFGeometryCollection *geomCollection = (SFGeometryCollection *) geometry;
                    for (SFGeometry *subGeometry in geomCollection.geometries) {
                        [cropCollection addGeometry:[self cropGeometry:subGeometry withEnvelope:envelope]];
                    }
                    crop = cropCollection;
                }
                break;
            default:
                break;
                
        }
    }
    
    return crop;
}

+(SFPoint *) cropPoint: (SFPoint *) point withEnvelope: (SFGeometryEnvelope *) envelope{
    SFPoint *crop = nil;
    if([self containsPoint:point withinEnvelope:envelope]){
        crop = [point mutableCopy];
    }
    return crop;
}

+(NSMutableArray<SFPoint *> *) cropPoints: (NSArray<SFPoint *> *) points withEnvelope: (SFGeometryEnvelope *) envelope{
    
    NSMutableArray<SFPoint *> *crop = [NSMutableArray array];
    
    SFLine *left = [envelope left];
    SFLine *bottom = [envelope bottom];
    SFLine *right = [envelope right];
    SFLine *top = [envelope top];
    
    SFPoint *previousPoint = nil;
    BOOL previousContains = NO;
    for(SFPoint *point in points){
        BOOL contains = [self containsPoint:point withinEnvelope:envelope];
        
        if(previousPoint != nil && (!contains || !previousContains)){
            
            SFLine *line = [SFLine lineWithPoint1:previousPoint andPoint2:point];
            double bearing = [self bearingOfLine:[self metersToDegreesWithLine:line]];
            
            BOOL westBearing = [self isWestBearing:bearing];
            BOOL eastBearing = [self isEastBearing:bearing];
            BOOL southBearing = [self isSouthBearing:bearing];
            BOOL northBearing = [self isNorthBearing:bearing];
            
            SFLine *vertLine = nil;
            if([point.x doubleValue] > [envelope.maxX doubleValue]){
                if(eastBearing){
                    vertLine = right;
                }
            }else if([point.x doubleValue] < [envelope.minX doubleValue]){
                if(westBearing){
                    vertLine = left;
                }
            }else if(eastBearing){
                vertLine = left;
            }else if(westBearing){
                vertLine = right;
            }
            
            SFLine *horizLine = nil;
            if([point.y doubleValue] > [envelope.maxY doubleValue]){
                if(northBearing){
                    horizLine = top;
                }
            }else if([point.y doubleValue] < [envelope.minY doubleValue]){
                if(southBearing){
                    horizLine = bottom;
                }
            }else if(northBearing){
                horizLine = bottom;
            }else if(southBearing){
                horizLine = top;
            }
            
            SFPoint *vertIntersection = nil;
            if(vertLine != nil){
                vertIntersection = [self intersectionBetweenLine1:line andLine2:vertLine];
                if(vertIntersection != nil && ![self containsPoint:vertIntersection withinEnvelope:envelope]){
                    vertIntersection = nil;
                }
            }
            
            SFPoint *horizIntersection = nil;
            if(horizLine != nil){
                horizIntersection = [self intersectionBetweenLine1:line andLine2:horizLine];
                if(horizIntersection != nil && ![self containsPoint:horizIntersection withinEnvelope:envelope]){
                    horizIntersection = nil;
                }
            }
            
            SFPoint *intersection1 = nil;
            SFPoint *intersection2 = nil;
            if(vertIntersection != nil && horizIntersection != nil){
                double vertDistance = [self distanceBetweenPoint1:previousPoint andPoint2:vertIntersection];
                double horizDistance = [self distanceBetweenPoint1:previousPoint andPoint2:horizIntersection];
                if(vertDistance <= horizDistance){
                    intersection1 = vertIntersection;
                    intersection2 = horizIntersection;
                }else{
                    intersection1 = horizIntersection;
                    intersection2 = vertIntersection;
                }
            }else if(vertIntersection != nil){
                intersection1 = vertIntersection;
            }else{
                intersection1 = horizIntersection;
            }
            
            if(intersection1 != nil && ![self isEqualWithPoint1:intersection1 andPoint2:point] && ![self isEqualWithPoint1:intersection1 andPoint2:previousPoint]){
                
                [crop addObject:intersection1];
                
                if(!contains && !previousContains && intersection2 != nil && ![self isEqualWithPoint1:intersection2 andPoint2:intersection1]){
                    [crop addObject:intersection2];
                }
            }
            
        }
        
        if(contains){
            [crop addObject:point];
        }
        
        previousPoint = point;
        previousContains = contains;
    }
    
    if(crop.count == 0){
        crop = nil;
    }else if(crop.count > 1){
        
        if([[points firstObject] isEqual:[points lastObject]] && ![[crop firstObject] isEqual:[crop lastObject]] ){
            [crop addObject:[[crop firstObject] mutableCopy]];
        }
        
        if(crop.count > 2){
            
            NSMutableArray<SFPoint *> *simplified = [NSMutableArray array];
            [simplified addObject:[crop firstObject]];
            for(int i = 1; i < crop.count - 1; i++){
                SFPoint *previous = [simplified lastObject];
                SFPoint *point = [crop objectAtIndex:i];
                SFPoint *next = [crop objectAtIndex:i + 1];
                if(![self point:point onPathPoint1:previous andPoint2:next]){
                    [simplified addObject:point];
                }
            }
            [simplified addObject:[crop lastObject]];
            crop = simplified;
            
        }
        
    }
    
    return crop;
}

+(SFMultiPoint *) cropMultiPoint: (SFMultiPoint *) multiPoint withEnvelope: (SFGeometryEnvelope *) envelope{
    SFMultiPoint *crop = nil;
    NSMutableArray<SFPoint *> *cropPoints = [NSMutableArray array];
    for(SFPoint *point in [multiPoint points]){
        SFPoint *cropPoint = [self cropPoint:point withEnvelope:envelope];
        if(cropPoint != nil){
            [cropPoints addObject:cropPoint];
        }
    }
    if(cropPoints.count != 0){
        crop = [SFMultiPoint multiPointWithHasZ:multiPoint.hasZ andHasM:multiPoint.hasM];
        [crop setPoints:cropPoints];
    }
    return crop;
}

+(SFLineString *) cropLineString: (SFLineString *) lineString withEnvelope: (SFGeometryEnvelope *) envelope{
    SFLineString *crop = nil;
    NSMutableArray<SFPoint *> *cropPoints = [self cropPoints:lineString.points withEnvelope:envelope];
    if(cropPoints != nil){
        crop = [SFLineString lineStringWithHasZ:lineString.hasZ andHasM:lineString.hasM];
        [crop setPoints:cropPoints];
    }
    return crop;
}

+(SFLine *) cropLine: (SFLine *) line withEnvelope: (SFGeometryEnvelope *) envelope{
    SFLine *crop = nil;
    NSMutableArray<SFPoint *> *cropPoints = [self cropPoints:line.points withEnvelope:envelope];
    if(cropPoints != nil){
        crop = [SFLine lineWithHasZ:line.hasZ andHasM:line.hasM];
        [crop setPoints:cropPoints];
    }
    return crop;
}

+(SFMultiLineString *) cropMultiLineString: (SFMultiLineString *) multiLineString withEnvelope: (SFGeometryEnvelope *) envelope{
    SFMultiLineString *crop = nil;
    NSMutableArray<SFLineString *> *cropLineStrings = [NSMutableArray array];
    for(SFLineString *lineString in [multiLineString lineStrings]){
        SFLineString *cropLineString = [self cropLineString:lineString withEnvelope:envelope];
        if(cropLineString != nil){
            [cropLineStrings addObject:cropLineString];
        }
    }
    if(cropLineStrings.count != 0){
        crop = [SFMultiLineString multiLineStringWithHasZ:multiLineString.hasZ andHasM:multiLineString.hasM];
        [crop setLineStrings:cropLineStrings];
    }
    return crop;
}

+(SFPolygon *) cropPolygon: (SFPolygon *) polygon withEnvelope: (SFGeometryEnvelope *) envelope{
    SFPolygon *crop = nil;
    NSMutableArray<SFLineString *> *cropRings = [NSMutableArray array];
    for(SFLineString *ring in polygon.rings){
        NSMutableArray<SFPoint *> *points = ring.points;
        if(![ring isClosed]){
            [points addObject:[[points firstObject] mutableCopy]];
        }
        NSMutableArray<SFPoint *> *cropPoints = [self cropPoints:points withEnvelope:envelope];
        if(cropPoints != nil){
            SFLineString *cropRing = [SFLineString lineStringWithHasZ:ring.hasZ andHasM:ring.hasM];
            [cropRing setPoints:cropPoints];
            [cropRings addObject:cropRing];
        }
    }
    if(cropRings.count != 0){
        crop = [SFPolygon polygonWithHasZ:polygon.hasZ andHasM:polygon.hasM];
        [crop setRings:cropRings];
    }
    return crop;
}

+(SFMultiPolygon *) cropMultiPolygon: (SFMultiPolygon *) multiPolygon withEnvelope: (SFGeometryEnvelope *) envelope{
    SFMultiPolygon *crop = nil;
    NSMutableArray<SFPolygon *> *cropPolygons = [NSMutableArray array];
    for(SFPolygon *polygon in [multiPolygon polygons]){
        SFPolygon *cropPolygon = [self cropPolygon:polygon withEnvelope:envelope];
        if(cropPolygon != nil){
            [cropPolygons addObject:cropPolygon];
        }
    }
    if(cropPolygons.count != 0){
        crop = [SFMultiPolygon multiPolygonWithHasZ:multiPolygon.hasZ andHasM:multiPolygon.hasM];
        [crop setPolygons:cropPolygons];
    }
    return crop;
}

+(SFCircularString *) cropCircularString: (SFCircularString *) circularString withEnvelope: (SFGeometryEnvelope *) envelope{
    SFCircularString *crop = nil;
    NSMutableArray<SFPoint *> *cropPoints = [self cropPoints:circularString.points withEnvelope:envelope];
    if(cropPoints != nil){
        crop = [SFCircularString circularStringWithHasZ:circularString.hasZ andHasM:circularString.hasM];
        [crop setPoints:cropPoints];
    }
    return crop;
}

+(SFCompoundCurve *) cropCompoundCurve: (SFCompoundCurve *) compoundCurve withEnvelope: (SFGeometryEnvelope *) envelope{
    SFCompoundCurve *crop = nil;
    NSMutableArray<SFLineString *> *cropLineStrings = [NSMutableArray array];
    for(SFLineString *lineString in compoundCurve.lineStrings){
        SFLineString *cropLineString = [self cropLineString:lineString withEnvelope:envelope];
        if(cropLineString != nil){
            [cropLineStrings addObject:cropLineString];
        }
    }
    if(cropLineStrings.count != 0){
        crop = [SFCompoundCurve compoundCurveWithHasZ:compoundCurve.hasZ andHasM:compoundCurve.hasM];
        [crop setLineStrings:cropLineStrings];
    }
    return crop;
}

+(SFCurvePolygon *) cropCurvePolygon: (SFCurvePolygon *) curvePolygon withEnvelope: (SFGeometryEnvelope *) envelope{
    SFCurvePolygon *crop = nil;
    NSMutableArray<SFCurve *> *cropRings = [NSMutableArray array];
    for(SFCurve *ring in curvePolygon.rings){
        SFGeometry *cropRing = [self cropGeometry:ring withEnvelope:envelope];
        if(cropRing != nil){
            [cropRings addObject:(SFCurve *) cropRing];
        }
    }
    if(cropRings.count != 0){
        crop = [SFCurvePolygon curvePolygonWithHasZ:curvePolygon.hasZ andHasM:curvePolygon.hasM];
        [crop setRings:cropRings];
    }
    return crop;
}

+(SFPolyhedralSurface *) cropPolyhedralSurface: (SFPolyhedralSurface *) polyhedralSurface withEnvelope: (SFGeometryEnvelope *) envelope{
    SFPolyhedralSurface *crop = nil;
    NSMutableArray<SFPolygon *> *cropPolygons = [NSMutableArray array];
    for(SFPolygon *polygon in polyhedralSurface.polygons){
        SFPolygon *cropPolygon = [self cropPolygon:polygon withEnvelope:envelope];
        if(cropPolygon != nil){
            [cropPolygons addObject:cropPolygon];
        }
    }
    if(cropPolygons.count != 0){
        crop = [SFPolyhedralSurface polyhedralSurfaceWithHasZ:polyhedralSurface.hasZ andHasM:polyhedralSurface.hasM];
        [crop setPolygons:cropPolygons];
    }
    return crop;
}

+(SFTIN *) cropTIN: (SFTIN *) tin withEnvelope: (SFGeometryEnvelope *) envelope{
    SFTIN *crop = nil;
    NSMutableArray<SFPolygon *> *cropPolygons = [NSMutableArray array];
    for(SFPolygon *polygon in tin.polygons){
        SFPolygon *cropPolygon = [self cropPolygon:polygon withEnvelope:envelope];
        if(cropPolygon != nil){
            [cropPolygons addObject:cropPolygon];
        }
    }
    if(cropPolygons.count != 0){
        crop = [SFTIN tinWithHasZ:tin.hasZ andHasM:tin.hasM];
        [crop setPolygons:cropPolygons];
    }
    return crop;
}

+(SFTriangle *) cropTriangle: (SFTriangle *) triangle withEnvelope: (SFGeometryEnvelope *) envelope{
    SFTriangle *crop = nil;
    NSMutableArray<SFLineString *> *cropRings = [NSMutableArray array];
    for(SFLineString *ring in triangle.rings){
        NSMutableArray<SFPoint *> *points = ring.points;
        if(![ring isClosed]){
            [points addObject:[[points firstObject] mutableCopy]];
        }
        NSMutableArray<SFPoint *> *cropPoints = [self cropPoints:points withEnvelope:envelope];
        if(cropPoints != nil){
            SFLineString *cropRing = [SFLineString lineStringWithHasZ:ring.hasZ andHasM:ring.hasM];
            [cropRing setPoints:cropPoints];
            [cropRings addObject:cropRing];
        }
    }
    if(cropRings.count != 0){
        crop = [SFTriangle triangleWithHasZ:triangle.hasZ andHasM:triangle.hasM];
        [crop setRings:cropRings];
    }
    return crop;
}

+(BOOL) isEqualWithPoint1: (SFPoint *) point1 andPoint2: (SFPoint *) point2{
    return [self isEqualWithPoint1:point1 andPoint2:point2 andEpsilon:SF_DEFAULT_EQUAL_EPSILON];
}

+(BOOL) isEqualWithPoint1: (SFPoint *) point1 andPoint2: (SFPoint *) point2 andEpsilon: (double) epsilon{
    BOOL equal = fabs([point1.x doubleValue] - [point2.x doubleValue]) <= epsilon && fabs([point1.y doubleValue] - [point2.y doubleValue]) <= epsilon && point1.hasZ == point2.hasZ && point1.hasM == point2.hasM;
    if(equal){
        if(point1.hasZ){
            equal = fabs([point1.z doubleValue] - [point2.z doubleValue]) <= epsilon;
        }
        if(equal && point1.hasM){
            equal = fabs([point1.m doubleValue] - [point2.m doubleValue]) <= epsilon;
        }
    }
    return equal;
}

+(BOOL) containsPoint: (SFPoint *) point withinEnvelope: (SFGeometryEnvelope *) envelope{
    return [envelope containsPoint:point withEpsilon:SF_DEFAULT_EQUAL_EPSILON];
}

+(BOOL) containsEnvelope: (SFGeometryEnvelope *) envelope2 withinEnvelope: (SFGeometryEnvelope *) envelope1{
    return [envelope1 containsEnvelope:envelope2 withEpsilon:SF_DEFAULT_EQUAL_EPSILON];
}

+(void) boundWGS84Geometry: (SFGeometry *) geometry{
    [self boundGeometry:geometry withEnvelope:[self wgs84Envelope]];
}

+(void) boundWGS84TransformableGeometry: (SFGeometry *) geometry{
    [self boundGeometry:geometry withEnvelope:[self wgs84TransformableEnvelope]];
}

+(void) boundWebMercatorGeometry: (SFGeometry *) geometry{
    [self boundGeometry:geometry withEnvelope:[self webMercatorEnvelope]];
}

+(void) boundWGS84WithWebMercatorGeometry: (SFGeometry *) geometry{
    [self boundGeometry:geometry withEnvelope:[self wgs84EnvelopeWithWebMercator]];
}

+(void) boundGeometry: (SFGeometry *) geometry withEnvelope: (SFGeometryEnvelope *) envelope{

    enum SFGeometryType geometryType = geometry.geometryType;
    switch (geometryType) {
        case SF_POINT:
            [self boundPoint:(SFPoint *)geometry withEnvelope:envelope];
            break;
        case SF_LINESTRING:
            [self boundLineString:(SFLineString *)geometry withEnvelope:envelope];
            break;
        case SF_POLYGON:
            [self boundPolygon:(SFPolygon *)geometry withEnvelope:envelope];
            break;
        case SF_MULTIPOINT:
            [self boundMultiPoint:(SFMultiPoint *)geometry withEnvelope:envelope];
            break;
        case SF_MULTILINESTRING:
            [self boundMultiLineString:(SFMultiLineString *)geometry withEnvelope:envelope];
            break;
        case SF_MULTIPOLYGON:
            [self boundMultiPolygon:(SFMultiPolygon *)geometry withEnvelope:envelope];
            break;
        case SF_CIRCULARSTRING:
            [self boundLineString:(SFCircularString *)geometry withEnvelope:envelope];
            break;
        case SF_COMPOUNDCURVE:
            [self boundCompoundCurve:(SFCompoundCurve *)geometry withEnvelope:envelope];
            break;
        case SF_CURVEPOLYGON:
            [self boundCurvePolygon:(SFCurvePolygon *)geometry withEnvelope:envelope];
            break;
        case SF_POLYHEDRALSURFACE:
            [self boundPolyhedralSurface:(SFPolyhedralSurface *)geometry withEnvelope:envelope];
            break;
        case SF_TIN:
            [self boundPolyhedralSurface:(SFTIN *)geometry withEnvelope:envelope];
            break;
        case SF_TRIANGLE:
            [self boundPolygon:(SFTriangle *)geometry withEnvelope:envelope];
            break;
        case SF_GEOMETRYCOLLECTION:
        case SF_MULTICURVE:
        case SF_MULTISURFACE:
            {
                SFGeometryCollection *geomCollection = (SFGeometryCollection *) geometry;
                for (SFGeometry *subGeometry in geomCollection.geometries) {
                    [self boundGeometry:subGeometry withEnvelope:envelope];
                }
            }
            break;
        default:
            break;
            
    }
    
}

+(void) boundPoint: (SFPoint *) point withEnvelope: (SFGeometryEnvelope *) envelope{
    double x = [point.x doubleValue];
    double y = [point.y doubleValue];
    if(x < [envelope.minX doubleValue]){
        [point setX:envelope.minX];
    }else if(x > [envelope.maxX doubleValue]){
        [point setX:envelope.maxX];
    }
    if(y < [envelope.minY doubleValue]){
        [point setY:envelope.minY];
    }else if(y > [envelope.maxY doubleValue]){
        [point setY:envelope.maxY];
    }
}

+(void) boundMultiPoint: (SFMultiPoint *) multiPoint withEnvelope: (SFGeometryEnvelope *) envelope{
    for(SFPoint *point in [multiPoint points]){
        [self boundPoint:point withEnvelope:envelope];
    }
}

+(void) boundLineString: (SFLineString *) lineString withEnvelope: (SFGeometryEnvelope *) envelope{
    for(SFPoint *point in lineString.points){
        [self boundPoint:point withEnvelope:envelope];
    }
}

+(void) boundMultiLineString: (SFMultiLineString *) multiLineString withEnvelope: (SFGeometryEnvelope *) envelope{
    for(SFLineString *lineString in [multiLineString lineStrings]){
        [self boundLineString:lineString withEnvelope:envelope];
    }
}

+(void) boundPolygon: (SFPolygon *) polygon withEnvelope: (SFGeometryEnvelope *) envelope{
    for(SFLineString *ring in polygon.rings){
        [self boundLineString:ring withEnvelope:envelope];
    }
}

+(void) boundMultiPolygon: (SFMultiPolygon *) multiPolygon withEnvelope: (SFGeometryEnvelope *) envelope{
    for(SFPolygon *polygon in [multiPolygon polygons]){
        [self boundPolygon:polygon withEnvelope:envelope];
    }
}

+(void) boundCompoundCurve: (SFCompoundCurve *) compoundCurve withEnvelope: (SFGeometryEnvelope *) envelope{
    for(SFLineString *lineString in compoundCurve.lineStrings){
        [self boundLineString:lineString withEnvelope:envelope];
    }
}

+(void) boundCurvePolygon: (SFCurvePolygon *) curvePolygon withEnvelope: (SFGeometryEnvelope *) envelope{
    for(SFCurve *ring in curvePolygon.rings){
        [self boundGeometry:ring withEnvelope:envelope];
    }
}

+(void) boundPolyhedralSurface: (SFPolyhedralSurface *) polyhedralSurface withEnvelope: (SFGeometryEnvelope *) envelope{
    for(SFPolygon *polygon in polyhedralSurface.polygons){
        [self boundPolygon:polygon withEnvelope:envelope];
    }
}

+(BOOL) hasZ: (NSArray<SFGeometry *> *) geometries{
    BOOL hasZ = NO;
    for (SFGeometry *geometry in geometries) {
        if ([geometry hasZ]) {
            hasZ = YES;
            break;
        }
    }
    return hasZ;
}

+(BOOL) hasM: (NSArray<SFGeometry *> *) geometries{
    BOOL hasM = NO;
    for (SFGeometry *geometry in geometries) {
        if ([geometry hasM]) {
            hasM = YES;
            break;
        }
    }
    return hasM;
}

+(NSArray<NSNumber *> *) parentHierarchyOfType: (enum SFGeometryType) geometryType{
    
    NSMutableArray<NSNumber *> *hierarchy = [NSMutableArray array];
    
    enum SFGeometryType parentType = [self parentTypeOfType:geometryType];
    while(parentType != SF_NONE && parentType >= 0){
        [hierarchy addObject:[NSNumber numberWithInt:parentType]];
        parentType = [self parentTypeOfType:parentType];
    }
    
    return hierarchy;
}

+(enum SFGeometryType) parentTypeOfType: (enum SFGeometryType) geometryType{
    
    enum SFGeometryType parentType = SF_NONE;
    
    switch(geometryType){
            
        case SF_GEOMETRY:
            break;
        case SF_POINT:
            parentType = SF_GEOMETRY;
            break;
        case SF_LINESTRING:
            parentType = SF_CURVE;
            break;
        case SF_POLYGON:
            parentType = SF_CURVEPOLYGON;
            break;
        case SF_MULTIPOINT:
            parentType = SF_GEOMETRYCOLLECTION;
            break;
        case SF_MULTILINESTRING:
            parentType = SF_MULTICURVE;
            break;
        case SF_MULTIPOLYGON:
            parentType = SF_MULTISURFACE;
            break;
        case SF_GEOMETRYCOLLECTION:
            parentType = SF_GEOMETRY;
            break;
        case SF_CIRCULARSTRING:
            parentType = SF_LINESTRING;
            break;
        case SF_COMPOUNDCURVE:
            parentType = SF_CURVE;
            break;
        case SF_CURVEPOLYGON:
            parentType = SF_SURFACE;
            break;
        case SF_MULTICURVE:
            parentType = SF_GEOMETRYCOLLECTION;
            break;
        case SF_MULTISURFACE:
            parentType = SF_GEOMETRYCOLLECTION;
            break;
        case SF_CURVE:
            parentType = SF_GEOMETRY;
            break;
        case SF_SURFACE:
            parentType = SF_GEOMETRY;
            break;
        case SF_POLYHEDRALSURFACE:
            parentType = SF_SURFACE;
            break;
        case SF_TIN:
            parentType = SF_POLYHEDRALSURFACE;
            break;
        case SF_TRIANGLE:
            parentType = SF_POLYGON;
            break;
        default:
            [NSException raise:@"Geometry Type Not Supported" format:@"Geomery Type is not supported: %@", [SFGeometryTypes name:geometryType]];
    }
    
    return parentType;
}


+(NSDictionary<NSNumber *, NSDictionary *> *) childHierarchyOfType: (enum SFGeometryType) geometryType{
    
    NSMutableDictionary<NSNumber *, NSDictionary *> *hierarchy = [NSMutableDictionary dictionary];
    
    NSArray<NSNumber *> *childTypes = [self childTypesOfType:geometryType];
    
    if(childTypes.count > 0){
        
        for(NSNumber *childTypeNumber in childTypes){
            enum SFGeometryType childType = [childTypeNumber intValue];
            [hierarchy setObject:[self childHierarchyOfType:childType] forKey:childTypeNumber];
        }
    }
    
    return hierarchy;
}

+(NSArray<NSNumber *> *) childTypesOfType: (enum SFGeometryType) geometryType{
    
    NSMutableArray<NSNumber *> *childTypes = [NSMutableArray array];
    
    switch (geometryType) {
            
        case SF_GEOMETRY:
            [childTypes addObject:[NSNumber numberWithInt:SF_POINT]];
            [childTypes addObject:[NSNumber numberWithInt:SF_GEOMETRYCOLLECTION]];
            [childTypes addObject:[NSNumber numberWithInt:SF_CURVE]];
            [childTypes addObject:[NSNumber numberWithInt:SF_SURFACE]];
            break;
        case SF_POINT:
            break;
        case SF_LINESTRING:
            [childTypes addObject:[NSNumber numberWithInt:SF_CIRCULARSTRING]];
            break;
        case SF_POLYGON:
            [childTypes addObject:[NSNumber numberWithInt:SF_TRIANGLE]];
            break;
        case SF_MULTIPOINT:
            break;
        case SF_MULTILINESTRING:
            break;
        case SF_MULTIPOLYGON:
            break;
        case SF_GEOMETRYCOLLECTION:
            [childTypes addObject:[NSNumber numberWithInt:SF_MULTIPOINT]];
            [childTypes addObject:[NSNumber numberWithInt:SF_MULTICURVE]];
            [childTypes addObject:[NSNumber numberWithInt:SF_MULTISURFACE]];
            break;
        case SF_CIRCULARSTRING:
            break;
        case SF_COMPOUNDCURVE:
            break;
        case SF_CURVEPOLYGON:
            [childTypes addObject:[NSNumber numberWithInt:SF_POLYGON]];
            break;
        case SF_MULTICURVE:
            [childTypes addObject:[NSNumber numberWithInt:SF_MULTILINESTRING]];
            break;
        case SF_MULTISURFACE:
            [childTypes addObject:[NSNumber numberWithInt:SF_MULTIPOLYGON]];
            break;
        case SF_CURVE:
            [childTypes addObject:[NSNumber numberWithInt:SF_LINESTRING]];
            [childTypes addObject:[NSNumber numberWithInt:SF_COMPOUNDCURVE]];
            break;
        case SF_SURFACE:
            [childTypes addObject:[NSNumber numberWithInt:SF_CURVEPOLYGON]];
            [childTypes addObject:[NSNumber numberWithInt:SF_POLYHEDRALSURFACE]];
            break;
        case SF_POLYHEDRALSURFACE:
            [childTypes addObject:[NSNumber numberWithInt:SF_TIN]];
            break;
        case SF_TIN:
            break;
        case SF_TRIANGLE:
            break;
        default:
            [NSException raise:@"Geometry Type Not Supported" format:@"Geomery Type is not supported: %@", [SFGeometryTypes name:geometryType]];
    }
    
    return childTypes;
}

+(NSData *) encodeGeometry: (SFGeometry *) geometry{
    NSError *error = nil;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:geometry requiringSecureCoding:YES error:&error];
    if(error != nil){
        [NSException raise:@"Encode Geometry" format:@"Failed to encode geometry with error: %@", error];
    }
    return data;
}

+(SFGeometry *) decodeGeometry: (NSData *) data{
    NSError *error = nil;
    SFGeometry *geometry = [NSKeyedUnarchiver unarchivedObjectOfClass:[SFGeometry class] fromData:data error:&error];
    if(error != nil){
        [NSException raise:@"Decode Geometry" format:@"Failed to decode geometry with error: %@", error];
    }
    return geometry;
}

@end
