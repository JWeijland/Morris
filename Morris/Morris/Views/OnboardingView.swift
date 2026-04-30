import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appVM: AppViewModel
    @StateObject private var vm = OnboardingViewModel(role: .youngProfessional)

    var body: some View {
        NavigationStack {
            ZStack {
                Color.wmBackground.ignoresSafeArea()

                VStack(spacing: 0) {
                    progressBar

                    Group {
                        switch vm.step {
                        case .basics:  basicsStep
                        case .goal:    goalStep
                        case .preview: previewStep
                        case .done:    EmptyView()
                        }
                    }
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
                    .animation(.easeInOut(duration: 0.28), value: vm.step)

                    Spacer()
                    navigationButtons
                }
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if vm.step != .basics {
                        Button { vm.back() } label: {
                            Image(systemName: "chevron.left").foregroundColor(.wmPrimary)
                        }
                    }
                }
            }
        }
        .onAppear {
            vm.selectedRole = appVM.selectedRole
        }
    }

    // MARK: - Progress bar

    private var progressBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Rectangle().fill(Color.wmBorder).frame(height: 2)
                Rectangle()
                    .fill(Color.wmPrimary)
                    .frame(width: geo.size.width * vm.progressFraction, height: 2)
                    .animation(.easeInOut, value: vm.progressFraction)
            }
        }
        .frame(height: 2)
    }

    // MARK: - Steps

    private var basicsStep: some View {
        VStack(alignment: .leading, spacing: WMSpacing.lg) {
            stepHeader(
                icon: "person.circle",
                title: "Tell us the basics",
                subtitle: "Just a few details to get you started."
            )
            VStack(spacing: 14) {
                WMTextField(placeholder: "Your first name", text: $vm.name, icon: "person")

                VStack(alignment: .leading, spacing: 6) {
                    Text("Industry")
                        .font(WMFont.caption())
                        .foregroundColor(.wmTextSecondary)
                        .textCase(.uppercase)
                    Picker("Industry", selection: $vm.selectedIndustry) {
                        ForEach(Industry.allCases) { industry in
                            Text(industry.rawValue).tag(industry)
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(.wmPrimary)
                    .padding(14)
                    .background(Color.wmSurface)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.wmBorder, lineWidth: 1))
                }
            }
        }
        .padding(WMSpacing.lg)
    }

    private var goalStep: some View {
        VStack(alignment: .leading, spacing: WMSpacing.lg) {
            stepHeader(
                icon: appVM.isYoungUser ? "target" : "lightbulb",
                title: appVM.isYoungUser ? "What are you working toward?" : "What can you help with?",
                subtitle: appVM.isYoungUser
                    ? "Describe your main career goal or the question you want help with."
                    : "What expertise and experience do you bring to the table?"
            )
            WMTextArea(
                placeholder: appVM.isYoungUser
                    ? "e.g. \"I want to break into investment banking after my MSc...\""
                    : "e.g. \"I spent 20 years in consulting and can help with...\""  ,
                text: $vm.goal
            )
        }
        .padding(WMSpacing.lg)
    }

    private var previewStep: some View {
        VStack(alignment: .leading, spacing: WMSpacing.lg) {
            stepHeader(
                icon: "cup.and.saucer.fill",
                title: "Here are your first matches",
                subtitle: appVM.isYoungUser
                    ? "Senior professionals ready to meet you for coffee."
                    : "Young professionals who could use your guidance."
            )
            VStack(spacing: 10) {
                ForEach(previewProfiles.prefix(3), id: \.id) { card in
                    miniMentorCard(card)
                }
            }
        }
        .padding(WMSpacing.lg)
    }

    private var previewProfiles: [DiscoveryCard] {
        let data = MockDataService.shared
        return data.seniorProfiles.prefix(3).compactMap { sp in
            guard let su = data.seniorUsers.first(where: { $0.id == sp.userId }) else { return nil }
            let result = MatchingService.MatchResult(score: 0.85, breakdown: [:])
            return DiscoveryCard(id: sp.id, seniorProfile: sp, seniorUser: su, matchResult: result, badges: [])
        }
    }

    private func miniMentorCard(_ card: DiscoveryCard) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle().fill(Color.wmPrimary.opacity(0.12)).frame(width: 44, height: 44)
                Text(card.seniorUser.initials)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.wmPrimary)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(card.seniorUser.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.wmText)
                Text(card.seniorProfile.currentRole)
                    .font(.system(size: 12))
                    .foregroundColor(.wmTextSecondary)
                Text(card.seniorProfile.topicsCanHelpWith.prefix(2).joined(separator: " · "))
                    .font(.system(size: 11))
                    .foregroundColor(.wmTextTertiary)
                    .lineLimit(1)
            }
            Spacer()
            Image(systemName: "cup.and.saucer")
                .font(.system(size: 14))
                .foregroundColor(.wmAccent)
        }
        .padding(14)
        .background(Color.wmSurface)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.wmBorder, lineWidth: 1))
    }

    // MARK: - Navigation buttons

    private var navigationButtons: some View {
        VStack(spacing: 12) {
            WMPrimaryButton(title: vm.step == .preview ? "Get started" : "Continue") {
                if vm.step == .preview {
                    appVM.completeOnboarding()
                } else {
                    vm.advance()
                }
            }
            .disabled(!vm.canAdvance)
            .opacity(vm.canAdvance ? 1 : 0.4)
        }
        .padding(WMSpacing.lg)
    }

    private func stepHeader(icon: String, title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon).font(.system(size: 30)).foregroundColor(.wmPrimary)
            Text(title).font(WMFont.display(24)).foregroundColor(.wmText)
            Text(subtitle).font(WMFont.body()).foregroundColor(.wmTextSecondary).lineSpacing(4)
        }
    }
}

// MARK: - Reusable field components

struct WMTextField: View {
    var placeholder: String
    @Binding var text: String
    var icon: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon).font(.system(size: 15)).foregroundColor(.wmPrimary).frame(width: 22)
            TextField(placeholder, text: $text)
                .font(WMFont.body())
                .foregroundColor(Color.wmText)
                .tint(Color.wmPrimary)
                .keyboardType(keyboardType)
        }
        .padding(14)
        .background(Color.wmSurface)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.wmBorder, lineWidth: 1))
    }
}

struct WMTextArea: View {
    var placeholder: String
    @Binding var text: String
    var minHeight: CGFloat = 100

    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .font(WMFont.body())
                    .foregroundColor(.wmTextTertiary)
                    .padding(14)
                    .allowsHitTesting(false)
            }
            TextEditor(text: $text)
                .font(WMFont.body())
                .foregroundColor(Color.wmText)
                .tint(Color.wmPrimary)
                .padding(10)
                .frame(minHeight: minHeight)
                .scrollContentBackground(.hidden)
        }
        .background(Color.wmSurface)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.wmBorder, lineWidth: 1))
    }
}

#Preview {
    OnboardingView().environmentObject(AppViewModel())
}
