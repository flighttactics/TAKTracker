//
//  TAKLogger.debug.swift
//  TAKTracker
//
//  Created by Cory Foy on 7/30/23.
//

import Foundation
import UIKit

class TAKLogger: NSObject {
    static func debug(_ message: String) {
        NSLog(message)
        message.enumerateLines { (line, _) in
            print(line)
        }
    }
    
    static func info(_ message: String) {
        NSLog(message)
    }
    
    static func error(_ message: String) {
        NSLog(message)
    }
}
