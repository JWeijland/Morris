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
    @Published var cardOpacity: Double = 1.0

    private let data = MockDataService.shared
    private weak var appViewModel: AppViewModel?

    var onMatchTriggered: ((User, Match) -> Void)?

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

    func decide(save: Bool) {
        guard let card = topCard else { return }
        withAnimation(.easeInOut(duration: 0.2)) { cardOpacity = 0 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
            if save { self.checkForMatch(card: card) }
            self.currentIndex += 1
            withAnimation(.easeInOut(duration: 0.2)) { self.cardOpacity = 1 }
        }
    }

    private func checkForMatch(card: DiscoveryCard) {
        guard let youngUser = appViewModel?.currentUser else { return }
        let preInterestedIds: Set<UUID> = [data.seniorUsers[0].id, data.seniorUsers[1].id]
        guard preInterestedIds.contains(card.seniorUser.id) else { return }

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
