//
//  SFMultiCurve.m
//  sf-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "SFMultiCurve.h"

@implementation SFMultiCurve

-(instancetype) initWithType: (enum SFGeometryType) geometryType andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    self = [super initWithType:geometryType andHasZ:hasZ andHasM:hasM];
    return self;
}

-(NSMutableArray<SFCurve *> *) curves{
    return (NSMutableArray<SFCurve *> *)[self geometries];
}

-(void) setCurves: (NSMutableArray<SFCurve *> *) curves{
    [self setGeometries:(NSMutableArray<SFGeometry *> *)curves];
}

-(void) addCurve: (SFCurve *) curve{
    [self addGeometry:curve];
}

-(void) addCurves: (NSArray<SFCurve *> *) curves{
    return [self addGeometries:curves];
}

-(int) numCurves{
    return [self numGeometries];
}

-(SFCurve *) curveAtIndex: (int) n{
    return (SFCurve *)[self geometryAtIndex:n];
}

-(BOOL) isClosed{
    BOOL closed = YES;
    for (SFCurve *curve in self.geometries) {
        if (![curve isClosed]) {
            closed = NO;
            break;
        }
    }
    return closed;
}

@end
