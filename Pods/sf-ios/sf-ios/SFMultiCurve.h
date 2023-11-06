//
//  SFMultiCurve.h
//  sf-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "SFGeometryCollection.h"
#import "SFCurve.h"

/**
 * A restricted form of GeometryCollection where each Geometry in the collection
 * must be of type Curve.
 */
@interface SFMultiCurve : SFGeometryCollection

/**
 *  Initialize
 *
 *  @param geometryType geometry type
 *  @param hasZ         has z values
 *  @param hasM         has m values
 *
 *  @return new multi curve
 */
-(instancetype) initWithType: (enum SFGeometryType) geometryType andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Get the curves
 *
 *  @return curves
 */
-(NSMutableArray<SFCurve *> *) curves;

/**
 *  Set the curves
 *
 *  @param curves curves
 */
-(void) setCurves: (NSMutableArray<SFCurve *> *) curves;

/**
 *  Add a curve
 *
 *  @param curve curve
 */
-(void) addCurve: (SFCurve *) curve;

/**
 * Add curves
 *
 * @param curves
 *            curves
 */
-(void) addCurves: (NSArray<SFCurve *> *) curves;

/**
 *  Get the number of curves
 *
 *  @return curve count
 */
-(int) numCurves;

/**
 * Returns the Nth curve
 *
 * @param n
 *            nth curve to return
 * @return curve
 */
-(SFCurve *) curveAtIndex: (int) n;

/**
 * Determine if this Multi Curve is closed for each Curve (start point = end
 * point)
 *
 * @return true if closed
 */
-(BOOL) isClosed;

@end
