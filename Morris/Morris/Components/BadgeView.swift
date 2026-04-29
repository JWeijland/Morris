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
                .foregroundColor(badge.type.color)
            Text(badge.type.rawValue)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(badge.type.color)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(badge.type.color.opacity(0.12))
        .clipShape(Capsule())
    }

    private var fullBadge: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(badge.type.color.opacity(0.15))
                    .frame(width: 44, height: 44)
                Image(systemName: badge.type.icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(badge.type.color)
            }
            Text(badge.type.rawValue)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(Color.wmText)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(width: 72)
    }
}

struct BadgesRow: View {
    let badges: [Badge]
    var compact: Bool = true

    var body: some View {
        if compact {
            FlowLayout(spacing: 6) {
                ForEach(badges) { badge in
                    BadgeView(badge: badge, compact: true)
                }
            }
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(badges) { badge in
                        BadgeView(badge: badge, compact: false)
                    }
                }
                .padding(.horizontal, WMSpacing.md)
            }
        }
    }
}

// MARK: - Simple flow layout for badges

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.replacingUnspecifiedDimensions().width, subviews: subviews, spacing: spacing)
        return result.bounds
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, frame) in result.frames.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + frame.minX, y: bounds.minY + frame.minY), proposal: .unspecified)
        }
    }

    private struct FlowResult {
        var bounds: CGSize = .zero
        var frames: [CGRect] = []

        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var lineHeight: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                if x + size.width > maxWidth, x > 0 {
                    y += lineHeight + spacing
                    x = 0
                    lineHeight = 0
                }
                frames.append(CGRect(origin: CGPoint(x: x, y: y), size: size))
                x += size.width + spacing
                lineHeight = max(lineHeight, size.height)
            }
            bounds = CGSize(width: maxWidth, height: y + lineHeight)
        }
    }
}
