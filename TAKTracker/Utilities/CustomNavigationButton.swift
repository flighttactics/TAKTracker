//
//  CustomButtonType.swift
//  TAKTracker
//
//  Created by Craig Clayton on 10/8/25.
//


import SwiftUI

enum CustomButtonType: String {
    case next = "Next"
    case previous = "Previous"
}

struct CustomButton: View {
    var type: CustomButtonType
    var action: () -> Void
    
    var body: some View {
        Button(action: { action() }) {
            Text(type.rawValue)
                .padding(.vertical, 15)
                .padding(.horizontal, 20)
                .foregroundColor(type == .previous ? .teal : .white)
                .background(type == .previous ? Color.white : .teal)
        }
        .buttonStyle(.borderedProminent)
    }
}
