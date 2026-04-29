import SwiftUI

struct CompanyView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showContactAlert = false
    @State private var contactEmail = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Color.wmBackground.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: WMSpacing.lg) {

                        // Header
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(spacing: 12) {
                                Image(systemName: "building.2.fill")
                                    .font(.system(size: 28))
                                    .foregroundColor(.wmPrimary)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("For Companies")
                                        .font(WMFont.display(22))
                                        .foregroundColor(.wmText)
                                    Text("Coming soon")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 3)
                                        .background(Color.wmPrimary)
                                        .clipShape(Capsule())
                                }
                            }
                            Text("Help the next generation of talent — and tell your story while doing it.")
                                .font(WMFont.body())
                                .foregroundColor(.wmTextSecondary)
                                .lineSpacing(4)
                        }

                        // Value proposition
                        VStack(spacing: 12) {
                            valueCard(
                                icon: "cup.and.saucer.fill",
                                title: "Sponsor career coffees",
                                description: "Your company sponsors first-coffee meetings for young professionals in your industry. Show you invest in talent, not just talk about it.",
                                color: .wmPrimary
                            )
                            valueCard(
                                icon: "star.circle.fill",
                                title: "Employer branding",
                                description: "Your logo appears on mentor profiles from your alumni network. When a mentee lands their first job, they remember who helped them get ready.",
                                color: Color(wmHex: "#6366F1")
                            )
                            valueCard(
                                icon: "person.2.wave.2.fill",
                                title: "Alumni mentoring programme",
                                description: "Organise structured mentoring between your retirees and their successors — or with external talent you want to attract.",
                                color: Color(wmHex: "#10B981")
                            )
                            valueCard(
                                icon: "chart.bar.xaxis",
                                title: "Impact dashboard",
                                description: "Track coffees sponsored, matches made, and talent pipeline built. Report CSR impact to your board with real data.",
                                color: Color(wmHex: "#F59E0B")
                            )
                        }

                        // Pricing preview
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Pricing")
                                .font(WMFont.subheading())
                                .foregroundColor(.wmText)
                            Text("Company plans start from €299/month for up to 20 sponsored coffees. Volume pricing available for larger companies.")
                                .font(WMFont.body(14))
                                .foregroundColor(.wmTextSecondary)
                                .lineSpacing(4)
                        }
                        .padding(WMSpacing.md)
                        .wmCard(cornerRadius: 14)

                        // CTA
                        VStack(spacing: 12) {
                            WMPrimaryButton(title: "Request a demo") {
                                showContactAlert = true
                            }
                            Text("We'll be in touch within one business day.")
                                .font(.system(size: 12))
                                .foregroundColor(.wmTextTertiary)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }

                        // TODO: Replace with real company listing when backend is ready
                        partnerLogosPlaceholder
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
            .alert("Request a demo", isPresented: $showContactAlert) {
                TextField("Your email address", text: $contactEmail)
                    .keyboardType(.emailAddress)
                Button("Send request") {
                    // TODO: Send to backend / CRM
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Enter your work email and we'll reach out to set up a 20-minute call.")
            }
        }
    }

    private func valueCard(icon: String, title: String, description: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(color.opacity(0.12))
                    .frame(width: 46, height: 46)
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(WMFont.subheading(15))
                    .foregroundColor(.wmText)
                Text(description)
                    .font(WMFont.body(13))
                    .foregroundColor(.wmTextSecondary)
                    .lineSpacing(3)
            }
        }
        .padding(WMSpacing.md)
        .wmCard(cornerRadius: 14)
    }

    private var partnerLogosPlaceholder: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Early partners")
                .font(WMFont.caption(11))
                .foregroundColor(.wmTextSecondary)
                .textCase(.uppercase)
                .tracking(0.4)

            HStack(spacing: 12) {
                ForEach(["KPMG", "ING", "McKinsey", "Deloitte"], id: \.self) { name in
                    Text(name)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.wmTextSecondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.wmSurface)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.wmBorder, lineWidth: 1))
                }
            }
            Text("Logo placeholder — real logos will appear once agreements are signed.")
                .font(.system(size: 11))
                .foregroundColor(.wmTextTertiary)
                .italic()
        }
    }
}

#Preview {
    CompanyView()
}
