# MGRS iOS

#### Military Grid Reference System Lib ####

The MGRS Library was developed at the [National Geospatial-Intelligence Agency (NGA)](http://www.nga.mil/) in collaboration with [BIT Systems](https://www.caci.com/bit-systems/). The government has "unlimited rights" and is releasing this software to increase the impact of government investments by providing developers with the opportunity to take things in new directions. The software use, modification, and distribution rights are stipulated within the [MIT license](http://choosealicense.com/licenses/mit/).

### Pull Requests ###
If you'd like to contribute to this project, please make a pull request. We'll review the pull request and discuss the changes. All pull request contributions to this project will be released under the MIT license.

Software source code previously released under an open source license and then modified by NGA staff is considered a "joint work" (see 17 USC § 101); it is partially copyrighted, partially public domain, and as a whole is protected by the copyrights of the non-government authors and must be released according to the terms of the original open source license.

### About ###

[MGRS](http://ngageoint.github.io/mgrs-ios/) is a Swift library providing Military Grid Reference System functionality, a geocoordinate standard used by NATO militaries for locating points on Earth.  [MGRS App](https://github.com/ngageoint/mgrs-ios/tree/master/app) is a map implementation utilizing this library.

### Usage ###

View the latest [Appledoc](http://ngageoint.github.io/mgrs-ios/docs/api/)

#### Import ####

```swift

import mgrs_ios

```

#### Coordinates ####

```swift

let mgrs = MGRS.parse("33XVG74594359")
let point = mgrs.toPoint()
let pointMeters = point.toMeters()
let utm = mgrs.toUTM()
let utmCoordinate = utm.description
let point2 = utm.toPoint()

let mgrs2 = MGRS.parse("33X VG 74596 43594")

let latitude = 63.98862388
let longitude = 29.06755082
let point3 = GridPoint(longitude, latitude)
let mgrs3 = MGRS.from(point3)
let mgrsCoordinate = mgrs3.description
let mgrsGZD = mgrs3.coordinate(GridType.GZD)
let mgrs100k = mgrs3.coordinate(GridType.HUNDRED_KILOMETER)
let mgrs10k = mgrs3.coordinate(GridType.TEN_KILOMETER)
let mgrs1k = mgrs3.coordinate(GridType.KILOMETER)
let mgrs100m = mgrs3.coordinate(GridType.HUNDRED_METER)
let mgrs10m = mgrs3.coordinate(GridType.TEN_METER)
let mgrs1m = mgrs3.coordinate(GridType.METER)

let utm2 = UTM.from(point3)
let mgrs4 = utm2.toMGRS()

let utm3 = UTM.parse("18 N 585628 4511322")
let mgrs5 = utm3.toMGRS()

```

#### Tile Overlay ####

```swift

// let mapView: MKMapView = ...

// Tile size determined from display density
let tileOverlay = MGRSTileOverlay()

// Manually specify tile size
let tileOverlay2 = MGRSTileOverlay(512, 512)

// GZD only grid
let gzdTileOverlay = MGRSTileOverlay.createGZD()

// Specified grids
let customTileOverlay = MGRSTileOverlay(
        [GridType.GZD, GridType.HUNDRED_KILOMETER])

mapView.addOverlay(tileOverlay)

```

#### Tile Overlay Options ####

```swift

let tileOverlay = MGRSTileOverlay()

let x = 8
let y = 12
let zoom = 5

// Manually get a tile or draw the tile bitmap
let tile = tileOverlay.tile(x, y, zoom)
let tileImage = tileOverlay.drawTile(x, y, zoom)

let latitude = 63.98862388
let longitude = 29.06755082
let locationCoordinate = CLLocationCoordinate2DMake(latitude, longitude)

// MGRS Coordinates
let mgrs = tileOverlay.mgrs(locationCoordinate)
let coordinate = tileOverlay.coordinate(locationCoordinate)
let zoomCoordinate = tileOverlay.coordinate(locationCoordinate, zoom)

let mgrsGZD = tileOverlay.coordinate(locationCoordinate, GridType.GZD)
let mgrs100k = tileOverlay.coordinate(locationCoordinate, GridType.HUNDRED_KILOMETER)
let mgrs10k = tileOverlay.coordinate(locationCoordinate, GridType.TEN_KILOMETER)
let mgrs1k = tileOverlay.coordinate(locationCoordinate, GridType.KILOMETER)
let mgrs100m = tileOverlay.coordinate(locationCoordinate, GridType.HUNDRED_METER)
let mgrs10m = tileOverlay.coordinate(locationCoordinate, GridType.TEN_METER)
let mgrs1m = tileOverlay.coordinate(locationCoordinate, GridType.METER)

```

#### Custom Grids ####

```swift

let grids = Grids()

grids.setColor(GridType.GZD, UIColor.red)
grids.setWidth(GridType.GZD, 5.0)

grids.setLabelMinZoom(GridType.GZD, 3)
grids.setLabelMaxZoom(GridType.GZD, 8)
grids.setLabelTextSize(GridType.GZD, 32.0)

grids.setMinZoom(GridType.HUNDRED_KILOMETER, 4)
grids.setMaxZoom(GridType.HUNDRED_KILOMETER, 8)
grids.setColor(GridType.HUNDRED_KILOMETER, UIColor.blue)

grids.setLabelColor(GridType.HUNDRED_KILOMETER, UIColor.orange)
grids.setLabelBuffer(GridType.HUNDRED_KILOMETER, 0.1)

grids.setColor([GridType.TEN_KILOMETER, GridType.KILOMETER, GridType.HUNDRED_METER, GridType.TEN_METER], UIColor.darkGray)

grids.disable(GridType.METER)

grids.enableLabeler(GridType.TEN_KILOMETER)

let tileOverlay = MGRSTileOverlay(grids)

```

#### Draw Tile Template ####

```swift

// let tile: GridTile = ...

let grids = Grids()

let zoomGrids = grids.grids(tile.zoom)
if zoomGrids.hasGrids() {

    let gridRange = GridZones.gridRange(tile.bounds)

    for grid in zoomGrids {

        // draw this grid for each zone
        for zone in gridRange {

            let lines = grid.lines(tile, zone)
            if lines != nil {
                let pixelRange = zone.bounds.pixelRange(tile)
                for line in lines! {
                    let pixel1 = line.point1.pixel(tile)
                    let pixel2 = line.point2.pixel(tile)
                    // Draw line
                }
            }

            let labels = grid.labels(tile, zone)
            if labels != nil {
                for label in labels! {
                    let pixelRange = label.bounds.pixelRange(tile)
                    let centerPixel = label.center.pixel(tile)
                    // Draw label
                }
            }

        }
    }
}

```

#### Objective-C ####

```objectivec

#import "mgrs_ios-Swift.h"

```

```objectivec

MKTileOverlay *tileOverlay = [[MGRSTileOverlay alloc] init];
[mapView addOverlay:tileOverlay];

```

### Build ###

[![Build & Test](https://github.com/ngageoint/mgrs-ios/workflows/Build%20&%20Test/badge.svg)](https://github.com/ngageoint/mgrs-ios/actions/workflows/build-test.yml)

Build this repository using Xcode and/or CocoaPods:

    pod install

Open mgrs-ios.xcworkspace in Xcode or build from command line:

    xcodebuild -workspace 'mgrs-ios.xcworkspace' -scheme mgrs-ios build

Run tests from Xcode or from command line:

    xcodebuild test -workspace 'mgrs-ios.xcworkspace' -scheme mgrs-ios -destination 'platform=iOS Simulator,name=iPhone 14'

### Include Library ###

Include this repository by specifying it in a Podfile using a supported option.

Pull from [CocoaPods](https://cocoapods.org/pods/mgrs-ios):

    pod 'mgrs-ios', '~> 1.1.4'

Pull from GitHub:

    pod 'mgrs-ios', :git => 'https://github.com/ngageoint/mgrs-ios.git', :branch => 'master'
    pod 'mgrs-ios', :git => 'https://github.com/ngageoint/mgrs-ios.git', :tag => '1.1.4'

Include as local project:

    pod 'mgrs-ios', :path => '../mgrs-ios'

### Remote Dependencies ###

* [Grid](https://github.com/ngageoint/grid-ios) (The MIT License (MIT)) - Grid Library

### MGRS App ###

The [MGRS App](https://github.com/ngageoint/mgrs-ios/tree/master/app) provides a Military Grid Reference System map using this library.
