//
//  StreamParser.swift
//  TAKTracker
//
//  Created by Cory Foy on 3/15/24.
//

import Foundation
import SwiftTAK

class StreamParser: NSObject {

    static let STREAM_DELIMTER = "</event>"

    func parse(dataStream: Data?) -> Array<String> {
        guard let data = dataStream else { return [] }
        let str = String(decoding: data, as: UTF8.self)
        
        var cotEvents: Array<String> = []
        
        let scanner = Scanner(string: str)
        
        while !scanner.isAtEnd {
            guard let line = scanner.scanUpToString(StreamParser.STREAM_DELIMTER) else { return cotEvents }
            if(!scanner.isAtEnd) {
                scanner.currentIndex = scanner.string.index(scanner.currentIndex, offsetBy: StreamParser.STREAM_DELIMTER.count)
                cotEvents.append("\(line)\(StreamParser.STREAM_DELIMTER)")
            }
        }
        return cotEvents
    }
}
