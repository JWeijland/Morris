import SwiftUI

struct BadgeView: View {
    let badge: Badge
    var compact: Bool = false

    var body: some View {
        if compact {
            compactBadge
        } else {
            fullBadge
        }
    }

    private var compactBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: badge.type.icon)
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(.wmAccent)
            Text(badge.type.rawValue)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.wmAccent)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.wmAccent.opacity(0.12))
        .clipShape(Capsule())
    }

    private var fullBadge: some View {
        HStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color.wmAccent.opacity(0.15))
                    .frame(width: 36, height: 36)
                Image(systemName: badge.type.icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.wmAccent)
            }
            Text(badge.type.rawValue)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.wmText)
        }
    }
}

struct BadgesRow: View {
    let badges: [Badge]
    var compact: Bool = true

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: compact ? 6 : 12) {
                ForEach(badges) { badge in
                    BadgeView(badge: badge, compact: compact)
                }
            }
        }
    }
}
