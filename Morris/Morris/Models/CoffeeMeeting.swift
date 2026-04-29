import Foundation

enum MeetingStatus: String, Codable {
    case proposed
    case confirmed
    case completed
    case cancelled
}

struct CoffeeMeeting: Identifiable, Codable {
    let id: UUID
    var matchId: UUID
    var cafeId: UUID
    var proposedDate: Date
    var confirmedDate: Date?
    var status: MeetingStatus
    var firstCoffeeIncluded: Bool
    var notes: String?
}
