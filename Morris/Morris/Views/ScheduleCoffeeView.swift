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
                        header
                        cafeSection
                        dateSection
                        notesSection
                        confirmButton
                        conductNote
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
                let cafeName = selectedCafe?.name ?? "the café"
                let dateStr = selectedDate.formatted(date: .abbreviated, time: .shortened)
                return Text("We've notified \(otherUser?.firstName ?? "your match"). Your coffee at \(cafeName) on \(dateStr) is awaiting confirmation. The first drink is on us!")
            }
        }
    }

    // MARK: - Sections

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                Image(systemName: "cup.and.saucer.fill")
                    .font(.system(size: 26))
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

            HStack(spacing: 8) {
                Image(systemName: "gift.fill").foregroundColor(.wmAccent)
                Text("First coffee is on WisdomMatch at all partner cafés.")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.wmText)
            }
            .padding(12)
            .background(Color.wmAccent.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
    }

    private var cafeSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionLabel("Choose a partner café", icon: "mappin.circle.fill")
            VStack(spacing: 8) {
                ForEach(cafes) { cafe in
                    cafeRow(cafe)
                }
            }
        }
    }

    private var dateSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionLabel("Pick a date & time", icon: "calendar")
            DatePicker(
                "Meeting time",
                selection: $selectedDate,
                in: Date()...,
                displayedComponents: [.date, .hourAndMinute]
            )
            .datePickerStyle(.graphical)
            .tint(.wmPrimary)
            .environment(\.colorScheme, .light)
            .padding(12)
            .background(Color.wmBackground)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
    }

    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionLabel("Add a note (optional)", icon: "note.text")
            WMTextArea(
                placeholder: "e.g. \"I'll be near Centrum — any time after 10am works\"",
                text: $notes,
                minHeight: 80
            )
        }
    }

    private var confirmButton: some View {
        VStack(spacing: 8) {
            WMPrimaryButton(title: "Send meeting request") {
                confirmed = true
            }
            .disabled(selectedCafe == nil)
            .opacity(selectedCafe == nil ? 0.4 : 1)

            if selectedCafe == nil {
                Text("Select a café to continue")
                    .font(.system(size: 12))
                    .foregroundColor(.wmTextTertiary)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }

    private var conductNote: some View {
        HStack(spacing: 6) {
            Image(systemName: "shield.fill").font(.system(size: 11)).foregroundColor(.wmSuccess)
            Text("By meeting up, both parties agree to our Code of Conduct.")
                .font(.system(size: 12))
                .foregroundColor(.wmTextTertiary)
        }
    }

    // MARK: - Café row

    private func cafeRow(_ cafe: Cafe) -> some View {
        let isSelected = selectedCafe?.id == cafe.id
        return Button { selectedCafe = cafe } label: {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.wmPrimary.opacity(0.1))
                        .frame(width: 48, height: 48)
                    Image(systemName: "cup.and.saucer.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.wmPrimary)
                }

                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Text(cafe.name)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.wmText)
                        if cafe.isPartner {
                            Text("Partner")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 5)
                                .padding(.vertical, 2)
                                .background(Color.wmAccent)
                                .clipShape(Capsule())
                        }
                    }
                    Text("\(cafe.neighborhood) · \(String(format: "%.1f km", cafe.distanceKm))")
                        .font(.system(size: 12))
                        .foregroundColor(.wmTextSecondary)
                    HStack(spacing: 3) {
                        Image(systemName: "star.fill").font(.system(size: 10)).foregroundColor(.wmAccent)
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
            .padding(12)
            .background(isSelected ? Color.wmPrimary.opacity(0.06) : Color.wmSurface)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.wmPrimary.opacity(0.5) : Color.wmBorder, lineWidth: isSelected ? 1.5 : 1)
            )
        }
    }

    private func sectionLabel(_ title: String, icon: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon).font(.system(size: 11, weight: .semibold)).foregroundColor(.wmPrimary)
            Text(title)
                .font(WMFont.caption(11))
                .foregroundColor(.wmTextSecondary)
                .textCase(.uppercase)
                .tracking(0.4)
        }
    }
}

#Preview {
    ScheduleCoffeeView(match: MockDataService.shared.matches[0])
        .environmentObject(AppViewModel())
}
