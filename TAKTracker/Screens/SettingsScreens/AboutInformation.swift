//
//  AboutInformation.swift
//  TAKTracker
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation
import SwiftUI

struct SwiftTAK: View {
    var body: some View {
        Text("""
SwiftTAK Copyright 2023 Flight Tactics

https://github.com/flighttactics/SwiftTAK

Licensed under the Apache License, Version 2.0 (the 'License'); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an 'AS IS' BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
""").padding([.leading, .trailing], 12)
    }
}

struct AboutInformation: View {
    var body: some View {
        Group {
            Text("TAK Tracker v\(AppConstants.getAppVersion())")
                .frame(maxWidth: .infinity, alignment: .center)
            Text("""
Copyright 2023, Flight Tactics

For support: \("opensource" + "@" + "flighttactics.com")

This app uses the following open-source libraries:
""")
            NavigationLink(destination: SwiftTAK()) {
                Text("SwiftTAK")
            }
        }
        .foregroundColor(.secondary)
    }
}
