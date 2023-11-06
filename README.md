#  TAK Tracker

TAK Tracker is a update-only version of [TAK](https://www.tak.gov) for Apple Devices. It is designed to be quick to deploy and easy to use for teams to give to users who just need location tracked. The app is configured to send both broadcast and to a TAK Server directly, and is being to developed to support all of the features from the Android TAK Tracker.

Below is a portion of the roadmap being tracked. If something isn't working or you don't see something on the list below, please use [GitHub Issues](https://github.com/flighttactics/TAKTracker/issues) to let us know about it (if it isn't already being tracked there) and we'll route it either to this project or to [SwiftTAK](https://github.com/flighttactics/SwiftTAK) depending on where the issue/feature is.

If you are interested in integrating this into your own product or want a custom iOS/Android/etc TAK app, plugins or features, let us know by contacting opensource at flighttactics dot com or visiting [Flight Tactics](https://www.flighttactics.com)

## Current TAK Tracker Parity Feature Status in rough priority / sequence:

- [ ] [Group/Channel Support](https://github.com/flighttactics/TAKTracker/issues/14)
- [ ] [Protobuf Support](https://github.com/flighttactics/TAKTracker/issues/9)
- [ ] [TAK Chat](https://github.com/flighttactics/TAKTracker/issues/12)
- [ ] [QR Code Enrollment for connecting to server](https://github.com/flighttactics/TAKTracker/issues/15)
- [ ] [Show GPS Status](https://github.com/flighttactics/TAKTracker/issues/7)
- [ ] [Show Compass Accuracy](https://github.com/flighttactics/TAKTracker/issues/7)
- [ ] [App notifications when connection lost](https://github.com/flighttactics/TAKTracker/issues/13)
- [ ] [Allow user to toggle background update indicator](https://github.com/flighttactics/TAKTracker/issues/17)
- [X] ~[Toggle Coordinates between DMS and MGRS](https://github.com/flighttactics/TAKTracker/issues/8)~
- [X] ~[Allow setting the Team/Role](https://github.com/flighttactics/TAKTracker/issues/10)~
- [X] ~[Emergency Beacon](https://github.com/flighttactics/TAKTracker/issues/11)~
- [X] ~[Have compass / heading recognize landscape mode](https://github.com/flighttactics/TAKTracker/issues/16)~
- [X] ~Better messages and logging about the state of parsing the packages and data connections~
- [X] ~[Allow map to be scrolled without resetting](https://github.com/flighttactics/TAKTracker/issues/1)~
- [X] ~Certificate Enrollment for connecting to server~
- [X] ~Toggle Compass and Speed Units by tapping the numbers~
- [X] ~Continuing transmitting location while app is in the background~
- [X] ~Automatically connect when adding a new data package / connection~
- [x] ~Broadcast location over UDP~
- [x] ~Broadcast location over TCP to TAK Server~
- [x] ~Send location automatically~
- [x] ~TCP Connections~
- [x] ~Show Current Coordinates~
- [x] ~Show Heading / Bearing~
- [x] ~Show Speed~
- [x] ~Show Server Status~

## Current Extended Features Status:

These will likely end up being pulled out into a separate app rather than integrated into TAK Tracker, but tracking here for now

- [ ] Show other TAK Users on the Map
- [ ] Allow sending of a point other than your current spot
- [ ] [Show GPS Accuracy](https://github.com/flighttactics/TAKTracker/issues/7)
- [X] ~Ensure both iTAK and ATAK packages can be imported~
- [X] ~Show Current Map Center Coordinates~
- [x] ~Show Current Location on Map~

## License & Copyright

Copyright 2023 Flight Tactics

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

Commercial Use support licenses are available - please contact opensource@flighttactics.com for more information.

This app uses the following Open Source libraries:
- [SwiftTAK](https://github.com/flighttactics/swifttak) under the Apache License, Version 2.0
- [mgrs-ios](https://github.com/ngageoint/mgrs-ios) under the MIT License
