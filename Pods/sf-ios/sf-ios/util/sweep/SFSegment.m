//
//  SFSegment.m
//  sf-ios
//
//  Created by Brian Osborn on 1/12/18.
//  Copyright © 2018 NGA. All rights reserved.
//

#import "SFSegment.h"

@interface SFSegment()

/**
 * Edge number
 */
@property (nonatomic) int edge;

/**
 * Polygon ring number
 */
@property (nonatomic) int ring;

/**
 * Left point
 */
@property (nonatomic, strong) SFPoint *leftPoint;

/**
 * Right point
 */
@property (nonatomic, strong) SFPoint *rightPoint;

@end

@implementation SFSegment

-(instancetype) initWithEdge: (int) edge
                     andRing: (int) ring
                andLeftPoint: (SFPoint *) leftPoint
               andRightPoint: (SFPoint *) rightPoint{
    self = [super init];
    if(self != nil){
        self.edge = edge;
        self.ring = ring;
        self.leftPoint = leftPoint;
        self.rightPoint = rightPoint;
    }
    return self;
}

-(int) edge{
    return _edge;
}

-(int) ring{
    return _ring;
}

-(SFPoint *) leftPoint{
    return _leftPoint;
}

-(SFPoint *) rightPoint{
    return _rightPoint;
}

@end
