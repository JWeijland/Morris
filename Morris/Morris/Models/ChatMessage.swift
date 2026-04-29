import Foundation

struct ChatMessage: Identifiable, Codable {
    let id: UUID
    var matchId: UUID
    var senderId: UUID
    var text: String?
    var isVoiceNote: Bool
    var isVideoCallRequest: Bool
    var sentAt: Date
    var isRead: Bool
}
