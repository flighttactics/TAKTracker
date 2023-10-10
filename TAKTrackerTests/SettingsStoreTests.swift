//
//  SettingsStoreTests.swift
//  TAKTrackerTests
//
//  Created by Cory Foy on 9/26/23.
//

import Foundation
import XCTest

final class SettingsStoreTests: TAKTrackerTestCase {
    
    func testGenerateDefaultCallsign() {
        let trackerAppend = AppConstants.getClientID().split(separator: "-").first!
        let expected = "TRACKER-\(trackerAppend)"
        XCTAssertEqual(expected, SettingsStore.generateDefaultCallSign(), "Initial gen failed to match")
        XCTAssertEqual(expected, SettingsStore.generateDefaultCallSign(), "Second gen failed to match")
        XCTAssertEqual(expected, SettingsStore.generateDefaultCallSign(), "Third gen failed to match")
        
    }
}
