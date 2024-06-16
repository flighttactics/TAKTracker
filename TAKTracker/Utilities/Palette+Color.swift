//
//  Palette+Color.swift
//  TAKTracker
//
//  Created by Craig Clayton on 1/11/24.
//

import Foundation
import SwiftUI

extension Color {
    static let baseChatButtonColor = Color("baseChatButtonColor")
    static let baseIncomingChatColor = Color("baseIncomingChatColor")
    static let baseIncomingTextColor = Color("baseIncomingTextColor")
    static let baseStrokeColor = Color("baseStrokeColor")
    static let baseUserChatColor = Color("baseUserChatColor")
}

extension UIColor {
    static let baseChatButtonColor = Color("baseChatButtonColor")
    static let baseIncomingChatColor = Color("baseIncomingChatColor")
    static let baseIncomingTextColor = Color("baseIncomingTextColor")
    static let baseStrokeColor = Color("baseStrokeColor")
    static let baseUserChatColor = Color("baseUserChatColor")
    
    private static func Color(_ key: String) -> UIColor {
        if let color = UIColor(named: key, in: .main, compatibleWith: nil) {
            return color
        }
        
        return .black
    }
}

