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
                    Text("Chats")
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
        List {
            ForEach(matches) { match in
                matchRow(match)
                    .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                    .listRowBackground(Color.wmBackground)
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .padding(.top, 4)
    }

    private func matchRow(_ match: Match) -> some View {
        let otherUser: User? = {
            guard let me = appVM.currentUser else { return nil }
            let otherId = match.youngUserId == me.id ? match.seniorUserId : match.youngUserId
            return appVM.data.user(for: otherId)
        }()

        let messages = appVM.data.messagesFor(matchId: match.id)
        let lastMsg = messages.last
        let hasUnread = messages.contains { !$0.isRead && $0.senderId != appVM.currentUser?.id }

        return Button {
            selectedMatch = match
            showChat = true
        } label: {
            HStack(spacing: 0) {
                // Unread indicator bar
                Rectangle()
                    .fill(hasUnread ? Color.wmAccent : Color.clear)
                    .frame(width: 3)
                    .clipShape(RoundedRectangle(cornerRadius: 2))

                HStack(spacing: 12) {
                    // Avatar
                    ZStack {
                        Circle()
                            .fill(Color.wmPrimary.opacity(0.12))
                            .frame(width: 50, height: 50)
                        Text(otherUser?.initials ?? "--")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.wmPrimary)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(otherUser?.name ?? "Unknown")
                                .font(WMFont.subheading(15))
                                .foregroundColor(.wmText)
                                .fontWeight(hasUnread ? .semibold : .medium)
                            Spacer()
                            if let msg = lastMsg {
                                Text(msg.sentAt, style: .relative)
                                    .font(.system(size: 11))
                                    .foregroundColor(.wmTextTertiary)
                            }
                        }

                        if let msg = lastMsg, let text = msg.text {
                            Text(text)
                                .font(.system(size: 13))
                                .foregroundColor(hasUnread ? .wmTextSecondary : .wmTextTertiary)
                                .fontWeight(hasUnread ? .medium : .regular)
                                .lineLimit(1)
                        } else {
                            Text("Career coffee match — say hello!")
                                .font(.system(size: 13))
                                .foregroundColor(.wmTextTertiary)
                                .lineLimit(1)
                        }
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 14)
            }
            .background(Color.wmSurface)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .shadow(color: .black.opacity(0.03), radius: 4, x: 0, y: 2)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "bubble.left.and.bubble.right")
                .font(.system(size: 52))
                .foregroundColor(.wmBorder)
            Text("No conversations yet")
                .font(WMFont.heading())
                .foregroundColor(.wmText)
            Text("Connect with a mentor in Discover.\nYour conversations will appear here.")
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
