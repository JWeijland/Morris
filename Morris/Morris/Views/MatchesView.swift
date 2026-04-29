import SwiftUI

struct MatchesView: View {
    @EnvironmentObject var appVM: AppViewModel
    @State private var selectedMatch: Match?
    @State private var showChat = false

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
                    Text("Your Matches")
                        .font(WMFont.heading())
                        .foregroundColor(.wmText)
                }
            }
        }
        .sheet(isPresented: $showChat) {
            if let match = selectedMatch {
                ChatView(match: match)
            }
        }
    }

    private var matchList: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Section header
                HStack {
                    Text("\(matches.count) career \(matches.count == 1 ? "match" : "matches")")
                        .font(WMFont.caption())
                        .foregroundColor(.wmTextSecondary)
                        .textCase(.uppercase)
                        .tracking(0.4)
                    Spacer()
                }
                .padding(.horizontal, WMSpacing.md)
                .padding(.top, WMSpacing.md)
                .padding(.bottom, WMSpacing.sm)

                VStack(spacing: 10) {
                    ForEach(matches) { match in
                        matchRow(match)
                    }
                }
                .padding(.horizontal, WMSpacing.md)
            }
        }
    }

    private func matchRow(_ match: Match) -> some View {
        let otherUser: User? = {
            guard let me = appVM.currentUser else { return nil }
            let otherId = match.youngUserId == me.id ? match.seniorUserId : match.youngUserId
            return appVM.data.user(for: otherId)
        }()

        let lastMsg = appVM.data.messagesFor(matchId: match.id).last

        return Button {
            selectedMatch = match
            showChat = true
        } label: {
            HStack(spacing: 14) {
                // Avatar
                ZStack {
                    Circle()
                        .fill(Color.wmPrimaryLight.opacity(0.4))
                        .frame(width: 54, height: 54)
                    Text(otherUser?.initials ?? "--")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.wmPrimaryDark)
                }
                .overlay(alignment: .bottomTrailing) {
                    if lastMsg != nil && !lastMsg!.isRead {
                        Circle().fill(Color.wmPrimary).frame(width: 12, height: 12)
                            .overlay(Circle().stroke(Color.wmSurface, lineWidth: 2))
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(otherUser?.name ?? "Unknown")
                            .font(WMFont.subheading(15))
                            .foregroundColor(.wmText)
                        Spacer()
                        if let msg = lastMsg {
                            Text(msg.sentAt, style: .relative)
                                .font(.system(size: 11))
                                .foregroundColor(.wmTextTertiary)
                        }
                    }

                    // Match score badge inline
                    HStack(spacing: 6) {
                        Text("\(match.matchPercentage)% match")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.wmPrimary)
                        Text("·")
                            .foregroundColor(.wmTextTertiary)
                        Text(match.status == .coffeePlanned ? "Coffee planned ☕" : "Career coffee")
                            .font(.system(size: 11))
                            .foregroundColor(.wmTextSecondary)
                    }

                    if let msg = lastMsg, let text = msg.text {
                        Text(text)
                            .font(.system(size: 13))
                            .foregroundColor(.wmTextSecondary)
                            .lineLimit(1)
                    }
                }
            }
            .padding(14)
            .background(Color.wmSurface)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "cup.and.saucer")
                .font(.system(size: 52))
                .foregroundColor(.wmBorder)
            Text("No matches yet")
                .font(WMFont.heading())
                .foregroundColor(.wmText)
            Text("Keep swiping in Discover.\nWhen both sides show interest, you'll match here.")
                .font(WMFont.body())
                .foregroundColor(.wmTextSecondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

#Preview {
    MatchesView().environmentObject(AppViewModel())
}
