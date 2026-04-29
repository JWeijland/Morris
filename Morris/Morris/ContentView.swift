import SwiftUI

// Root coordinator — switches between app states
struct ContentView: View {
    @EnvironmentObject var appVM: AppViewModel

    var body: some View {
        Group {
            switch appVM.appState {
            case .welcome:
                WelcomeView()
                    .transition(.opacity)
            case .onboarding:
                OnboardingView()
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            case .main:
                MainTabView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.35), value: appVM.appState)
    }
}

#Preview {
    ContentView().environmentObject(AppViewModel())
}
