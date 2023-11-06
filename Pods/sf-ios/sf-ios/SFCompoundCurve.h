//
//  SFCompoundCurve.h
//  sf-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "SFLineString.h"

/**
 * Compound Curve, Curve sub type
 */
@interface SFCompoundCurve : SFCurve

/**
 *  Array of line strings
 */
@property (nonatomic, strong) NSMutableArray<SFLineString *> *lineStrings;

/**
 *  Create
 *
 *  @return new compound curve
 */
+(SFCompoundCurve *) compoundCurve;

/**
 *  Create
 *
 *  @param hasZ has z values
 *  @param hasM has m values
 *
 *  @return new compound curve
 */
+(SFCompoundCurve *) compoundCurveWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 * Create
 *
 * @param lineStrings
 *            list of line strings
 *
 *  @return new compound curve
 */
+(SFCompoundCurve *) compoundCurveWithLineStrings: (NSMutableArray<SFLineString *> *) lineStrings;

/**
 * Create
 *
 * @param lineString
 *            line string
 *
 *  @return new compound curve
 */
+(SFCompoundCurve *) compoundCurveWithLineString: (SFLineString *) lineString;

/**
 * Create
 *
 * @param compoundCurve
 *            compound curve
 *
 *  @return new compound curve
 */
+(SFCompoundCurve *) compoundCurveWithCompoundCurve: (SFCompoundCurve *) compoundCurve;

/**
 *  Initialize
 *
 *  @return new compound curve
 */
-(instancetype) init;

/**
 *  Initialize
 *
 *  @param hasZ has z values
 *  @param hasM has m values
 *
 *  @return new compound curve
 */
-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 * Initialize
 *
 * @param lineStrings
 *            list of line strings
 *
 *  @return new compound curve
 */
-(instancetype) initWithLineStrings: (NSMutableArray<SFLineString *> *) lineStrings;

/**
 * Initialize
 *
 * @param lineString
 *            line string
 *
 *  @return new compound curve
 */
-(instancetype) initWithLineString: (SFLineString *) lineString;

/**
 * Initialize
 *
 * @param compoundCurve
 *            compound curve
 *
 *  @return new compound curve
 */
-(instancetype) initWithCompoundCurve: (SFCompoundCurve *) compoundCurve;

/**
 *  Add a line string
 *
 *  @param lineString line string
 */
-(void) addLineString: (SFLineString *) lineString;

/**
 * Add line strings
 *
 * @param lineStrings
 *            line strings
 */
-(void) addLineStrings: (NSArray<SFLineString *> *) lineStrings;

/**
 *  Get the number of line strings
 *
 *  @return line string count
 */
-(int) numLineStrings;

/**
 * Returns the Nth line string
 *
 * @param n
 *            nth line string to return
 * @return line string
 */
-(SFLineString *) lineStringAtIndex: (int) n;

@end
