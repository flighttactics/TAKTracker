//
//  SFTextReader.h
//  sf-ios
//
//  Created by Brian Osborn on 8/3/20.
//  Copyright © 2020 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *Read through text string
 */
@interface SFTextReader : NSObject

/**
 *  Initialize
 *
 *  @param text text
 *
 *  @return new text reader
 */
-(instancetype) initWithText: (NSString *) text;

/**
 *  Get the text
 *
 *  @return text
 */
-(NSString *) text;

/**
 * Read the next token. Ignores whitespace until a non whitespace character
 * is encountered. Returns a contiguous block of token characters ( [a-z] |
 * [A-Z] | [0-9] | - | . | + ) or a non whitespace single character.
 *
 * @return token
 */
-(NSString *) readToken;

/**
 * Peek at the next token without reading past it
 *
 * @return next token
 */
-(NSString *) peekToken;

/**
 * Read a double
 *
 * @return double
 */
-(double) readDouble;

@end
