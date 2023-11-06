//
//  SFSurface.m
//  sf-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "SFSurface.h"

@implementation SFSurface

-(instancetype) initWithType: (enum SFGeometryType) geometryType andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    self = [super initWithType:geometryType andHasZ:hasZ andHasM:hasM];
    return self;
}

@end
