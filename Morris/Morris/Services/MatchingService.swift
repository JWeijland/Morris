import Foundation

// TODO: Replace with backend API call when Supabase/Firebase is integrated
struct MatchingService {

    struct MatchResult {
        let score: Double
        let breakdown: [String: Double]
        var percentage: Int { Int((score * 100).rounded()) }
    }

    static func calculate(
        youngProfile: YoungProfessionalProfile,
        youngUser: User,
        seniorProfile: SeniorProfessionalProfile,
        seniorUser: User,
        question: CareerQuestion?
    ) -> MatchResult {

        var score: Double = 0.0
        var breakdown: [String: Double] = [:]

        // Industry overlap: 35%
        let industryScore: Double = seniorProfile.industries.contains(youngProfile.industry) ? 0.35 : 0.0
        score += industryScore
        breakdown["Industry"] = industryScore

        // Topic / question overlap: 30%
        var topicScore: Double = 0.0
        if let question = question {
            let questionTerms = (question.tags + question.preferredBackground).map { $0.lowercased() }
            let mentorTopics = seniorProfile.topicsCanHelpWith.map { $0.lowercased() }
            let overlap = questionTerms.filter { term in mentorTopics.contains { $0.contains(term) } }
            let ratio = min(Double(overlap.count) / max(Double(questionTerms.count), 1.0), 1.0)
            topicScore = ratio * 0.30
        }
        score += topicScore
        breakdown["Topics"] = topicScore

        // Experience depth: 15%
        let expScore: Double
        switch seniorProfile.yearsOfExperience {
        case 30...: expScore = 0.15
        case 20..<30: expScore = 0.10
        case 10..<20: expScore = 0.06
        default: expScore = 0.03
        }
        score += expScore
        breakdown["Experience"] = expScore

        // Age / generation gap: 10%
        let ageDiff = seniorUser.age - youngUser.age
        let ageScore: Double
        switch ageDiff {
        case 40...: ageScore = 0.10
        case 30..<40: ageScore = 0.08
        case 20..<30: ageScore = 0.05
        default: ageScore = 0.02
        }
        score += ageScore
        breakdown["Generational gap"] = ageScore

        // Senior track record: 10%
        let helpScore: Double
        switch seniorProfile.helpedCount {
        case 15...: helpScore = 0.10
        case 8..<15: helpScore = 0.07
        case 1..<8: helpScore = 0.04
        default: helpScore = 0.01
        }
        score += helpScore
        breakdown["Track record"] = helpScore

        return MatchResult(score: min(score, 1.0), breakdown: breakdown)
    }

    static func sortedSeniorProfiles(
        for youngProfile: YoungProfessionalProfile,
        youngUser: User,
        seniorProfiles: [SeniorProfessionalProfile],
        seniorUsers: [User],
        question: CareerQuestion?,
        data: MockDataService = .shared
    ) -> [(SeniorProfessionalProfile, User, MatchResult)] {

        var results: [(SeniorProfessionalProfile, User, MatchResult)] = []

        for senior in seniorProfiles {
            guard let seniorUser = seniorUsers.first(where: { $0.id == senior.userId }) else { continue }
            let result = calculate(youngProfile: youngProfile, youngUser: youngUser, seniorProfile: senior, seniorUser: seniorUser, question: question)
            results.append((senior, seniorUser, result))
        }

        return results.sorted { $0.2.score > $1.2.score }
    }
}
