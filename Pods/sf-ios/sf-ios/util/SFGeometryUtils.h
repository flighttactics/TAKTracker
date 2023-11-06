//
//  SFGeometryUtils.h
//  sf-ios
//
//  Created by Brian Osborn on 4/14/17.
//  Copyright © 2017 NGA. All rights reserved.
//

#import "SFLine.h"
#import "SFMultiPoint.h"
#import "SFCircularString.h"
#import "SFCompoundCurve.h"
#import "SFTIN.h"
#import "SFTriangle.h"

/**
 * Utilities for Geometry objects
 */
@interface SFGeometryUtils : NSObject

/**
 * Get the dimension of the Geometry, 0 for points, 1 for curves, 2 for
 * surfaces. If a collection, the largest dimension is returned.
 *
 * @param geometry
 *            geometry object
 * @return dimension (0, 1, or 2)
 */
+(int) dimensionOfGeometry: (SFGeometry *) geometry;

/**
 * Get the Pythagorean theorem distance between two points
 *
 * @param point1
 *            point 1
 * @param point2
 *            point 2
 * @return distance
 */
+(double) distanceBetweenPoint1: (SFPoint *) point1 andPoint2: (SFPoint *) point2;

/**
 * Get the Pythagorean theorem distance between the line end points
 *
 * @param line
 *            line
 * @return distance
 */
+(double) distanceOfLine: (SFLine *) line;

/**
 * Get the bearing heading in degrees between two points in degrees
 *
 * @param point1
 *            point 1
 * @param point2
 *            point 2
 * @return bearing angle in degrees between 0 and 360
 */
+(double) bearingBetweenPoint1: (SFPoint *) point1 andPoint2: (SFPoint *) point2;

/**
 * Get the bearing heading in degrees between line end points in degrees
 *
 * @param line
 *            line
 * @return bearing angle in degrees between 0 inclusively and 360
 *         exclusively
 */
+(double) bearingOfLine: (SFLine *) line;

/**
 * Determine if the bearing is in any north direction
 *
 * @param bearing
 *            bearing angle in degrees
 * @return true if north bearing
 */
+(BOOL) isNorthBearing: (double) bearing;

/**
 * Determine if the bearing is in any east direction
 *
 * @param bearing
 *            bearing angle in degrees
 * @return true if east bearing
 */
+(BOOL) isEastBearing: (double) bearing;

/**
 * Determine if the bearing is in any south direction
 *
 * @param bearing
 *            bearing angle in degrees
 * @return true if south bearing
 */
+(BOOL) isSouthBearing: (double) bearing;

/**
 * Determine if the bearing is in any west direction
 *
 * @param bearing
 *            bearing angle in degrees
 * @return true if west bearing
 */
+(BOOL) isWestBearing: (double) bearing;

/**
 * Convert degrees to radians
 *
 * @param degrees
 *            degrees
 * @return radians
 */
+(double) degreesToRadians: (double) degrees;

/**
 * Convert radians to degrees
 *
 * @param radians
 *            radians
 * @return degrees
 */
+(double) radiansToDegrees: (double) radians;
    
/**
 * Get the centroid point of a 2 dimensional representation of the Geometry
 * (balancing point of a 2d cutout of the geometry). Only the x and y
 * coordinate of the resulting point are calculated and populated. The
 * resulting SFPoint.z and SFPoint.m values will always be nil.
 *
 * @param geometry
 *            geometry object
 * @return centroid point
 */
+(SFPoint *) centroidOfGeometry: (SFGeometry *) geometry;

/**
 * Get the geographic centroid point of a 2 dimensional representation of
 * the degree unit Geometry. Only the x and y coordinate of the resulting
 * point are calculated and populated. The resulting SFPoint.z and
 * SFPoint.m values will always be nil.
 *
 * @param geometry
 *            geometry object
 * @return centroid point
 */
+(SFPoint *) degreesCentroidOfGeometry: (SFGeometry *) geometry;

/**
 * Minimize the WGS84 geometry using the shortest x distance between each
 * connected set of points. Resulting x values will be in the range: -540.0
 * &lt;= x &lt;= 540.0
 *
 * @param geometry
 *            geometry
 */
+(void) minimizeWGS84Geometry: (SFGeometry *) geometry;

/**
 * Minimize the Web Mercator geometry using the shortest x distance between
 * each connected set of points. Resulting x values will be in the range:
 * -60112525.028367732 &lt;= x &lt;= 60112525.028367732
 *
 * @param geometry
 *            geometry
 */
+(void) minimizeWebMercatorGeometry: (SFGeometry *) geometry;

/**
 * Minimize the geometry using the shortest x distance between each
 * connected set of points. The resulting geometry point x values will be in
 * the range: (3 * min value &lt;= x &lt;= 3 * max value
 *
 * Example: For WGS84 provide a max x of
 * SF_WGS84_HALF_WORLD_LON_WIDTH. Resulting x values
 * will be in the range: -540.0 &lt;= x &lt;= 540.0
 *
 * Example: For web mercator provide a world width of
 * SF_WEB_MERCATOR_HALF_WORLD_WIDTH. Resulting x
 * values will be in the range: -60112525.028367732 &lt;= x &lt;=
 * 60112525.028367732
 *
 * @param geometry
 *            geometry
 * @param maxX
 *            max positive x value in the geometry projection
 */
+(void) minimizeGeometry: (SFGeometry *) geometry withMaxX: (double) maxX;

/**
 * Normalize the WGS84 geometry using the shortest x distance between each
 * connected set of points. Resulting x values will be in the range: -180.0
 * &lt;= x &lt;= 180.0
 *
 * @param geometry
 *            geometry
 */
+(void) normalizeWGS84Geometry: (SFGeometry *) geometry;

/**
 * Normalize the Web Mercator geometry using the shortest x distance between
 * each connected set of points. Resulting x values will be in the range:
 * -20037508.342789244 &lt;= x &lt;= 20037508.342789244
 *
 * @param geometry
 *            geometry
 */
+(void) normalizeWebMercatorGeometry: (SFGeometry *) geometry;

/**
 * Normalize the geometry so all points outside of the min and max value
 * range are adjusted to fall within the range.
 *
 * Example: For WGS84 provide a max x of
 * SF_WGS84_HALF_WORLD_LON_WIDTH. Resulting x values
 * will be in the range: -180.0 &lt;= x &lt;= 180.0
 *
 * Example: For web mercator provide a world width of
 * SF_WEB_MERCATOR_HALF_WORLD_WIDTH. Resulting x
 * values will be in the range: -20037508.342789244 &lt;= x &lt;=
 * 20037508.342789244
 *
 * @param geometry
 *            geometry
 * @param maxX
 *            max positive x value in the geometry projection
 */
+(void) normalizeGeometry: (SFGeometry *) geometry withMaxX: (double) maxX;

/**
 * Simplify the ordered points (representing a line, polygon, etc) using the Douglas Peucker algorithm
 * to create a similar curve with fewer points. Points should be in a meters unit type projection.
 * The tolerance is the minimum tolerated distance between consecutive points.
 *
 * @param points
 *            geometry points
 * @param tolerance
 *            minimum tolerance in meters for consecutive points
 * @return simplified points
 */
+ (NSArray<SFPoint *> *) simplifyPoints: (NSArray<SFPoint *> *) points withTolerance : (double) tolerance;

/**
 * Calculate the perpendicular distance between the point and the line represented by the start and end points.
 * Points should be in a meters unit type projection.
 *
 * @param point
 *            point
 * @param lineStart
 *            point representing the line start
 * @param lineEnd
 *            point representing the line end
 * @return distance in meters
 */
+ (double) perpendicularDistanceBetweenPoint: (SFPoint *) point lineStart: (SFPoint *) lineStart lineEnd: (SFPoint *) lineEnd;

/**
 * Check if the point is in the polygon
 *
 * @param point
 *            point
 * @param polygon
 *            polygon
 * @return true if in the polygon
 */
+(BOOL) point: (SFPoint *) point inPolygon: (SFPolygon *) polygon;

/**
 * Check if the point is in the polygon
 *
 * @param point
 *            point
 * @param polygon
 *            polygon
 * @param epsilon
 *            epsilon line tolerance
 * @return true if in the polygon
 */
+(BOOL) point: (SFPoint *) point inPolygon: (SFPolygon *) polygon withEpsilon: (double) epsilon;

/**
 * Check if the point is in the polygon ring
 *
 * @param point
 *            point
 * @param ring
 *            polygon ring
 * @return true if in the polygon
 */
+(BOOL) point: (SFPoint *) point inPolygonRing: (SFLineString *) ring;

/**
 * Check if the point is in the polygon ring
 *
 * @param point
 *            point
 * @param ring
 *            polygon ring
 * @param epsilon
 *            epsilon line tolerance
 * @return true if in the polygon
 */
+(BOOL) point: (SFPoint *) point inPolygonRing: (SFLineString *) ring withEpsilon: (double) epsilon;

/**
 * Check if the point is in the polygon points
 *
 * @param point
 *            point
 * @param points
 *            polygon points
 * @return true if in the polygon
 */
+(BOOL) point: (SFPoint *) point inPolygonPoints: (NSArray<SFPoint *> *) points;

/**
 * Check if the point is in the polygon points
 *
 * @param point
 *            point
 * @param points
 *            polygon points
 * @param epsilon
 *            epsilon line tolerance
 * @return true if in the polygon
 */
+(BOOL) point: (SFPoint *) point inPolygonPoints: (NSArray<SFPoint *> *) points withEpsilon: (double) epsilon;

/**
 * Check if the point is on the polygon edge
 *
 * @param point
 *            point
 * @param polygon
 *            polygon
 * @return true if on the polygon edge
 */
+(BOOL) point: (SFPoint *) point onPolygonEdge: (SFPolygon *) polygon;

/**
 * Check if the point is on the polygon edge
 *
 * @param point
 *            point
 * @param polygon
 *            polygon
 * @param epsilon
 *            epsilon line tolerance
 * @return true if on the polygon edge
 */
+(BOOL) point: (SFPoint *) point onPolygonEdge: (SFPolygon *) polygon withEpsilon: (double) epsilon;

/**
 * Check if the point is on the polygon ring edge
 *
 * @param point
 *            point
 * @param ring
 *            polygon ring
 * @return true if on the polygon edge
 */
+(BOOL) point: (SFPoint *) point onPolygonRingEdge: (SFLineString *) ring;

/**
 * Check if the point is on the polygon ring edge
 *
 * @param point
 *            point
 * @param ring
 *            polygon ring
 * @param epsilon
 *            epsilon line tolerance
 * @return true if on the polygon edge
 */
+(BOOL) point: (SFPoint *) point onPolygonRingEdge: (SFLineString *) ring withEpsilon: (double) epsilon;

/**
 * Check if the point is on the polygon ring edge points
 *
 * @param point
 *            point
 * @param points
 *            polygon points
 * @return true if on the polygon edge
 */
+(BOOL) point: (SFPoint *) point onPolygonPointsEdge: (NSArray<SFPoint *> *) points;

/**
 * Check if the point is on the polygon ring edge points
 *
 * @param point
 *            point
 * @param points
 *            polygon points
 * @param epsilon
 *            epsilon line tolerance
 * @return true if on the polygon edge
 */
+(BOOL) point: (SFPoint *) point onPolygonPointsEdge: (NSArray<SFPoint *> *) points withEpsilon: (double) epsilon;

/**
 * Check if the polygon outer ring is explicitly closed, where the first and
 * last point are the same
 *
 * @param polygon
 *            polygon
 * @return true if the first and last points are the same
 */
+(BOOL) closedPolygon: (SFPolygon *) polygon;

/**
 * Check if the polygon ring is explicitly closed, where the first and last
 * point are the same
 *
 * @param ring
 *            polygon ring
 * @return true if the first and last points are the same
 */
+(BOOL) closedPolygonRing: (SFLineString *) ring;

/**
 * Check if the polygon ring points are explicitly closed, where the first
 * and last point are the same
 *
 * @param points
 *            polygon ring points
 * @return true if the first and last points are the same
 */
+(BOOL) closedPolygonPoints: (NSArray<SFPoint *> *) points;

/**
 * Check if the point is on the line
 *
 * @param point
 *            point
 * @param line
 *            line
 * @return true if on the line
 */
+(BOOL) point: (SFPoint *) point onLine: (SFLineString *) line;

/**
 * Check if the point is on the line
 *
 * @param point
 *            point
 * @param line
 *            line
 * @param epsilon
 *            epsilon line tolerance
 * @return true if on the line
 */
+(BOOL) point: (SFPoint *) point onLine: (SFLineString *) line withEpsilon: (double) epsilon;

/**
 * Check if the point is on the line represented by the points
 *
 * @param point
 *            point
 * @param points
 *            line points
 * @return true if on the line
 */
+(BOOL) point: (SFPoint *) point onLinePoints: (NSArray<SFPoint *> *) points;

/**
 * Check if the point is on the line represented by the points
 *
 * @param point
 *            point
 * @param points
 *            line points
 * @param epsilon
 *            epsilon line tolerance
 * @return true if on the line
 */
+(BOOL) point: (SFPoint *) point onLinePoints: (NSArray<SFPoint *> *) points withEpsilon: (double) epsilon;

/**
 * Check if the point is on the path between point 1 and point 2
 *
 * @param point
 *            point
 * @param point1
 *            path point 1
 * @param point2
 *            path point 2
 * @return true if on the path
 */
+(BOOL) point: (SFPoint *) point onPathPoint1: (SFPoint *) point1 andPoint2: (SFPoint *) point2;

/**
 * Check if the point is on the path between point 1 and point 2
 *
 * @param point
 *            point
 * @param point1
 *            path point 1
 * @param point2
 *            path point 2
 * @param epsilon
 *            epsilon line tolerance
 * @return true if on the path
 */
+(BOOL) point: (SFPoint *) point onPathPoint1: (SFPoint *) point1 andPoint2: (SFPoint *) point2 withEpsilon: (double) epsilon;

/**
 * Get the point intersection between two lines
 *
 * @param line1
 *            first line
 * @param line2
 *            second line
 * @return intersection point or null if no intersection
 */
+(SFPoint *) intersectionBetweenLine1: (SFLine *) line1 andLine2: (SFLine *) line2;

/**
 * Get the point intersection between end points of two lines
 *
 * @param line1Point1
 *            first point of the first line
 * @param line1Point2
 *            second point of the first line
 * @param line2Point1
 *            first point of the second line
 * @param line2Point2
 *            second point of the second line
 * @return intersection point or null if no intersection
 */
+(SFPoint *) intersectionBetweenLine1Point1: (SFPoint *) line1Point1 andLine1Point2: (SFPoint *) line1Point2 andLine2Point1: (SFPoint *) line2Point1 andLine2Point2: (SFPoint *) line2Point2;

/**
 * Convert a geometry in degrees to a geometry in meters
 *
 * @param geometry
 *            geometry in degrees
 * @return geometry in meters
 */
+(SFGeometry *) degreesToMetersWithGeometry: (SFGeometry *) geometry;

/**
 * Convert a point in degrees to a point in meters
 *
 * @param point
 *            point in degrees
 * @return point in meters
 */
+(SFPoint *) degreesToMetersWithPoint: (SFPoint *) point;

/**
 * Convert a coordinate in degrees to a point in meters
 *
 * @param x
 *            x value in degrees
 * @param y
 *            y value in degrees
 * @return point in meters
 */
+(SFPoint *) degreesToMetersWithX: (double) x andY: (double) y;

/**
 * Convert a multi point in degrees to a multi point in meters
 *
 * @param multiPoint
 *            multi point in degrees
 * @return multi point in meters
 */
+(SFMultiPoint *) degreesToMetersWithMultiPoint: (SFMultiPoint *) multiPoint;

/**
 * Convert a line string in degrees to a line string in meters
 *
 * @param lineString
 *            line string in degrees
 * @return line string in meters
 */
+(SFLineString *) degreesToMetersWithLineString: (SFLineString *) lineString;

/**
 * Convert a line in degrees to a line in meters
 *
 * @param line
 *            line in degrees
 * @return line in meters
 */
+(SFLine *) degreesToMetersWithLine: (SFLine *) line;

/**
 * Convert a multi line string in degrees to a multi line string in meters
 *
 * @param multiLineString
 *            multi line string in degrees
 * @return multi line string in meters
 */
+(SFMultiLineString *) degreesToMetersWithMultiLineString: (SFMultiLineString *) multiLineString;

/**
 * Convert a polygon in degrees to a polygon in meters
 *
 * @param polygon
 *            polygon in degrees
 * @return polygon in meters
 */
+(SFPolygon *) degreesToMetersWithPolygon: (SFPolygon *) polygon;

/**
 * Convert a multi polygon in degrees to a multi polygon in meters
 *
 * @param multiPolygon
 *            multi polygon in degrees
 * @return multi polygon in meters
 */
+(SFMultiPolygon *) degreesToMetersWithMultiPolygon: (SFMultiPolygon *) multiPolygon;

/**
 * Convert a circular string in degrees to a circular string in meters
 *
 * @param circularString
 *            circular string in degrees
 * @return circular string in meters
 */
+(SFCircularString *) degreesToMetersWithCircularString: (SFCircularString *) circularString;

/**
 * Convert a compound curve in degrees to a compound curve in meters
 *
 * @param compoundCurve
 *            compound curve in degrees
 * @return compound curve in meters
 */
+(SFCompoundCurve *) degreesToMetersWithCompoundCurve: (SFCompoundCurve *) compoundCurve;

/**
 * Convert a curve polygon in degrees to a curve polygon in meters
 *
 * @param curvePolygon
 *            curve polygon in degrees
 * @return curve polygon in meters
 */
+(SFCurvePolygon *) degreesToMetersWithCurvePolygon: (SFCurvePolygon *) curvePolygon;

/**
 * Convert a polyhedral surface in degrees to a polyhedral surface in meters
 *
 * @param polyhedralSurface
 *            polyhedral surface in degrees
 * @return polyhedral surface in meters
 */
+(SFPolyhedralSurface *) degreesToMetersWithPolyhedralSurface: (SFPolyhedralSurface *) polyhedralSurface;

/**
 * Convert a TIN in degrees to a TIN in meters
 *
 * @param tin
 *            TIN in degrees
 * @return TIN in meters
 */
+(SFTIN *) degreesToMetersWithTIN: (SFTIN *) tin;

/**
 * Convert a triangle in degrees to a triangle in meters
 *
 * @param triangle
 *            triangle in degrees
 * @return triangle in meters
 */
+(SFTriangle *) degreesToMetersWithTriangle: (SFTriangle *) triangle;

/**
 * Convert a geometry in meters to a geometry in degrees
 *
 * @param geometry
 *            geometry in meters
 * @return geometry in degrees
 */
+(SFGeometry *) metersToDegreesWithGeometry: (SFGeometry *) geometry;

/**
 * Convert a point in meters to a point in degrees
 *
 * @param point
 *            point in meters
 * @return point in degrees
 */
+(SFPoint *) metersToDegreesWithPoint: (SFPoint *) point;

/**
 * Convert a coordinate in meters to a point in degrees
 *
 * @param x
 *            x value in meters
 * @param y
 *            y value in meters
 * @return point in degrees
 */
+(SFPoint *) metersToDegreesWithX: (double) x andY: (double) y;

/**
 * Convert a multi point in meters to a multi point in degrees
 *
 * @param multiPoint
 *            multi point in meters
 * @return multi point in degrees
 */
+(SFMultiPoint *) metersToDegreesWithMultiPoint: (SFMultiPoint *) multiPoint;

/**
 * Convert a line string in meters to a line string in degrees
 *
 * @param lineString
 *            line string in meters
 * @return line string in degrees
 */
+(SFLineString *) metersToDegreesWithLineString: (SFLineString *) lineString;

/**
 * Convert a line in meters to a line in degrees
 *
 * @param line
 *            line in meters
 * @return line in degrees
 */
+(SFLine *) metersToDegreesWithLine: (SFLine *) line;

/**
 * Convert a multi line string in meters to a multi line string in degrees
 *
 * @param multiLineString
 *            multi line string in meters
 * @return multi line string in degrees
 */
+(SFMultiLineString *) metersToDegreesWithMultiLineString: (SFMultiLineString *) multiLineString;

/**
 * Convert a polygon in meters to a polygon in degrees
 *
 * @param polygon
 *            polygon in meters
 * @return polygon in degrees
 */
+(SFPolygon *) metersToDegreesWithPolygon: (SFPolygon *) polygon;

/**
 * Convert a multi polygon in meters to a multi polygon in degrees
 *
 * @param multiPolygon
 *            multi polygon in meters
 * @return multi polygon in degrees
 */
+(SFMultiPolygon *) metersToDegreesWithMultiPolygon: (SFMultiPolygon *) multiPolygon;

/**
 * Convert a circular string in meters to a circular string in degrees
 *
 * @param circularString
 *            circular string in meters
 * @return circular string in degrees
 */
+(SFCircularString *) metersToDegreesWithCircularString: (SFCircularString *) circularString;

/**
 * Convert a compound curve in meters to a compound curve in degrees
 *
 * @param compoundCurve
 *            compound curve in meters
 * @return compound curve in degrees
 */
+(SFCompoundCurve *) metersToDegreesWithCompoundCurve: (SFCompoundCurve *) compoundCurve;

/**
 * Convert a curve polygon in meters to a curve polygon in degrees
 *
 * @param curvePolygon
 *            curve polygon in meters
 * @return curve polygon in degrees
 */
+(SFCurvePolygon *) metersToDegreesWithCurvePolygon: (SFCurvePolygon *) curvePolygon;

/**
 * Convert a polyhedral surface in meters to a polyhedral surface in degrees
 *
 * @param polyhedralSurface
 *            polyhedral surface in meters
 * @return polyhedral surface in degrees
 */
+(SFPolyhedralSurface *) metersToDegreesWithPolyhedralSurface: (SFPolyhedralSurface *) polyhedralSurface;

/**
 * Convert a TIN in meters to a TIN in degrees
 *
 * @param tin
 *            TIN in meters
 * @return TIN in degrees
 */
+(SFTIN *) metersToDegreesWithTIN: (SFTIN *) tin;

/**
 * Convert a triangle in meters to a triangle in degrees
 *
 * @param triangle
 *            triangle in meters
 * @return triangle in degrees
 */
+(SFTriangle *) metersToDegreesWithTriangle: (SFTriangle *) triangle;

/**
 * Get a WGS84 bounded geometry envelope
 *
 * @return geometry envelope
 */
+(SFGeometryEnvelope *) wgs84Envelope;

/**
 * Get a WGS84 bounded geometry envelope used for projection transformations
 * (degrees to meters)
 *
 * @return geometry envelope
 */
+(SFGeometryEnvelope *) wgs84TransformableEnvelope;

/**
 * Get a Web Mercator bounded geometry envelope
 *
 * @return geometry envelope
 */
+(SFGeometryEnvelope *) webMercatorEnvelope;

/**
 * Get a WGS84 geometry envelope with Web Mercator bounds
 *
 * @return geometry envelope
 */
+(SFGeometryEnvelope *) wgs84EnvelopeWithWebMercator;

/**
 * Crop the geometry in meters by web mercator world bounds. Cropping
 * removes points outside the envelope and creates new points on the line
 * intersections with the envelope.
 *
 * @param geometry
 *            geometry in meters
 * @return cropped geometry in meters or null
 */
+(SFGeometry *) cropWebMercatorGeometry: (SFGeometry *) geometry;

/**
 * Crop the geometry in meters by the envelope bounds in meters. Cropping
 * removes points outside the envelope and creates new points on the line
 * intersections with the envelope.
 *
 * @param geometry
 *            geometry in meters
 * @param envelope
 *            envelope in meters
 * @return cropped geometry in meters or null
 */
+(SFGeometry *) cropGeometry: (SFGeometry *) geometry withEnvelope: (SFGeometryEnvelope *) envelope;

/**
 * Crop the point by the envelope bounds.
 *
 * @param point
 *            point
 * @param envelope
 *            envelope
 * @return cropped point or null
 */
+(SFPoint *) cropPoint: (SFPoint *) point withEnvelope: (SFGeometryEnvelope *) envelope;

/**
 * Crop the list of consecutive points in meters by the envelope bounds in
 * meters. Cropping removes points outside the envelope and creates new
 * points on the line intersections with the envelope.
 *
 * @param points
 *            consecutive points
 * @param envelope
 *            envelope in meters
 * @return cropped points in meters or null
 */
+(NSMutableArray<SFPoint *> *) cropPoints: (NSArray<SFPoint *> *) points withEnvelope: (SFGeometryEnvelope *) envelope;

/**
 * Crop the multi point by the envelope bounds.
 *
 * @param multiPoint
 *            multi point
 * @param envelope
 *            envelope
 * @return cropped multi point or null
 */
+(SFMultiPoint *) cropMultiPoint: (SFMultiPoint *) multiPoint withEnvelope: (SFGeometryEnvelope *) envelope;

/**
 * Crop the line string in meters by the envelope bounds in meters. Cropping
 * removes points outside the envelope and creates new points on the line
 * intersections with the envelope.
 *
 * @param lineString
 *            line string in meters
 * @param envelope
 *            envelope in meters
 * @return cropped line string in meters or null
 */
+(SFLineString *) cropLineString: (SFLineString *) lineString withEnvelope: (SFGeometryEnvelope *) envelope;

/**
 * Crop the line in meters by the envelope bounds in meters. Cropping
 * removes points outside the envelope and creates new points on the line
 * intersections with the envelope.
 *
 * @param line
 *            line in meters
 * @param envelope
 *            envelope in meters
 * @return cropped line in meters or null
 */
+(SFLine *) cropLine: (SFLine *) line withEnvelope: (SFGeometryEnvelope *) envelope;

/**
 * Crop the multi line string in meters by the envelope bounds in meters.
 * Cropping removes points outside the envelope and creates new points on
 * the line intersections with the envelope.
 *
 * @param multiLineString
 *            multi line string in meters
 * @param envelope
 *            envelope in meters
 * @return cropped multi line string in meters or null
 */
+(SFMultiLineString *) cropMultiLineString: (SFMultiLineString *) multiLineString withEnvelope: (SFGeometryEnvelope *) envelope;

/**
 * Crop the polygon in meters by the envelope bounds in meters. Cropping
 * removes points outside the envelope and creates new points on the line
 * intersections with the envelope.
 *
 * @param polygon
 *            polygon in meters
 * @param envelope
 *            envelope in meters
 * @return cropped polygon in meters or null
 */
+(SFPolygon *) cropPolygon: (SFPolygon *) polygon withEnvelope: (SFGeometryEnvelope *) envelope;

/**
 * Crop the multi polygon in meters by the envelope bounds in meters.
 * Cropping removes points outside the envelope and creates new points on
 * the line intersections with the envelope.
 *
 * @param multiPolygon
 *            multi polygon in meters
 * @param envelope
 *            envelope in meters
 * @return cropped multi polygon in meters or null
 */
+(SFMultiPolygon *) cropMultiPolygon: (SFMultiPolygon *) multiPolygon withEnvelope: (SFGeometryEnvelope *) envelope;

/**
 * Crop the circular string in meters by the envelope bounds in meters.
 * Cropping removes points outside the envelope and creates new points on
 * the line intersections with the envelope.
 *
 * @param circularString
 *            circular string in meters
 * @param envelope
 *            envelope in meters
 * @return cropped circular string in meters or null
 */
+(SFCircularString *) cropCircularString: (SFCircularString *) circularString withEnvelope: (SFGeometryEnvelope *) envelope;

/**
 * Crop the compound curve in meters by the envelope bounds in meters.
 * Cropping removes points outside the envelope and creates new points on
 * the line intersections with the envelope.
 *
 * @param compoundCurve
 *            compound curve in meters
 * @param envelope
 *            envelope in meters
 * @return cropped compound curve in meters or null
 */
+(SFCompoundCurve *) cropCompoundCurve: (SFCompoundCurve *) compoundCurve withEnvelope: (SFGeometryEnvelope *) envelope;

/**
 * Crop the curve polygon in meters by the envelope bounds in meters.
 * Cropping removes points outside the envelope and creates new points on
 * the line intersections with the envelope.
 *
 * @param curvePolygon
 *            curve polygon in meters
 * @param envelope
 *            envelope in meters
 * @return cropped curve polygon in meters or null
 */
+(SFCurvePolygon *) cropCurvePolygon: (SFCurvePolygon *) curvePolygon withEnvelope: (SFGeometryEnvelope *) envelope;

/**
 * Crop the polyhedral surface in meters by the envelope bounds in meters.
 * Cropping removes points outside the envelope and creates new points on
 * the line intersections with the envelope.
 *
 * @param polyhedralSurface
 *            polyhedral surface in meters
 * @param envelope
 *            envelope in meters
 * @return cropped polyhedral surface in meters or null
 */
+(SFPolyhedralSurface *) cropPolyhedralSurface: (SFPolyhedralSurface *) polyhedralSurface withEnvelope: (SFGeometryEnvelope *) envelope;

/**
 * Crop the TIN in meters by the envelope bounds in meters. Cropping removes
 * points outside the envelope and creates new points on the line
 * intersections with the envelope.
 *
 * @param tin
 *            TIN in meters
 * @param envelope
 *            envelope in meters
 * @return cropped TIN in meters or null
 */
+(SFTIN *) cropTIN: (SFTIN *) tin withEnvelope: (SFGeometryEnvelope *) envelope;

/**
 * Crop the triangle in meters by the envelope bounds in meters. Cropping
 * removes points outside the envelope and creates new points on the line
 * intersections with the envelope.
 *
 * @param triangle
 *            triangle in meters
 * @param envelope
 *            envelope in meters
 * @return cropped triangle in meters or null
 */
+(SFTriangle *) cropTriangle: (SFTriangle *) triangle withEnvelope: (SFGeometryEnvelope *) envelope;

/**
 * Determine if the points are equal within the default tolerance of
 * SF_DEFAULT_EQUAL_EPSILON. For exact equality, use SFPoint.isEqual(id).
 *
 * @param point1
 *            point 1
 * @param point2
 *            point 2
 * @return true if equal
 */
+(BOOL) isEqualWithPoint1: (SFPoint *) point1 andPoint2: (SFPoint *) point2;

/**
 * Determine if the points are equal within the tolerance. For exact
 * equality, use SFPoint.isEqual(id).
 *
 * @param point1
 *            point 1
 * @param point2
 *            point 2
 * @param epsilon
 *            epsilon equality tolerance
 * @return true if equal
 */
+(BOOL) isEqualWithPoint1: (SFPoint *) point1 andPoint2: (SFPoint *) point2 andEpsilon: (double) epsilon;

/**
 * Determine if the envelope contains the point within the default tolerance
 * of SF_DEFAULT_EQUAL_EPSILON. For exact equality,
 * use SFGeometryEnvelope.containsPoint(SFPoint).
 *
 * @param envelope
 *            envelope
 * @param point
 *            point
 * @return true if contains
 */
+(BOOL) containsPoint: (SFPoint *) point withinEnvelope: (SFGeometryEnvelope *) envelope;

/**
 * Determine if envelope 1 contains the envelope 2 within the default
 * tolerance of SF_DEFAULT_EQUAL_EPSILON. For exact
 * equality, use SFGeometryEnvelope.containsEnvelope(SFGeometryEnvelope).
 *
 * @param envelope1
 *            envelope 1
 * @param envelope2
 *            envelope 2
 * @return true if contains
 */
+(BOOL) containsEnvelope: (SFGeometryEnvelope *) envelope2 withinEnvelope: (SFGeometryEnvelope *) envelope1;

/**
 * Bound all points in the geometry to be within WGS84 limits.
 *
 * To perform a geometry crop using line intersections, see
 * degreesToMetersWithGeometry(SFGeometry) and
 * cropGeometry(SFGeometry)withEnvelope:(SFGeometryEnvelope).
 *
 * @param geometry
 *            geometry
 */
+(void) boundWGS84Geometry: (SFGeometry *) geometry;

/**
 * Bound all points in the geometry to be within WGS84 projection
 * transformable (degrees to meters) limits.
 *
 * To perform a geometry crop using line intersections, see
 * degreesToMetersWithGeometry(SFGeometry) and
 * cropGeometry(SFGeometry)withEnvelope:(SFGeometryEnvelope).
 *
 * @param geometry
 *            geometry
 */
+(void) boundWGS84TransformableGeometry: (SFGeometry *) geometry;

/**
 * Bound all points in the geometry to be within Web Mercator limits.
 *
 * To perform a geometry crop using line intersections, see
 * cropWebMercatorGeometry(SFGeometry).
 *
 * @param geometry
 *            geometry
 */
+(void) boundWebMercatorGeometry: (SFGeometry *) geometry;

/**
 * Bound all points in the WGS84 geometry to be within degree Web Mercator
 * limits.
 *
 * To perform a geometry crop using line intersections, see
 * degreesToMetersWithGeometry(SFGeometry) and
 * cropWebMercatorGeometry(SFGeometry).
 *
 * @param geometry
 *            geometry
 */
+(void) boundWGS84WithWebMercatorGeometry: (SFGeometry *) geometry;

/**
 * Bound all points in the geometry to be within the geometry envelope.
 * Point x and y values are bounded by the min and max envelope values.
 *
 * To perform a geometry crop using line intersections, see
 * cropGeometry(SFGeometry)withEnvelope:(SFGeometryEnvelope) (requires geometry in meters).
 *
 * @param geometry
 *            geometry
 * @param envelope
 *            geometry envelope
 */
+(void) boundGeometry: (SFGeometry *) geometry withEnvelope: (SFGeometryEnvelope *) envelope;

/**
 * Determine if the geometries contain a Z value
 *
 * @param geometries
 *            list of geometries
 * @return true if has z
 */
+(BOOL) hasZ: (NSArray<SFGeometry *> *) geometries;

/**
 * Determine if the geometries contain a M value
 *
 * @param geometries
 *            list of geometries
 * @return true if has m
 */
+(BOOL) hasM: (NSArray<SFGeometry *> *) geometries;

/**
 * Get the parent type hierarchy of the provided geometry type starting with
 * the immediate parent. If the argument is GEOMETRY, an empty list is
 * returned, else the final type in the list will be GEOMETRY.
 *
 * @param geometryType
 *            geometry type
 * @return list of increasing parent types
 */
+(NSArray<NSNumber *> *) parentHierarchyOfType: (enum SFGeometryType) geometryType;

/**
 * Get the parent Geometry Type of the provided geometry type
 *
 * @param geometryType
 *            geometry type
 * @return parent geometry type or null if argument is GEOMETRY (no parent
 *         type)
 */
+(enum SFGeometryType) parentTypeOfType: (enum SFGeometryType) geometryType;

/**
 * Get the child type hierarchy of the provided geometry type.
 *
 * @param geometryType
 *            geometry type
 * @return child type hierarchy, null if no children
 */
+(NSDictionary<NSNumber *, NSDictionary *> *) childHierarchyOfType: (enum SFGeometryType) geometryType;

/**
 * Get the immediate child Geometry Types of the provided geometry type
 *
 * @param geometryType
 *            geometry type
 * @return child geometry types, empty list if no child types
 */
+(NSArray<NSNumber *> *) childTypesOfType: (enum SFGeometryType) geometryType;

/**
 * Encode the geometry to data
 *
 * @param geometry
 *            geometry
 * @return encoded dta
 */
+(NSData *) encodeGeometry: (SFGeometry *) geometry;

/**
 * Decode the data into a geometry
 *
 * @param data
 *            encoded data
 * @return geometry
 */
+(SFGeometry *) decodeGeometry: (NSData *) data;

@end
