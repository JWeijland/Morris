import Foundation
import SwiftUI
import Combine

enum OnboardingStep: Int, CaseIterable {
    case basics
    case goal
    case preview
    case done
}

class OnboardingViewModel: ObservableObject {
    @Published var step: OnboardingStep = .basics
    @Published var name: String = ""
    @Published var selectedIndustry: Industry = .finance
    @Published var goal: String = ""

    var selectedRole: UserRole

    init(role: UserRole) {
        self.selectedRole = role
    }

    var progressFraction: Double {
        Double(step.rawValue) / Double(OnboardingStep.allCases.count - 1)
    }

    var canAdvance: Bool {
        switch step {
        case .basics:   return !name.trimmingCharacters(in: .whitespaces).isEmpty
        case .goal:     return !goal.trimmingCharacters(in: .whitespaces).isEmpty
        case .preview:  return true
        case .done:     return true
        }
    }

    func advance() {
        if let next = OnboardingStep(rawValue: step.rawValue + 1) {
            step = next
        }
    }

    func back() {
        if let prev = OnboardingStep(rawValue: step.rawValue - 1) {
            step = prev
        }
    }
}
