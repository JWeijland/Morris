import Foundation

struct CareerQuestion: Identifiable, Codable {
    let id: UUID
    var userId: UUID
    var title: String
    var description: String
    var industry: Industry
    var preferredBackground: [String]
    var tags: [String]
    var createdAt: Date
    var isActive: Bool
}
