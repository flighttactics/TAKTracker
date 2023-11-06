//
//  SFGeometryEnvelope.h
//  sf-ios
//
//  Created by Brian Osborn on 6/1/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SFPoint;
@class SFLine;
@class SFGeometry;

/**
 *  Geometry envelope containing x and y range with optional z and m range
 */
@interface SFGeometryEnvelope : NSObject <NSMutableCopying, NSSecureCoding>

/**
 *  X coordinate range
 */
@property (nonatomic, strong) NSDecimalNumber *minX;
@property (nonatomic, strong) NSDecimalNumber *maxX;

/**
 *  Y coordinate range
 */
@property (nonatomic, strong) NSDecimalNumber *minY;
@property (nonatomic, strong) NSDecimalNumber *maxY;

/**
 * Has Z value and Z coordinate range
 */
@property (nonatomic) BOOL hasZ;
@property (nonatomic, strong) NSDecimalNumber *minZ;
@property (nonatomic, strong) NSDecimalNumber *maxZ;

/**
 *  Has M value and M coordinate range
 */
@property (nonatomic) BOOL hasM;
@property (nonatomic, strong) NSDecimalNumber *minM;
@property (nonatomic, strong) NSDecimalNumber *maxM;

/**
 *  Create with no z or m
 *
 *  @return new geometry envelope
 */
+(SFGeometryEnvelope *) envelope;

/**
 *  Create with the has z and m values
 *
 *  @param hasZ geometry has z
 *  @param hasM geometry has m
 *
 *  @return new geometry envelope
 */
+(SFGeometryEnvelope *) envelopeWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Create with number range
 *
 *  @param minX minimum x
 *  @param minY minimum y
 *  @param maxX maximum x
 *  @param maxY maximum y
 *
 *  @return new geometry envelope
 */
+(SFGeometryEnvelope *) envelopeWithMinX: (NSDecimalNumber *) minX
                     andMinY: (NSDecimalNumber *) minY
                     andMaxX: (NSDecimalNumber *) maxX
                     andMaxY: (NSDecimalNumber *) maxY;

/**
 *  Create with double range
 *
 *  @param minX minimum x
 *  @param minY minimum y
 *  @param maxX maximum x
 *  @param maxY maximum y
 *
 *  @return new geometry envelope
 */
+(SFGeometryEnvelope *) envelopeWithMinXValue: (double) minX
                     andMinYValue: (double) minY
                     andMaxXValue: (double) maxX
                     andMaxYValue: (double) maxY;

/**
 *  Create with number range
 *
 *  @param minX minimum x
 *  @param minY minimum y
 *  @param minZ minimum z
 *  @param maxX maximum x
 *  @param maxY maximum y
 *  @param maxZ maximum z
 *
 *  @return new geometry envelope
 */
+(SFGeometryEnvelope *) envelopeWithMinX: (NSDecimalNumber *) minX
                     andMinY: (NSDecimalNumber *) minY
                     andMinZ: (NSDecimalNumber *) minZ
                     andMaxX: (NSDecimalNumber *) maxX
                     andMaxY: (NSDecimalNumber *) maxY
                     andMaxZ: (NSDecimalNumber *) maxZ;

/**
 *  Create with double range
 *
 *  @param minX minimum x
 *  @param minY minimum y
 *  @param minZ minimum z
 *  @param maxX maximum x
 *  @param maxY maximum y
 *  @param maxZ maximum z
 *
 *  @return new geometry envelope
 */
+(SFGeometryEnvelope *) envelopeWithMinXValue: (double) minX
                     andMinYValue: (double) minY
                     andMinZValue: (double) minZ
                     andMaxXValue: (double) maxX
                     andMaxYValue: (double) maxY
                     andMaxZValue: (double) maxZ;

/**
 *  Create with number range
 *
 *  @param minX minimum x
 *  @param minY minimum y
 *  @param minZ minimum z
 *  @param minM minimum m
 *  @param maxX maximum x
 *  @param maxY maximum y
 *  @param maxZ maximum z
 *  @param maxM maximum m
 *
 *  @return new geometry envelope
 */
+(SFGeometryEnvelope *) envelopeWithMinX: (NSDecimalNumber *) minX
                     andMinY: (NSDecimalNumber *) minY
                     andMinZ: (NSDecimalNumber *) minZ
                     andMinM: (NSDecimalNumber *) minM
                     andMaxX: (NSDecimalNumber *) maxX
                     andMaxY: (NSDecimalNumber *) maxY
                     andMaxZ: (NSDecimalNumber *) maxZ
                     andMaxM: (NSDecimalNumber *) maxM;

/**
 *  Create with double range
 *
 *  @param minX minimum x
 *  @param minY minimum y
 *  @param minZ minimum z
 *  @param minM minimum m
 *  @param maxX maximum x
 *  @param maxY maximum y
 *  @param maxZ maximum z
 *  @param maxM maximum m
 *
 *  @return new geometry envelope
 */
+(SFGeometryEnvelope *) envelopeWithMinXValue: (double) minX
                     andMinYValue: (double) minY
                     andMinZValue: (double) minZ
                     andMinMValue: (double) minM
                     andMaxXValue: (double) maxX
                     andMaxYValue: (double) maxY
                     andMaxZValue: (double) maxZ
                     andMaxMValue: (double) maxM;

/**
 *  Create
 *
 *  @param geometryEnvelope geometry envelope
 *
 *  @return new geometry envelope
 */
+(SFGeometryEnvelope *) geometryEnvelopeWithGeometryEnvelope: (SFGeometryEnvelope *) geometryEnvelope;

/**
 *  Initialize with no z or m
 *
 *  @return new geometry envelope
 */
-(instancetype) init;

/**
 *  Initialize with the has z and m values
 *
 *  @param hasZ geometry has z
 *  @param hasM geometry has m
 *
 *  @return new geometry envelope
 */
-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Initialize with number range
 *
 *  @param minX minimum x
 *  @param minY minimum y
 *  @param maxX maximum x
 *  @param maxY maximum y
 *
 *  @return new geometry envelope
 */
-(instancetype) initWithMinX: (NSDecimalNumber *) minX
                     andMinY: (NSDecimalNumber *) minY
                     andMaxX: (NSDecimalNumber *) maxX
                     andMaxY: (NSDecimalNumber *) maxY;

/**
 *  Initialize with double range
 *
 *  @param minX minimum x
 *  @param minY minimum y
 *  @param maxX maximum x
 *  @param maxY maximum y
 *
 *  @return new geometry envelope
 */
-(instancetype) initWithMinXValue: (double) minX
                     andMinYValue: (double) minY
                     andMaxXValue: (double) maxX
                     andMaxYValue: (double) maxY;

/**
 *  Initialize with number range
 *
 *  @param minX minimum x
 *  @param minY minimum y
 *  @param minZ minimum z
 *  @param maxX maximum x
 *  @param maxY maximum y
 *  @param maxZ maximum z
 *
 *  @return new geometry envelope
 */
-(instancetype) initWithMinX: (NSDecimalNumber *) minX
                     andMinY: (NSDecimalNumber *) minY
                     andMinZ: (NSDecimalNumber *) minZ
                     andMaxX: (NSDecimalNumber *) maxX
                     andMaxY: (NSDecimalNumber *) maxY
                     andMaxZ: (NSDecimalNumber *) maxZ;

/**
 *  Initialize with double range
 *
 *  @param minX minimum x
 *  @param minY minimum y
 *  @param minZ minimum z
 *  @param maxX maximum x
 *  @param maxY maximum y
 *  @param maxZ maximum z
 *
 *  @return new geometry envelope
 */
-(instancetype) initWithMinXValue: (double) minX
                     andMinYValue: (double) minY
                     andMinZValue: (double) minZ
                     andMaxXValue: (double) maxX
                     andMaxYValue: (double) maxY
                     andMaxZValue: (double) maxZ;

/**
 *  Initialize with number range
 *
 *  @param minX minimum x
 *  @param minY minimum y
 *  @param minZ minimum z
 *  @param minM minimum m
 *  @param maxX maximum x
 *  @param maxY maximum y
 *  @param maxZ maximum z
 *  @param maxM maximum m
 *
 *  @return new geometry envelope
 */
-(instancetype) initWithMinX: (NSDecimalNumber *) minX
                     andMinY: (NSDecimalNumber *) minY
                     andMinZ: (NSDecimalNumber *) minZ
                     andMinM: (NSDecimalNumber *) minM
                     andMaxX: (NSDecimalNumber *) maxX
                     andMaxY: (NSDecimalNumber *) maxY
                     andMaxZ: (NSDecimalNumber *) maxZ
                     andMaxM: (NSDecimalNumber *) maxM;

/**
 *  Initialize with double range
 *
 *  @param minX minimum x
 *  @param minY minimum y
 *  @param minZ minimum z
 *  @param minM minimum m
 *  @param maxX maximum x
 *  @param maxY maximum y
 *  @param maxZ maximum z
 *  @param maxM maximum m
 *
 *  @return new geometry envelope
 */
-(instancetype) initWithMinXValue: (double) minX
                     andMinYValue: (double) minY
                     andMinZValue: (double) minZ
                     andMinMValue: (double) minM
                     andMaxXValue: (double) maxX
                     andMaxYValue: (double) maxY
                     andMaxZValue: (double) maxZ
                     andMaxMValue: (double) maxM;

/**
 *  Initialize
 *
 *  @param geometryEnvelope geometry envelope
 *
 *  @return new geometry envelope
 */
-(instancetype) initWithGeometryEnvelope: (SFGeometryEnvelope *) geometryEnvelope;

/**
 *  Set the min x value
 *
 *  @param x   x coordinate
 */
-(void) setMinXValue: (double) x;

/**
 *  Set the max x value
 *
 *  @param x   x coordinate
 */
-(void) setMaxXValue: (double) x;

/**
 *  Set the min y value
 *
 *  @param y   y coordinate
 */
-(void) setMinYValue: (double) y;

/**
 *  Set the max y value
 *
 *  @param y   y coordinate
 */
-(void) setMaxYValue: (double) y;

/**
 *  Set the min z value
 *
 *  @param z   z coordinate
 */
-(void) setMinZValue: (double) z;

/**
 *  Set the max z value
 *
 *  @param z   z coordinate
 */
-(void) setMaxZValue: (double) z;

/**
 *  Set the min m value
 *
 *  @param m   m coordinate
 */
-(void) setMinMValue: (double) m;

/**
 *  Set the max m value
 *
 *  @param m   m coordinate
 */
-(void) setMaxMValue: (double) m;

/**
 * True if has Z coordinates
 *
 * @return has z
 */
-(BOOL) is3D;

/**
 * True if has M measurements
 *
 * @return has m
 */
-(BOOL) isMeasured;

/**
 * Get the x range
 *
 * @return x range
 */
-(double) xRange;

/**
 * Get the y range
 *
 * @return y range
 */
-(double) yRange;

/**
 * Get the z range
 *
 * @return z range
 */
-(NSDecimalNumber *) zRange;

/**
 * Get the m range
 *
 * @return m range
 */
-(NSDecimalNumber *) mRange;

/**
 * Determine if the envelope is of a single point
 *
 * @return true if a single point bounds
 */
-(BOOL) isPoint;

/**
 * Get the top left point
 *
 * @return top left point
 */
-(SFPoint *) topLeft;

/**
 * Get the bottom left point
 *
 * @return bottom left point
 */
-(SFPoint *) bottomLeft;

/**
 * Get the bottom right point
 *
 * @return bottom right point
 */
-(SFPoint *) bottomRight;

/**
 * Get the top right point
 *
 * @return top right point
 */
-(SFPoint *) topRight;

/**
 * Get the left line
 *
 * @return left line
 */
-(SFLine *) left;

/**
 * Get the bottom line
 *
 * @return bottom line
 */
-(SFLine *) bottom;

/**
 * Get the right line
 *
 * @return right line
 */
-(SFLine *) right;

/**
 * Get the top line
 *
 * @return top line
 */
-(SFLine *) top;

/**
 * Get the envelope mid x
 *
 * @return mid x
 */
-(double) midX;

/**
 * Get the envelope mid y
 *
 * @return mid y
 */
-(double) midY;

/**
 * Get the envelope centroid point
 *
 * @return centroid point
 */
-(SFPoint *) centroid;

/**
 * Determine if the envelope is empty
 *
 * @return true if empty
 */
-(BOOL) isEmpty;

/**
 * Determine if intersects with the provided envelope
 *
 * @param envelope
 *            geometry envelope
 * @return true if intersects
 */
-(BOOL) intersectsWithEnvelope: (SFGeometryEnvelope *) envelope;

/**
 * Determine if intersects with the provided envelope
 *
 * @param envelope
 *            geometry envelope
 * @param allowEmpty
 *            allow empty ranges when determining intersection
 * @return true if intersects
 */
-(BOOL) intersectsWithEnvelope: (SFGeometryEnvelope *) envelope withAllowEmpty: (BOOL) allowEmpty;

/**
 * Get the overlapping geometry envelope with the provided envelope
 *
 * @param envelope
 *            geometry envelope
 * @return geometry envelope
 */
-(SFGeometryEnvelope *) overlapWithEnvelope: (SFGeometryEnvelope *) envelope;

/**
 * Get the overlapping geometry envelope with the provided envelope
 *
 * @param envelope
 *            geometry envelope
 * @param allowEmpty
 *            allow empty ranges when determining overlap
 * @return geometry envelope
 */
-(SFGeometryEnvelope *) overlapWithEnvelope: (SFGeometryEnvelope *) envelope withAllowEmpty: (BOOL) allowEmpty;

/**
 * Get the union geometry envelope combined with the provided envelope
 *
 * @param envelope
 *            geometry envelope
 * @return geometry envelope
 */
-(SFGeometryEnvelope *) unionWithEnvelope: (SFGeometryEnvelope *) envelope;

/**
 * Determine if contains the point
 *
 * @param point
 *            point
 * @return true if contains
 */
-(BOOL) containsPoint: (SFPoint *) point;

/**
 * Determine if contains the point
 *
 * @param point
 *            point
 * @param epsilon
 *            epsilon equality tolerance
 * @return true if contains
 */
-(BOOL) containsPoint: (SFPoint *) point withEpsilon: (double) epsilon;

/**
 * Determine if contains the coordinate
 *
 * @param x
 *            x value
 * @param y
 *            y value
 * @return true if contains
 */
-(BOOL) containsX: (double) x andY: (double) y;

/**
 * Determine if contains the coordinate
 *
 * @param x
 *            x value
 * @param y
 *            y value
 * @param epsilon
 *            epsilon equality tolerance
 * @return true if contains
 */
-(BOOL) containsX: (double) x andY: (double) y withEpsilon: (double) epsilon;

/**
 * Determine if inclusively contains the provided envelope
 *
 * @param envelope
 *            geometry envelope
 * @return true if contains
 */
-(BOOL) containsEnvelope: (SFGeometryEnvelope *) envelope;

/**
 * Determine if inclusively contains the provided envelope
 *
 * @param envelope
 *            geometry envelope
 * @param epsilon
 *            epsilon equality tolerance
 * @return true if contains
 */
-(BOOL) containsEnvelope: (SFGeometryEnvelope *) envelope withEpsilon: (double) epsilon;

/**
 * Build a geometry representation of the geometry envelope
 *
 * @return geometry, polygon or point
 */
-(SFGeometry *) buildGeometry;

@end
