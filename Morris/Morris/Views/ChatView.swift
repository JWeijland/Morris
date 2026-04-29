import SwiftUI

struct ChatView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appVM: AppViewModel

    let match: Match

    @State private var messages: [ChatMessage] = []
    @State private var draft: String = ""
    @State private var showSchedule = false
    @State private var showVoiceNoteAlert = false
    @State private var showVideoAlert = false
    @State private var showReport = false

    private var otherUser: User? {
        guard let me = appVM.currentUser else { return nil }
        let otherId = match.youngUserId == me.id ? match.seniorUserId : match.youngUserId
        return appVM.data.user(for: otherId)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if let other = otherUser { contextBanner(user: other) }
                Divider().background(Color.wmBorder)
                messageList
                Divider().background(Color.wmBorder)
                inputBar
            }
            .background(Color.wmBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbarContent }
        }
        .onAppear { loadMessages() }
        .sheet(isPresented: $showSchedule) { ScheduleCoffeeView(match: match) }
        .alert("Voice notes", isPresented: $showVoiceNoteAlert) {
            Button("OK") {}
        } message: {
            // TODO: Integrate AVFoundation voice recording
            Text("Voice notes are coming in the next release.")
        }
        .alert("Video calls", isPresented: $showVideoAlert) {
            Button("OK") {}
        } message: {
            // TODO: Integrate Whereby / Daily.co SDK
            Text("Video calls are coming soon and will launch inside the app.")
        }
        .alert("Report user", isPresented: $showReport) {
            Button("Report", role: .destructive) {}
            Button("Cancel", role: .cancel) {}
        } message: {
            // TODO: Send report to moderation backend
            Text("Thank you. We'll review this conversation within 24 hours.")
        }
    }

    // MARK: - Context banner

    private func contextBanner(user: User) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle().fill(Color.wmPrimaryLight.opacity(0.35)).frame(width: 44, height: 44)
                Text(user.initials)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.wmPrimaryDark)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(user.name).font(WMFont.subheading(15)).foregroundColor(.wmText)
                HStack(spacing: 4) {
                    Circle().fill(Color.wmSuccess).frame(width: 6, height: 6)
                    Text("\(match.matchPercentage)% match · Career coffee")
                        .font(.system(size: 12)).foregroundColor(.wmTextSecondary)
                }
            }
            Spacer()
            Button { showSchedule = true } label: {
                HStack(spacing: 4) {
                    Image(systemName: "cup.and.saucer.fill")
                    Text("Plan")
                }
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.wmPrimary)
                .clipShape(Capsule())
            }
        }
        .padding(.horizontal, WMSpacing.md)
        .padding(.vertical, WMSpacing.sm)
        .background(Color.wmSurface)
    }

    // MARK: - Message list

    private var messageList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(messages) { message in
                        MessageBubble(
                            message: message,
                            isFromMe: message.senderId == appVM.currentUser?.id
                        )
                        .id(message.id)
                    }
                }
                .padding(WMSpacing.md)
            }
            .onChange(of: messages.count) {
                if let last = messages.last {
                    withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
                }
            }
            .onAppear {
                if let last = messages.last { proxy.scrollTo(last.id, anchor: .bottom) }
            }
        }
    }

    // MARK: - Input bar

    private var inputBar: some View {
        HStack(spacing: 10) {
            Button { showVoiceNoteAlert = true } label: {
                Image(systemName: "waveform")
                    .font(.system(size: 18))
                    .foregroundColor(.wmPrimary)
                    .frame(width: 40, height: 40)
            }
            HStack {
                TextField("Message...", text: $draft)
                    .font(WMFont.body())
                    .submitLabel(.send)
                    .onSubmit { send() }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color(wmHex: "#F5F5F5"))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

            Button { showVideoAlert = true } label: {
                Image(systemName: "video.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.wmPrimary)
                    .frame(width: 40, height: 40)
            }
            Button { send() } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(draft.isEmpty ? .wmTextTertiary : .wmPrimary)
            }
            .disabled(draft.isEmpty)
        }
        .padding(.horizontal, WMSpacing.md)
        .padding(.vertical, WMSpacing.sm)
        .background(Color.wmSurface)
    }

    // MARK: - Toolbar

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left").foregroundColor(.wmPrimary)
            }
        }
        ToolbarItem(placement: .principal) {
            Text(otherUser?.firstName ?? "Chat")
                .font(WMFont.subheading()).foregroundColor(.wmText)
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Menu {
                Button { showReport = true } label: { Label("Report user", systemImage: "exclamationmark.triangle") }
                Button { showSchedule = true } label: { Label("Schedule coffee", systemImage: "cup.and.saucer") }
            } label: {
                Image(systemName: "ellipsis.circle").foregroundColor(.wmPrimary)
            }
        }
    }

    // MARK: - Helpers

    private func loadMessages() {
        messages = appVM.data.messagesFor(matchId: match.id)
    }

    private func send() {
        let text = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty, let senderId = appVM.currentUser?.id else { return }
        appVM.sendMessage(text: text, matchId: match.id, senderId: senderId)
        draft = ""
        loadMessages()
    }
}

// MARK: - Message bubble

struct MessageBubble: View {
    let message: ChatMessage
    let isFromMe: Bool

    private var timeString: String {
        let f = DateFormatter()
        f.timeStyle = .short
        return f.string(from: message.sentAt)
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if isFromMe { Spacer(minLength: 60) }
            VStack(alignment: isFromMe ? .trailing : .leading, spacing: 4) {
                if let text = message.text {
                    Text(text)
                        .font(WMFont.body(15))
                        .foregroundColor(isFromMe ? .white : .wmText)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(isFromMe ? Color.wmPrimary : Color.wmSurface)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .shadow(color: isFromMe ? Color.wmPrimary.opacity(0.25) : Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                }
                Text(timeString)
                    .font(.system(size: 11))
                    .foregroundColor(.wmTextTertiary)
            }
            if !isFromMe { Spacer(minLength: 60) }
        }
    }
}
