//
//  TeamC.swift
//  
//
//  Created by Craig Clayton on 10/7/25.
//

import Foundation
import SwiftTAK
import SwiftUI

public extension TeamColor {
    var color: Color {
        switch self {
        case .Blue:       return .blue
        case .DarkBlue:   return Color(red: 0.0, green: 0.2, blue: 0.6)
        case .Brown:      return .brown
        case .Cyan:       return .cyan
        case .Green:      return .green
        case .DarkGreen:  return Color(red: 0.0, green: 0.3, blue: 0.1)
        case .Magenta:    return Color(red: 1.0, green: 0.0, blue: 1.0)
        case .Maroon:     return Color(red: 0.5, green: 0.0, blue: 0.0)
        case .Orange:     return .orange
        case .Purple:     return .purple
        case .Red:        return .red
        case .Teal:       return .teal
        case .White:      return .white
        case .Yellow:     return .yellow
        }
    }
}
