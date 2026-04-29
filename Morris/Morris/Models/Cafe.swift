import Foundation

struct Cafe: Identifiable, Codable {
    let id: UUID
    var name: String
    var address: String
    var city: String
    var neighborhood: String
    var description: String
    var imageName: String?
    var rating: Double
    var distanceKm: Double
    var isPartner: Bool
    var mapURL: String?
}
