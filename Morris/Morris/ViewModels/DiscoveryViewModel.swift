import Foundation
import SwiftUI
import Combine

struct DiscoveryCard: Identifiable {
    let id: UUID
    let seniorProfile: SeniorProfessionalProfile
    let seniorUser: User
    let matchResult: MatchingService.MatchResult
    let badges: [Badge]
}

class DiscoveryViewModel: ObservableObject {
    @Published var cards: [DiscoveryCard] = []
    @Published var currentIndex: Int = 0
    @Published var dragOffset: CGSize = .zero
    @Published var isDragging: Bool = false
    @Published var lastDecision: SwipeDecision? = nil

    private let data = MockDataService.shared
    private weak var appViewModel: AppViewModel?

    var onMatchTriggered: ((User, Match) -> Void)?

    enum SwipeDecision {
        case interested
        case pass
    }

    init(appViewModel: AppViewModel) {
        self.appViewModel = appViewModel
        loadCards()
    }

    private func loadCards() {
        guard let youngProfile = appViewModel?.currentYoungProfile,
              let youngUser = appViewModel?.currentUser else { return }
        let question = appViewModel?.currentQuestion
        let sorted = MatchingService.sortedSeniorProfiles(
            for: youngProfile,
            youngUser: youngUser,
            seniorProfiles: data.seniorProfiles,
            seniorUsers: data.seniorUsers,
            question: question
        )
        cards = sorted.map { (sp, su, result) in
            DiscoveryCard(id: sp.id, seniorProfile: sp, seniorUser: su, matchResult: result, badges: data.badgesForUser(su.id))
        }
    }

    var topCard: DiscoveryCard? {
        guard currentIndex < cards.count else { return nil }
        return cards[currentIndex]
    }

    var hasMoreCards: Bool { currentIndex < cards.count }

    var swipeIndicator: SwipeDecision? {
        guard isDragging else { return nil }
        if dragOffset.width > 60 { return .interested }
        if dragOffset.width < -60 { return .pass }
        return nil
    }

    func swipe(_ decision: SwipeDecision) {
        guard let card = topCard else { return }
        lastDecision = decision
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            dragOffset = CGSize(width: decision == .interested ? 500 : -500, height: 0)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            self.advanceCard(card: card, decision: decision)
        }
    }

    private func advanceCard(card: DiscoveryCard, decision: SwipeDecision) {
        if decision == .interested {
            checkForMatch(card: card)
        }
        currentIndex += 1
        dragOffset = .zero
    }

    private func checkForMatch(card: DiscoveryCard) {
        guard let youngUser = appViewModel?.currentUser else { return }
        // Hans (sUser1) and Margaret (sUser2) are pre-set as already interested
        let preInterestedIds: Set<UUID> = [data.seniorUsers[0].id, data.seniorUsers[1].id]
        guard preInterestedIds.contains(card.seniorUser.id) else { return }

        // Reuse existing match if present, otherwise create a new one
        if let existing = data.matches.first(where: {
            $0.youngUserId == youngUser.id && $0.seniorUserId == card.seniorUser.id
        }) {
            onMatchTriggered?(card.seniorUser, existing)
        } else {
            let newMatch = Match(
                id: UUID(),
                youngUserId: youngUser.id,
                seniorUserId: card.seniorUser.id,
                matchScore: card.matchResult.score,
                youngLiked: true,
                seniorLiked: true,
                createdAt: Date(),
                status: .matched
            )
            data.matches.append(newMatch)
            onMatchTriggered?(card.seniorUser, newMatch)
        }
    }
}
