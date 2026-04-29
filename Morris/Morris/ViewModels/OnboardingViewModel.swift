import Foundation
import SwiftUI
import Combine

enum OnboardingStep: Int, CaseIterable {
    case roleConfirm
    case basicInfo
    case industryGoal
    case linkedIn
    case done
}

class OnboardingViewModel: ObservableObject {
    @Published var step: OnboardingStep = .roleConfirm
    @Published var name: String = ""
    @Published var city: String = ""
    @Published var age: String = ""
    @Published var selectedIndustry: Industry = .finance
    @Published var careerGoal: String = ""
    @Published var motivation: String = ""
    @Published var linkedInPlaceholder: String = ""
    @Published var showLinkedInImportAlert: Bool = false

    var selectedRole: UserRole
    var onComplete: () -> Void

    init(role: UserRole, onComplete: @escaping () -> Void) {
        self.selectedRole = role
        self.onComplete = onComplete
    }

    var progressFraction: Double {
        Double(step.rawValue) / Double(OnboardingStep.allCases.count - 1)
    }

    var canAdvance: Bool {
        switch step {
        case .roleConfirm:  return true
        case .basicInfo:    return !name.isEmpty && !city.isEmpty
        case .industryGoal: return !careerGoal.isEmpty
        case .linkedIn:     return true
        case .done:         return true
        }
    }

    func advance() {
        if let next = OnboardingStep(rawValue: step.rawValue + 1) {
            step = next
            if next == .done { onComplete() }
        }
    }

    func back() {
        if let prev = OnboardingStep(rawValue: step.rawValue - 1) {
            step = prev
        }
    }
}
