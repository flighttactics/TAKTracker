# Grid iOS

#### Grid Lib ####

The Grid Library was developed at the [National Geospatial-Intelligence Agency (NGA)](http://www.nga.mil/) in collaboration with [BIT Systems](https://www.caci.com/bit-systems/). The government has "unlimited rights" and is releasing this software to increase the impact of government investments by providing developers with the opportunity to take things in new directions. The software use, modification, and distribution rights are stipulated within the [MIT license](http://choosealicense.com/licenses/mit/).

### Pull Requests ###
If you'd like to contribute to this project, please make a pull request. We'll review the pull request and discuss the changes. All pull request contributions to this project will be released under the MIT license.

Software source code previously released under an open source license and then modified by NGA staff is considered a "joint work" (see 17 USC § 101); it is partially copyrighted, partially public domain, and as a whole is protected by the copyrights of the non-government authors and must be released according to the terms of the original open source license.

### About ###

[Grid](http://ngageoint.github.io/grid-ios/) is a Swift library providing common geospatial reference system grid functionality.

### Usage ###

View the latest [Appledoc](http://ngageoint.github.io/grid-ios/docs/api/)

#### Military Grid Reference System ####

[MGRS](https://github.com/ngageoint/mgrs-ios) is a Swift library providing Military Grid Reference System functionality, a geocoordinate standard used by NATO militaries for locating points on Earth.

#### Global Area Reference System ####

[GARS](https://github.com/ngageoint/gars-ios) is a Swift library providing Global Area Reference System functionality, a standardized geospatial reference system for areas.

#### Import ####

```swift

import grid_ios

```

### Build ###

[![Build & Test](https://github.com/ngageoint/grid-ios/workflows/Build%20&%20Test/badge.svg)](https://github.com/ngageoint/grid-ios/actions/workflows/build-test.yml)

Build this repository using Xcode and/or CocoaPods:

    pod install

Open grid-ios.xcworkspace in Xcode or build from command line:

    xcodebuild -workspace 'grid-ios.xcworkspace' -scheme grid-ios build

Run tests from Xcode or from command line:

    xcodebuild test -workspace 'grid-ios.xcworkspace' -scheme grid-ios -destination 'platform=iOS Simulator,name=iPhone 14'

### Include Library ###

Include this repository by specifying it in a Podfile using a supported option.

Pull from [CocoaPods](https://cocoapods.org/pods/grid-ios):

    pod 'grid-ios', '~> 1.0.5'

Pull from GitHub:

    pod 'grid-ios', :git => 'https://github.com/ngageoint/grid-ios.git', :branch => 'master'
    pod 'grid-ios', :git => 'https://github.com/ngageoint/grid-ios.git', :tag => '1.0.5'

Include as local project:

    pod 'grid-ios', :path => '../grid-ios'

### Remote Dependencies ###

* [Simple Features](https://github.com/ngageoint/simple-features-ios) (The MIT License (MIT)) - Simple Features Lib
* [Color](https://github.com/ngageoint/color-ios) (The MIT License (MIT)) - Color Lib
