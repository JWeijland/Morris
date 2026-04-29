import SwiftUI

struct ProfileCardView: View {
    let card: DiscoveryCard
    var dragOffset: CGSize = .zero
    var swipeIndicator: DiscoveryViewModel.SwipeDecision? = nil

    private var rotationDegrees: Double { Double(dragOffset.width) / 22 }
    private var interestedOpacity: Double { max(0, min(1, Double(dragOffset.width) / 100)) }
    private var passOpacity: Double { max(0, min(1, Double(-dragOffset.width) / 100)) }

    var body: some View {
        ZStack(alignment: .topLeading) {
            cardContent
            swipeOverlay
        }
        .offset(dragOffset)
        .rotationEffect(.degrees(rotationDegrees))
        .shadow(color: .black.opacity(0.10), radius: 18, x: 0, y: 8)
    }

    // MARK: - Card Content

    private var cardContent: some View {
        VStack(alignment: .leading, spacing: 0) {

            // Header: avatar + name + match score
            HStack(alignment: .top, spacing: 12) {
                avatarCircle
                VStack(alignment: .leading, spacing: 3) {
                    Text(card.seniorUser.name)
                        .font(WMFont.heading(20))
                        .foregroundColor(.wmText)
                    Text("\(card.seniorUser.age) · \(card.seniorProfile.currentRole)")
                        .font(WMFont.body(14))
                        .foregroundColor(.wmTextSecondary)
                    Text(card.seniorUser.city)
                        .font(WMFont.caption(12))
                        .foregroundColor(.wmTextTertiary)
                }
                Spacer()
                matchScoreBadge
            }
            .padding(WMSpacing.md)

            Divider().background(Color.wmBorder)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 14) {

                    // Industries
                    industrySection

                    // Career highlights
                    careerSection

                    // Topics
                    topicsSection

                    // Motivation quote
                    motivationSection

                    // Badges
                    if !card.badges.isEmpty { badgesSection }

                    // Availability
                    availabilityRow

                    // Track record
                    trackRecordRow
                }
                .padding(WMSpacing.md)
            }
        }
        .background(Color.wmSurface)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    // MARK: - Subviews

    private var avatarCircle: some View {
        ZStack {
            Circle()
                .fill(Color.wmPrimaryLight.opacity(0.4))
                .frame(width: 56, height: 56)
            Text(card.seniorUser.initials)
                .font(WMFont.heading(20))
                .foregroundColor(Color.wmPrimaryDark)
        }
        .overlay(
            Group {
                if card.seniorUser.isVerified {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.wmSuccess)
                        .offset(x: 18, y: 18)
                }
            }
        )
    }

    private var matchScoreBadge: some View {
        VStack(spacing: 2) {
            Text("\(card.matchResult.percentage)%")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(scoreColor)
            Text("match")
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.wmTextSecondary)
        }
        .frame(width: 52, height: 52)
        .background(scoreColor.opacity(0.12))
        .clipShape(Circle())
        .overlay(Circle().stroke(scoreColor.opacity(0.3), lineWidth: 1.5))
    }

    private var scoreColor: Color {
        switch card.matchResult.percentage {
        case 85...: return .wmSuccess
        case 70..<85: return Color(wmHex: "#F59E0B")
        default: return .wmTextSecondary
        }
    }

    private var industrySection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label("Industries", systemImage: "briefcase")
                .font(WMFont.caption(11))
                .foregroundColor(.wmTextSecondary)
                .textCase(.uppercase)
                .tracking(0.5)
            HStack(spacing: 6) {
                ForEach(card.seniorProfile.industries, id: \.id) { industry in
                    IndustryPill(industry: industry)
                }
            }
        }
    }

    private var careerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Career highlights", systemImage: "star")
                .font(WMFont.caption(11))
                .foregroundColor(.wmTextSecondary)
                .textCase(.uppercase)
                .tracking(0.5)
            VStack(alignment: .leading, spacing: 6) {
                ForEach(card.seniorProfile.pastRoles.prefix(3)) { role in
                    HStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.wmPrimary)
                            .frame(width: 3, height: 32)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(role.title)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.wmText)
                            Text("\(role.company) · \(role.yearRange)")
                                .font(.system(size: 12))
                                .foregroundColor(.wmTextSecondary)
                        }
                    }
                }
            }
        }
    }

    private var topicsSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label("Can help with", systemImage: "lightbulb")
                .font(WMFont.caption(11))
                .foregroundColor(.wmTextSecondary)
                .textCase(.uppercase)
                .tracking(0.5)
            FlowLayout(spacing: 6) {
                ForEach(card.seniorProfile.topicsCanHelpWith.prefix(5), id: \.self) { topic in
                    WMTag(text: topic)
                }
            }
        }
    }

    private var motivationSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label("Why I mentor", systemImage: "quote.opening")
                .font(WMFont.caption(11))
                .foregroundColor(.wmTextSecondary)
                .textCase(.uppercase)
                .tracking(0.5)
            Text("\u{201C}\(card.seniorProfile.motivation)\u{201D}")
                .font(.system(size: 13, weight: .regular, design: .serif))
                .foregroundColor(.wmText)
                .italic()
                .lineSpacing(4)
        }
        .padding(12)
        .background(Color.wmBackground)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }

    private var badgesSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label("Badges", systemImage: "medal")
                .font(WMFont.caption(11))
                .foregroundColor(.wmTextSecondary)
                .textCase(.uppercase)
                .tracking(0.5)
            BadgesRow(badges: card.badges, compact: true)
        }
    }

    private var availabilityRow: some View {
        HStack(spacing: 8) {
            Image(systemName: "calendar.badge.clock")
                .font(.system(size: 13))
                .foregroundColor(.wmPrimary)
            Text("Available: \(card.seniorProfile.availability)")
                .font(.system(size: 13))
                .foregroundColor(.wmTextSecondary)
        }
    }

    private var trackRecordRow: some View {
        HStack(spacing: 16) {
            HStack(spacing: 4) {
                Image(systemName: "hands.sparkles.fill")
                    .foregroundColor(.wmSuccess)
                    .font(.system(size: 13))
                Text("Helped \(card.seniorProfile.helpedCount) people")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.wmText)
            }
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .foregroundColor(.wmGold)
                    .font(.system(size: 12))
                Text(String(format: "%.1f", card.seniorProfile.rating))
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.wmText)
            }
        }
    }

    // MARK: - Swipe Overlay

    private var swipeOverlay: some View {
        ZStack {
            // Interested overlay (swipe right)
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.wmSuccess.opacity(0.15))
                .opacity(interestedOpacity)

            // Pass overlay (swipe left)
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.wmDanger.opacity(0.15))
                .opacity(passOpacity)

            // Labels
            VStack {
                HStack {
                    // Interested label
                    Text("Interested")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.wmSuccess)
                        .padding(10)
                        .background(Color.wmSuccess.opacity(0.15))
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.wmSuccess, lineWidth: 2.5))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .rotationEffect(.degrees(-15))
                        .opacity(interestedOpacity)
                        .padding(.leading, 20)
                    Spacer()
                    // Pass label
                    Text("Pass")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.wmDanger)
                        .padding(10)
                        .background(Color.wmDanger.opacity(0.15))
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.wmDanger, lineWidth: 2.5))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .rotationEffect(.degrees(15))
                        .opacity(passOpacity)
                        .padding(.trailing, 20)
                }
                .padding(.top, 30)
                Spacer()
            }
        }
    }
}
