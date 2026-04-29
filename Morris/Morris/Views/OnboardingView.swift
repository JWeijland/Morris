import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appVM: AppViewModel
    // ViewModel is built in onAppear with the correct role
    @StateObject private var vm = OnboardingViewModel(role: .youngProfessional, onComplete: {})
    @State private var vmReady = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.wmBackground.ignoresSafeArea()

                VStack(spacing: 0) {
                    progressBar

                    Group {
                        switch vm.step {
                        case .roleConfirm:  roleConfirmStep
                        case .basicInfo:    basicInfoStep
                        case .industryGoal: industryGoalStep
                        case .linkedIn:     linkedInStep
                        case .done:         EmptyView()
                        }
                    }
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    .animation(.easeInOut(duration: 0.3), value: vm.step)

                    Spacer()
                    navigationButtons
                }
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if vm.step != .roleConfirm {
                        Button { vm.back() } label: {
                            Image(systemName: "chevron.left").foregroundColor(.wmPrimary)
                        }
                    }
                }
            }
        }
        .onAppear {
            // Wire the vm to the selected role + completion callback
            vm.selectedRole = appVM.selectedRole
        }
    }

    // MARK: - Progress Bar

    private var progressBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Rectangle().fill(Color.wmBorder).frame(height: 3)
                Rectangle()
                    .fill(Color.wmPrimary)
                    .frame(width: geo.size.width * vm.progressFraction, height: 3)
                    .animation(.easeInOut, value: vm.progressFraction)
            }
        }
        .frame(height: 3)
    }

    // MARK: - Steps

    private var roleConfirmStep: some View {
        VStack(alignment: .leading, spacing: WMSpacing.lg) {
            stepHeader(
                icon: appVM.isYoungUser ? "person.fill.questionmark" : "lightbulb.fill",
                title: appVM.isYoungUser ? "You're looking for guidance" : "You want to share wisdom",
                subtitle: appVM.isYoungUser
                    ? "Let's set up your profile so we can find the right mentor for you."
                    : "Let's set up your profile so young professionals can find you."
            )
            VStack(alignment: .leading, spacing: 12) {
                Text("What you'll get:")
                    .font(WMFont.subheading())
                    .foregroundColor(.wmText)
                ForEach(appVM.isYoungUser ? youngBenefits : seniorBenefits, id: \.self) { benefit in
                    HStack(spacing: 10) {
                        Image(systemName: "checkmark.circle.fill").foregroundColor(.wmSuccess)
                        Text(benefit).font(WMFont.body()).foregroundColor(.wmTextSecondary)
                    }
                }
            }
            .wmCard(cornerRadius: 14, padding: 16)
        }
        .padding(WMSpacing.lg)
    }

    private var youngBenefits: [String] {
        ["Matched with senior professionals in your field",
         "Structured career conversations",
         "First coffee on us — at a partner café",
         "No awkward cold messages — both sides opt in"]
    }

    private var seniorBenefits: [String] {
        ["Help the next generation succeed",
         "Flexible — on your schedule",
         "Meet interesting young talent",
         "Build your legacy, one coffee at a time"]
    }

    private var basicInfoStep: some View {
        VStack(alignment: .leading, spacing: WMSpacing.lg) {
            stepHeader(icon: "person.circle", title: "Tell us about yourself", subtitle: "Basic info to personalise your experience.")
            VStack(spacing: 14) {
                WMTextField(placeholder: "Your full name", text: $vm.name, icon: "person")
                WMTextField(placeholder: "City (e.g. Amsterdam)", text: $vm.city, icon: "mappin")
                WMTextField(placeholder: "Your age", text: $vm.age, icon: "calendar", keyboardType: .numberPad)
            }
        }
        .padding(WMSpacing.lg)
    }

    private var industryGoalStep: some View {
        VStack(alignment: .leading, spacing: WMSpacing.lg) {
            stepHeader(
                icon: "chart.bar",
                title: appVM.isYoungUser ? "Your industry & goals" : "Your expertise",
                subtitle: appVM.isYoungUser ? "What field are you targeting?" : "Where can you add the most value?"
            )
            VStack(spacing: 14) {
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
                    .padding(12)
                    .background(Color.wmSurface)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.wmBorder, lineWidth: 1))
                }
                WMTextArea(
                    placeholder: appVM.isYoungUser ? "What is your main career goal?" : "What motivates you to mentor?",
                    text: appVM.isYoungUser ? $vm.careerGoal : $vm.motivation
                )
            }
        }
        .padding(WMSpacing.lg)
    }

    private var linkedInStep: some View {
        VStack(alignment: .leading, spacing: WMSpacing.lg) {
            stepHeader(icon: "link.circle", title: "Connect LinkedIn", subtitle: "Optional — but it builds trust and speeds up matching.")
            VStack(spacing: 16) {
                HStack(spacing: 12) {
                    Image(systemName: "link.badge.plus")
                        .font(.system(size: 28))
                        .foregroundColor(Color(wmHex: "#0077B5"))
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Import from LinkedIn")
                            .font(WMFont.subheading())
                            .foregroundColor(.wmText)
                        Text("Auto-fill your profile in seconds")
                            .font(WMFont.body(13))
                            .foregroundColor(.wmTextSecondary)
                    }
                    Spacer()
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(Color(wmHex: "#0077B5"))
                }
                .padding(16)
                .wmCard(cornerRadius: 14)
                .onTapGesture { vm.showLinkedInImportAlert = true }

                Text("or").font(WMFont.body(13)).foregroundColor(.wmTextTertiary)
                WMTextField(placeholder: "Paste your LinkedIn URL", text: $vm.linkedInPlaceholder, icon: "link")
            }
            HStack(spacing: 8) {
                Image(systemName: "lock.shield.fill").foregroundColor(.wmSuccess)
                Text("Your data is never shared without your consent.")
                    .font(.system(size: 12))
                    .foregroundColor(.wmTextTertiary)
            }
        }
        .padding(WMSpacing.lg)
        .alert("LinkedIn Import", isPresented: $vm.showLinkedInImportAlert) {
            Button("OK") {}
        } message: {
            // TODO: Integrate LinkedIn OAuth SDK
            Text("LinkedIn import will be available in the next release. For now, paste your profile URL below.")
        }
    }

    private var navigationButtons: some View {
        VStack(spacing: 12) {
            WMPrimaryButton(title: vm.step == .linkedIn ? "Finish & start matching" : "Continue") {
                if vm.step == .linkedIn {
                    appVM.completeOnboarding()
                } else {
                    vm.advance()
                }
            }
            .disabled(!vm.canAdvance)
            .opacity(vm.canAdvance ? 1 : 0.5)

            if vm.step == .linkedIn {
                Button { appVM.completeOnboarding() } label: {
                    Text("Skip for now")
                        .font(WMFont.body(14))
                        .foregroundColor(.wmTextSecondary)
                        .underline()
                }
            }
        }
        .padding(WMSpacing.lg)
    }

    private func stepHeader(icon: String, title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon).font(.system(size: 32)).foregroundColor(.wmPrimary)
            Text(title).font(WMFont.display(26)).foregroundColor(.wmText)
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
                .foregroundColor(.wmText)
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
