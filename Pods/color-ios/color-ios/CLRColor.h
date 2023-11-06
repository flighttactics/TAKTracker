//
//  CLRColor.h
//  color-ios
//
//  Created by Brian Osborn on 7/18/22.
//  Copyright © 2022 NGA. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Color representation with support for hex, RBG, arithmetic RBG, and integer
 * colors
 */
@interface CLRColor : NSObject <NSMutableCopying>

/**
 * Red arithmetic color value
 */
@property (nonatomic) float redArithmetic;

/**
 * Green arithmetic color value
 */
@property (nonatomic) float greenArithmetic;

/**
 * Blue arithmetic color value
 */
@property (nonatomic) float blueArithmetic;

/**
 * Opacity arithmetic value
 */
@property (nonatomic) float opacity;

/**
 * Create a black color
 *
 * @return color
 */
+(CLRColor *) black;

/**
 * Create a blue color
 *
 * @return color
 */
+(CLRColor *) blue;

/**
 * Create a brown color
 *
 * @return color
 */
+(CLRColor *) brown;

/**
 * Create a cyan color
 *
 * @return color
 */
+(CLRColor *) cyan;

/**
 * Create a dark gray color
 *
 * @return color
 */
+(CLRColor *) darkGray;

/**
 * Create a gray color
 *
 * @return color
 */
+(CLRColor *) gray;

/**
 * Create a green color
 *
 * @return color
 */
+(CLRColor *) green;

/**
 * Create a light gray color
 *
 * @return color
 */
+(CLRColor *) lightGray;

/**
 * Create a magenta color
 *
 * @return color
 */
+(CLRColor *) magenta;

/**
 * Create an orange color
 *
 * @return color
 */
+(CLRColor *) orange;

/**
 * Create a pink color
 *
 * @return color
 */
+(CLRColor *) pink;

/**
 * Create a purple color
 *
 * @return color
 */
+(CLRColor *) purple;

/**
 * Create a red color
 *
 * @return color
 */
+(CLRColor *) red;

/**
 * Create a violet color
 *
 * @return color
 */
+(CLRColor *) violet;

/**
 * Create a white color
 *
 * @return color
 */
+(CLRColor *) white;

/**
 * Create a yellow color
 *
 * @return color
 */
+(CLRColor *) yellow;

/**
 * Create the color in hex
 *
 * @param color
 *            hex color in format #RRGGBB, RRGGBB, #RGB, RGB, #AARRGGBB,
 *            AARRGGBB, #ARGB, or ARGB
 *
 * @return color
 */
+(CLRColor *) colorWithHex: (NSString *) color;

/**
 * Create the color in hex with an opacity
 *
 * @param color
 *            hex color in format #RRGGBB, RRGGBB, #RGB, RGB, #AARRGGBB,
 *            AARRGGBB, #ARGB, or ARGB
 * @param opacity
 *            opacity float inclusively between 0.0 and 1.0
 *
 * @return color
 */
+(CLRColor *) colorWithHex: (NSString *) color andOpacity: (float) opacity;

/**
 * Create the color in hex with an alpha
 *
 * @param color
 *            hex color in format #RRGGBB, RRGGBB, #RGB, RGB, #AARRGGBB,
 *            AARRGGBB, #ARGB, or ARGB
 * @param alpha
 *            alpha integer color inclusively between 0 and 255
 *
 * @return color
 */
+(CLRColor *) colorWithHex: (NSString *) color andAlpha: (int) alpha;

/**
 * Create the color with individual hex colors
 *
 * @param red
 *            red hex color in format RR
 * @param green
 *            green hex color in format GG
 * @param blue
 *            blue hex color in format BB
 *
 * @return color
 */
+(CLRColor *) colorWithHexRed: (NSString *) red andGreen: (NSString *) green andBlue: (NSString *) blue;

/**
 * Create the color with individual hex colors and alpha
 *
 * @param red
 *            red hex color in format RR
 * @param green
 *            green hex color in format GG
 * @param blue
 *            blue hex color in format BB
 * @param alpha
 *            alpha hex color in format AA
 *
 * @return color
 */
+(CLRColor *) colorWithHexRed: (NSString *) red andGreen: (NSString *) green andBlue: (NSString *) blue andAlpha: (NSString *) alpha;

/**
 * Create the color with individual hex colors and opacity
 *
 * @param red
 *            red hex color in format RR
 * @param green
 *            green hex color in format GG
 * @param blue
 *            blue hex color in format BB
 * @param opacity
 *            opacity float inclusively between 0.0 and 1.0
 *
 * @return color
 */
+(CLRColor *) colorWithHexRed: (NSString *) red andGreen: (NSString *) green andBlue: (NSString *) blue andOpacity: (float) opacity;

/**
 * Create the color with RGB values
 *
 * @param red
 *            red integer color inclusively between 0 and 255
 * @param green
 *            green integer color inclusively between 0 and 255
 * @param blue
 *            blue integer color inclusively between 0 and 255
 *
 * @return color
 */
+(CLRColor *) colorWithRed: (int) red andGreen: (int) green andBlue: (int) blue;

/**
 * Create the color with RGBA values
 *
 * @param red
 *            red integer color inclusively between 0 and 255
 * @param green
 *            green integer color inclusively between 0 and 255
 * @param blue
 *            blue integer color inclusively between 0 and 255
 * @param alpha
 *            alpha integer color inclusively between 0 and 255
 *
 * @return color
 */
+(CLRColor *) colorWithRed: (int) red andGreen: (int) green andBlue: (int) blue andAlpha: (int) alpha;

/**
 * Create the color with RGBA values
 *
 * @param red
 *            red integer color inclusively between 0 and 255
 * @param green
 *            green integer color inclusively between 0 and 255
 * @param blue
 *            blue integer color inclusively between 0 and 255
 * @param opacity
 *            opacity float inclusively between 0.0 and 1.0
 *
 * @return color
 */
+(CLRColor *) colorWithRed: (int) red andGreen: (int) green andBlue: (int) blue andOpacity: (float) opacity;

/**
 * Create the color with arithmetic RGB values
 *
 * @param red
 *            red float color inclusively between 0.0 and 1.0
 * @param green
 *            green float color inclusively between 0.0 and 1.0
 * @param blue
 *            blue float color inclusively between 0.0 and 1.0
 *
 * @return color
 */
+(CLRColor *) colorWithArithmeticRed: (float) red andGreen: (float) green andBlue: (float) blue;

/**
 * Create the color with arithmetic RGB values
 *
 * @param red
 *            red float color inclusively between 0.0 and 1.0
 * @param green
 *            green float color inclusively between 0.0 and 1.0
 * @param blue
 *            blue float color inclusively between 0.0 and 1.0
 * @param opacity
 *            opacity float inclusively between 0.0 and 1.0
 *
 * @return color
 */
+(CLRColor *) colorWithArithmeticRed: (float) red andGreen: (float) green andBlue: (float) blue andOpacity: (float) opacity;

/**
 * Create the color with HSL (hue, saturation, lightness) or HSL (alpha)
 * values
 *
 * @param hue
 *            hue
 * @param saturation
 *            saturation
 * @param lightness
 *            lightness
 *
 * @return color
 */
+(CLRColor *) colorWithHue: (float) hue andSaturation: (float) saturation andLightness: (float) lightness;

/**
 * Create the color with HSLA (hue, saturation, lightness, alpha) values
 *
 * @param hue
 *            hue
 * @param saturation
 *            saturation
 * @param lightness
 *            lightness
 * @param alpha
 *            alpha inclusively between 0.0 and 1.0
 *
 * @return color
 */
+(CLRColor *) colorWithHue: (float) hue andSaturation: (float) saturation andLightness: (float) lightness andAlpha: (float) alpha;

/**
 * Create the color as a single integer
 *
 * @param color
 *            color integer
 *
 * @return color
 */
+(CLRColor *) colorWithColor: (int) color;

/**
 * Create the color as a single unsigned integer
 *
 * @param color
 *            color unsigned integer
 *
 * @return color
 */
+(CLRColor *) colorWithUnsignedColor: (unsigned int) color;

/**
 * Default color initializer, opaque black
 *
 * @return new color
 */
-(instancetype) init;

/**
 * Create the color in hex
 *
 * @param color
 *            hex color in format #RRGGBB, RRGGBB, #RGB, RGB, #AARRGGBB,
 *            AARRGGBB, #ARGB, or ARGB
 *
 * @return new color
 */
-(instancetype) initWithHex: (NSString *) color;

/**
 * Create the color in hex with an opacity
 *
 * @param color
 *            hex color in format #RRGGBB, RRGGBB, #RGB, RGB, #AARRGGBB,
 *            AARRGGBB, #ARGB, or ARGB
 * @param opacity
 *            opacity float inclusively between 0.0 and 1.0
 *
 * @return new color
 */
-(instancetype) initWithHex: (NSString *) color andOpacity: (float) opacity;

/**
 * Create the color in hex with an alpha
 *
 * @param color
 *            hex color in format #RRGGBB, RRGGBB, #RGB, RGB, #AARRGGBB,
 *            AARRGGBB, #ARGB, or ARGB
 * @param alpha
 *            alpha integer color inclusively between 0 and 255
 *
 * @return new color
 */
-(instancetype) initWithHex: (NSString *) color andAlpha: (int) alpha;

/**
 * Create the color with individual hex colors
 *
 * @param red
 *            red hex color in format RR
 * @param green
 *            green hex color in format GG
 * @param blue
 *            blue hex color in format BB
 *
 * @return new color
 */
-(instancetype) initWithHexRed: (NSString *) red andGreen: (NSString *) green andBlue: (NSString *) blue;

/**
 * Create the color with individual hex colors and alpha
 *
 * @param red
 *            red hex color in format RR
 * @param green
 *            green hex color in format GG
 * @param blue
 *            blue hex color in format BB
 * @param alpha
 *            alpha hex color in format AA
 *
 * @return new color
 */
-(instancetype) initWithHexRed: (NSString *) red andGreen: (NSString *) green andBlue: (NSString *) blue andAlpha: (NSString *) alpha;

/**
 * Create the color with individual hex colors and opacity
 *
 * @param red
 *            red hex color in format RR
 * @param green
 *            green hex color in format GG
 * @param blue
 *            blue hex color in format BB
 * @param opacity
 *            opacity float inclusively between 0.0 and 1.0
 *
 * @return new color
 */
-(instancetype) initWithHexRed: (NSString *) red andGreen: (NSString *) green andBlue: (NSString *) blue andOpacity: (float) opacity;

/**
 * Create the color with RGB values
 *
 * @param red
 *            red integer color inclusively between 0 and 255
 * @param green
 *            green integer color inclusively between 0 and 255
 * @param blue
 *            blue integer color inclusively between 0 and 255
 *
 * @return new color
 */
-(instancetype) initWithRed: (int) red andGreen: (int) green andBlue: (int) blue;

/**
 * Create the color with RGBA values
 *
 * @param red
 *            red integer color inclusively between 0 and 255
 * @param green
 *            green integer color inclusively between 0 and 255
 * @param blue
 *            blue integer color inclusively between 0 and 255
 * @param alpha
 *            alpha integer color inclusively between 0 and 255
 *
 * @return new color
 */
-(instancetype) initWithRed: (int) red andGreen: (int) green andBlue: (int) blue andAlpha: (int) alpha;

/**
 * Create the color with RGBA values
 *
 * @param red
 *            red integer color inclusively between 0 and 255
 * @param green
 *            green integer color inclusively between 0 and 255
 * @param blue
 *            blue integer color inclusively between 0 and 255
 * @param opacity
 *            opacity float inclusively between 0.0 and 1.0
 *
 * @return new color
 */
-(instancetype) initWithRed: (int) red andGreen: (int) green andBlue: (int) blue andOpacity: (float) opacity;

/**
 * Create the color with arithmetic RGB values
 *
 * @param red
 *            red float color inclusively between 0.0 and 1.0
 * @param green
 *            green float color inclusively between 0.0 and 1.0
 * @param blue
 *            blue float color inclusively between 0.0 and 1.0
 *
 * @return new color
 */
-(instancetype) initWithArithmeticRed: (float) red andGreen: (float) green andBlue: (float) blue;

/**
 * Create the color with arithmetic RGB values
 *
 * @param red
 *            red float color inclusively between 0.0 and 1.0
 * @param green
 *            green float color inclusively between 0.0 and 1.0
 * @param blue
 *            blue float color inclusively between 0.0 and 1.0
 * @param opacity
 *            opacity float inclusively between 0.0 and 1.0
 *
 * @return new color
 */
-(instancetype) initWithArithmeticRed: (float) red andGreen: (float) green andBlue: (float) blue andOpacity: (float) opacity;

/**
 * Create the color with HSL (hue, saturation, lightness) or HSL (alpha)
 * values
 *
 * @param hue
 *            hue
 * @param saturation
 *            saturation
 * @param lightness
 *            lightness
 *
 * @return new color
 */
-(instancetype) initWithHue: (float) hue andSaturation: (float) saturation andLightness: (float) lightness;

/**
 * Create the color with HSLA (hue, saturation, lightness, alpha) values
 *
 * @param hue
 *            hue
 * @param saturation
 *            saturation
 * @param lightness
 *            lightness
 * @param alpha
 *            alpha inclusively between 0.0 and 1.0
 *
 * @return new color
 */
-(instancetype) initWithHue: (float) hue andSaturation: (float) saturation andLightness: (float) lightness andAlpha: (float) alpha;

/**
 * Create the color as a single integer
 *
 * @param color
 *            color integer
 *
 * @return new color
 */
-(instancetype) initWithColor: (int) color;

/**
 * Create the color as a single unsigned integer
 *
 * @param color
 *            color unsigned integer
 *
 * @return new color
 */
-(instancetype) initWithUnsignedColor: (unsigned int) color;

/**
 * Copy Initialize
 *
 * @param color
 *            color to copy
 *
 * @return new color
 */
-(instancetype) initWithCLRColor: (CLRColor *) color;

/**
 * Set the color in hex
 *
 * @param color
 *            hex color in format #RRGGBB, RRGGBB, #RGB, RGB, #AARRGGBB,
 *            AARRGGBB, #ARGB, or ARGB
 */
-(void) setColorWithHex: (NSString *) color;

/**
 * Set the color in hex with an opacity
 *
 * @param color
 *            hex color in format #RRGGBB, RRGGBB, #RGB, RGB, #AARRGGBB,
 *            AARRGGBB, #ARGB, or ARGB
 * @param opacity
 *            opacity float inclusively between 0.0 and 1.0
 */
-(void) setColorWithHex: (NSString *) color andOpacity: (float) opacity;

/**
 * Set the color in hex with an alpha
 *
 * @param color
 *            hex color in format #RRGGBB, RRGGBB, #RGB, RGB, #AARRGGBB,
 *            AARRGGBB, #ARGB, or ARGB
 * @param alpha
 *            alpha integer color inclusively between 0 and 255
 */
-(void) setColorWithHex: (NSString *) color andAlpha: (int) alpha;

/**
 * Set the color with individual hex colors
 *
 * @param red
 *            red hex color in format RR
 * @param green
 *            green hex color in format GG
 * @param blue
 *            blue hex color in format BB
 */
-(void) setColorWithHexRed: (NSString *) red andGreen: (NSString *) green andBlue: (NSString *) blue;

/**
 * Set the color with individual hex colors and alpha
 *
 * @param red
 *            red hex color in format RR
 * @param green
 *            green hex color in format GG
 * @param blue
 *            blue hex color in format BB
 * @param alpha
 *            alpha hex color in format AA
 */
-(void) setColorWithHexRed: (NSString *) red andGreen: (NSString *) green andBlue: (NSString *) blue andAlpha: (NSString *) alpha;

/**
 * Set the color with individual hex colors and opacity
 *
 * @param red
 *            red hex color in format RR
 * @param green
 *            green hex color in format GG
 * @param blue
 *            blue hex color in format BB
 * @param opacity
 *            opacity float inclusively between 0.0 and 1.0
 */
-(void) setColorWithHexRed: (NSString *) red andGreen: (NSString *) green andBlue: (NSString *) blue andOpacity: (float) opacity;

/**
 * Set the color with RGB values
 *
 * @param red
 *            red integer color inclusively between 0 and 255
 * @param green
 *            green integer color inclusively between 0 and 255
 * @param blue
 *            blue integer color inclusively between 0 and 255
 */
-(void) setColorWithRed: (int) red andGreen: (int) green andBlue: (int) blue;

/**
 * Set the color with RGBA values
 *
 * @param red
 *            red integer color inclusively between 0 and 255
 * @param green
 *            green integer color inclusively between 0 and 255
 * @param blue
 *            blue integer color inclusively between 0 and 255
 * @param alpha
 *            alpha integer color inclusively between 0 and 255
 */
-(void) setColorWithRed: (int) red andGreen: (int) green andBlue: (int) blue andAlpha: (int) alpha;

/**
 * Set the color with RGBA values
 *
 * @param red
 *            red integer color inclusively between 0 and 255
 * @param green
 *            green integer color inclusively between 0 and 255
 * @param blue
 *            blue integer color inclusively between 0 and 255
 * @param opacity
 *            opacity float inclusively between 0.0 and 1.0
 */
-(void) setColorWithRed: (int) red andGreen: (int) green andBlue: (int) blue andOpacity: (float) opacity;

/**
 * Set the color with arithmetic RGB values
 *
 * @param red
 *            red float color inclusively between 0.0 and 1.0
 * @param green
 *            green float color inclusively between 0.0 and 1.0
 * @param blue
 *            blue float color inclusively between 0.0 and 1.0
 */
-(void) setColorWithArithmeticRed: (float) red andGreen: (float) green andBlue: (float) blue;

/**
 * Set the color with arithmetic RGB values
 *
 * @param red
 *            red float color inclusively between 0.0 and 1.0
 * @param green
 *            green float color inclusively between 0.0 and 1.0
 * @param blue
 *            blue float color inclusively between 0.0 and 1.0
 * @param opacity
 *            opacity float inclusively between 0.0 and 1.0
 */
-(void) setColorWithArithmeticRed: (float) red andGreen: (float) green andBlue: (float) blue andOpacity: (float) opacity;

/**
 * Set the color with HSL (hue, saturation, lightness) values
 *
 * @param hue
 *            hue value inclusively between 0.0 and 360.0
 * @param saturation
 *            saturation inclusively between 0.0 and 1.0
 * @param lightness
 *            lightness inclusively between 0.0 and 1.0
 */
-(void) setColorWithHue: (float) hue andSaturation: (float) saturation andLightness: (float) lightness;

/**
 * Set the color with HSLA (hue, saturation, lightness, alpha) values
 *
 * @param hue
 *            hue value inclusively between 0.0 and 360.0
 * @param saturation
 *            saturation inclusively between 0.0 and 1.0
 * @param lightness
 *            lightness inclusively between 0.0 and 1.0
 * @param alpha
 *            alpha inclusively between 0.0 and 1.0
 */
-(void) setColorWithHue: (float) hue andSaturation: (float) saturation andLightness: (float) lightness andAlpha: (float) alpha;

/**
 * Set the color as a single integer
 *
 * @param color
 *            color integer
 */
-(void) setColor: (int) color;

/**
 * Set the color as a single unsigned integer
 *
 * @param color
 *            color unsigned integer
 */
-(void) setUnsignedColor: (unsigned int) color;

/**
 * Set the red color in hex
 *
 * @param red
 *            red hex color in format RR or R
 */
-(void) setRedHex: (NSString *) red;

/**
 * Set the green color in hex
 *
 * @param green
 *            green hex color in format GG or G
 */
-(void) setGreenHex: (NSString *) green;

/**
 * Set the blue color in hex
 *
 * @param blue
 *            blue hex color in format BB or B
 */
-(void) setBlueHex: (NSString *) blue;

/**
 * Set the alpha color in hex
 *
 * @param alpha
 *            alpha hex color in format AA or A
 */
-(void) setAlphaHex: (NSString *) alpha;

/**
 * Set the red color as an integer
 *
 * @param red
 *            red integer color inclusively between 0 and 255
 */
-(void) setRed: (int) red;

/**
 * Set the green color as an integer
 *
 * @param green
 *            green integer color inclusively between 0 and 255
 */
-(void) setGreen: (int) green;

/**
 * Set the blue color as an integer
 *
 * @param blue
 *            blue integer color inclusively between 0 and 255
 */
-(void) setBlue: (int) blue;

/**
 * Set the alpha color as an integer
 *
 * @param alpha
 *            alpha integer color inclusively between 0 and 255
 */
-(void) setAlpha: (int) alpha;

/**
 * Set the alpha color as an arithmetic float
 *
 * @param alpha
 *            alpha float color inclusively between 0.0 and 1.0
 */
-(void) setAlphaArithmetic: (float) alpha;

/**
 * Check if the color is opaque (opacity or alpha of 1.0, 255, or x00)
 *
 * @return true if opaque
 */
-(BOOL) isOpaque;

/**
 * Get a UIColor from this color
 *
 * @return color
 */
-(UIColor *) uiColor;

/**
 * Get the color as a hex string
 *
 * @return hex color in the format #RRGGBB
 */
-(NSString *) colorHex;

/**
 * Get the color as a hex string with alpha
 *
 * @return hex color in the format #AARRGGBB
 */
-(NSString *) colorHexWithAlpha;

/**
 * Get the color as a hex string, shorthanded when possible
 *
 * @return hex color in the format #RGB or #RRGGBB
 */
-(NSString *) colorHexShorthand;

/**
 * Get the color as a hex string with alpha, shorthanded when possible
 *
 * @return hex color in the format #ARGB or #AARRGGBB
 */
-(NSString *) colorHexShorthandWithAlpha;

/**
 * Get the color as an integer
 *
 * @return integer color
 */
-(int) color;

/**
 * Get the color as an unsigned integer
 *
 * @return unsigned integer color
 */
-(unsigned int) unsignedColor;

/**
 * Get the color as an integer including the alpha
 *
 * @return integer color
 */
-(int) colorWithAlpha;

/**
 * Get the color as an unsigned integer including the alpha
 *
 * @return unsigned integer color
 */
-(unsigned int) unsignedColorWithAlpha;

/**
 * Get the red color in hex
 *
 * @return red hex color in format RR
 */
-(NSString *) redHex;

/**
 * Get the green color in hex
 *
 * @return green hex color in format GG
 */
-(NSString *) greenHex;

/**
 * Get the blue color in hex
 *
 * @return blue hex color in format BB
 */
-(NSString *) blueHex;

/**
 * Get the alpha color in hex
 *
 * @return alpha hex color in format AA
 */
-(NSString *) alphaHex;

/**
 * Get the red color in hex, shorthand when possible
 *
 * @return red hex color in format R or RR
 */
-(NSString *) redHexShorthand;

/**
 * Get the green color in hex, shorthand when possible
 *
 * @return green hex color in format G or GG
 */
-(NSString *) greenHexShorthand;

/**
 * Get the blue color in hex, shorthand when possible
 *
 * @return blue hex color in format B or BB
 */
-(NSString *) blueHexShorthand;

/**
 * Get the alpha color in hex, shorthand when possible
 *
 * @return alpha hex color in format A or AA
 */
-(NSString *) alphaHexShorthand;

/**
 * Get the red color as an integer
 *
 * @return red integer color inclusively between 0 and 255
 */
-(int) red;

/**
 * Get the green color as an integer
 *
 * @return green integer color inclusively between 0 and 255
 */
-(int) green;

/**
 * Get the blue color as an integer
 *
 * @return blue integer color inclusively between 0 and 255
 */
-(int) blue;

/**
 * Get the alpha color as an integer
 *
 * @return alpha integer color inclusively between 0 and 255
 */
-(int) alpha;

/**
 * Get the alpha color as an arithmetic float
 *
 * @return alpha float color inclusively between 0.0 and 1.0
 */
-(float) alphaArithmetic;

/**
 * Get the HSL (hue, saturation, lightness) values
 *
 * @return HSL array where: 0 = hue, 1 = saturation, 2 = lightness
 */
-(float *) hsl;

/**
 * Get the HSL hue value
 *
 * @return hue value
 */
-(float) hue;

/**
 * Get the HSL saturation value
 *
 * @return saturation value
 */
-(float) saturation;

/**
 * Get the HSL lightness value
 *
 * @return lightness value
 */
-(float) lightness;

@end
