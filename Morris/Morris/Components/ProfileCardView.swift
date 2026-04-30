import SwiftUI

struct ProfileCardView: View {
    let card: DiscoveryCard

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerRow
            Divider().background(Color.wmBorder)
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    careerSection
                    topicsSection
                    motivationBlock
                    footerRow
                }
                .padding(WMSpacing.md)
            }
        }
        .background(Color.wmSurface)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.08), radius: 16, x: 0, y: 6)
    }

    // MARK: - Header

    private var headerRow: some View {
        HStack(spacing: 12) {
            avatarView
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(card.seniorUser.name)
                        .font(WMFont.heading(19))
                        .foregroundColor(.wmText)
                    if card.seniorUser.isVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 13))
                            .foregroundColor(.wmSuccess)
                    }
                }
                Text(card.seniorProfile.currentRole)
                    .font(WMFont.body(13))
                    .foregroundColor(.wmTextSecondary)
                Text(card.seniorUser.city)
                    .font(.system(size: 12))
                    .foregroundColor(.wmTextTertiary)
            }
            Spacer()
        }
        .padding(WMSpacing.md)
    }

    private var avatarView: some View {
        ZStack {
            Circle()
                .fill(Color.wmPrimary.opacity(0.12))
                .frame(width: 56, height: 56)
            Text(card.seniorUser.initials)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.wmPrimary)
        }
    }

    // MARK: - Career highlights

    private var careerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionLabel("Career highlights", icon: "star")
            VStack(alignment: .leading, spacing: 8) {
                ForEach(card.seniorProfile.pastRoles.prefix(3)) { role in
                    HStack(alignment: .top, spacing: 10) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.wmPrimary)
                            .frame(width: 3, height: 34)
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

    // MARK: - Topics

    private var topicsSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            sectionLabel("Can help with", icon: "lightbulb")
            Text(card.seniorProfile.topicsCanHelpWith.prefix(5).joined(separator: ", "))
                .font(.system(size: 13, weight: .regular))
                .italic()
                .foregroundColor(.wmTextSecondary)
                .lineSpacing(3)
        }
    }

    // MARK: - Motivation quote block

    private var motivationBlock: some View {
        HStack(alignment: .top, spacing: 0) {
            Rectangle()
                .fill(Color.wmPrimary)
                .frame(width: 3)
                .clipShape(RoundedRectangle(cornerRadius: 2))
            Text("\u{201C}\(card.seniorProfile.motivation)\u{201D}")
                .font(.system(size: 13, weight: .regular))
                .italic()
                .foregroundColor(.wmText)
                .lineSpacing(4)
                .padding(.leading, 12)
        }
        .padding(12)
        .background(Color.wmBackground)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }

    // MARK: - Footer

    private var footerRow: some View {
        HStack(spacing: 16) {
            HStack(spacing: 4) {
                Image(systemName: "hands.sparkles.fill")
                    .font(.system(size: 12))
                    .foregroundColor(.wmSuccess)
                Text("Helped \(card.seniorProfile.helpedCount)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.wmTextSecondary)
            }
            HStack(spacing: 4) {
                Image(systemName: "calendar")
                    .font(.system(size: 12))
                    .foregroundColor(.wmAccent)
                Text(card.seniorProfile.availability)
                    .font(.system(size: 12))
                    .foregroundColor(.wmTextSecondary)
            }
        }
    }

    // MARK: - Helpers

    private func sectionLabel(_ title: String, icon: String) -> some View {
        Label(title, systemImage: icon)
            .font(.system(size: 11, weight: .semibold))
            .foregroundColor(.wmTextTertiary)
            .textCase(.uppercase)
            .tracking(0.5)
    }
}
