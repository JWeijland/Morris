import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var appVM: AppViewModel
    @State private var animateIn = false
    @State private var showCompanySheet = false

    var body: some View {
        ZStack {
            Color.wmBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Logo + headline
                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(Color.wmPrimary)
                            .frame(width: 80, height: 80)
                            .shadow(color: Color.wmPrimary.opacity(0.3), radius: 16, x: 0, y: 8)
                        Image(systemName: "cup.and.saucer.fill")
                            .font(.system(size: 32, weight: .medium))
                            .foregroundColor(.white)
                    }
                    .scaleEffect(animateIn ? 1 : 0.7)
                    .opacity(animateIn ? 1 : 0)

                    VStack(spacing: 8) {
                        Text("WisdomMatch")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(.wmText)
                        Text("Career wisdom, shared over coffee.")
                            .font(.system(size: 16))
                            .foregroundColor(.wmTextSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .opacity(animateIn ? 1 : 0)
                    .offset(y: animateIn ? 0 : 16)
                }

                Spacer()

                // Role cards
                VStack(spacing: 12) {
                    roleCard(
                        icon: "person.fill.questionmark",
                        title: "I'm looking for guidance",
                        subtitle: "Student or early-career professional",
                        isPrimary: true
                    ) {
                        appVM.selectRole(.youngProfessional)
                    }

                    roleCard(
                        icon: "lightbulb.fill",
                        title: "I want to share experience",
                        subtitle: "Senior professional or retiree",
                        isPrimary: false
                    ) {
                        appVM.selectRole(.seniorProfessional)
                    }

                    Button { showCompanySheet = true } label: {
                        Text("For teams & companies")
                            .font(.system(size: 14))
                            .foregroundColor(.wmTextSecondary)
                            .underline()
                    }
                    .padding(.top, 4)
                }
                .padding(.horizontal, WMSpacing.lg)
                .opacity(animateIn ? 1 : 0)
                .offset(y: animateIn ? 0 : 24)

                Spacer().frame(height: WMSpacing.xxl)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.75).delay(0.15)) {
                animateIn = true
            }
        }
        .sheet(isPresented: $showCompanySheet) {
            CompanyInfoSheet()
        }
    }

    private func roleCard(icon: String, title: String, subtitle: String, isPrimary: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .frame(width: 28)
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                    Text(subtitle)
                        .font(.system(size: 13))
                        .opacity(0.75)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .opacity(0.6)
            }
            .foregroundColor(isPrimary ? .white : .wmPrimary)
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
            .background(isPrimary ? Color.wmPrimary : Color.wmSurface)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(isPrimary ? Color.clear : Color.wmBorder, lineWidth: 1.5)
            )
            .shadow(color: isPrimary ? Color.wmPrimary.opacity(0.25) : Color.black.opacity(0.04), radius: 10, x: 0, y: 4)
        }
    }
}

// MARK: - Company info sheet (inline)

struct CompanyInfoSheet: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: WMSpacing.lg) {
                    VStack(alignment: .leading, spacing: 8) {
                        Image(systemName: "building.2.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.wmPrimary)
                        Text("WisdomMatch for Teams")
                            .font(WMFont.display(26))
                            .foregroundColor(.wmText)
                        Text("Give your employees access to senior mentors across every industry.")
                            .font(WMFont.body())
                            .foregroundColor(.wmTextSecondary)
                            .lineSpacing(4)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        featureRow(icon: "person.2.fill", text: "Bulk onboarding for your entire team")
                        featureRow(icon: "chart.bar.fill", text: "Track engagement and mentoring outcomes")
                        featureRow(icon: "shield.fill", text: "Enterprise-grade privacy and moderation")
                        featureRow(icon: "cup.and.saucer.fill", text: "Coffee vouchers covered for all meetings")
                    }
                    .padding(WMSpacing.md)
                    .background(Color.wmBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                    Text("Enterprise plans start at €299/month. Contact us at hello@wisdommatch.nl to get started.")
                        .font(.system(size: 14))
                        .foregroundColor(.wmTextSecondary)
                        .lineSpacing(4)
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

    private func featureRow(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(.wmPrimary)
                .frame(width: 20)
            Text(text)
                .font(WMFont.body(14))
                .foregroundColor(.wmText)
        }
    }
}

#Preview {
    WelcomeView().environmentObject(AppViewModel())
}
