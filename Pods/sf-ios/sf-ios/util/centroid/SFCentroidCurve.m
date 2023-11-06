//
//  SFCentroidCurve.m
//  sf-ios
//
//  Created by Brian Osborn on 4/14/17.
//  Copyright © 2017 NGA. All rights reserved.
//

#import "SFCentroidCurve.h"
#import "SFGeometryUtils.h"
#import "SFMultiLineString.h"

@interface SFCentroidCurve()

/**
 * Sum of curve point locations
 */
@property (nonatomic, strong) SFPoint *sum;

/**
 * Total length of curves
 */
@property (nonatomic) double totalLength;

@end

@implementation SFCentroidCurve

-(instancetype) init{
    return [self initWithGeometry:nil];
}

-(instancetype) initWithGeometry: (SFGeometry *) geometry{
    self = [super init];
    if(self != nil){
        self.sum = [SFPoint point];
        self.totalLength = 0;
        [self addGeometry:geometry];
    }
    return self;
}

-(void) addGeometry: (SFGeometry *) geometry{
    enum SFGeometryType geometryType = geometry.geometryType;
    switch (geometryType) {
        case SF_LINESTRING:
        case SF_CIRCULARSTRING:
            [self addLineString:(SFLineString *)geometry];
            break;
        case SF_MULTILINESTRING:
            [self addLineStrings:[((SFMultiLineString *)geometry) lineStrings]];
            break;
        case SF_COMPOUNDCURVE:
            [self addLineStrings:((SFCompoundCurve *)geometry).lineStrings];
            break;
        case SF_GEOMETRYCOLLECTION:
        case SF_MULTICURVE:
        case SF_MULTISURFACE:
            {
                SFGeometryCollection *geomCollection = (SFGeometryCollection *) geometry;
                for (SFGeometry *subGeometry in geomCollection.geometries) {
                    [self addGeometry:subGeometry];
                }
            
            }
            break;
        case SF_POINT:
        case SF_MULTIPOINT:
            // Doesn't contribute to curve dimension
            break;
        default:
            [NSException raise:@"Geometry Not Supported" format:@"Unsupported Geometry Type: %d", geometryType];
    }
}

/**
 * Add line strings to the centroid total
 *
 * @param lineStrings
 *            line strings
 */
-(void) addLineStrings: (NSArray *) lineStrings{
    for(SFLineString *lineString in lineStrings){
        [self addLineString:lineString];
    }
}

/**
 * Add a line string to the centroid total
 *
 * @param lineString
 *            line string
 */
-(void) addLineString: (SFLineString *) lineString{
    [self addPoints:lineString.points];
}

/**
 * Add points to the centroid total
 *
 * @param points
 *            points
 */
-(void) addPoints: (NSArray *) points{
    for(int i = 0; i < points.count - 1; i++){
        SFPoint *point = [points objectAtIndex:i];
        SFPoint *nextPoint = [points objectAtIndex:i + 1];
        
        double length = [SFGeometryUtils distanceBetweenPoint1:point andPoint2:nextPoint];
        self.totalLength += length;
        
        double midX = ([point.x doubleValue] + [nextPoint.x doubleValue]) / 2;
        [self.sum setX:[self.sum.x decimalNumberByAdding:[[NSDecimalNumber alloc] initWithDouble:length * midX]]];
        double midY = ([point.y doubleValue] + [nextPoint.y doubleValue]) / 2;
        [self.sum setY:[self.sum.y decimalNumberByAdding:[[NSDecimalNumber alloc] initWithDouble:length * midY]]];
    }
}

-(SFPoint *) centroid{
    SFPoint *centroid = [SFPoint pointWithXValue:([self.sum.x doubleValue] / self.totalLength) andYValue:([self.sum.y doubleValue] / self.totalLength)];
    return centroid;
}

@end
