import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appVM: AppViewModel

    @State private var showLinkedInAlert = false
    @State private var showCodeOfConduct = false

    private var user: User? { appVM.currentUser }
    private var seniorProfile: SeniorProfessionalProfile? { appVM.currentSeniorProfile }
    private var youngProfile: YoungProfessionalProfile? { appVM.currentYoungProfile }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.wmBackground.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 0) {
                        profileHeader
                        Divider().background(Color.wmBorder)
                        if let senior = seniorProfile { seniorContent(senior) }
                        if let young = youngProfile { youngContent(young) }
                        settingsSection
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .alert("LinkedIn Verification", isPresented: $showLinkedInAlert) {
            Button("OK") {}
        } message: {
            Text("LinkedIn verification will be available in the next update.")
        }
        .sheet(isPresented: $showCodeOfConduct) {
            CodeOfConductSheet()
        }
    }

    // MARK: - Header

    private var profileHeader: some View {
        VStack(spacing: 12) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.wmPrimary.opacity(0.12))
                        .frame(width: 68, height: 68)
                    Text(user?.initials ?? "--")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.wmPrimary)
                }

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(user?.name ?? "")
                            .font(WMFont.heading(20))
                            .foregroundColor(.wmText)
                        if user?.isVerified == true {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(.wmSuccess)
                                .font(.system(size: 14))
                        }
                    }
                    Text("\(user?.role.rawValue ?? "") · \(user?.city ?? "")")
                        .font(.system(size: 14))
                        .foregroundColor(.wmTextSecondary)
                    if user?.isVerified == false {
                        Button { showLinkedInAlert = true } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "link").font(.system(size: 10))
                                Text("Verify with LinkedIn").font(.system(size: 12, weight: .semibold))
                            }
                            .foregroundColor(Color(wmHex: "#0077B5"))
                        }
                    }
                }

                Spacer()
            }
            .padding(.horizontal, WMSpacing.md)
            .padding(.top, WMSpacing.lg)
            .padding(.bottom, WMSpacing.md)
        }
        .background(Color.wmSurface)
    }

    // MARK: - Senior content

    private func seniorContent(_ profile: SeniorProfessionalProfile) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            statsRow(values: [
                ("\(profile.helpedCount)", "Helped"),
                (String(format: "%.1f", profile.rating), "Rating"),
                ("\(profile.yearsOfExperience)", "Yrs exp")
            ])

            listSection(title: "Current role", icon: "briefcase") {
                Text(profile.currentRole)
                    .font(WMFont.body())
                    .foregroundColor(.wmText)
            }

            listSection(title: "Can help with", icon: "lightbulb") {
                Text(profile.topicsCanHelpWith.joined(separator: ", "))
                    .font(.system(size: 14))
                    .italic()
                    .foregroundColor(.wmTextSecondary)
                    .lineSpacing(3)
            }

            listSection(title: "Career history", icon: "clock") {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(profile.pastRoles) { role in
                        pastRoleRow(role)
                    }
                }
            }

            listSection(title: "Why I mentor", icon: "quote.opening") {
                Text("\u{201C}\(profile.motivation)\u{201D}")
                    .font(.system(size: 14, design: .default))
                    .italic()
                    .foregroundColor(.wmTextSecondary)
                    .lineSpacing(4)
            }

            listSection(title: "Availability", icon: "calendar.badge.clock") {
                Text(profile.availability)
                    .font(WMFont.body())
                    .foregroundColor(.wmTextSecondary)
            }
        }
    }

    // MARK: - Young content

    private func youngContent(_ profile: YoungProfessionalProfile) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            statsRow(values: [
                ("\(appVM.currentMatches.count)", "Matches"),
                (profile.industry.rawValue, "Industry")
            ])

            listSection(title: "Career goal", icon: "target") {
                Text(profile.careerGoal)
                    .font(WMFont.body())
                    .foregroundColor(.wmTextSecondary)
                    .lineSpacing(4)
            }
        }
    }

    // MARK: - Stats row

    private func statsRow(values: [(String, String)]) -> some View {
        HStack(spacing: 0) {
            ForEach(Array(values.enumerated()), id: \.offset) { i, pair in
                if i > 0 { Divider().frame(height: 36) }
                VStack(spacing: 3) {
                    Text(pair.0)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.wmPrimary)
                    Text(pair.1)
                        .font(.system(size: 11))
                        .foregroundColor(.wmTextSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
            }
        }
        .background(Color.wmSurface)
        .padding(.vertical, 2)
    }

    // MARK: - List section

    private func listSection<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 12))
                    .foregroundColor(.wmPrimary)
                    .frame(width: 18)
                Text(title)
                    .font(WMFont.caption(12))
                    .foregroundColor(.wmTextSecondary)
                    .textCase(.uppercase)
                    .tracking(0.4)
            }
            .padding(.horizontal, WMSpacing.md)
            .padding(.top, 20)
            .padding(.bottom, 10)

            content()
                .padding(.horizontal, WMSpacing.md)
                .padding(.bottom, 16)

            Divider().background(Color.wmBorder)
        }
        .background(Color.wmSurface)
    }

    // MARK: - Past role row

    private func pastRoleRow(_ role: PastRole) -> some View {
        HStack(alignment: .top, spacing: 10) {
            VStack(spacing: 4) {
                Circle().fill(Color.wmPrimary).frame(width: 7, height: 7).padding(.top, 4)
                Rectangle().fill(Color.wmBorder).frame(width: 1.5).frame(maxHeight: .infinity)
            }
            VStack(alignment: .leading, spacing: 2) {
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

    // MARK: - Settings

    private var settingsSection: some View {
        VStack(spacing: 0) {
            Divider().background(Color.wmBorder).padding(.top, WMSpacing.md)

            settingsRow(icon: "shield.fill", title: "Code of Conduct", color: .wmSuccess) {
                showCodeOfConduct = true
            }
            Divider().padding(.leading, 50)
            settingsRow(icon: "questionmark.circle.fill", title: "Help & FAQ", color: .wmTextSecondary) {}
            Divider().padding(.leading, 50)
            settingsRow(icon: "exclamationmark.triangle.fill", title: "Report a concern", color: .wmDanger) {}
        }
        .background(Color.wmSurface)
        .padding(.bottom, WMSpacing.xxl)
    }

    private func settingsRow(icon: String, title: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 15))
                    .foregroundColor(color)
                    .frame(width: 22)
                    .padding(.leading, WMSpacing.md)
                Text(title)
                    .font(WMFont.body())
                    .foregroundColor(.wmText)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.wmTextTertiary)
                    .padding(.trailing, WMSpacing.md)
            }
            .padding(.vertical, 14)
        }
    }
}

// MARK: - Code of Conduct Sheet (inline)

struct CodeOfConductSheet: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: WMSpacing.lg) {
                    VStack(alignment: .leading, spacing: 8) {
                        Image(systemName: "shield.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.wmSuccess)
                        Text("Code of Conduct")
                            .font(WMFont.display(26))
                            .foregroundColor(.wmText)
                        Text("WisdomMatch is built on mutual respect. These guidelines keep the community safe and valuable for everyone.")
                            .font(WMFont.body())
                            .foregroundColor(.wmTextSecondary)
                            .lineSpacing(4)
                    }

                    conductSection(title: "Respect & Professionalism", items: [
                        "Treat every interaction with courtesy and professional respect.",
                        "Be on time for your coffee meetings. If you can't make it, cancel at least 24 hours in advance.",
                        "Keep conversations focused on career guidance."
                    ])

                    conductSection(title: "Safety & Privacy", items: [
                        "Never share personal contact details until you feel comfortable.",
                        "All meetings take place at partner cafés — never private locations.",
                        "Report any behaviour that makes you uncomfortable."
                    ])

                    conductSection(title: "Commitment", items: [
                        "Senior mentors commit to at least one meeting per month.",
                        "Young professionals commit to coming prepared with a clear question or goal.",
                        "Both parties agree to give honest, constructive feedback after meetings."
                    ])

                    Text("Violations may result in removal from the platform. Questions? hello@wisdommatch.nl")
                        .font(.system(size: 13))
                        .foregroundColor(.wmTextTertiary)
                        .lineSpacing(3)
                }
                .padding(WMSpacing.lg)
            }
            .background(Color.wmBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }.foregroundColor(.wmPrimary)
                }
            }
        }
    }

    private func conductSection(title: String, items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(WMFont.subheading(15))
                .foregroundColor(.wmText)
            VStack(alignment: .leading, spacing: 8) {
                ForEach(items, id: \.self) { item in
                    HStack(alignment: .top, spacing: 10) {
                        Circle().fill(Color.wmSuccess).frame(width: 6, height: 6).padding(.top, 5)
                        Text(item)
                            .font(.system(size: 14))
                            .foregroundColor(.wmTextSecondary)
                            .lineSpacing(3)
                    }
                }
            }
        }
        .padding(WMSpacing.md)
        .background(Color.wmSurface)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

#Preview {
    ProfileView().environmentObject(AppViewModel())
}
