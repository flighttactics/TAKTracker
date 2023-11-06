//
//  SFMultiLineString.h
//  sf-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "SFMultiCurve.h"
#import "SFLineString.h"

/**
 * A restricted form of MultiCurve where each Curve in the collection must be of
 * type LineString.
 */
@interface SFMultiLineString : SFMultiCurve

/**
 *  Create
 *
 *  @return new multi line string
 */
+(SFMultiLineString *) multiLineString;

/**
 *  Create
 *
 *  @param hasZ has z values
 *  @param hasM has m values
 *
 *  @return new multi line string
 */
+(SFMultiLineString *) multiLineStringWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 * Create
 *
 * @param lineStrings
 *            list of line strings
 *
 *  @return new multi line string
 */
+(SFMultiLineString *) multiLineStringWithLineStrings: (NSMutableArray<SFLineString *> *) lineStrings;

/**
 * Create
 *
 * @param lineString
 *            line string
 *
 *  @return new multi line string
 */
+(SFMultiLineString *) multiLineStringWithLineString: (SFLineString *) lineString;

/**
 * Create
 *
 * @param multiLineString
 *            multi line string
 *
 *  @return new multi line string
 */
+(SFMultiLineString *) multiLineStringWithMultiLineString: (SFMultiLineString *) multiLineString;

/**
 *  Initialize
 *
 *  @return new multi line string
 */
-(instancetype) init;

/**
 *  Initialize
 *
 *  @param hasZ has z values
 *  @param hasM has m values
 *
 *  @return new multi line string
 */
-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 * Initialize
 *
 * @param lineStrings
 *            list of line strings
 *
 *  @return new multi line string
 */
-(instancetype) initWithLineStrings: (NSMutableArray<SFLineString *> *) lineStrings;

/**
 * Initialize
 *
 * @param lineString
 *            line string
 *
 *  @return new multi line string
 */
-(instancetype) initWithLineString: (SFLineString *) lineString;

/**
 * Initialize
 *
 * @param multiLineString
 *            multi line string
 *
 *  @return new multi line string
 */
-(instancetype) initWithMultiLineString: (SFMultiLineString *) multiLineString;

/**
 *  Get the line strings
 *
 *  @return line strings
 */
-(NSMutableArray<SFLineString *> *) lineStrings;

/**
 *  Set the line strings
 *
 *  @param lineStrings line strings
 */
-(void) setLineStrings: (NSMutableArray<SFLineString *> *) lineStrings;

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
