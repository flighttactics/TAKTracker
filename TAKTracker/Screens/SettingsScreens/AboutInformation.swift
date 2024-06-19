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
        List{
            Text("""
    SwiftTAK Copyright 2023 Flight Tactics

    https://github.com/flighttactics/SwiftTAK

    Licensed under the Apache License, Version 2.0 (the 'License'); you may not use this file except in compliance with the License. You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an 'AS IS' BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
    """).padding([.leading, .trailing], 12)
        }
    }
}

struct TAKTrackerInfo: View {
    var body: some View {
        List {
            Text("Copyright 2023, Flight Tactics")
                .listRowSeparator(.hidden)
            Text("For support or feature suggestions contact:")
                .listRowSeparator(.hidden)
            Link("opensource@flighttactics.com", destination: URL(string: "mailto:opensource@flighttactics.com")!)
                .listRowSeparator(.hidden)
            Text("This app uses the following open-source libraries:")
                .listRowSeparator(.hidden)
            NavigationLink(destination: SwiftTAK()) {
                Text("SwiftTAK")
            }
            .navigationTitle("About")
        }
    }
}

struct AboutInformation: View {
    var body: some View {
        Group {
            NavigationLink(destination: TAKTrackerInfo()) {
                Text("About")
            }
            Text("TAK Tracker v\(AppConstants.getAppReleaseAndBuildVersion())")
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(.secondary)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
