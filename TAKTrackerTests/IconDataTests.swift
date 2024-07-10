//
//  IconDataTests.swift
//  TAKTrackerTests
//
//  Created by Cory Foy on 7/6/24.
//

import Foundation
import XCTest

final class IconDataTests: TAKTrackerTestCase {
    
    var someVar: String?
    
    func testRetrieveIconSets() {
        let iconSets = IconData.availableIconSets()
        XCTAssertEqual(10, iconSets.count, "No Iconsets may have been found")
    }
    
    func testRetrieveIconForIconset() throws {
        let iconString = "de450cbf-2ffc-47fb-bd2b-ba2db89b035e/Resources/ESF4-FIRE-HAZMAT_Aerial-Apparatus-Ladder.png"
        let icon = IconData.iconFor(type2525: "a-F-G", iconsetPath: iconString)
    }
    
    func testParseCotTypeTo2525() {
        let cotType = "a-H-G"
        let expected = "shgp-----------"
        XCTAssertEqual(IconData.mil2525FromCotType(cotType: cotType), expected)
    }
    
    func testParseSfgpiut() {
        let cotType = "a-f-G-I-U-T"
        let expected = "sfgpiut---h----"
        XCTAssertEqual(IconData.mil2525FromCotType(cotType: cotType), expected)
    }
}
