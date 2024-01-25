//
//  Sheet.swift
//  TAKTracker
//
//  Created by Craig Clayton on 1/11/24.
//

import Foundation
import SwiftUI

struct Sheet: View {
    let type: SheetType
    
    enum SheetType: Identifiable {
        case none
        case emergencySettings
        case settings
        case chat
        
        var id: String {
            switch self {
                case .none: return "none"
                case .emergencySettings: return "emergencysettings"
                case .settings: return "settings"
                case .chat: return "chat"
            }
        }
    }
    
    @ViewBuilder private func make() -> some View {
        switch type {
            case .none: EmptyView()
            case .emergencySettings: EmergencyView()
            case .settings: SettingsView()
            case .chat: ChatView()
        }
    }
    
    var body: some View {
        make()
    }
}
