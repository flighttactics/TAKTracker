//
//  OnboardingViewModel.swift
//  TAKTracker
//
//  Created by Craig Clayton on 10/8/25.
//

import Foundation
import SwiftUI

import Combine



final class OnboardingManager: ObservableObject {
    @Published var currentStep: OnboardingPage = .permissions
    @Published var hasAskedPermissions: Bool = false

    private let orderedSteps: [OnboardingPage] = [
        .permissions, .userInfo, .server, .connections, .enrollment, .qr, .finish
    ]

    func nextStep() {
        guard let i = orderedSteps.firstIndex(of: currentStep),
              i + 1 < orderedSteps.count else { return }
        currentStep = orderedSteps[i + 1]
    }

    func previousStep() {
        guard let i = orderedSteps.firstIndex(of: currentStep), i > 0 else { return }
        currentStep = orderedSteps[i - 1]
    }
}
