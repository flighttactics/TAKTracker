#  TAK Tracker

TAK Tracker is a update-only version of [TAK](https://www.tak.gov) for Apple Devices. It is designed to be quick to deploy and easy to use for teams to give to users who just need location tracked. The app is configured to send both broadcast and to a TAK Server directly, and is being to developed to support all of the features from the Android TAK Tracker.

Below is the roadmap being tracked. It is _highly_ likely that this project will end up spawing a separate iOS TAK app since TAK Tracker is supposed to be very lightweight. So if something isn't working or you don't see something on the list below, please use GitHub Issues to let us know about it. 

If you are interested in integrating this into your own product or want a custom iOS/Android/etc TAK app, plugins or features, let us know by contacting foyc at flighttactics dot com or visiting [Flight Tactics](https://www.flighttactics.com)

## Current TAK Tracker Parity Feature Status in rough priority / sequence:

- [X] Certificate Enrollment for connecting to server
- [ ] QR Code Enrollment for connecting to server
- [ ] Have compass / heading recognize landscape mode
- [X] Automatically connect when adding a new data package / connection (must restart the app now to pick them up)
- [ ] Better messages and logging about the state of parsing the packages and data connections
- [X] Continuing transmitting location while app is in the background
- [ ] Emergency Beacon
- [ ] TAK Chat
- [ ] Allow map to be scrolled without resetting
- [ ] Show GPS Status
- [ ] Show Compass Accuracy
- [ ] App notifications when connection lost
- [ ] Allow user to toggle background update indicator
- [x] Broadcast location over UDP
- [x] Broadcast location over TCP to TAK Server
- [x] Send location automatically
- [x] TCP Connections
- [x] Show Current Coordinates
- [x] Show Heading / Bearing
- [x] Show Speed
- [x] Show Server Status

## Current Extended Features Status:

These will likely end up being pulled out into a separate app rather than integrated into TAK Tracker, but tracking here for now

- [ ] Show other TAK Users on the Map
- [ ] Allow sending of a point other than your current spot
- [ ] Show GPS Accuracy
- [X] Ensure both iTAK and ATAK packages can be imported
- [X] Show Current Map Center Coordinates
- [x] Show Current Location on Map

## License & Copyright

Copyright 2023 Flight Tactics

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
