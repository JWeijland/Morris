import SwiftUI

struct CodeOfConductView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var agreed = false
    @State private var showAgreement = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.wmBackground.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: WMSpacing.lg) {

                        // Header
                        VStack(alignment: .leading, spacing: 8) {
                            Image(systemName: "shield.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.wmSuccess)
                            Text("Code of Conduct")
                                .font(WMFont.display(24))
                                .foregroundColor(.wmText)
                            Text("WisdomMatch is built on mutual respect, trust, and the genuine desire to help. These principles are non-negotiable.")
                                .font(WMFont.body())
                                .foregroundColor(.wmTextSecondary)
                                .lineSpacing(4)
                        }

                        // Principles
                        VStack(spacing: 10) {
                            conductCard(
                                icon: "heart.circle.fill",
                                title: "Meet with good intentions",
                                body: "Every coffee is a professional meeting — not a networking pitch, not a sales call, not a date. Come with the intention to genuinely help or learn.",
                                color: .wmPrimary
                            )
                            conductCard(
                                icon: "person.fill.checkmark",
                                title: "Be who you say you are",
                                body: "Your profile must be truthful. Don't embellish your title, companies, or experience. The other person is trusting you with their career.",
                                color: Color(wmHex: "#6366F1")
                            )
                            conductCard(
                                icon: "lock.fill",
                                title: "Keep it confidential",
                                body: "What's shared in a career conversation stays there. Don't share personal details, career struggles, or plans without explicit permission.",
                                color: Color(wmHex: "#10B981")
                            )
                            conductCard(
                                icon: "clock.fill",
                                title: "Respect time commitments",
                                body: "If you've scheduled a coffee, show up — or cancel at least 24 hours in advance. Reliability is the foundation of a good mentor relationship.",
                                color: Color(wmHex: "#F59E0B")
                            )
                            conductCard(
                                icon: "hand.raised.fill",
                                title: "Zero tolerance",
                                body: "Romantic advances, harassment, discrimination, or any behaviour that makes the other person uncomfortable will result in immediate removal from the platform.",
                                color: .wmDanger
                            )
                            conductCard(
                                icon: "arrow.up.forward.circle.fill",
                                title: "No selling or recruiting",
                                body: "This is not a recruitment platform. Do not use meetings to hire, pitch services, or collect leads. Focus on genuine career guidance.",
                                color: Color(wmHex: "#8B5CF6")
                            )
                        }

                        // Reporting
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Something wrong?", systemImage: "exclamationmark.triangle.fill")
                                .font(WMFont.subheading(15))
                                .foregroundColor(.wmDanger)
                            Text("If another user violates this code, report them immediately via the chat menu or the report button on their profile. We take every report seriously and respond within 24 hours.")
                                .font(WMFont.body(14))
                                .foregroundColor(.wmTextSecondary)
                                .lineSpacing(4)
                        }
                        .padding(WMSpacing.md)
                        .background(Color.wmDanger.opacity(0.06))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                        // Agreement button
                        if !agreed {
                            WMPrimaryButton(title: "I agree to this Code of Conduct") {
                                agreed = true
                                showAgreement = true
                            }
                        } else {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.wmSuccess)
                                Text("You've agreed to our Code of Conduct")
                                    .font(WMFont.body(14))
                                    .foregroundColor(.wmTextSecondary)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.wmSuccess.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }

                        Text("Last updated: April 2026 · WisdomMatch B.V.")
                            .font(.system(size: 11))
                            .foregroundColor(.wmTextTertiary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.bottom, WMSpacing.xl)
                    }
                    .padding(WMSpacing.lg)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") { dismiss() }.foregroundColor(.wmPrimary)
                }
            }
            .alert("Thank you", isPresented: $showAgreement) {
                Button("Continue") {}
            } message: {
                Text("Your agreement has been recorded. Enjoy your career coffees — with integrity.")
            }
        }
    }

    private func conductCard(icon: String, title: String, body: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(color.opacity(0.12))
                    .frame(width: 44, height: 44)
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(color)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(WMFont.subheading(14))
                    .foregroundColor(.wmText)
                Text(body)
                    .font(WMFont.body(13))
                    .foregroundColor(.wmTextSecondary)
                    .lineSpacing(3)
            }
        }
        .padding(WMSpacing.md)
        .wmCard(cornerRadius: 14)
    }
}

#Preview {
    CodeOfConductView()
}
