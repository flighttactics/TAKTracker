//
//  StreamParserTests.swift
//  TAKTrackerTests
//
//  Created by Cory Foy on 7/6/24.
//

import Foundation
import XCTest

final class StreamParserTests: TAKTrackerTestCase {
    
    let event1 = "<?xml version=\"1.0\"><event uid=\"1\"></event>"
    let event2 = "<?xml version=\"1.0\"><event uid=\"2\"></event>"
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
    
    func testWS() {
        let urlSession = URLSession.shared
        let url: URL = URL(string: "ws://localhost:8080")!
        let body: Data = Data("<xml version='1.0'><event></event>".utf8)
        var request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData
        )
        request.httpMethod = "PUT"

        print("uploadTask")
        let task = urlSession.uploadTask(
            with: request,
            from: body,
            completionHandler: { data, response, error in
                print(data)
                print(response)
                print(error)
            }
        )

        print("Resuming")
        task.resume()
        sleep(5)
    }
}
