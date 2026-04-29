import Foundation
import SwiftUI
import Combine

enum AppState {
    case welcome
    case onboarding
    case main
}

class AppViewModel: ObservableObject {
    @Published var appState: AppState = .welcome
    @Published var selectedRole: UserRole = .youngProfessional

    // Current session user
    @Published var currentUser: User?
    @Published var currentYoungProfile: YoungProfessionalProfile?
    @Published var currentSeniorProfile: SeniorProfessionalProfile?

    // Match notification
    @Published var pendingMatchUser: User?
    @Published var pendingMatch: Match?
    @Published var showMatchSheet: Bool = false

    // TODO: Replace with repository layer backed by Firebase/Supabase
    let data = MockDataService.shared

    var isYoungUser: Bool { currentUser?.role == .youngProfessional }
    var isSeniorUser: Bool { currentUser?.role == .seniorProfessional }

    var currentQuestion: CareerQuestion? {
        guard let qId = currentYoungProfile?.currentQuestionId else { return nil }
        return data.question(for: qId)
    }

    var currentMatches: [Match] {
        guard let user = currentUser else { return [] }
        return data.matchesFor(youngUserId: user.id)
    }

    func selectRole(_ role: UserRole) {
        selectedRole = role
        switch role {
        case .youngProfessional:
            let user = data.youngUsers[0]
            currentUser = user
            currentYoungProfile = data.youngProfile(for: user.id)
        case .seniorProfessional:
            let user = data.seniorUsers[0]
            currentUser = user
            currentSeniorProfile = data.seniorProfile(for: user.id)
        case .company:
            // TODO: Company onboarding flow
            currentUser = User(id: UUID(), name: "Company User", age: 0, role: .company, city: "Amsterdam", profileImageName: nil, isVerified: false, linkedInURL: nil, createdAt: Date())
        }
        appState = .onboarding
    }

    func completeOnboarding() {
        appState = .main
    }

    func triggerMatch(seniorUser: User, match: Match) {
        pendingMatchUser = seniorUser
        pendingMatch = match
        showMatchSheet = true
    }

    func dismissMatch() {
        showMatchSheet = false
        pendingMatch = nil
        pendingMatchUser = nil
    }

    func messagesFor(matchId: UUID) -> [ChatMessage] {
        data.messagesFor(matchId: matchId)
    }

    func sendMessage(text: String, matchId: UUID, senderId: UUID) {
        let msg = ChatMessage(id: UUID(), matchId: matchId, senderId: senderId, text: text, isVoiceNote: false, isVideoCallRequest: false, sentAt: Date(), isRead: false)
        if data.messages[matchId] != nil {
            data.messages[matchId]!.append(msg)
        } else {
            data.messages[matchId] = [msg]
        }
    }
}
