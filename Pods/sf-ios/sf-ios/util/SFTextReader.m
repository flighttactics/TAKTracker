//
//  SFTextReader.m
//  sf-ios
//
//  Created by Brian Osborn on 8/3/20.
//  Copyright © 2020 NGA. All rights reserved.
//

#import "SFTextReader.h"

@interface SFTextReader()

/**
 * Text
 */
@property (nonatomic, strong) NSString *text;

/**
 * Next token cache for peeks
 */
@property (nonatomic, strong) NSString *nextToken;

/**
 * Next character number cache for between token caching
 */
@property (nonatomic) int nextCharacterNum;

@end

@implementation SFTextReader

-(instancetype) initWithText: (NSString *) text{
    self = [super init];
    if(self != nil){
        self.text = text;
        self.nextCharacterNum = 0;
    }
    return self;
}

-(NSString *) text{
    return _text;
}

-(NSString *) readToken{

    NSString *token = nil;

    // Get the next token, cached or read
    if (_nextToken != nil) {
        token = _nextToken;
        _nextToken = nil;
    } else {

        NSMutableString *buildToken = nil;

        // Continue while characters are left
        while (_nextCharacterNum < _text.length) {
            
            unichar character = [_text characterAtIndex:_nextCharacterNum];

            // Check if not the first character in the token
            if (buildToken != nil) {

                // Append token characters
                if ([self isTokenCharacter:character]) {
                    [buildToken appendFormat:@"%C", character];
                } else {
                    break;
                }

            } else if (![NSCharacterSet.whitespaceAndNewlineCharacterSet characterIsMember:character]) {

                // First non whitespace character in the token
                buildToken = [NSMutableString stringWithFormat:@"%C", character];

                // Complete token if a single character token
                if(![self isTokenCharacter:character]){
                    _nextCharacterNum++;
                    break;
                }

            }

            // Continue to the next character
            _nextCharacterNum++;
        }

        if (buildToken != nil) {
            token = buildToken;
        }

    }
    return token;
}

-(NSString *) peekToken{
    if (_nextToken == nil) {
        _nextToken = [self readToken];
    }
    return _nextToken;
}

-(double) readDouble{
    NSString *token = [self readToken];
    if (token == nil) {
        [NSException raise:@"Expected Double" format:@"Failed to read expected double value"];
    }
    double value;
    if([token caseInsensitiveCompare:@"NaN"] == NSOrderedSame){
        value = NAN;
    }else if([token caseInsensitiveCompare:@"infinity"] == NSOrderedSame){
        value = INFINITY;
    }else if([token caseInsensitiveCompare:@"-infinity"] == NSOrderedSame){
        value = -INFINITY;
    }else{
        value = [token doubleValue];
    }
    return value;
}

/**
 * Check if the character is a contiguous block token character: ( [a-z] |
 * [A-Z] | [0-9] | - | . | + )
 *
 * @param c character
 * @return true if token character
 */
-(BOOL) isTokenCharacter: (unichar) c{
    return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z')
            || (c >= '0' && c <= '9') || c == '-' || c == '.' || c == '+';
}

@end
