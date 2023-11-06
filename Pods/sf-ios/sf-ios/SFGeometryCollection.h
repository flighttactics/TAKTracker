//
//  SFGeometryCollection.h
//  sf-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "SFGeometry.h"

@class SFMultiPoint;
@class SFMultiLineString;
@class SFMultiPolygon;
@class SFMultiCurve;
@class SFMultiSurface;

/**
 *  A collection of zero or more Geometry instances.
 */
@interface SFGeometryCollection : SFGeometry

/**
 *  Array of geometries
 */
@property (nonatomic, strong) NSMutableArray<SFGeometry *> *geometries;

/**
 *  Create
 *
 *  @return new geometry collection
 */
+(SFGeometryCollection *) geometryCollection;

/**
 *  Create
 *
 *  @param hasZ has z values
 *  @param hasM has m values
 *
 *  @return new geometry collection
 */
+(SFGeometryCollection *) geometryCollectionWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 * Create
 *
 * @param geometries
 *            list of geometries
 *
 *  @return new geometry collection
 */
+(SFGeometryCollection *) geometryCollectionWithGeometries: (NSMutableArray<SFGeometry *> *) geometries;

/**
 * Create
 *
 * @param geometry
 *            geometry
 *
 *  @return new geometry collection
 */
+(SFGeometryCollection *) geometryCollectionWithGeometry: (SFGeometry *) geometry;

/**
 * Create
 *
 * @param geometryCollection
 *            geometry ollection
 *
 *  @return new geometry collection
 */
+(SFGeometryCollection *) geometryCollectionWithGeometryCollection: (SFGeometryCollection *) geometryCollection;

/**
 *  Initialize
 *
 *  @return new geometry collection
 */
-(instancetype) init;

/**
 *  Initialize
 *
 *  @param hasZ has z values
 *  @param hasM has m values
 *
 *  @return new geometry collection
 */
-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 * Initialize
 *
 * @param geometries
 *            list of geometries
 *
 *  @return new geometry collection
 */
-(instancetype) initWithGeometries: (NSMutableArray<SFGeometry *> *) geometries;

/**
 * Initialize
 *
 * @param geometry
 *            geometry
 *
 *  @return new geometry collection
 */
-(instancetype) initWithGeometry: (SFGeometry *) geometry;

/**
 *  Initialize
 *
 *  @param geometryType geometry type
 *  @param hasZ         has z values
 *  @param hasM         has m values
 *
 *  @return new geometry collection
 */
-(instancetype) initWithType: (enum SFGeometryType) geometryType andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 * Initialize
 *
 * @param geometryCollection
 *            geometry ollection
 *
 *  @return new geometry collection
 */
-(instancetype) initWithGeometryCollection: (SFGeometryCollection *) geometryCollection;

/**
 *  Add geometry
 *
 *  @param geometry geometry
 */
-(void) addGeometry: (SFGeometry *) geometry;

/**
 * Add geometries
 *
 * @param geometries
 *            geometries
 */
-(void) addGeometries: (NSArray<SFGeometry *> *) geometries;

/**
 *  Get the number of geometries
 *
 *  @return geometry count
 */
-(int) numGeometries;

/**
 * Returns the Nth geometry
 *
 * @param n
 *            nth geometry to return
 * @return geometry
 */
-(SFGeometry *) geometryAtIndex: (int)  n;

/**
 * Get the collection type by evaluating the geometries
 *
 * @return collection geometry type, one of:
 *         MULTIPOINT,
 *         MULTILINESTRING,
 *         MULTIPOLYGON,
 *         MULTICURVE,
 *         MULTISURFACE,
 *         GEOMETRYCOLLECTION
 */
-(enum SFGeometryType) collectionType;

/**
 * Determine if this geometry collection is a MultiPoint instance or
 * contains only Point geometries
 *
 * @return true if a multi point or contains only points
 */
-(BOOL) isMultiPoint;

/**
 * Get as a MultiPoint, either the current instance or newly created
 * from the Point geometries
 *
 * @return multi point
 */
-(SFMultiPoint *) asMultiPoint;

/**
 * Determine if this geometry collection is a MultiLineString
 * instance or contains only LineString geometries
 *
 * @return true if a multi line string or contains only line strings
 */
-(BOOL) isMultiLineString;

/**
 * Get as a MultiLineString, either the current instance or newly
 * created from the LineString geometries
 *
 * @return multi line string
 */
-(SFMultiLineString *) asMultiLineString;

/**
 * Determine if this geometry collection is a MultiPolygon instance
 * or contains only Polygon geometries
 *
 * @return true if a multi polygon or contains only polygons
 */
-(BOOL) isMultiPolygon;

/**
 * Get as a MultiPolygon, either the current instance or newly
 * created from the Polygon geometries
 *
 * @return multi polygon
 */
-(SFMultiPolygon *) asMultiPolygon;

/**
 * Determine if this geometry collection contains only Curve
 * geometries
 *
 * @return true if contains only curves
 */
-(BOOL) isMultiCurve;

/**
 * Get as a Multi Curve, a Curve typed Geometry Collection
 *
 * @return multi curve
 */
-(SFGeometryCollection *) asMultiCurve;

/**
 * Determine if this geometry collection contains only Surface
 * geometries
 *
 * @return true if contains only surfaces
 */
-(BOOL) isMultiSurface;

/**
 * Get as a Multi Surface, a Surface typed Geometry Collection
 *
 * @return multi surface
 */
-(SFGeometryCollection *) asMultiSurface;

/**
 * Get as a top level Geometry Collection
 *
 * @return geometry collection
 */
-(SFGeometryCollection *) asGeometryCollection;

@end
