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
            // Warm gradient
            LinearGradient(
                colors: [Color(wmHex: "#FDF6EC"), Color(wmHex: "#F5E6D3"), Color(wmHex: "#EDD5B8")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Confetti-like dots
            confettiLayer

            VStack(spacing: WMSpacing.xl) {
                Spacer()

                // Match icon
                ZStack {
                    Circle()
                        .fill(Color.wmPrimary.opacity(0.12))
                        .frame(width: 110, height: 110)
                    Image(systemName: "cup.and.saucer.fill")
                        .font(.system(size: 46, weight: .medium))
                        .foregroundColor(Color.wmPrimary)
                }
                .scaleEffect(animateIn ? 1 : 0.3)
                .opacity(animateIn ? 1 : 0)

                // Headline
                VStack(spacing: 10) {
                    Text("It's a career match!")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(Color.wmPrimaryDark)

                    Text("You and \(seniorUser.firstName) are a \(match.matchPercentage)% match")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.wmTextSecondary)
                        .multilineTextAlignment(.center)

                    Text("Both of you showed interest in a career coffee.\nTime to make it happen.")
                        .font(.system(size: 14))
                        .foregroundColor(.wmTextSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                .opacity(animateIn ? 1 : 0)
                .offset(y: animateIn ? 0 : 20)

                // Avatar pair
                avatarPair

                // Action buttons
                VStack(spacing: 12) {
                    WMPrimaryButton(title: "Start the conversation") {
                        showChat = true
                    }
                    WMSecondaryButton(title: "Plan your coffee meeting") {
                        showCoffee = true
                    }
                    Button {
                        dismiss()
                    } label: {
                        Text("Maybe later")
                            .font(WMFont.body(14))
                            .foregroundColor(.wmTextSecondary)
                            .underline()
                    }
                }
                .padding(.horizontal, WMSpacing.lg)
                .opacity(animateIn ? 1 : 0)

                Spacer()
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2)) {
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
        HStack(spacing: -20) {
            // Young user
            ZStack {
                Circle()
                    .fill(Color(wmHex: "#D4E8F0"))
                    .frame(width: 70, height: 70)
                    .overlay(Circle().stroke(Color.white, lineWidth: 3))
                Text(currentUser?.initials ?? "?")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(Color(wmHex: "#2B6CB0"))
            }
            .zIndex(1)

            // Coffee icon bridge
            ZStack {
                Circle()
                    .fill(Color.wmPrimary)
                    .frame(width: 36, height: 36)
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                Image(systemName: "heart.fill")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
            }
            .zIndex(2)

            // Senior user
            ZStack {
                Circle()
                    .fill(Color.wmPrimaryLight.opacity(0.5))
                    .frame(width: 70, height: 70)
                    .overlay(Circle().stroke(Color.white, lineWidth: 3))
                Text(seniorUser.initials)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(Color.wmPrimaryDark)
            }
            .zIndex(1)
        }
        .scaleEffect(animateIn ? 1 : 0.7)
        .opacity(animateIn ? 1 : 0)
    }

    private var confettiLayer: some View {
        ZStack {
            ForEach(0..<12, id: \.self) { i in
                Circle()
                    .fill(confettiColor(i).opacity(0.6))
                    .frame(width: CGFloat.random(in: 8...18), height: CGFloat.random(in: 8...18))
                    .offset(
                        x: CGFloat.random(in: -180...180),
                        y: CGFloat.random(in: -350...350)
                    )
                    .opacity(animateIn ? 0.7 : 0)
                    .scaleEffect(animateIn ? 1 : 0)
                    .animation(.easeOut(duration: 0.6).delay(Double(i) * 0.04), value: animateIn)
            }
        }
    }

    private func confettiColor(_ index: Int) -> Color {
        let colors: [Color] = [.wmPrimary, .wmGold, .wmSuccess, Color(wmHex: "#F59E0B"), Color(wmHex: "#8B5CF6")]
        return colors[index % colors.count]
    }
}
