import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appVM: AppViewModel
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {

            SwipeDiscoveryView(appViewModel: appVM)
                .tabItem { Label("Discover", systemImage: "rectangle.stack.fill") }
                .tag(0)

            MatchesView()
                .tabItem { Label("Chats", systemImage: "bubble.left.and.bubble.right.fill") }
                .badge(unreadCount)
                .tag(1)

            CoffeeTabView()
                .tabItem { Label("Coffee", systemImage: "cup.and.saucer.fill") }
                .tag(2)

            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.circle.fill") }
                .tag(3)
        }
        .tint(Color.wmPrimary)
    }

    private var unreadCount: Int {
        let allMessages = appVM.currentMatches.flatMap { appVM.data.messagesFor(matchId: $0.id) }
        return allMessages.filter { !$0.isRead && $0.senderId != appVM.currentUser?.id }.count
    }
}

#Preview {
    MainTabView().environmentObject(AppViewModel())
}
