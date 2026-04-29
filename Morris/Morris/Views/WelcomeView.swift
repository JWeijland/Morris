import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var appVM: AppViewModel
    @State private var animateIn = false

    var body: some View {
        ZStack {
            // Warm gradient background
            LinearGradient(
                colors: [Color(wmHex: "#FDF6EC"), Color(wmHex: "#FAF0E1"), Color(wmHex: "#F5E6D3")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Decorative circles
            decorativeCircles

            VStack(spacing: 0) {
                Spacer()

                // Logo area
                VStack(spacing: 16) {
                    logoIcon
                        .scaleEffect(animateIn ? 1 : 0.6)
                        .opacity(animateIn ? 1 : 0)

                    VStack(spacing: 8) {
                        Text("WisdomMatch")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(Color.wmPrimaryDark)

                        Text("Career wisdom, shared over coffee.")
                            .font(.system(size: 17, weight: .regular, design: .default))
                            .foregroundColor(Color.wmTextSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .opacity(animateIn ? 1 : 0)
                    .offset(y: animateIn ? 0 : 20)
                }

                Spacer()

                // CTA buttons
                VStack(spacing: 12) {
                    Button {
                        appVM.selectRole(.youngProfessional)
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "person.fill.questionmark")
                                .font(.system(size: 18))
                            VStack(alignment: .leading, spacing: 2) {
                                Text("I'm looking for guidance")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Student or early-career professional")
                                    .font(.system(size: 12))
                                    .opacity(0.8)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 13, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(Color.wmPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: Color.wmPrimary.opacity(0.35), radius: 12, x: 0, y: 6)
                    }

                    Button {
                        appVM.selectRole(.seniorProfessional)
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "lightbulb.fill")
                                .font(.system(size: 18))
                            VStack(alignment: .leading, spacing: 2) {
                                Text("I want to share experience")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Senior professional or retiree")
                                    .font(.system(size: 12))
                                    .opacity(0.8)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 13, weight: .semibold))
                        }
                        .foregroundColor(Color.wmPrimaryDark)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(Color.wmPrimaryLight.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(Color.wmPrimary.opacity(0.35), lineWidth: 1.5)
                        )
                    }

                    Button {
                        appVM.selectRole(.company)
                    } label: {
                        Text("We're a company — learn more")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.wmTextSecondary)
                            .underline()
                    }
                    .padding(.top, 4)
                }
                .padding(.horizontal, WMSpacing.lg)
                .opacity(animateIn ? 1 : 0)
                .offset(y: animateIn ? 0 : 30)

                // Social proof
                VStack(spacing: 6) {
                    HStack(spacing: 4) {
                        ForEach(0..<5, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .font(.system(size: 11))
                                .foregroundColor(Color.wmGold)
                        }
                    }
                    Text("Trusted by 1,200+ professionals across the Netherlands")
                        .font(.system(size: 12))
                        .foregroundColor(.wmTextTertiary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 24)
                .padding(.bottom, 48)
                .opacity(animateIn ? 1 : 0)
            }
            .padding(.horizontal, WMSpacing.md)
        }
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.75).delay(0.2)) {
                animateIn = true
            }
        }
    }

    private var logoIcon: some View {
        ZStack {
            Circle()
                .fill(LinearGradient(colors: [Color.wmPrimary, Color.wmPrimaryDark], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 88, height: 88)
                .shadow(color: Color.wmPrimary.opacity(0.4), radius: 20, x: 0, y: 10)
            Image(systemName: "cup.and.saucer.fill")
                .font(.system(size: 36, weight: .medium))
                .foregroundColor(.white)
        }
    }

    private var decorativeCircles: some View {
        ZStack {
            Circle()
                .fill(Color.wmPrimary.opacity(0.07))
                .frame(width: 320, height: 320)
                .offset(x: 150, y: -200)
            Circle()
                .fill(Color.wmPrimaryLight.opacity(0.12))
                .frame(width: 240, height: 240)
                .offset(x: -130, y: 280)
        }
    }
}

#Preview {
    WelcomeView().environmentObject(AppViewModel())
}
