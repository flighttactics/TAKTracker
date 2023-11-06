# Color iOS

#### Color Lib ####

The Color Library was developed at the [National Geospatial-Intelligence Agency (NGA)](http://www.nga.mil/) in collaboration with [BIT Systems](https://www.caci.com/bit-systems/). The government has "unlimited rights" and is releasing this software to increase the impact of government investments by providing developers with the opportunity to take things in new directions. The software use, modification, and distribution rights are stipulated within the [MIT license](http://choosealicense.com/licenses/mit/).

### Pull Requests ###
If you'd like to contribute to this project, please make a pull request. We'll review the pull request and discuss the changes. All pull request contributions to this project will be released under the MIT license.

Software source code previously released under an open source license and then modified by NGA staff is considered a "joint work" (see 17 USC § 101); it is partially copyrighted, partially public domain, and as a whole is protected by the copyrights of the non-government authors and must be released according to the terms of the original open source license.

### About ###

[Color](http://ngageoint.github.io/color-ios/) is an iOS Objective-C library providing color representation with support for hex, RBG, arithmetic RBG, HSL, and integer colors.

### Usage ###

View the latest [Appledoc](http://ngageoint.github.io/color-ios/docs/api/)

```objectivec

CLRColor *rgb = [CLRColor colorWithRed:154 andGreen:205 andBlue:50];
CLRColor *rgba = [CLRColor colorWithRed:255 andGreen:165 andBlue:0 andAlpha:64];
CLRColor *rgbOpacity = [CLRColor colorWithRed:255 andGreen:165 andBlue:0 andOpacity:0.25];
CLRColor *arithmeticRGB = [CLRColor colorWithArithmeticRed:1.0 andGreen:0.64705882352 andBlue:0.0];
CLRColor *arithmeticRGBOpacity = [CLRColor colorWithArithmeticRed:1.0 andGreen:0.64705882352 andBlue:0.0 andOpacity:0.25098039215];
CLRColor *hex = [CLRColor colorWithHex:@"#BA55D3"];
CLRColor *hexAlpha = [CLRColor colorWithHex:@"#D9FFFF00"];
CLRColor *hexInteger = [CLRColor colorWithColor:0xFFC000];
CLRColor *hexIntegerAlpha = [CLRColor colorWithColor:0x40FFA500];
CLRColor *integer = [CLRColor colorWithColor:16711680];
CLRColor *integerAlpha = [CLRColor colorWithColor:-12303292];
CLRColor *hexSingles = [CLRColor colorWithHexRed:@"FF" andGreen:@"C0" andBlue:@"CB"];
CLRColor *hexSinglesAlpha = [CLRColor colorWithHexRed:@"00" andGreen:@"00" andBlue:@"00" andAlpha:@"80"];
CLRColor *hexSinglesOpacity = [CLRColor colorWithHexRed:@"FF" andGreen:@"A5" andBlue:@"00" andOpacity:0.25];
CLRColor *hsl = [CLRColor colorWithHue:300.0 andSaturation:1.0 andLightness:0.2509804];
CLRColor *hsla = [CLRColor colorWithHue:60.0 andSaturation:1.0 andLightness:0.5 andAlpha:0.85098039215];
CLRColor *orangeAlpha = [CLRColor colorWithHex:CLR_COLOR_ORANGE andAlpha:120];
CLRColor *orangeOpacity = [CLRColor colorWithHex:CLR_COLOR_ORANGE andOpacity:0.25];

CLRColor *color = [CLRColor blue];
[color setAlpha:56];
NSString *hexValue = [color colorHex];
NSString *hexShorthand = [color colorHexShorthand];
NSString *hexWithAlpha = [color colorHexWithAlpha];
NSString *hexShorthandWithAlpha = [color colorHexShorthandWithAlpha];
int integerValue = [color color];
int integerAlphaValue = [color colorWithAlpha];
int red = [color red];
float greenArithmetic = color.greenArithmetic;
NSString *blueHex = [color blueHex];
NSString *alphaHexShorthand = [color alphaHexShorthand];
float opacity = color.opacity;
float *hslValue = [color hsl];
float hue = [color hue];
float saturation = [color saturation];
float lightness = [color lightness];

```

### Build ###

[![Build & Test](https://github.com/ngageoint/color-ios/workflows/Build%20&%20Test/badge.svg)](https://github.com/ngageoint/color-ios/actions/workflows/build-test.yml)

Build this repository using Xcode and/or CocoaPods:

    pod install

Open color-ios.xcworkspace in Xcode or build from command line:

    xcodebuild -workspace 'color-ios.xcworkspace' -scheme color-ios build

Run tests from Xcode or from command line:

    xcodebuild test -workspace 'color-ios.xcworkspace' -scheme color-ios -destination 'platform=iOS Simulator,name=iPhone 14'

### Include Library ###

Include this repository by specifying it in a Podfile using a supported option.

Pull from [CocoaPods](https://cocoapods.org/pods/color-ios):

    pod 'color-ios', '~> 1.0.1'

Pull from GitHub:

    pod 'color-ios', :git => 'https://github.com/ngageoint/color-ios.git', :branch => 'master'
    pod 'color-ios', :git => 'https://github.com/ngageoint/color-ios.git', :tag => '1.0.1'

Include as local project:

    pod 'color-ios', :path => '../color-ios'

### Swift ###

To use from Swift, import the color-ios bridging header from the Swift project's bridging header

    #import "color-ios-Bridging-Header.h"

```swift

let rgb : CLRColor = CLRColor.init(red:154, andGreen:205, andBlue:50)
let rgba : CLRColor = CLRColor.init(red:255, andGreen:165, andBlue:0, andAlpha:64)
let rgbOpacity : CLRColor = CLRColor.init(red:255, andGreen:165, andBlue:0, andOpacity:0.25)
let arithmeticRGB : CLRColor = CLRColor.init(arithmeticRed:1.0, andGreen:0.64705882352, andBlue:0.0)
let arithmeticRGBOpacity : CLRColor = CLRColor.init(arithmeticRed:1.0, andGreen:0.64705882352, andBlue:0.0, andOpacity:0.25098039215)
let hex : CLRColor = CLRColor.init(hex:"#BA55D3")
let hexAlpha : CLRColor = CLRColor.init(hex:"#D9FFFF00")
let hexInteger : CLRColor = CLRColor.init(color:0xFFC000)
let hexIntegerAlpha : CLRColor = CLRColor.init(color:0x40FFA500)
let integer : CLRColor = CLRColor.init(color:16711680)
let integerAlpha : CLRColor = CLRColor.init(color:-12303292)
let hexSingles : CLRColor = CLRColor.init(hexRed:"FF", andGreen:"C0", andBlue:"CB")
let hexSinglesAlpha : CLRColor = CLRColor.init(hexRed:"00", andGreen:"00", andBlue:"00", andAlpha:"80")
let hexSinglesOpacity : CLRColor = CLRColor.init(hexRed:"FF", andGreen:"A5", andBlue:"00", andOpacity:0.25)
let hsl : CLRColor = CLRColor.init(hue:300.0, andSaturation:1.0, andLightness:0.2509804)
let hsla : CLRColor = CLRColor.init(hue:60.0, andSaturation:1.0, andLightness:0.5, andAlpha:0.85098039215)
let orangeAlpha : CLRColor = CLRColor.init(hex:CLR_COLOR_ORANGE, andAlpha:120)
let orangeOpacity : CLRColor = CLRColor.init(hex:CLR_COLOR_ORANGE, andOpacity:0.25)

let color : CLRColor = CLRColor.blue()
color.setAlpha(56)
let hexValue : String = color.colorHex()
let hexShorthand : String = color.colorHexShorthand()
let hexWithAlpha : String = color.colorHexWithAlpha()
let hexShorthandWithAlpha : String = color.colorHexShorthandWithAlpha()
let integerValue : Int32 = color.color()
let integerAlphaValue : Int32 = color.colorWithAlpha()
let red : Int32 = color.red()
let greenArithmetic : Float = color.greenArithmetic
let blueHex : String = color.blueHex()
let alphaHexShorthand : String = color.alphaHexShorthand()
let opacity : Float = color.opacity
let hslValue : UnsafeMutablePointer<Float> = color.hsl()
let hue : Float = color.hue()
let saturation : Float = color.saturation()
let lightness : Float = color.lightness()

```
