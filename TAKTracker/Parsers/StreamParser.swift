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
        return str.components(separatedBy: StreamParser.STREAM_DELIMTER).filter { !$0.isEmpty }.map { "\($0)\(StreamParser.STREAM_DELIMTER)" }
        //return str.split(separator: StreamParser.STREAM_DELIMTER).map(String.init)
    }
}
