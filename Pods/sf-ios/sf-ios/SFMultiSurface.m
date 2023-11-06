//
//  SFMultiSurface.m
//  sf-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "SFMultiSurface.h"

@implementation SFMultiSurface

-(instancetype) initWithType: (enum SFGeometryType) geometryType andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    self = [super initWithType:geometryType andHasZ:hasZ andHasM:hasM];
    return self;
}

-(NSMutableArray<SFSurface *> *) surfaces{
    return (NSMutableArray<SFSurface *> *)[self geometries];
}

-(void) setSurfaces: (NSMutableArray<SFSurface *> *) surfaces{
    [self setGeometries:(NSMutableArray<SFGeometry *> *)surfaces];
}

-(void) addSurface: (SFSurface *) surface{
    [self addGeometry:surface];
}

-(void) addSurfaces: (NSArray<SFSurface *> *) surfaces{
    return [self addGeometries:surfaces];
}

-(int) numSurfaces{
    return [self numGeometries];
}

-(SFSurface *) surfaceAtIndex: (int) n{
    return (SFSurface *)[self geometryAtIndex:n];
}

@end
