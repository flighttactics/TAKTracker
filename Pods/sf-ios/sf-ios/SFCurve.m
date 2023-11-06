//
//  SFCurve.m
//  sf-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "SFCurve.h"

@implementation SFCurve

-(instancetype) initWithType: (enum SFGeometryType) geometryType andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    self = [super initWithType:geometryType andHasZ:hasZ andHasM:hasM];
    return self;
}

-(SFPoint *) startPoint{
    [NSException raise:@"Abstract" format:@"Can not determine start point of abstract curve"];
    return nil;
}

-(SFPoint *) endPoint{
    [NSException raise:@"Abstract" format:@"Can not determine end point of abstract curve"];
    return nil;
}

-(BOOL) isClosed{
    return ![self isEmpty] && [[self startPoint] isEqual:[self endPoint]];
}

-(BOOL) isRing{
    return [self isClosed] && [self isSimple];
}

@end
