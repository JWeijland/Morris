import SwiftUI

struct ScheduleCoffeeView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appVM: AppViewModel

    let match: Match

    @State private var selectedDate = Date().addingTimeInterval(86400 * 3)
    @State private var selectedCafe: Cafe?
    @State private var notes: String = ""
    @State private var confirmed = false

    private var cafes: [Cafe] { appVM.data.cafes }

    private var otherUser: User? {
        guard let me = appVM.currentUser else { return nil }
        let otherId = match.youngUserId == me.id ? match.seniorUserId : match.youngUserId
        return appVM.data.user(for: otherId)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.wmBackground.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: WMSpacing.lg) {

                        // Header
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 10) {
                                Image(systemName: "cup.and.saucer.fill")
                                    .font(.system(size: 28))
                                    .foregroundColor(.wmPrimary)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Plan your coffee")
                                        .font(WMFont.display(22))
                                        .foregroundColor(.wmText)
                                    if let other = otherUser {
                                        Text("with \(other.name)")
                                            .font(WMFont.body())
                                            .foregroundColor(.wmTextSecondary)
                                    }
                                }
                            }

                            // Free coffee banner
                            HStack(spacing: 10) {
                                Image(systemName: "gift.fill")
                                    .foregroundColor(Color.wmGold)
                                Text("First coffee is on WisdomMatch — included at all partner cafés.")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.wmText)
                            }
                            .padding(12)
                            .background(Color.wmGold.opacity(0.12))
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        }

                        // Date picker
                        sectionHeader("Pick a date & time", icon: "calendar")
                        DatePicker(
                            "Meeting time",
                            selection: $selectedDate,
                            in: Date()...,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        .datePickerStyle(.graphical)
                        .tint(.wmPrimary)
                        .wmCard(cornerRadius: 14, padding: 12)

                        // Café selection
                        sectionHeader("Choose a partner café", icon: "mappin.circle.fill")
                        VStack(spacing: 10) {
                            ForEach(cafes) { cafe in
                                cafeCard(cafe)
                            }
                        }

                        // Notes
                        sectionHeader("Any notes for \(otherUser?.firstName ?? "your match")?", icon: "note.text")
                        WMTextArea(
                            placeholder: "e.g. \"I'll be near Centrum that day — any time after 10am works\"",
                            text: $notes,
                            minHeight: 80
                        )

                        // Confirm button
                        WMPrimaryButton(title: "Send meeting request") {
                            confirmed = true
                        }
                        .disabled(selectedCafe == nil)
                        .opacity(selectedCafe == nil ? 0.5 : 1)

                        if selectedCafe == nil {
                            Text("Please select a café to continue.")
                                .font(.system(size: 12))
                                .foregroundColor(.wmTextTertiary)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }

                        // Code of conduct reminder
                        HStack(spacing: 6) {
                            Image(systemName: "shield.fill")
                                .font(.system(size: 11))
                                .foregroundColor(.wmSuccess)
                            Text("By meeting up, both parties agree to our Code of Conduct.")
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
                    Button("Cancel") { dismiss() }.foregroundColor(.wmPrimary)
                }
            }
            .alert("Meeting request sent!", isPresented: $confirmed) {
                Button("Done") { dismiss() }
            } message: {
                // TODO: Send push notification to other user via backend
                // TODO: Create calendar event via Calendar API
                let cafeName = selectedCafe?.name ?? "the café"
                let dateStr = selectedDate.formatted(date: .abbreviated, time: .shortened)
                return Text("We've notified \(otherUser?.firstName ?? "your match"). Your coffee at \(cafeName) on \(dateStr) is awaiting confirmation. The first drink is on us!")
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

    private func cafeCard(_ cafe: Cafe) -> some View {
        let isSelected = selectedCafe?.id == cafe.id
        return Button {
            selectedCafe = cafe
        } label: {
            HStack(spacing: 12) {
                // Icon placeholder
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.wmPrimary.opacity(0.12))
                        .frame(width: 52, height: 52)
                    Image(systemName: "cup.and.saucer.fill")
                        .font(.system(size: 22))
                        .foregroundColor(.wmPrimary)
                }

                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Text(cafe.name)
                            .font(WMFont.subheading(14))
                            .foregroundColor(.wmText)
                        if cafe.isPartner {
                            Text("Partner")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 5)
                                .padding(.vertical, 2)
                                .background(Color.wmPrimary)
                                .clipShape(Capsule())
                        }
                    }
                    Text(cafe.neighborhood + " · " + String(format: "%.1f km away", cafe.distanceKm))
                        .font(.system(size: 12))
                        .foregroundColor(.wmTextSecondary)
                    Text(cafe.description)
                        .font(.system(size: 12))
                        .foregroundColor(.wmTextTertiary)
                        .lineLimit(2)

                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.wmGold)
                        Text(String(format: "%.1f", cafe.rating))
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.wmTextSecondary)
                    }
                }

                Spacer()

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 22))
                    .foregroundColor(isSelected ? .wmPrimary : .wmBorder)
            }
            .padding(14)
            .background(isSelected ? Color.wmPrimaryLight.opacity(0.15) : Color.wmSurface)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? Color.wmPrimary.opacity(0.4) : Color.wmBorder, lineWidth: isSelected ? 2 : 1)
            )
        }
    }
}

#Preview {
    let data = MockDataService.shared
    ScheduleCoffeeView(match: data.matches[0])
        .environmentObject(AppViewModel())
}
