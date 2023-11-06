//
//  SFMultiLineString.m
//  sf-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "SFMultiLineString.h"
#import "SFGeometryUtils.h"

@implementation SFMultiLineString

+(SFMultiLineString *) multiLineString{
    return [[SFMultiLineString alloc] init];
}

+(SFMultiLineString *) multiLineStringWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [[SFMultiLineString alloc] initWithHasZ:hasZ andHasM:hasM];
}

+(SFMultiLineString *) multiLineStringWithLineStrings: (NSMutableArray<SFLineString *> *) lineStrings{
    return [[SFMultiLineString alloc] initWithLineStrings:lineStrings];
}

+(SFMultiLineString *) multiLineStringWithLineString: (SFLineString *) lineString{
    return [[SFMultiLineString alloc] initWithLineString:lineString];
}

+(SFMultiLineString *) multiLineStringWithMultiLineString: (SFMultiLineString *) multiLineString{
    return [[SFMultiLineString alloc] initWithMultiLineString:multiLineString];
}

-(instancetype) init{
    self = [self initWithHasZ:false andHasM:false];
    return self;
}

-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    self = [super initWithType:SF_MULTILINESTRING andHasZ:hasZ andHasM:hasM];
    return self;
}

-(instancetype) initWithLineStrings: (NSMutableArray<SFLineString *> *) lineStrings{
    self = [self initWithHasZ:[SFGeometryUtils hasZ:lineStrings] andHasM:[SFGeometryUtils hasM:lineStrings]];
    if(self != nil){
        [self setLineStrings:lineStrings];
    }
    return self;
}

-(instancetype) initWithLineString: (SFLineString *) lineString{
    self = [self initWithHasZ:lineString.hasZ andHasM:lineString.hasM];
    if(self != nil){
        [self addLineString:lineString];
    }
    return self;
}

-(instancetype) initWithMultiLineString: (SFMultiLineString *) multiLineString{
    self = [self initWithHasZ:multiLineString.hasZ andHasM:multiLineString.hasM];
    if(self != nil){
        for(SFLineString *lineString in multiLineString.geometries){
            [self addLineString:[lineString mutableCopy]];
        }
    }
    return self;
}

-(NSMutableArray<SFLineString *> *) lineStrings{
    return (NSMutableArray<SFLineString *> *)[self curves];
}

-(void) setLineStrings: (NSMutableArray<SFLineString *> *) lineStrings{
    [self setCurves:(NSMutableArray<SFCurve *> *)lineStrings];
}

-(void) addLineString: (SFLineString *) lineString{
    [self addCurve:lineString];
}

-(void) addLineStrings: (NSArray<SFLineString *> *) lineStrings{
    [self addCurves:lineStrings];
}

-(int) numLineStrings{
    return [self numCurves];
}

-(SFLineString *) lineStringAtIndex: (int) n{
    return (SFLineString *)[self curveAtIndex:n];
}

-(id) mutableCopyWithZone: (NSZone *) zone{
    return [SFMultiLineString multiLineStringWithMultiLineString:self];
}

@end
