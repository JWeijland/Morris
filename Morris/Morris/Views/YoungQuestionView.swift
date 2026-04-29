import SwiftUI

struct YoungQuestionView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appVM: AppViewModel

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var selectedIndustry: Industry = .finance
    @State private var preferredBackground: String = ""
    @State private var tags: String = ""
    @State private var submitted = false

    private var existingQuestion: CareerQuestion? { appVM.currentQuestion }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.wmBackground.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: WMSpacing.lg) {
                        // Header
                        VStack(alignment: .leading, spacing: 6) {
                            Image(systemName: "questionmark.bubble.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.wmPrimary)
                            Text(existingQuestion != nil ? "Update your question" : "Post your career question")
                                .font(WMFont.display(24))
                                .foregroundColor(.wmText)
                            Text("Be specific — a great question attracts the right mentor.")
                                .font(WMFont.body())
                                .foregroundColor(.wmTextSecondary)
                        }

                        // Question title
                        fieldGroup(label: "Your question", icon: "text.bubble") {
                            WMTextField(placeholder: "e.g. How do I break into consulting?", text: $title, icon: "text.cursor")
                        }

                        // Description
                        fieldGroup(label: "Tell us more", icon: "doc.text") {
                            WMTextArea(placeholder: "Give context: your background, what you've tried, what specifically you need help with...", text: $description, minHeight: 120)
                        }

                        // Industry
                        fieldGroup(label: "Industry", icon: "briefcase") {
                            Picker("Industry", selection: $selectedIndustry) {
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

                        // Preferred background
                        fieldGroup(label: "Preferred mentor background", icon: "person.badge.shield.checkmark") {
                            WMTextField(placeholder: "e.g. M&A lawyer, CFO, ex-McKinsey", text: $preferredBackground, icon: "person.fill")
                        }

                        // Submit
                        WMPrimaryButton(title: existingQuestion != nil ? "Update question" : "Post question") {
                            submitted = true
                        }
                        .disabled(title.isEmpty || description.isEmpty)
                        .opacity(title.isEmpty || description.isEmpty ? 0.5 : 1)

                        // Note
                        HStack(spacing: 6) {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 11))
                                .foregroundColor(.wmTextTertiary)
                            Text("Only visible to senior professionals you're matched with.")
                                .font(.system(size: 12))
                                .foregroundColor(.wmTextTertiary)
                        }
                    }
                    .padding(WMSpacing.lg)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.wmPrimary)
                }
            }
            .alert("Question posted!", isPresented: $submitted) {
                Button("Great") { dismiss() }
            } message: {
                // TODO: Send question to backend API
                Text("We'll now surface your question to matching senior professionals. Expect your first match within 24 hours.")
            }
            .onAppear { prefillIfEditing() }
        }
    }

    private func prefillIfEditing() {
        if let q = existingQuestion {
            title = q.title
            description = q.description
            selectedIndustry = q.industry
            preferredBackground = q.preferredBackground.joined(separator: ", ")
        }
    }

    @ViewBuilder
    private func fieldGroup<Content: View>(label: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.wmPrimary)
                Text(label)
                    .font(WMFont.caption(11))
                    .foregroundColor(.wmTextSecondary)
                    .textCase(.uppercase)
                    .tracking(0.4)
            }
            content()
        }
    }
}

#Preview {
    YoungQuestionView().environmentObject(AppViewModel())
}
