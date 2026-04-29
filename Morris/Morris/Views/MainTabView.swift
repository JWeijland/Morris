import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appVM: AppViewModel
    @State private var selectedTab: Int = 0
    @State private var showCompany = false

    var body: some View {
        TabView(selection: $selectedTab) {

            // MARK: - Tab 1: Discover
            SwipeDiscoveryView(appViewModel: appVM)
                .tabItem {
                    Label("Discover", systemImage: "rectangle.stack.fill")
                }
                .tag(0)

            // MARK: - Tab 2: Matches / Chat
            MatchesView()
                .tabItem {
                    Label("Matches", systemImage: "bubble.left.and.bubble.right.fill")
                }
                .badge(unreadCount)
                .tag(1)

            // MARK: - Tab 3: Profile
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle.fill")
                }
                .tag(2)
        }
        .tint(Color.wmPrimary)
        .sheet(isPresented: $appVM.showMatchSheet) {
            if let match = appVM.pendingMatch, let user = appVM.pendingMatchUser {
                MatchView(seniorUser: user, match: match)
            }
        }
    }

    private var unreadCount: Int {
        let allMessages = appVM.currentMatches.flatMap { appVM.data.messagesFor(matchId: $0.id) }
        return allMessages.filter { !$0.isRead && $0.senderId != appVM.currentUser?.id }.count
    }
}

#Preview {
    MainTabView().environmentObject(AppViewModel())
}
