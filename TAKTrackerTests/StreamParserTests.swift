//
//  XmlParserTests.swift
//  TAKTrackerTests
//
//  Created by Cory Foy on 3/15/24.
//

import Foundation
import XCTest

final class StreamParserTests: TAKTrackerTestCase {

    let event1 = "<?xml version=\"1.0\"><event uid=\"1\"></event>"
    let event2 = "<?xml version=\"1.0\"><event uid=\"2\"></event>"
    let incomplete_event_start = "<?xml version=\"1.0\"><event uid=\"2\">"
    let incomplete_event_end = "</event>"
    let parser = StreamParser()

    func testSplitOnEventClosureCreatesCorrectNumberOfEvents() {
        let eventStream = Data("\(event1)\(event2)".utf8)
        let events = parser.parse(dataStream: eventStream)
        TAKLogger.debug(String(describing: events))
        XCTAssertEqual(2, events.count, "Parser did not split properly")
    }

    func testSplitOnEventClosureIncludesClosureElement() {
        let eventStream = Data("\(event1)\(event2)".utf8)
        let events = parser.parse(dataStream: eventStream)
        XCTAssertEqual(event1, String(events[0]), "Parser split did not match event1")
        XCTAssertEqual(event2, String(events[1]), "Parser split did not match event2")
    }

    func testParsingWithSingleEventReturnsSingleNode() {
        let eventStream = Data("\(event1)".utf8)
        let events = parser.parse(dataStream: eventStream)
        XCTAssertEqual(1, events.count, "Parser did not split properly")
        XCTAssertEqual(event1, String(events[0]), "Parser split did not match event1")
    }
    
    func testCompleteEventsAreParsedEvenWithIncompleteEvents() {
        let eventStream = Data("\(event1)\(incomplete_event_start)".utf8)
        let events = parser.parse(dataStream: eventStream)
        TAKLogger.debug(String(describing: events))
        XCTAssertEqual(1, events.count, "Parser did not handle incomplete event properly")
    }
}
