//
//  SFGeometryPrinter.h
//  sf-ios
//
//  Created by Brian Osborn on 6/1/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "SFGeometry.h"

/**
 *  String representation of a Geometry
 */
@interface SFGeometryPrinter : NSObject

/**
 *  Get Geometry information as a String
 *
 *  @param geometry geometry
 *
 *  @return geometry string
 */
+(NSString *) geometryString: (SFGeometry *) geometry;

@end
