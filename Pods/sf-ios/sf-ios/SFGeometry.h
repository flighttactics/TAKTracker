//
//  SFGeometry.h
//  sf-ios
//
//  Created by Brian Osborn on 6/1/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "SFGeometryTypes.h"
#import "SFGeometryEnvelope.h"

@class SFPoint;

/**
 *  The root of the geometry type hierarchy
 */
@interface SFGeometry : NSObject <NSMutableCopying, NSSecureCoding>

/**
 *  Geometry type
 */
@property (nonatomic) enum SFGeometryType geometryType;

/**
 *  Has Z values
 */
@property (nonatomic) BOOL hasZ;

/**
 *  Has M values
 */
@property (nonatomic) BOOL hasM;

/**
 *  Initialize
 *
 *  @param geometryType geometry type
 *  @param hasZ         has z values
 *  @param hasM         has m values
 *
 *  @return new geometry
 */
-(instancetype) initWithType: (enum SFGeometryType) geometryType andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 * Does the geometry have z coordinates
 *
 * @return true if has z coordinates
 */
-(BOOL) is3D;

/**
 * Does the geometry have m coordinates.
 *
 * @return true if has m coordinates
 */
-(BOOL) isMeasured;

/**
 * Get the minimum bounding box for this Geometry
 *
 * @return geometry envelope
 */
-(SFGeometryEnvelope *) envelope;

/**
 * Expand the envelope with the minimum bounding box for this Geometry
 *
 * @param envelope
 *            geometry envelope to expand
 */
-(void) expandEnvelope: (SFGeometryEnvelope *) envelope;

/**
 * Get the inherent dimension (0, 1, or 2) for this Geometry
 *
 * @return dimension
 */
-(int) dimension;

/**
 * Get the mathematical centroid point of a 2 dimensional representation of
 * the Geometry (balancing point of a 2d cutout of the geometry). Only the x
 * and y coordinate of the resulting point are calculated and populated. The
 * resulting SFPoint.z and SFPoint.m values will always be nil.
 *
 * @return centroid point
 */
-(SFPoint *) centroid;

/**
 * Get the geographic centroid point of a 2 dimensional representation of
 * the degree unit Geometry. Only the x and y coordinate of the resulting
 * point are calculated and populated. The resulting SFPoint.z and
 * SFPoint.m values will always be nil.
 *
 * @return centroid point
 */
-(SFPoint *) degreesCentroid;

/**
 * Is the Geometry empty
 *
 * @return true if empty
 */
-(BOOL) isEmpty;

/**
 * Determine if this Geometry has no anomalous geometric points, such as
 * self intersection or self tangency
 *
 * @return true if simple
 */
-(BOOL) isSimple;

/**
 * Update currently false hasZ and hasM values using the provided geometry
 *
 * @param geometry
 *            geometry
 */
-(void) updateZM: (SFGeometry *) geometry;

@end
