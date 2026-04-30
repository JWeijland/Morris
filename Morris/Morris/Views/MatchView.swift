import SwiftUI

struct MatchView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appVM: AppViewModel

    let seniorUser: User
    let match: Match

    @State private var animateIn = false
    @State private var showChat = false
    @State private var showCoffee = false

    private var currentUser: User? { appVM.currentUser }

    var body: some View {
        ZStack {
            Color.wmBackground.ignoresSafeArea()

            VStack(spacing: WMSpacing.xl) {
                Spacer()

                // Match icon
                ZStack {
                    Circle()
                        .fill(Color.wmPrimary.opacity(0.10))
                        .frame(width: 100, height: 100)
                    Image(systemName: "cup.and.saucer.fill")
                        .font(.system(size: 42, weight: .medium))
                        .foregroundColor(Color.wmPrimary)
                }
                .scaleEffect(animateIn ? 1 : 0.4)
                .opacity(animateIn ? 1 : 0)

                // Headline
                VStack(spacing: 10) {
                    Text("It's a match!")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.wmText)

                    Text("You and \(seniorUser.firstName) both want to connect.")
                        .font(.system(size: 16))
                        .foregroundColor(.wmTextSecondary)
                        .multilineTextAlignment(.center)

                    Text("Time to plan your first career coffee.")
                        .font(.system(size: 14))
                        .foregroundColor(.wmTextTertiary)
                        .multilineTextAlignment(.center)
                }
                .opacity(animateIn ? 1 : 0)
                .offset(y: animateIn ? 0 : 16)

                // Avatar pair
                avatarPair

                // Action buttons
                VStack(spacing: 12) {
                    WMPrimaryButton(title: "Start the conversation") {
                        showChat = true
                    }
                    WMSecondaryButton(title: "Plan your coffee") {
                        showCoffee = true
                    }
                    WMGhostButton(title: "Maybe later", action: { dismiss() }, color: .wmTextSecondary)
                }
                .padding(.horizontal, WMSpacing.lg)
                .opacity(animateIn ? 1 : 0)

                Spacer()
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.55, dampingFraction: 0.72).delay(0.15)) {
                animateIn = true
            }
        }
        .sheet(isPresented: $showChat) {
            ChatView(match: match)
        }
        .sheet(isPresented: $showCoffee) {
            ScheduleCoffeeView(match: match)
        }
    }

    private var avatarPair: some View {
        HStack(spacing: -16) {
            ZStack {
                Circle()
                    .fill(Color.wmPrimary.opacity(0.12))
                    .frame(width: 66, height: 66)
                    .overlay(Circle().stroke(Color.wmBackground, lineWidth: 3))
                Text(currentUser?.initials ?? "?")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.wmPrimary)
            }
            .zIndex(1)

            ZStack {
                Circle()
                    .fill(Color.wmAccent)
                    .frame(width: 32, height: 32)
                    .overlay(Circle().stroke(Color.wmBackground, lineWidth: 2))
                Image(systemName: "heart.fill")
                    .font(.system(size: 13))
                    .foregroundColor(.white)
            }
            .zIndex(2)

            ZStack {
                Circle()
                    .fill(Color.wmAccent.opacity(0.15))
                    .frame(width: 66, height: 66)
                    .overlay(Circle().stroke(Color.wmBackground, lineWidth: 3))
                Text(seniorUser.initials)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.wmPrimary)
            }
            .zIndex(1)
        }
        .scaleEffect(animateIn ? 1 : 0.7)
        .opacity(animateIn ? 1 : 0)
    }
}
