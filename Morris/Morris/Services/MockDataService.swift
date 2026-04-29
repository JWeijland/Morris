import Foundation

// MARK: - Stable UUIDs for mock data
private enum MID {
    // Senior users
    static let sUser1 = UUID(uuidString: "11000000-0000-0000-0000-000000000001")!
    static let sUser2 = UUID(uuidString: "11000000-0000-0000-0000-000000000002")!
    static let sUser3 = UUID(uuidString: "11000000-0000-0000-0000-000000000003")!
    static let sUser4 = UUID(uuidString: "11000000-0000-0000-0000-000000000004")!
    static let sUser5 = UUID(uuidString: "11000000-0000-0000-0000-000000000005")!

    // Young users
    static let yUser1 = UUID(uuidString: "22000000-0000-0000-0000-000000000001")!
    static let yUser2 = UUID(uuidString: "22000000-0000-0000-0000-000000000002")!
    static let yUser3 = UUID(uuidString: "22000000-0000-0000-0000-000000000003")!

    // Senior profiles
    static let sPro1 = UUID(uuidString: "33000000-0000-0000-0000-000000000001")!
    static let sPro2 = UUID(uuidString: "33000000-0000-0000-0000-000000000002")!
    static let sPro3 = UUID(uuidString: "33000000-0000-0000-0000-000000000003")!
    static let sPro4 = UUID(uuidString: "33000000-0000-0000-0000-000000000004")!
    static let sPro5 = UUID(uuidString: "33000000-0000-0000-0000-000000000005")!

    // Young profiles
    static let yPro1 = UUID(uuidString: "44000000-0000-0000-0000-000000000001")!
    static let yPro2 = UUID(uuidString: "44000000-0000-0000-0000-000000000002")!
    static let yPro3 = UUID(uuidString: "44000000-0000-0000-0000-000000000003")!

    // Questions
    static let q1 = UUID(uuidString: "55000000-0000-0000-0000-000000000001")!
    static let q2 = UUID(uuidString: "55000000-0000-0000-0000-000000000002")!
    static let q3 = UUID(uuidString: "55000000-0000-0000-0000-000000000003")!

    // Cafes
    static let cafe1 = UUID(uuidString: "66000000-0000-0000-0000-000000000001")!
    static let cafe2 = UUID(uuidString: "66000000-0000-0000-0000-000000000002")!
    static let cafe3 = UUID(uuidString: "66000000-0000-0000-0000-000000000003")!

    // Matches
    static let match1 = UUID(uuidString: "77000000-0000-0000-0000-000000000001")!
    static let match2 = UUID(uuidString: "77000000-0000-0000-0000-000000000002")!
}

class MockDataService {
    static let shared = MockDataService()

    let seniorUsers: [User]
    let youngUsers: [User]
    let seniorProfiles: [SeniorProfessionalProfile]
    let youngProfiles: [YoungProfessionalProfile]
    let careerQuestions: [CareerQuestion]
    let cafes: [Cafe]
    let badges: [Badge]
    var matches: [Match]
    var messages: [UUID: [ChatMessage]]

    private init() {
        // MARK: - Senior Users
        let su1 = User(id: MID.sUser1, name: "Hans van der Berg", age: 64, role: .seniorProfessional, city: "Amsterdam", profileImageName: nil, isVerified: true, linkedInURL: "https://linkedin.com", createdAt: Date())
        let su2 = User(id: MID.sUser2, name: "Margaret Okafor", age: 61, role: .seniorProfessional, city: "Amsterdam", profileImageName: nil, isVerified: true, linkedInURL: "https://linkedin.com", createdAt: Date())
        let su3 = User(id: MID.sUser3, name: "Peter Janssen", age: 67, role: .seniorProfessional, city: "Rotterdam", profileImageName: nil, isVerified: true, linkedInURL: "https://linkedin.com", createdAt: Date())
        let su4 = User(id: MID.sUser4, name: "Eleanor de Vries", age: 58, role: .seniorProfessional, city: "Utrecht", profileImageName: nil, isVerified: false, linkedInURL: "https://linkedin.com", createdAt: Date())
        let su5 = User(id: MID.sUser5, name: "Robert van Amstel", age: 70, role: .seniorProfessional, city: "The Hague", profileImageName: nil, isVerified: true, linkedInURL: "https://linkedin.com", createdAt: Date())
        seniorUsers = [su1, su2, su3, su4, su5]

        // MARK: - Young Users
        let yu1 = User(id: MID.yUser1, name: "Sofia Rodriguez", age: 23, role: .youngProfessional, city: "Amsterdam", profileImageName: nil, isVerified: false, linkedInURL: nil, createdAt: Date())
        let yu2 = User(id: MID.yUser2, name: "Tim Bakker", age: 25, role: .youngProfessional, city: "Amsterdam", profileImageName: nil, isVerified: false, linkedInURL: nil, createdAt: Date())
        let yu3 = User(id: MID.yUser3, name: "Priya Sharma", age: 22, role: .youngProfessional, city: "Delft", profileImageName: nil, isVerified: false, linkedInURL: nil, createdAt: Date())
        youngUsers = [yu1, yu2, yu3]

        // MARK: - Senior Profiles
        let sp1 = SeniorProfessionalProfile(
            id: MID.sPro1, userId: MID.sUser1,
            currentRole: "Retired CFO",
            industries: [.finance, .entrepreneurship],
            pastRoles: [
                PastRole(id: UUID(), title: "Chief Financial Officer", company: "ING Group", yearStart: 2005, yearEnd: 2021, description: "Led global finance operations across 40 countries"),
                PastRole(id: UUID(), title: "Head of Corporate Finance", company: "ABN AMRO", yearStart: 1995, yearEnd: 2005, description: "M&A deals and capital markets"),
                PastRole(id: UUID(), title: "Senior Financial Analyst", company: "KPMG", yearStart: 1988, yearEnd: 1995, description: nil)
            ],
            topicsCanHelpWith: ["CFO career path", "Corporate finance", "M&A strategy", "Career transitions in finance", "Leadership in banking", "Work-life balance"],
            motivation: "I spent 35 years navigating global finance. Now I want to help the next generation avoid the pitfalls I learned the hard way — and take the shortcuts I wish someone had shown me.",
            availability: "Weekday mornings",
            yearsOfExperience: 35,
            helpedCount: 14,
            rating: 4.9,
            linkedInURL: "https://linkedin.com"
        )
        let sp2 = SeniorProfessionalProfile(
            id: MID.sPro2, userId: MID.sUser2,
            currentRole: "Retired Senior Partner",
            industries: [.consulting, .finance, .entrepreneurship],
            pastRoles: [
                PastRole(id: UUID(), title: "Senior Partner", company: "McKinsey & Company", yearStart: 2000, yearEnd: 2022, description: "Led financial services practice for EMEA region"),
                PastRole(id: UUID(), title: "Associate Principal", company: "Boston Consulting Group", yearStart: 1993, yearEnd: 2000, description: "Strategy consulting across FS and tech"),
                PastRole(id: UUID(), title: "Analyst", company: "Goldman Sachs", yearStart: 1988, yearEnd: 1993, description: nil)
            ],
            topicsCanHelpWith: ["Breaking into consulting", "Partner track strategy", "Case interview prep", "Moving from banking to consulting", "Leadership & executive presence", "Building a portfolio career"],
            motivation: "Consulting shaped who I am. The joy of solving a hard problem never fades. I want to give that to you — the frameworks, the mindset, and the unwritten rules no one tells you.",
            availability: "Flexible — mornings preferred",
            yearsOfExperience: 34,
            helpedCount: 22,
            rating: 4.8,
            linkedInURL: "https://linkedin.com"
        )
        let sp3 = SeniorProfessionalProfile(
            id: MID.sPro3, userId: MID.sUser3,
            currentRole: "Retired CTO",
            industries: [.technology, .engineering],
            pastRoles: [
                PastRole(id: UUID(), title: "Chief Technology Officer", company: "Philips", yearStart: 2007, yearEnd: 2020, description: "Led global R&D and digital transformation"),
                PastRole(id: UUID(), title: "VP Engineering", company: "ASML", yearStart: 1998, yearEnd: 2007, description: "Advanced semiconductor software"),
                PastRole(id: UUID(), title: "Senior Software Engineer", company: "Ericsson", yearStart: 1990, yearEnd: 1998, description: nil)
            ],
            topicsCanHelpWith: ["CTO career path", "Technical leadership", "Digital transformation", "Building engineering teams", "From IC to manager", "Startup vs corporate trade-offs"],
            motivation: "Technology changes fast; wisdom changes slowly. I have seen enough hype cycles to know what actually matters. Let me save you years of trial and error.",
            availability: "Weekends and Thursday afternoons",
            yearsOfExperience: 32,
            helpedCount: 8,
            rating: 4.7,
            linkedInURL: "https://linkedin.com"
        )
        let sp4 = SeniorProfessionalProfile(
            id: MID.sPro4, userId: MID.sUser4,
            currentRole: "Brand Advisor",
            industries: [.marketing, .media, .entrepreneurship],
            pastRoles: [
                PastRole(id: UUID(), title: "Chief Marketing Officer", company: "Unilever", yearStart: 2009, yearEnd: 2023, description: "Global brand strategy for 20+ brands"),
                PastRole(id: UUID(), title: "VP Marketing Europe", company: "Heineken", yearStart: 2001, yearEnd: 2009, description: "Campaign strategy and brand repositioning"),
                PastRole(id: UUID(), title: "Marketing Manager", company: "L'Oréal", yearStart: 1995, yearEnd: 2001, description: nil)
            ],
            topicsCanHelpWith: ["CMO career path", "Brand strategy", "Marketing in FMCG", "Personal branding", "Managing creative teams", "From agency to corporate"],
            motivation: "Great marketing is about human truth. After 28 years I have countless stories — what worked, what flopped spectacularly, and why. I want to share all of it.",
            availability: "Tuesday & Thursday mornings",
            yearsOfExperience: 28,
            helpedCount: 11,
            rating: 4.6,
            linkedInURL: nil
        )
        let sp5 = SeniorProfessionalProfile(
            id: MID.sPro5, userId: MID.sUser5,
            currentRole: "Retired Founding Partner",
            industries: [.law, .entrepreneurship, .finance],
            pastRoles: [
                PastRole(id: UUID(), title: "Founding Partner", company: "Van Amstel & Partners", yearStart: 1995, yearEnd: 2020, description: "Built a 120-lawyer M&A and corporate law firm"),
                PastRole(id: UUID(), title: "Senior Associate", company: "Allen & Overy", yearStart: 1987, yearEnd: 1995, description: "Cross-border M&A and private equity"),
                PastRole(id: UUID(), title: "Junior Associate", company: "De Brauw Blackstone Westbroek", yearStart: 1983, yearEnd: 1987, description: nil)
            ],
            topicsCanHelpWith: ["Corporate law career", "Building your own firm", "M&A law", "Entrepreneurship as a lawyer", "Negotiation skills", "Law + business career combinations"],
            motivation: "I built a firm from scratch and later let it go. Both decisions taught me more than any textbook. I enjoy coffee, good questions, and making introductions that change careers.",
            availability: "Flexible — retired",
            yearsOfExperience: 40,
            helpedCount: 19,
            rating: 5.0,
            linkedInURL: "https://linkedin.com"
        )
        seniorProfiles = [sp1, sp2, sp3, sp4, sp5]

        // MARK: - Young Profiles
        let yp1 = YoungProfessionalProfile(id: MID.yPro1, userId: MID.yUser1, currentRole: "MSc Finance student", university: "University of Amsterdam", industry: .finance, careerGoal: "Become an investment banker and eventually a CFO", currentQuestionId: MID.q1, preferredMentorBackground: ["Banking", "CFO experience", "M&A"], linkedInURL: nil)
        let yp2 = YoungProfessionalProfile(id: MID.yPro2, userId: MID.yUser2, currentRole: "Junior Data Analyst", university: nil, industry: .technology, careerGoal: "Transition into product management at a scale-up", currentQuestionId: MID.q2, preferredMentorBackground: ["Product management", "Tech leadership", "Career pivots"], linkedInURL: nil)
        let yp3 = YoungProfessionalProfile(id: MID.yPro3, userId: MID.yUser3, currentRole: "BSc Economics student", university: "TU Delft", industry: .consulting, careerGoal: "Join a top consulting firm after graduation", currentQuestionId: MID.q3, preferredMentorBackground: ["Consulting", "Strategy", "Career entry from non-target"], linkedInURL: nil)
        youngProfiles = [yp1, yp2, yp3]

        // MARK: - Career Questions
        let baseDate = Date().addingTimeInterval(-86400 * 3)
        let cq1 = CareerQuestion(id: MID.q1, userId: MID.yUser1, title: "How do I position myself for investment banking after my MSc?", description: "I'm finishing my MSc in Finance at UvA and want to break into investment banking. I don't come from a target school. What do I focus on in the next 12 months?", industry: .finance, preferredBackground: ["Investment banking", "M&A", "CFO"], tags: ["banking", "MSc", "entry-level", "career strategy"], createdAt: baseDate, isActive: true)
        let cq2 = CareerQuestion(id: MID.q2, userId: MID.yUser2, title: "How do I pivot from data analytics to product management?", description: "I have 2 years of data analytics experience. I love working with products and users, but I don't know how to make the switch to PM without starting over.", industry: .technology, preferredBackground: ["Product management", "Tech leadership"], tags: ["product management", "career pivot", "tech", "analytics"], createdAt: baseDate.addingTimeInterval(-86400), isActive: true)
        let cq3 = CareerQuestion(id: MID.q3, userId: MID.yUser3, title: "How do I break into consulting from a non-target university?", description: "I study Economics at TU Delft, which is not considered a target school for McKinsey/BCG. What are my realistic chances and how should I prepare?", industry: .consulting, preferredBackground: ["Strategy consulting", "MBB experience", "Non-target background"], tags: ["consulting", "MBB", "case interview", "non-target"], createdAt: baseDate.addingTimeInterval(-86400 * 2), isActive: true)
        careerQuestions = [cq1, cq2, cq3]

        // MARK: - Cafés
        let c1 = Cafe(id: MID.cafe1, name: "Café de Jaren", address: "Nieuwe Doelenstraat 20", city: "Amsterdam", neighborhood: "Centrum", description: "A classic Amsterdam grand café with a stunning riverside terrace. Perfect for an unhurried career conversation.", imageName: nil, rating: 4.5, distanceKm: 0.8, isPartner: true, mapURL: nil)
        let c2 = Cafe(id: MID.cafe2, name: "Blackbird Coffee", address: "Van Baerlestraat 14", city: "Amsterdam", neighborhood: "Oud-Zuid", description: "Specialty coffee and a calm, focused atmosphere. Beloved by professionals for working lunches and meetings.", imageName: nil, rating: 4.8, distanceKm: 2.3, isPartner: true, mapURL: nil)
        let c3 = Cafe(id: MID.cafe3, name: "Headfirst Coffee", address: "Overhoeksplein 2", city: "Amsterdam", neighborhood: "Noord", description: "Modern coffee bar in a creative hub. Great vibe for open, exploratory conversations about your career.", imageName: nil, rating: 4.6, distanceKm: 3.1, isPartner: true, mapURL: nil)
        cafes = [c1, c2, c3]

        // MARK: - Badges
        let now = Date()
        let b1  = Badge(id: UUID(), userId: MID.sUser1, type: .helpedPeople,      earnedAt: now.addingTimeInterval(-86400 * 30))
        let b2  = Badge(id: UUID(), userId: MID.sUser1, type: .financeMentor,     earnedAt: now.addingTimeInterval(-86400 * 20))
        let b3  = Badge(id: UUID(), userId: MID.sUser1, type: .verified,          earnedAt: now.addingTimeInterval(-86400 * 60))
        let b4  = Badge(id: UUID(), userId: MID.sUser2, type: .consultingExpert,  earnedAt: now.addingTimeInterval(-86400 * 10))
        let b5  = Badge(id: UUID(), userId: MID.sUser2, type: .topMentor,         earnedAt: now.addingTimeInterval(-86400 * 5))
        let b6  = Badge(id: UUID(), userId: MID.sUser2, type: .verified,          earnedAt: now.addingTimeInterval(-86400 * 50))
        let b7  = Badge(id: UUID(), userId: MID.sUser3, type: .techLeader,        earnedAt: now.addingTimeInterval(-86400 * 15))
        let b8  = Badge(id: UUID(), userId: MID.sUser3, type: .verified,          earnedAt: now.addingTimeInterval(-86400 * 40))
        let b9  = Badge(id: UUID(), userId: MID.sUser4, type: .marketingPro,      earnedAt: now.addingTimeInterval(-86400 * 8))
        let b10 = Badge(id: UUID(), userId: MID.sUser4, type: .helpedPeople,      earnedAt: now.addingTimeInterval(-86400 * 25))
        let b11 = Badge(id: UUID(), userId: MID.sUser5, type: .retiredExecutive,  earnedAt: now.addingTimeInterval(-86400 * 45))
        let b12 = Badge(id: UUID(), userId: MID.sUser5, type: .startupExperience, earnedAt: now.addingTimeInterval(-86400 * 35))
        let b13 = Badge(id: UUID(), userId: MID.sUser5, type: .topMentor,         earnedAt: now.addingTimeInterval(-86400 * 2))
        let b14 = Badge(id: UUID(), userId: MID.sUser5, type: .verified,          earnedAt: now.addingTimeInterval(-86400 * 55))
        badges = [b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14]

        // MARK: - Pre-seeded Matches (seniors already interested in young users)
        let m1 = Match(id: MID.match1, youngUserId: MID.yUser1, seniorUserId: MID.sUser1, matchScore: 0.92, youngLiked: true, seniorLiked: true, createdAt: now.addingTimeInterval(-3600), status: .matched)
        let m2 = Match(id: MID.match2, youngUserId: MID.yUser1, seniorUserId: MID.sUser2, matchScore: 0.88, youngLiked: true, seniorLiked: true, createdAt: now.addingTimeInterval(-7200), status: .matched)
        matches = [m1, m2]

        // MARK: - Mock Chat Messages
        let msgs1: [ChatMessage] = [
            ChatMessage(id: UUID(), matchId: MID.match1, senderId: MID.sUser1, text: "Hi Sofia, congratulations on matching! I read your question about breaking into banking — a great one. Happy to meet for a coffee and walk you through how I'd approach your situation.", isVoiceNote: false, isVideoCallRequest: false, sentAt: now.addingTimeInterval(-3500), isRead: true),
            ChatMessage(id: UUID(), matchId: MID.match1, senderId: MID.yUser1, text: "Hans! Thank you so much. I'd love that. I've been struggling with the non-target angle and would appreciate your perspective.", isVoiceNote: false, isVideoCallRequest: false, sentAt: now.addingTimeInterval(-3400), isRead: true),
            ChatMessage(id: UUID(), matchId: MID.match1, senderId: MID.sUser1, text: "Don't worry about the non-target angle — it's a story problem, not a substance problem. I'll show you how to frame it. When works for you this week?", isVoiceNote: false, isVideoCallRequest: false, sentAt: now.addingTimeInterval(-3300), isRead: true),
        ]
        let msgs2: [ChatMessage] = [
            ChatMessage(id: UUID(), matchId: MID.match2, senderId: MID.sUser2, text: "Sofia, I saw your question about consulting. I spent years at McKinsey. The non-target school question is one I hear a lot. Let's talk.", isVoiceNote: false, isVideoCallRequest: false, sentAt: now.addingTimeInterval(-7100), isRead: true),
            ChatMessage(id: UUID(), matchId: MID.match2, senderId: MID.yUser1, text: "Margaret, that would mean the world. I really want to understand what it takes beyond the case prep.", isVoiceNote: false, isVideoCallRequest: false, sentAt: now.addingTimeInterval(-7000), isRead: false),
        ]
        messages = [MID.match1: msgs1, MID.match2: msgs2]
    }

    func badgesForUser(_ userId: UUID) -> [Badge] {
        badges.filter { $0.userId == userId }
    }

    func seniorProfile(for userId: UUID) -> SeniorProfessionalProfile? {
        seniorProfiles.first { $0.userId == userId }
    }

    func youngProfile(for userId: UUID) -> YoungProfessionalProfile? {
        youngProfiles.first { $0.userId == userId }
    }

    func user(for userId: UUID) -> User? {
        (seniorUsers + youngUsers).first { $0.id == userId }
    }

    func question(for questionId: UUID) -> CareerQuestion? {
        careerQuestions.first { $0.id == questionId }
    }

    func matchesFor(youngUserId: UUID) -> [Match] {
        matches.filter { $0.youngUserId == youngUserId && $0.isMatch }
    }

    func messagesFor(matchId: UUID) -> [ChatMessage] {
        messages[matchId] ?? []
    }
}
