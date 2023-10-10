//
//  TAKTrackerTestCase.swift
//  TAKTrackerTests
//
//  Created by Cory Foy on 10/10/23.
//

import Foundation
import XCTest

class TAKTrackerTestCase : XCTestCase {
    override class func setUp() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
            UserDefaults.standard.synchronize()
        }
    }
}
