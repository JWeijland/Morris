import SwiftUI

// MARK: - Colors

extension Color {
    static let wmBackground    = Color(wmHex: "#F4F5F7")
    static let wmSurface       = Color.white
    static let wmPrimary       = Color(wmHex: "#2D3A5E")
    static let wmAccent        = Color(wmHex: "#E8A84D")
    static let wmText          = Color(wmHex: "#1C1C1E")
    static let wmTextSecondary = Color(wmHex: "#6B7280")
    static let wmTextTertiary  = Color(wmHex: "#9CA3AF")
    static let wmBorder        = Color(wmHex: "#E5E7EB")
    static let wmSuccess       = Color(wmHex: "#34C759")
    static let wmDanger        = Color(wmHex: "#FF3B30")

    init(wmHex: String) {
        let hex = wmHex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 45, 58, 94)
        }
        self.init(.sRGB, red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255, opacity: Double(a)/255)
    }
}

// MARK: - Typography

struct WMFont {
    static func display(_ size: CGFloat = 32) -> Font { .system(size: size, weight: .bold, design: .default) }
    static func heading(_ size: CGFloat = 22) -> Font { .system(size: size, weight: .semibold, design: .default) }
    static func subheading(_ size: CGFloat = 17) -> Font { .system(size: size, weight: .semibold, design: .default) }
    static func body(_ size: CGFloat = 15) -> Font { .system(size: size, weight: .regular, design: .default) }
    static func caption(_ size: CGFloat = 12) -> Font { .system(size: size, weight: .medium, design: .default) }
    static func mono(_ size: CGFloat = 14) -> Font { .system(size: size, weight: .medium, design: .monospaced) }
}

// MARK: - Spacing

enum WMSpacing {
    static let xs: CGFloat  = 4
    static let sm: CGFloat  = 8
    static let md: CGFloat  = 16
    static let lg: CGFloat  = 24
    static let xl: CGFloat  = 32
    static let xxl: CGFloat = 48
}

// MARK: - View Modifiers

struct WMCardModifier: ViewModifier {
    var cornerRadius: CGFloat = 16
    var padding: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(Color.wmSurface)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 3)
    }
}

extension View {
    func wmCard(cornerRadius: CGFloat = 16, padding: CGFloat = 0) -> some View {
        modifier(WMCardModifier(cornerRadius: cornerRadius, padding: padding))
    }
}

// MARK: - Industry

enum Industry: String, Codable, CaseIterable, Identifiable {
    var id: String { rawValue }
    case finance         = "Finance"
    case consulting      = "Consulting"
    case technology      = "Technology"
    case healthcare      = "Healthcare"
    case law             = "Law"
    case marketing       = "Marketing"
    case education       = "Education"
    case entrepreneurship = "Entrepreneurship"
    case government      = "Government"
    case media           = "Media"
    case engineering     = "Engineering"
    case hr              = "Human Resources"
    case realEstate      = "Real Estate"
    case other           = "Other"

    var icon: String {
        switch self {
        case .finance:          return "chart.line.uptrend.xyaxis"
        case .consulting:       return "briefcase.fill"
        case .technology:       return "laptopcomputer"
        case .healthcare:       return "heart.circle.fill"
        case .law:              return "scroll.fill"
        case .marketing:        return "megaphone.fill"
        case .education:        return "graduationcap.fill"
        case .entrepreneurship: return "lightbulb.fill"
        case .government:       return "building.columns.fill"
        case .media:            return "tv.fill"
        case .engineering:      return "gearshape.fill"
        case .hr:               return "person.2.fill"
        case .realEstate:       return "house.fill"
        case .other:            return "circle.grid.2x2.fill"
        }
    }
}
