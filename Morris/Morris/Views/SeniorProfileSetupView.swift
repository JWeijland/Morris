import SwiftUI

struct SeniorProfileSetupView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appVM: AppViewModel

    @State private var currentRole: String = ""
    @State private var yearsExperience: String = ""
    @State private var selectedIndustries: Set<Industry> = []
    @State private var topicsText: String = ""
    @State private var motivation: String = ""
    @State private var availability: String = ""
    @State private var showLinkedInAlert = false
    @State private var saved = false

    private let availabilityOptions = [
        "Weekday mornings",
        "Weekday afternoons",
        "Weekends",
        "Thursday afternoons",
        "Flexible — retired",
        "By appointment only"
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.wmBackground.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: WMSpacing.lg) {

                        // Header
                        VStack(alignment: .leading, spacing: 6) {
                            Image(systemName: "star.circle.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.wmPrimary)
                            Text("Your mentor profile")
                                .font(WMFont.display(24))
                                .foregroundColor(.wmText)
                            Text("The more detail you share, the better we can match you with people you can genuinely help.")
                                .font(WMFont.body())
                                .foregroundColor(.wmTextSecondary)
                                .lineSpacing(4)
                        }

                        // Current role
                        sectionHeader("Current or last role", icon: "briefcase.fill")
                        WMTextField(placeholder: "e.g. Retired CFO, Senior Partner Emeritus", text: $currentRole, icon: "person.fill")

                        // Years of experience
                        sectionHeader("Years of experience", icon: "hourglass")
                        WMTextField(placeholder: "e.g. 32", text: $yearsExperience, icon: "number", keyboardType: .numberPad)

                        // Industries
                        sectionHeader("Industries (select all that apply)", icon: "building.2")
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                            ForEach(Industry.allCases) { industry in
                                industryToggle(industry)
                            }
                        }

                        // Topics
                        sectionHeader("Topics you can help with", icon: "lightbulb.fill")
                        WMTextArea(
                            placeholder: "e.g. CFO career path, M&A strategy, from consulting to corporate, leadership transition...\n\nSeparate topics with commas.",
                            text: $topicsText,
                            minHeight: 100
                        )

                        // Motivation
                        sectionHeader("Why do you want to mentor?", icon: "quote.opening")
                        WMTextArea(
                            placeholder: "Share what drives you to give back. Young professionals find this very motivating to read.",
                            text: $motivation,
                            minHeight: 100
                        )

                        // Availability
                        sectionHeader("When are you typically available?", icon: "calendar.badge.clock")
                        VStack(spacing: 8) {
                            ForEach(availabilityOptions, id: \.self) { option in
                                availabilityRow(option)
                            }
                        }

                        // LinkedIn
                        sectionHeader("LinkedIn (builds trust)", icon: "link")
                        Button {
                            showLinkedInAlert = true
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "link.badge.plus")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color(wmHex: "#0077B5"))
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Import from LinkedIn")
                                        .font(WMFont.subheading(15))
                                        .foregroundColor(.wmText)
                                    Text("Verified profiles get 3× more matches")
                                        .font(.system(size: 12))
                                        .foregroundColor(.wmTextSecondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.wmTextTertiary)
                            }
                            .padding(14)
                            .wmCard(cornerRadius: 12)
                        }

                        WMPrimaryButton(title: "Save profile") {
                            saved = true
                        }
                        .disabled(currentRole.isEmpty || motivation.isEmpty)
                        .opacity(currentRole.isEmpty || motivation.isEmpty ? 0.5 : 1)
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
            .alert("LinkedIn Import", isPresented: $showLinkedInAlert) {
                Button("OK") {}
            } message: {
                // TODO: Integrate LinkedIn OAuth
                Text("LinkedIn OAuth integration coming soon. Your profile will be verified and marked with a blue checkmark badge.")
            }
            .alert("Profile saved!", isPresented: $saved) {
                Button("Done") { dismiss() }
            } message: {
                // TODO: Save to backend (Supabase/Firebase)
                Text("Your mentor profile is live. Young professionals matching your expertise will start appearing soon.")
            }
        }
    }

    private func sectionHeader(_ title: String, icon: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.wmPrimary)
            Text(title)
                .font(WMFont.caption(11))
                .foregroundColor(.wmTextSecondary)
                .textCase(.uppercase)
                .tracking(0.4)
        }
    }

    private func industryToggle(_ industry: Industry) -> some View {
        let isSelected = selectedIndustries.contains(industry)
        return Button {
            if isSelected { selectedIndustries.remove(industry) }
            else { selectedIndustries.insert(industry) }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: industry.icon)
                    .font(.system(size: 11))
                Text(industry.rawValue)
                    .font(.system(size: 12, weight: .medium))
                    .lineLimit(1)
            }
            .foregroundColor(isSelected ? .white : industry.color)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(isSelected ? industry.color : industry.color.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
    }

    private func availabilityRow(_ option: String) -> some View {
        let isSelected = availability == option
        return Button {
            availability = option
        } label: {
            HStack {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .wmPrimary : .wmTextTertiary)
                Text(option)
                    .font(WMFont.body(14))
                    .foregroundColor(.wmText)
                Spacer()
            }
            .padding(12)
            .background(isSelected ? Color.wmPrimaryLight.opacity(0.2) : Color.wmSurface)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color.wmPrimary.opacity(0.4) : Color.wmBorder, lineWidth: 1)
            )
        }
    }
}

#Preview {
    SeniorProfileSetupView().environmentObject(AppViewModel())
}
