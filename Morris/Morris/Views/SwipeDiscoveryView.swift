import SwiftUI

struct SwipeDiscoveryView: View {
    @EnvironmentObject var appVM: AppViewModel
    @StateObject private var vm: DiscoveryViewModel

    @State private var showMatchSheet = false
    @State private var matchedUser: User?
    @State private var triggeredMatch: Match?
    @State private var showQuestion = false

    init(appViewModel: AppViewModel) {
        _vm = StateObject(wrappedValue: DiscoveryViewModel(appViewModel: appViewModel))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.wmBackground.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header
                    header

                    if let question = appVM.currentQuestion {
                        questionBanner(question: question)
                    }

                    // Card stack
                    if vm.hasMoreCards {
                        cardStack
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
                matchedUser = user
                triggeredMatch = match
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showMatchSheet = true
                }
            }
        }
        .sheet(isPresented: $showMatchSheet) {
            if let user = matchedUser, let match = triggeredMatch {
                MatchView(seniorUser: user, match: match)
            }
        }
        .sheet(isPresented: $showQuestion) {
            YoungQuestionView()
        }
    }

    // MARK: - Subviews

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Discover")
                    .font(WMFont.display(26))
                    .foregroundColor(.wmText)
                Text("Senior professionals ready to help")
                    .font(WMFont.body(13))
                    .foregroundColor(.wmTextSecondary)
            }
            Spacer()
            Button { showQuestion = true } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 26))
                    .foregroundColor(.wmPrimary)
            }
        }
        .padding(.horizontal, WMSpacing.md)
        .padding(.top, WMSpacing.md)
        .padding(.bottom, WMSpacing.sm)
    }

    private func questionBanner(question: CareerQuestion) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "questionmark.bubble.fill")
                .font(.system(size: 16))
                .foregroundColor(.wmPrimary)
            Text(question.title)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.wmText)
                .lineLimit(1)
            Spacer()
            Text("Edit")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.wmPrimary)
                .onTapGesture { showQuestion = true }
        }
        .padding(12)
        .background(Color.wmPrimaryLight.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .padding(.horizontal, WMSpacing.md)
        .padding(.bottom, WMSpacing.sm)
    }

    private var cardStack: some View {
        ZStack {
            ForEach(vm.cards.indices.reversed(), id: \.self) { index in
                if index >= vm.currentIndex && index < vm.currentIndex + 3 {
                    let isTop = index == vm.currentIndex
                    let stackOffset = CGFloat(index - vm.currentIndex)

                    ProfileCardView(
                        card: vm.cards[index],
                        dragOffset: isTop ? vm.dragOffset : .zero,
                        swipeIndicator: isTop ? vm.swipeIndicator : nil
                    )
                    .padding(.horizontal, 16)
                    .scaleEffect(isTop ? 1 : 1 - stackOffset * 0.03)
                    .offset(y: isTop ? 0 : stackOffset * 10)
                    .zIndex(isTop ? 10 : Double(vm.cards.count - index))
                    .gesture(isTop ? dragGesture : nil)
                }
            }
        }
        .padding(.top, WMSpacing.sm)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                vm.isDragging = true
                vm.dragOffset = value.translation
            }
            .onEnded { value in
                vm.isDragging = false
                let threshold: CGFloat = 100
                if value.translation.width > threshold {
                    vm.swipe(.interested)
                } else if value.translation.width < -threshold {
                    vm.swipe(.pass)
                } else {
                    withAnimation(.spring()) { vm.dragOffset = .zero }
                }
            }
    }

    private var actionButtons: some View {
        HStack(spacing: 32) {
            WMCircleButton("xmark", color: .wmDanger, size: 60) {
                vm.swipe(.pass)
            }
            WMCircleButton("info.circle", color: .wmTextSecondary, size: 44) {
                // TODO: Show full profile detail sheet
            }
            WMCircleButton("checkmark", color: .wmSuccess, size: 60) {
                vm.swipe(.interested)
            }
        }
        .padding(.bottom, WMSpacing.xl)
        .padding(.top, WMSpacing.md)
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "tray")
                .font(.system(size: 54))
                .foregroundColor(.wmBorder)
            Text("You've seen everyone")
                .font(WMFont.heading())
                .foregroundColor(.wmText)
            Text("New profiles are added regularly.\nCome back tomorrow or adjust your industry.")
                .font(WMFont.body())
                .foregroundColor(.wmTextSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}
