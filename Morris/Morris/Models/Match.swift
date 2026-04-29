import Foundation

enum MatchStatus: String, Codable {
    case pending
    case matched
    case coffeePlanned
    case completed
}

struct Match: Identifiable, Codable {
    let id: UUID
    var youngUserId: UUID
    var seniorUserId: UUID
    var matchScore: Double
    var youngLiked: Bool
    var seniorLiked: Bool
    var createdAt: Date
    var status: MatchStatus

    var isMatch: Bool { youngLiked && seniorLiked }
    var matchPercentage: Int { Int((matchScore * 100).rounded()) }
}
