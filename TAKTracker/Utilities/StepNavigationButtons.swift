//
//  StepNavigationButtons.swift
//  TAKTracker
//
//  Created by Craig Clayton on 10/8/25.
//


import SwiftUI

struct StepNavigationButtons: View {
    let showPrevious: Bool
    let onPrevious: () -> Void
    let onNext: () -> Void
    var onNextTitle: String = "Next"

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onPrevious) {
                Text("Previous")
                    .frame(width: 75)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.blue)
                    .cornerRadius(10)
                    .opacity(showPrevious ? 1 : 0)
            }
            
            Spacer()

            Button(action: onNext) {
                Text(onNextTitle)
                    .frame(width: 75)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
    }
}
