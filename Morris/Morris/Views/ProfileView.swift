import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appVM: AppViewModel

    @State private var showEditProfile = false
    @State private var showCodeOfConduct = false
    @State private var showLinkedInAlert = false

    private var user: User? { appVM.currentUser }
    private var seniorProfile: SeniorProfessionalProfile? { appVM.currentSeniorProfile }
    private var youngProfile: YoungProfessionalProfile? { appVM.currentYoungProfile }
    private var badges: [Badge] { user.map { appVM.data.badgesForUser($0.id) } ?? [] }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.wmBackground.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 0) {
                        profileHeader
                        if let senior = seniorProfile { seniorContent(senior) }
                        if let young = youngProfile { youngContent(young) }
                        settingsSection
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showEditProfile) {
                if appVM.isSeniorUser {
                    SeniorProfileSetupView()
                } else {
                    YoungQuestionView()
                }
            }
            .sheet(isPresented: $showCodeOfConduct) {
                CodeOfConductView()
            }
            .alert("LinkedIn Verification", isPresented: $showLinkedInAlert) {
                Button("OK") {}
            } message: {
                // TODO: LinkedIn OAuth integration
                Text("LinkedIn verification will be available in the next update. A verified badge builds trust and increases your match rate by up to 40%.")
            }
        }
    }

    // MARK: - Profile Header

    private var profileHeader: some View {
        VStack(spacing: 0) {
            // Background strip
            LinearGradient(
                colors: [Color(wmHex: "#F5E6D3"), Color(wmHex: "#FAF0E1")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 120)
            .overlay(alignment: .bottomTrailing) {
                Button { showEditProfile = true } label: {
                    Label("Edit profile", systemImage: "pencil")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.wmPrimary)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color.wmSurface)
                        .clipShape(Capsule())
                        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 2)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 14)
            }

            // Avatar + name
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(Color.wmPrimaryLight.opacity(0.4))
                        .frame(width: 84, height: 84)
                        .overlay(Circle().stroke(Color.wmSurface, lineWidth: 4))
                        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 3)
                    Text(user?.initials ?? "--")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundColor(.wmPrimaryDark)
                }
                .offset(y: -42)
                .padding(.bottom, -42)

                VStack(spacing: 4) {
                    HStack(spacing: 6) {
                        Text(user?.name ?? "")
                            .font(WMFont.display(22))
                            .foregroundColor(.wmText)
                        if user?.isVerified == true {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(.wmSuccess)
                                .font(.system(size: 16))
                        }
                    }
                    Text("\(user?.role.rawValue ?? "") · \(user?.city ?? "")")
                        .font(WMFont.body(14))
                        .foregroundColor(.wmTextSecondary)

                    // Verify LinkedIn CTA
                    if user?.isVerified == false {
                        Button { showLinkedInAlert = true } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "link")
                                    .font(.system(size: 11))
                                Text("Verify with LinkedIn")
                                    .font(.system(size: 12, weight: .semibold))
                            }
                            .foregroundColor(Color(wmHex: "#0077B5"))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color(wmHex: "#0077B5").opacity(0.1))
                            .clipShape(Capsule())
                        }
                        .padding(.top, 4)
                    }
                }
                .padding(.top, WMSpacing.md)
            }
            .padding(.horizontal, WMSpacing.md)
            .padding(.bottom, WMSpacing.md)
        }
        .background(Color.wmSurface)
    }

    // MARK: - Senior Content

    private func seniorContent(_ profile: SeniorProfessionalProfile) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Stats row
            statsRow(helpedCount: profile.helpedCount, rating: profile.rating, years: profile.yearsOfExperience)

            // Badges
            if !badges.isEmpty {
                sectionCard(title: "Your badges", icon: "medal.fill") {
                    BadgesRow(badges: badges, compact: false)
                }
            }

            // Industries
            sectionCard(title: "Industries", icon: "briefcase.fill") {
                FlowLayout(spacing: 6) {
                    ForEach(profile.industries, id: \.id) { IndustryPill(industry: $0) }
                }
            }

            // Topics
            sectionCard(title: "Topics you help with", icon: "lightbulb.fill") {
                FlowLayout(spacing: 6) {
                    ForEach(profile.topicsCanHelpWith, id: \.self) { WMTag(text: $0) }
                }
            }

            // Career history
            sectionCard(title: "Career history", icon: "clock.fill") {
                VStack(spacing: 10) {
                    ForEach(profile.pastRoles) { role in
                        pastRoleRow(role)
                    }
                }
            }

            // Motivation
            sectionCard(title: "Why I mentor", icon: "quote.opening") {
                Text("\u{201C}\(profile.motivation)\u{201D}")
                    .font(.system(size: 14, design: .serif))
                    .italic()
                    .foregroundColor(.wmText)
                    .lineSpacing(4)
            }

            // Availability
            sectionCard(title: "Availability", icon: "calendar.badge.clock") {
                Text(profile.availability)
                    .font(WMFont.body())
                    .foregroundColor(.wmTextSecondary)
            }
        }
    }

    // MARK: - Young Content

    private func youngContent(_ profile: YoungProfessionalProfile) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Stats row
            statsRow(helpedCount: nil, rating: nil, years: nil)

            // Industry
            sectionCard(title: "Target industry", icon: "briefcase.fill") {
                IndustryPill(industry: profile.industry)
            }

            // Career goal
            sectionCard(title: "Career goal", icon: "target") {
                Text(profile.careerGoal)
                    .font(WMFont.body())
                    .foregroundColor(.wmTextSecondary)
                    .lineSpacing(4)
            }

            // Current question
            if let qId = profile.currentQuestionId, let q = appVM.data.question(for: qId) {
                sectionCard(title: "Active question", icon: "questionmark.bubble.fill") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(q.title)
                            .font(WMFont.subheading(15))
                            .foregroundColor(.wmText)
                        Text(q.description)
                            .font(WMFont.body(13))
                            .foregroundColor(.wmTextSecondary)
                            .lineLimit(3)
                        FlowLayout(spacing: 6) {
                            ForEach(q.tags, id: \.self) { WMTag(text: $0, color: .wmTextSecondary) }
                        }
                    }
                }
            }
        }
    }

    // MARK: - Stats Row

    private func statsRow(helpedCount: Int?, rating: Double?, years: Int?) -> some View {
        HStack(spacing: 0) {
            if let count = helpedCount {
                statCell(value: "\(count)", label: "People helped")
                Divider().frame(height: 40)
            }
            if let r = rating {
                statCell(value: String(format: "%.1f", r), label: "Rating")
                Divider().frame(height: 40)
            }
            if let y = years {
                statCell(value: "\(y)", label: "Years exp.")
            } else {
                statCell(value: "\(appVM.currentMatches.count)", label: "Matches")
            }
        }
        .frame(maxWidth: .infinity)
        .wmCard(cornerRadius: 0, padding: 0)
        .padding(.vertical, 2)
    }

    private func statCell(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.wmPrimary)
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(.wmTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
    }

    // MARK: - Past Role Row

    private func pastRoleRow(_ role: PastRole) -> some View {
        HStack(alignment: .top, spacing: 10) {
            VStack(spacing: 4) {
                Circle().fill(Color.wmPrimary).frame(width: 8, height: 8).padding(.top, 5)
                Rectangle().fill(Color.wmBorder).frame(width: 1.5).frame(maxHeight: .infinity)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(role.title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.wmText)
                Text("\(role.company) · \(role.yearRange)")
                    .font(.system(size: 12))
                    .foregroundColor(.wmTextSecondary)
                if let desc = role.description {
                    Text(desc)
                        .font(.system(size: 12))
                        .foregroundColor(.wmTextTertiary)
                        .lineSpacing(2)
                }
            }
            .padding(.bottom, 10)
        }
    }

    // MARK: - Section Card

    private func sectionCard<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.wmPrimary)
                Text(title)
                    .font(WMFont.caption(11))
                    .foregroundColor(.wmTextSecondary)
                    .textCase(.uppercase)
                    .tracking(0.4)
            }
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(WMSpacing.md)
        .background(Color.wmSurface)
        .padding(.horizontal, WMSpacing.md)
        .padding(.top, WMSpacing.sm)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
    }

    // MARK: - Settings

    private var settingsSection: some View {
        VStack(spacing: 0) {
            settingsRow(icon: "shield.fill", title: "Code of Conduct", color: .wmSuccess) {
                showCodeOfConduct = true
            }
            Divider().padding(.leading, 52)
            settingsRow(icon: "exclamationmark.triangle.fill", title: "Report a concern", color: .wmDanger) {
                // TODO: Show report flow
            }
            Divider().padding(.leading, 52)
            settingsRow(icon: "questionmark.circle.fill", title: "Help & FAQ", color: .wmTextSecondary) {
                // TODO: Open help centre
            }
        }
        .background(Color.wmSurface)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
        .padding(WMSpacing.md)
        .padding(.top, WMSpacing.sm)
        .padding(.bottom, WMSpacing.xxl)
    }

    private func settingsRow(icon: String, title: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(color)
                    .frame(width: 30)
                Text(title)
                    .font(WMFont.body())
                    .foregroundColor(.wmText)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.wmTextTertiary)
            }
            .padding(.horizontal, WMSpacing.md)
            .padding(.vertical, 14)
        }
    }
}

#Preview {
    ProfileView().environmentObject(AppViewModel())
}
