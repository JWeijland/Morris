import Foundation

struct PastRole: Identifiable, Codable {
    let id: UUID
    var title: String
    var company: String
    var yearStart: Int
    var yearEnd: Int?
    var description: String?

    var yearRange: String { yearEnd.map { "\(yearStart)–\($0)" } ?? "\(yearStart)–present" }
    var durationYears: Int { (yearEnd ?? 2026) - yearStart }
}

struct YoungProfessionalProfile: Identifiable, Codable {
    let id: UUID
    var userId: UUID
    var currentRole: String
    var university: String?
    var industry: Industry
    var careerGoal: String
    var currentQuestionId: UUID?
    var preferredMentorBackground: [String]
    var linkedInURL: String?
}

struct SeniorProfessionalProfile: Identifiable, Codable {
    let id: UUID
    var userId: UUID
    var currentRole: String
    var industries: [Industry]
    var pastRoles: [PastRole]
    var topicsCanHelpWith: [String]
    var motivation: String
    var availability: String
    var yearsOfExperience: Int
    var helpedCount: Int
    var rating: Double
    var linkedInURL: String?

    var primaryIndustry: Industry { industries.first ?? .other }
    var topCompanyNames: [String] { Array(pastRoles.map(\.company).prefix(3)) }
}

struct CompanyProfile: Identifiable, Codable {
    let id: UUID
    var companyName: String
    var industry: Industry
    var description: String
    var logoName: String?
    var sponsoredCoffees: Int
    var contactEmail: String
    var employeeCount: String
    var website: String
}
