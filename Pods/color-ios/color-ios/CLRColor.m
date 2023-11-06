//
//  CLRColor.m
//  color-ios
//
//  Created by Brian Osborn on 7/18/22.
//  Copyright © 2022 NGA. All rights reserved.
//

#import "CLRColor.h"
#import "CLRColorUtils.h"
#import "CLRColorConstants.h"

@implementation CLRColor

+(CLRColor *) black{
    return [self colorWithHex:CLR_COLOR_BLACK];
}

+(CLRColor *) blue{
    return [self colorWithHex:CLR_COLOR_BLUE];
}

+(CLRColor *) brown{
    return [self colorWithHex:CLR_COLOR_BROWN];
}

+(CLRColor *) cyan{
    return [self colorWithHex:CLR_COLOR_CYAN];
}

+(CLRColor *) darkGray{
    return [self colorWithHex:CLR_COLOR_DKGRAY];
}

+(CLRColor *) gray{
    return [self colorWithHex:CLR_COLOR_GRAY];
}

+(CLRColor *) green{
    return [self colorWithHex:CLR_COLOR_GREEN];
}

+(CLRColor *) lightGray{
    return [self colorWithHex:CLR_COLOR_LTGRAY];
}

+(CLRColor *) magenta{
    return [self colorWithHex:CLR_COLOR_MAGENTA];
}

+(CLRColor *) orange{
    return [self colorWithHex:CLR_COLOR_ORANGE];
}

+(CLRColor *) pink{
    return [self colorWithHex:CLR_COLOR_PINK];
}

+(CLRColor *) purple{
    return [self colorWithHex:CLR_COLOR_PURPLE];
}

+(CLRColor *) red{
    return [self colorWithHex:CLR_COLOR_RED];
}

+(CLRColor *) violet{
    return [self colorWithHex:CLR_COLOR_VIOLET];
}

+(CLRColor *) white{
    return [self colorWithHex:CLR_COLOR_WHITE];
}

+(CLRColor *) yellow{
    return [self colorWithHex:CLR_COLOR_YELLOW];
}

+(CLRColor *) colorWithHex: (NSString *) color{
    return [[CLRColor alloc] initWithHex:color];
}

+(CLRColor *) colorWithHex: (NSString *) color andOpacity: (float) opacity{
    return [[CLRColor alloc] initWithHex:color andOpacity:opacity];
}

+(CLRColor *) colorWithHex: (NSString *) color andAlpha: (int) alpha{
    return [[CLRColor alloc] initWithHex:color andAlpha:alpha];
}

+(CLRColor *) colorWithHexRed: (NSString *) red andGreen: (NSString *) green andBlue: (NSString *) blue{
    return [[CLRColor alloc] initWithHexRed:red andGreen:green andBlue:blue];
}

+(CLRColor *) colorWithHexRed: (NSString *) red andGreen: (NSString *) green andBlue: (NSString *) blue andAlpha: (NSString *) alpha{
    return [[CLRColor alloc] initWithHexRed:red andGreen:green andBlue:blue andAlpha:alpha];
}

+(CLRColor *) colorWithHexRed: (NSString *) red andGreen: (NSString *) green andBlue: (NSString *) blue andOpacity: (float) opacity{
    return [[CLRColor alloc] initWithHexRed:red andGreen:green andBlue:blue andOpacity:opacity];
}

+(CLRColor *) colorWithRed: (int) red andGreen: (int) green andBlue: (int) blue{
    return [[CLRColor alloc] initWithRed:red andGreen:green andBlue:blue];
}

+(CLRColor *) colorWithRed: (int) red andGreen: (int) green andBlue: (int) blue andAlpha: (int) alpha{
    return [[CLRColor alloc] initWithRed:red andGreen:green andBlue:blue andAlpha:alpha];
}

+(CLRColor *) colorWithRed: (int) red andGreen: (int) green andBlue: (int) blue andOpacity: (float) opacity{
    return [[CLRColor alloc] initWithRed:red andGreen:green andBlue:blue andOpacity:opacity];
}

+(CLRColor *) colorWithArithmeticRed: (float) red andGreen: (float) green andBlue: (float) blue{
    return [[CLRColor alloc] initWithArithmeticRed:red andGreen:green andBlue:blue];
}

+(CLRColor *) colorWithArithmeticRed: (float) red andGreen: (float) green andBlue: (float) blue andOpacity: (float) opacity{
    return [[CLRColor alloc] initWithArithmeticRed:red andGreen:green andBlue:blue andOpacity:opacity];
}

+(CLRColor *) colorWithHue: (float) hue andSaturation: (float) saturation andLightness: (float) lightness{
    return [[CLRColor alloc] initWithHue:hue andSaturation:saturation andLightness:lightness];
}

+(CLRColor *) colorWithHue: (float) hue andSaturation: (float) saturation andLightness: (float) lightness andAlpha: (float) alpha{
    return [[CLRColor alloc] initWithHue:hue andSaturation:saturation andLightness:lightness andAlpha:alpha];
}

+(CLRColor *) colorWithColor: (int) color{
    return [[CLRColor alloc] initWithColor:color];
}

+(CLRColor *) colorWithUnsignedColor: (unsigned int) color{
    return [[CLRColor alloc] initWithUnsignedColor:color];
}

-(instancetype) init{
    self = [super init];
    if(self != nil){
        _redArithmetic = 0.0;
        _greenArithmetic = 0.0;
        _blueArithmetic = 0.0;
        _opacity = 1.0;
    }
    return self;
}

-(instancetype) initWithHex: (NSString *) color{
    self = [self init];
    if(self != nil){
        [self setColorWithHex:color];
    }
    return self;
}

-(instancetype) initWithHex: (NSString *) color andOpacity: (float) opacity{
    self = [self init];
    if(self != nil){
        [self setColorWithHex:color andOpacity:opacity];
    }
    return self;
}

-(instancetype) initWithHex: (NSString *) color andAlpha: (int) alpha{
    self = [self init];
    if(self != nil){
        [self setColorWithHex:color andAlpha:alpha];
    }
    return self;
}

-(instancetype) initWithHexRed: (NSString *) red andGreen: (NSString *) green andBlue: (NSString *) blue{
    self = [self init];
    if(self != nil){
        [self setColorWithHexRed:red andGreen:green andBlue:blue];
    }
    return self;
}

-(instancetype) initWithHexRed: (NSString *) red andGreen: (NSString *) green andBlue: (NSString *) blue andAlpha: (NSString *) alpha{
    self = [self init];
    if(self != nil){
        [self setColorWithHexRed:red andGreen:green andBlue:blue andAlpha:alpha];
    }
    return self;
}

-(instancetype) initWithHexRed: (NSString *) red andGreen: (NSString *) green andBlue: (NSString *) blue andOpacity: (float) opacity{
    self = [self init];
    if(self != nil){
        [self setColorWithHexRed:red andGreen:green andBlue:blue andOpacity:opacity];
    }
    return self;
}

-(instancetype) initWithRed: (int) red andGreen: (int) green andBlue: (int) blue{
    self = [self init];
    if(self != nil){
        [self setColorWithRed:red andGreen:green andBlue:blue];
    }
    return self;
}

-(instancetype) initWithRed: (int) red andGreen: (int) green andBlue: (int) blue andAlpha: (int) alpha{
    self = [self init];
    if(self != nil){
        [self setColorWithRed:red andGreen:green andBlue:blue andAlpha:alpha];
    }
    return self;
}

-(instancetype) initWithRed: (int) red andGreen: (int) green andBlue: (int) blue andOpacity: (float) opacity{
    self = [self init];
    if(self != nil){
        [self setColorWithRed:red andGreen:green andBlue:blue andOpacity:opacity];
    }
    return self;
}

-(instancetype) initWithArithmeticRed: (float) red andGreen: (float) green andBlue: (float) blue{
    self = [self init];
    if(self != nil){
        [self setColorWithArithmeticRed:red andGreen:green andBlue:blue];
    }
    return self;
}

-(instancetype) initWithArithmeticRed: (float) red andGreen: (float) green andBlue: (float) blue andOpacity: (float) opacity{
    self = [self init];
    if(self != nil){
        [self setColorWithArithmeticRed:red andGreen:green andBlue:blue andOpacity:opacity];
    }
    return self;
}

-(instancetype) initWithHue: (float) hue andSaturation: (float) saturation andLightness: (float) lightness{
    self = [self init];
    if(self != nil){
        [self setColorWithHue:hue andSaturation:saturation andLightness:lightness];
    }
    return self;
}

-(instancetype) initWithHue: (float) hue andSaturation: (float) saturation andLightness: (float) lightness andAlpha: (float) alpha{
    self = [self init];
    if(self != nil){
        [self setColorWithHue:hue andSaturation:saturation andLightness:lightness andAlpha:alpha];
    }
    return self;
}

-(instancetype) initWithColor: (int) color{
    self = [self init];
    if(self != nil){
        [self setColor:color];
    }
    return self;
}

-(instancetype) initWithUnsignedColor: (unsigned int) color{
    self = [self init];
    if(self != nil){
        [self setUnsignedColor:color];
    }
    return self;
}

-(instancetype) initWithCLRColor: (CLRColor *) color{
    self = [self init];
    if(self != nil){
        _redArithmetic = color.redArithmetic;
        _greenArithmetic = color.greenArithmetic;
        _blueArithmetic = color.blueArithmetic;
        _opacity = color.opacity;
    }
    return self;
}

-(void) setColorWithHex: (NSString *) color{
    [self setRedHex:[CLRColorUtils redHexFromHex:color]];
    [self setGreenHex:[CLRColorUtils greenHexFromHex:color]];
    [self setBlueHex:[CLRColorUtils blueHexFromHex:color]];
    NSString *alpha = [CLRColorUtils alphaHexFromHex:color];
    if(alpha != nil){
        [self setAlphaHex:alpha];
    }
}

-(void) setColorWithHex: (NSString *) color andOpacity: (float) opacity{
    [self setColorWithHex:color];
    [self setOpacity:opacity];
}

-(void) setColorWithHex: (NSString *) color andAlpha: (int) alpha{
    [self setColorWithHex:color];
    [self setAlpha:alpha];
}

-(void) setColorWithHexRed: (NSString *) red andGreen: (NSString *) green andBlue: (NSString *) blue{
    [self setRedHex:red];
    [self setGreenHex:green];
    [self setBlueHex:blue];
}

-(void) setColorWithHexRed: (NSString *) red andGreen: (NSString *) green andBlue: (NSString *) blue andAlpha: (NSString *) alpha{
    [self setColorWithHexRed:red andGreen:green andBlue:blue];
    [self setAlphaHex:alpha];
}

-(void) setColorWithHexRed: (NSString *) red andGreen: (NSString *) green andBlue: (NSString *) blue andOpacity: (float) opacity{
    [self setColorWithHexRed:red andGreen:green andBlue:blue];
    [self setOpacity:opacity];
}

-(void) setColorWithRed: (int) red andGreen: (int) green andBlue: (int) blue{
    [self setRed:red];
    [self setGreen:green];
    [self setBlue:blue];
}

-(void) setColorWithRed: (int) red andGreen: (int) green andBlue: (int) blue andAlpha: (int) alpha{
    [self setColorWithRed:red andGreen:green andBlue:blue];
    [self setAlpha:alpha];
}

-(void) setColorWithRed: (int) red andGreen: (int) green andBlue: (int) blue andOpacity: (float) opacity{
    [self setColorWithRed:red andGreen:green andBlue:blue];
    [self setOpacity:opacity];
}

-(void) setColorWithArithmeticRed: (float) red andGreen: (float) green andBlue: (float) blue{
    [self setRedArithmetic:red];
    [self setGreenArithmetic:green];
    [self setBlueArithmetic:blue];
}

-(void) setColorWithArithmeticRed: (float) red andGreen: (float) green andBlue: (float) blue andOpacity: (float) opacity{
    [self setColorWithArithmeticRed:red andGreen:green andBlue:blue];
    [self setOpacity:opacity];
}

-(void) setColorWithHue: (float) hue andSaturation: (float) saturation andLightness: (float) lightness{
    float *arithmeticRGB = [CLRColorUtils toArithmeticRGBFromHue:hue andSaturation:saturation andLightness:lightness];
    [self setRedArithmetic:arithmeticRGB[0]];
    [self setGreenArithmetic:arithmeticRGB[1]];
    [self setBlueArithmetic:arithmeticRGB[2]];
}

-(void) setColorWithHue: (float) hue andSaturation: (float) saturation andLightness: (float) lightness andAlpha: (float) alpha{
    [self setColorWithHue:hue andSaturation:saturation andLightness:lightness];
    [self setAlphaArithmetic:alpha];
}

-(void) setColor: (int) color{
    [self setRed:[CLRColorUtils redFromColor:color]];
    [self setGreen:[CLRColorUtils greenFromColor:color]];
    [self setBlue:[CLRColorUtils blueFromColor:color]];
    if (color > 16777215 || color < 0) {
        [self setAlpha:[CLRColorUtils alphaFromColor:color]];
    }
}

-(void) setUnsignedColor: (unsigned int) color{
    [self setColor:color];
}

-(void) setRedHex: (NSString *) red{
    [self setRedArithmetic:[CLRColorUtils toArithmeticRGBFromHex:red]];
}

-(void) setGreenHex: (NSString *) green{
    [self setGreenArithmetic:[CLRColorUtils toArithmeticRGBFromHex:green]];
}

-(void) setBlueHex: (NSString *) blue{
    [self setBlueArithmetic:[CLRColorUtils toArithmeticRGBFromHex:blue]];
}

-(void) setAlphaHex: (NSString *) alpha{
    [self setAlphaArithmetic:[CLRColorUtils toArithmeticRGBFromHex:alpha]];
}

-(void) setRed: (int) red{
    [self setRedHex:[CLRColorUtils toHexFromRGB:red]];
}

-(void) setGreen: (int) green{
    [self setGreenHex:[CLRColorUtils toHexFromRGB:green]];
}

-(void) setBlue: (int) blue{
    [self setBlueHex:[CLRColorUtils toHexFromRGB:blue]];
}

-(void) setAlpha: (int) alpha{
    [self setOpacity:[CLRColorUtils toArithmeticRGBFromRGB:alpha]];
}

-(void) setRedArithmetic: (float) redArithmetic{
    [CLRColorUtils validateArithmeticRGB:redArithmetic];
    _redArithmetic = redArithmetic;
}

-(void) setGreenArithmetic: (float) greenArithmetic{
    [CLRColorUtils validateArithmeticRGB:greenArithmetic];
    _greenArithmetic = greenArithmetic;
}

-(void) setBlueArithmetic: (float) blueArithmetic{
    [CLRColorUtils validateArithmeticRGB:blueArithmetic];
    _blueArithmetic = blueArithmetic;
}

-(void) setOpacity: (float) opacity{
    [CLRColorUtils validateArithmeticRGB:opacity];
    _opacity = opacity;
}

-(void) setAlphaArithmetic: (float) alpha{
    [self setOpacity:alpha];
}

-(BOOL) isOpaque{
    return self.opacity == 1.0;
}

-(UIColor *) uiColor{
    return [UIColor colorWithRed:[self redArithmetic] green:[self greenArithmetic] blue:[self blueArithmetic] alpha:[self alphaArithmetic]];
}

-(NSString *) colorHex{
    return [CLRColorUtils toColorFromHexRed:[self redHex] andGreen:[self greenHex] andBlue:[self blueHex]];
}

-(NSString *) colorHexWithAlpha{
    return [CLRColorUtils toColorWithAlphaFromHexRed:[self redHex] andGreen:[self greenHex] andBlue:[self blueHex] andAlpha:[self alphaHex]];
}

-(NSString *) colorHexShorthand{
    return [CLRColorUtils toColorShorthandFromHexRed:[self redHex] andGreen:[self greenHex] andBlue:[self blueHex]];
}

-(NSString *) colorHexShorthandWithAlpha{
    return [CLRColorUtils toColorShorthandWithAlphaFromHexRed:[self redHex] andGreen:[self greenHex] andBlue:[self blueHex] andAlpha:[self alphaHex]];
}

-(int) color{
    return [CLRColorUtils toColorFromRed:[self red] andGreen:[self green] andBlue:[self blue]];
}

-(unsigned int) unsignedColor{
    return [self color];
}

-(int) colorWithAlpha{
    return [CLRColorUtils toColorWithAlphaFromRed:[self red] andGreen:[self green] andBlue:[self blue] andAlpha:[self alpha]];
}

-(unsigned int) unsignedColorWithAlpha{
    return [self colorWithAlpha];
}

-(NSString *) redHex{
    return [CLRColorUtils toHexFromArithmeticRGB:self.redArithmetic];
}

-(NSString *) greenHex{
    return [CLRColorUtils toHexFromArithmeticRGB:self.greenArithmetic];
}

-(NSString *) blueHex{
    return [CLRColorUtils toHexFromArithmeticRGB:self.blueArithmetic];
}

-(NSString *) alphaHex{
    return [CLRColorUtils toHexFromArithmeticRGB:self.opacity];
}

-(NSString *) redHexShorthand{
    return [CLRColorUtils shorthandHexSingle:[self redHex]];
}

-(NSString *) greenHexShorthand{
    return [CLRColorUtils shorthandHexSingle:[self greenHex]];
}

-(NSString *) blueHexShorthand{
    return [CLRColorUtils shorthandHexSingle:[self blueHex]];
}

-(NSString *) alphaHexShorthand{
    return [CLRColorUtils shorthandHexSingle:[self alphaHex]];
}

-(int) red{
    return [CLRColorUtils toRGBFromArithmeticRGB:self.redArithmetic];
}

-(int) green{
    return [CLRColorUtils toRGBFromArithmeticRGB:self.greenArithmetic];
}

-(int) blue{
    return [CLRColorUtils toRGBFromArithmeticRGB:self.blueArithmetic];
}

-(int) alpha{
    return [CLRColorUtils toRGBFromArithmeticRGB:self.opacity];
}

-(float) alphaArithmetic{
    return _opacity;
}

-(float *) hsl{
    return [CLRColorUtils toHSLFromArithmeticRed:self.redArithmetic andGreen:self.greenArithmetic andBlue:self.blueArithmetic];
}

-(float) hue{
    return [self hsl][0];
}

-(float) saturation{
    return [self hsl][1];
}

-(float) lightness{
    return [self hsl][2];
}

-(id) mutableCopyWithZone: (NSZone *) zone{
    return [[CLRColor alloc] initWithCLRColor:self];
}

@end
