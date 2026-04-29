import Foundation

enum UserRole: String, Codable, CaseIterable {
    case youngProfessional  = "Young Professional"
    case seniorProfessional = "Senior Professional"
    case company            = "Company"
}

struct User: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var age: Int
    var role: UserRole
    var city: String
    var profileImageName: String?
    var isVerified: Bool
    var linkedInURL: String?
    var createdAt: Date

    var initials: String {
        name.split(separator: " ").compactMap(\.first).prefix(2).map(String.init).joined()
    }

    var firstName: String {
        name.split(separator: " ").first.map(String.init) ?? name
    }
}
