//
//  SFShamosHoey.h
//  sf-ios
//
//  Created by Brian Osborn on 1/12/18.
//  Copyright © 2018 NGA. All rights reserved.
//

#import "SFPolygon.h"

/**
 * Shamos-Hoey simple polygon detection
 *
 * Based upon C++ implementation:
 * http://geomalgorithms.com/a09-_intersect-3.html
 *
 * C++ implementation license:
 *
 * Copyright 2001 softSurfer, 2012 Dan Sunday This code may be freely used and
 * modified for any purpose providing that this copyright notice is included
 * with it. SoftSurfer makes no warranty for this code, and cannot be held
 * liable for any real or imagined damage resulting from its use. Users of this
 * code must verify correctness for their application.
 */
@interface SFShamosHoey : NSObject

/**
 * Determine if the polygon is simple
 *
 * @param polygon
 *            polygon
 * @return true if simple, false if intersects
 */
+(BOOL) simplePolygon: (SFPolygon *) polygon;

/**
 * Determine if the polygon points are simple
 *
 * @param points
 *            polygon as points
 * @return true if simple, false if intersects
 */
+(BOOL) simplePolygonPoints: (NSArray<SFPoint *> *) points;

/**
 * Determine if the polygon point rings are simple
 *
 * @param pointRings
 *            polygon point rings
 * @return true if simple, false if intersects
 */
+(BOOL) simplePolygonRingPoints: (NSArray<NSArray<SFPoint *>*> *) pointRings;

/**
 * Determine if the polygon line string ring is simple
 *
 * @param ring
 *            polygon ring as a line string
 * @return true if simple, false if intersects
 */
+(BOOL) simplePolygonRing: (SFLineString *) ring;

/**
 * Determine if the polygon rings are simple
 *
 * @param rings
 *            polygon rings
 * @return true if simple, false if intersects
 */
+(BOOL) simplePolygonRings: (NSArray<SFLineString *> *) rings;

@end
