import Foundation
import SwiftUI

enum BadgeType: String, Codable, CaseIterable {
    case helpedPeople      = "Community Helper"
    case financeMentor     = "Finance Mentor"
    case startupExperience = "Startup Experience"
    case retiredExecutive  = "Retired Executive"
    case topMentor         = "Top Mentor"
    case verified          = "LinkedIn Verified"
    case firstCoffee       = "First Coffee"
    case consultingExpert  = "Consulting Expert"
    case techLeader        = "Tech Leader"
    case marketingPro      = "Marketing Pro"

    var icon: String {
        switch self {
        case .helpedPeople:      return "hands.sparkles.fill"
        case .financeMentor:     return "chart.line.uptrend.xyaxis"
        case .startupExperience: return "lightbulb.fill"
        case .retiredExecutive:  return "crown.fill"
        case .topMentor:         return "star.fill"
        case .verified:          return "checkmark.seal.fill"
        case .firstCoffee:       return "cup.and.saucer.fill"
        case .consultingExpert:  return "briefcase.fill"
        case .techLeader:        return "cpu.fill"
        case .marketingPro:      return "megaphone.fill"
        }
    }

    var hexColor: String {
        switch self {
        case .helpedPeople:      return "#4CAF77"
        case .financeMentor:     return "#3B82F6"
        case .startupExperience: return "#F59E0B"
        case .retiredExecutive:  return "#8B5CF6"
        case .topMentor:         return "#D4AF37"
        case .verified:          return "#10B981"
        case .firstCoffee:       return "#C17D3C"
        case .consultingExpert:  return "#0EA5E9"
        case .techLeader:        return "#6366F1"
        case .marketingPro:      return "#EC4899"
        }
    }

    var color: Color { Color(wmHex: hexColor) }

    var description: String {
        switch self {
        case .helpedPeople:      return "Has helped multiple people"
        case .financeMentor:     return "Expert in Finance"
        case .startupExperience: return "Has worked in startups"
        case .retiredExecutive:  return "C-suite or executive experience"
        case .topMentor:         return "Highly rated mentor"
        case .verified:          return "LinkedIn profile verified"
        case .firstCoffee:       return "Completed first coffee meeting"
        case .consultingExpert:  return "Expert in Consulting"
        case .techLeader:        return "Technology leadership"
        case .marketingPro:      return "Marketing & brand expertise"
        }
    }
}

struct Badge: Identifiable, Codable {
    let id: UUID
    var userId: UUID
    var type: BadgeType
    var earnedAt: Date
}
