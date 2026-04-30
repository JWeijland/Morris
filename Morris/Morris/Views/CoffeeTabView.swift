import SwiftUI

struct CoffeeTabView: View {
    @EnvironmentObject var appVM: AppViewModel
    @State private var selectedMatch: Match?
    @State private var showBooking = false

    private var matches: [Match] { appVM.currentMatches }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.wmBackground.ignoresSafeArea()

                if matches.isEmpty {
                    emptyState
                } else {
                    matchList
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Coffee")
                        .font(WMFont.heading())
                        .foregroundColor(.wmText)
                }
            }
        }
        .sheet(isPresented: $showBooking) {
            if let match = selectedMatch {
                ScheduleCoffeeView(match: match)
            }
        }
    }

    // MARK: - Match list

    private var matchList: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Banner
                HStack(spacing: 10) {
                    Image(systemName: "gift.fill")
                        .foregroundColor(.wmAccent)
                    Text("Your first coffee is on us at all partner cafés.")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.wmText)
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.wmAccent.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .padding(.horizontal, WMSpacing.md)
                .padding(.top, WMSpacing.md)
                .padding(.bottom, WMSpacing.sm)

                // Section header
                HStack {
                    Text("Plan a coffee with your matches")
                        .font(WMFont.caption())
                        .foregroundColor(.wmTextSecondary)
                        .textCase(.uppercase)
                        .tracking(0.4)
                    Spacer()
                }
                .padding(.horizontal, WMSpacing.md)
                .padding(.vertical, WMSpacing.sm)

                VStack(spacing: 8) {
                    ForEach(matches) { match in
                        coffeeMatchRow(match)
                    }
                }
                .padding(.horizontal, WMSpacing.md)
            }
        }
    }

    private func coffeeMatchRow(_ match: Match) -> some View {
        let otherUser: User? = {
            guard let me = appVM.currentUser else { return nil }
            let otherId = match.youngUserId == me.id ? match.seniorUserId : match.youngUserId
            return appVM.data.user(for: otherId)
        }()

        let otherProfile: SeniorProfessionalProfile? = {
            guard let other = otherUser else { return nil }
            return appVM.data.seniorProfile(for: other.id)
        }()

        return HStack(spacing: 14) {
            // Avatar
            ZStack {
                Circle()
                    .fill(Color.wmPrimary.opacity(0.12))
                    .frame(width: 48, height: 48)
                Text(otherUser?.initials ?? "--")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.wmPrimary)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(otherUser?.name ?? "Unknown")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.wmText)
                if let profile = otherProfile {
                    Text(profile.currentRole)
                        .font(.system(size: 13))
                        .foregroundColor(.wmTextSecondary)
                }
                if let city = otherUser?.city {
                    HStack(spacing: 3) {
                        Image(systemName: "mappin").font(.system(size: 11))
                        Text(city)
                    }
                    .font(.system(size: 12))
                    .foregroundColor(.wmTextTertiary)
                }
            }

            Spacer()

            Button {
                selectedMatch = match
                showBooking = true
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "cup.and.saucer.fill")
                    Text("Plan")
                }
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Color.wmPrimary)
                .clipShape(Capsule())
            }
        }
        .padding(14)
        .background(Color.wmSurface)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(color: .black.opacity(0.03), radius: 4, x: 0, y: 2)
    }

    // MARK: - Empty state

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "cup.and.saucer")
                .font(.system(size: 52))
                .foregroundColor(.wmBorder)
            Text("No matches yet")
                .font(WMFont.heading())
                .foregroundColor(.wmText)
            Text("Connect with a mentor in Discover.\nWhen you match, you can plan a coffee here.")
                .font(WMFont.body())
                .foregroundColor(.wmTextSecondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

#Preview {
    CoffeeTabView().environmentObject(AppViewModel())
}
