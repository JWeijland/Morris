import SwiftUI

private struct MatchPresentation: Identifiable {
    let id = UUID()
    let seniorUser: User
    let match: Match
}

struct SwipeDiscoveryView: View {
    @EnvironmentObject var appVM: AppViewModel
    @StateObject private var vm: DiscoveryViewModel

    @State private var pendingMatch: MatchPresentation?

    init(appViewModel: AppViewModel) {
        _vm = StateObject(wrappedValue: DiscoveryViewModel(appViewModel: appViewModel))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.wmBackground.ignoresSafeArea()

                VStack(spacing: 0) {
                    header

                    if vm.hasMoreCards {
                        cardArea
                        actionButtons
                    } else {
                        emptyState
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            vm.onMatchTriggered = { user, match in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    pendingMatch = MatchPresentation(seniorUser: user, match: match)
                }
            }
        }
        .sheet(item: $pendingMatch) { data in
            MatchView(seniorUser: data.seniorUser, match: data.match)
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Discover")
                    .font(WMFont.display(26))
                    .foregroundColor(.wmText)
                Text("Senior professionals ready to help")
                    .font(.system(size: 13))
                    .foregroundColor(.wmTextSecondary)
            }
            Spacer()
        }
        .padding(.horizontal, WMSpacing.md)
        .padding(.top, WMSpacing.md)
        .padding(.bottom, WMSpacing.sm)
    }

    // MARK: - Card area

    private var cardArea: some View {
        Group {
            if let card = vm.topCard {
                ProfileCardView(card: card)
                    .padding(.horizontal, WMSpacing.md)
                    .opacity(vm.cardOpacity)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }

    // MARK: - Action buttons

    private var actionButtons: some View {
        HStack(spacing: 20) {
            Button { vm.decide(save: false) } label: {
                HStack(spacing: 6) {
                    Image(systemName: "xmark").font(.system(size: 14, weight: .semibold))
                    Text("Pass").font(.system(size: 15, weight: .semibold))
                }
                .foregroundColor(.wmTextSecondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.wmSurface)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.wmBorder, lineWidth: 1.5))
            }

            Button { vm.decide(save: true) } label: {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark").font(.system(size: 14, weight: .semibold))
                    Text("Connect").font(.system(size: 15, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.wmPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
        }
        .padding(.horizontal, WMSpacing.md)
        .padding(.bottom, WMSpacing.xl)
        .padding(.top, WMSpacing.md)
    }

    // MARK: - Empty state

    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "tray").font(.system(size: 52)).foregroundColor(.wmBorder)
            Text("You've seen everyone").font(WMFont.heading()).foregroundColor(.wmText)
            Text("New profiles are added regularly.\nCheck back tomorrow or broaden your industry.")
                .font(WMFont.body()).foregroundColor(.wmTextSecondary).multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}
