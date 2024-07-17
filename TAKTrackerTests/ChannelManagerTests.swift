//
//  ChannelManagerTests.swift
//  TAKTrackerTests
//
//  Created by Cory Foy on 7/10/24.
//

import Foundation
import XCTest

final class ChannelManagerTests: TAKTrackerTestCase {
    
    let CHANNEL_CREATION_DATE = "2024-03-01"
    let CHANNEL_CREATION_DATE_FORMAT = "yyyy-MM-dd"
    let channelManager = ChannelManager()
    
    var responseDataString = ""
    var responseData = Data()
    
    override func setUp() async throws {
        responseDataString = """
{"version":"3","type":"com.bbn.marti.remote.groups.Group","data":[{"name":"SARTopo","direction":"IN","created":"\(CHANNEL_CREATION_DATE)","type":"SYSTEM","bitpos":4,"active":false},{"name":"SearchAndRescue","direction":"BOTH","created":"\(CHANNEL_CREATION_DATE)","type":"SYSTEM","bitpos":5,"active":true},{"name":"Sensors","direction":"IN","created":"\(CHANNEL_CREATION_DATE)","type":"SYSTEM","bitpos":3,"active":true},{"name":"__ANON__","direction":"OUT","created":"\(CHANNEL_CREATION_DATE)","type":"SYSTEM","bitpos":2,"active":true}],"nodeId":"68628339b5034463af404583476b1bf0"}
"""
        responseData = Data(responseDataString.utf8)
    }
    
    func genChannel(name: String, direction: String, bitPos: Int, active: Bool) -> TAKChannel {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = CHANNEL_CREATION_DATE_FORMAT
        let dateString = CHANNEL_CREATION_DATE
        let date = dateFormatter.date(from: dateString)
        return TAKChannel(name: name, active: active, direction: direction, created: date, type: "SYSTEM", bitpos: bitPos)
    }
    
    func testParsingChannelResponseIgnoresANON() throws {
        channelManager.storeChannelsResponse(responseData)
        
        let anonChannel = genChannel(name: "__ANON__", direction: "OUT", bitPos: 2, active: true)
        
        XCTAssertFalse(channelManager.activeChannels.contains(anonChannel))
    }
    
    func testParsingChannelResponseHandleInactiveChannels() throws {
        channelManager.storeChannelsResponse(responseData)
        let inactiveChannel = genChannel(name: "SARTopo", direction: "IN", bitPos: 4, active: false)
        XCTAssertTrue(channelManager.activeChannels.contains(inactiveChannel))
    }
    
    func testParsingChannelResponseHandleActiveChannels() throws {
        channelManager.storeChannelsResponse(responseData)
        let activeChannel = genChannel(name: "Sensors", direction: "IN", bitPos: 3, active: true)
        XCTAssertTrue(channelManager.activeChannels.contains(activeChannel))
    }
    
    func testParsingChannelResponseHandleInOutChannels() throws {
        channelManager.storeChannelsResponse(responseData)
        let inOutChannel = genChannel(name: "SearchAndRescue", direction: "BOTH", bitPos: 5, active: true)
        XCTAssertTrue(channelManager.activeChannels.contains(inOutChannel))
    }
}
