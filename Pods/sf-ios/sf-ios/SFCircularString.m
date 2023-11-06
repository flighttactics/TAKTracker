//
//  SFCircularString.m
//  sf-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "SFCircularString.h"
#import "SFGeometryUtils.h"

@implementation SFCircularString

+(SFCircularString *) circularString{
    return [[SFCircularString alloc] init];
}

+(SFCircularString *) circularStringWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [[SFCircularString alloc] initWithHasZ:hasZ andHasM:hasM];
}

+(SFCircularString *) circularStringWithPoints: (NSMutableArray<SFPoint *> *) points{
    return [[SFCircularString alloc] initWithPoints:points];
}

+(SFCircularString *) circularStringWithCircularString: (SFCircularString *) circularString{
    return [[SFCircularString alloc] initWithCircularString:circularString];
}

-(instancetype) init{
    self = [self initWithHasZ:false andHasM:false];
    return self;
}

-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    self = [super initWithType:SF_CIRCULARSTRING andHasZ:hasZ andHasM:hasM];
    return self;
}

-(instancetype) initWithPoints: (NSMutableArray<SFPoint *> *) points{
    self = [self initWithHasZ:[SFGeometryUtils hasZ:points] andHasM:[SFGeometryUtils hasM:points]];
    if(self != nil){
        [self setPoints:points];
    }
    return self;
}

-(instancetype) initWithCircularString: (SFCircularString *) circularString{
    self = [self initWithHasZ:circularString.hasZ andHasM:circularString.hasM];
    if(self != nil){
        for(SFPoint *point in circularString.points){
            [self addPoint:[point mutableCopy]];
        }
    }
    return self;
}

-(id) mutableCopyWithZone: (NSZone *) zone{
    return [SFCircularString circularStringWithCircularString:self];
}

@end
