import SwiftUI

// MARK: - Primary button (navy fill)

struct WMPrimaryButton: View {
    let title: String
    let action: () -> Void
    var isFullWidth: Bool = true
    var isLoading: Bool = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading { ProgressView().tint(.white) }
                Text(title)
                    .font(WMFont.subheading())
                    .foregroundColor(.white)
            }
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
            .background(Color.wmPrimary)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .disabled(isLoading)
    }
}

// MARK: - Secondary button (amber fill)

struct WMSecondaryButton: View {
    let title: String
    let action: () -> Void
    var isFullWidth: Bool = true

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(WMFont.subheading())
                .foregroundColor(.white)
                .frame(maxWidth: isFullWidth ? .infinity : nil)
                .padding(.vertical, 16)
                .padding(.horizontal, 24)
                .background(Color.wmAccent)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
    }
}

// MARK: - Ghost button (text only)

struct WMGhostButton: View {
    let title: String
    let action: () -> Void
    var color: Color = .wmPrimary

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(WMFont.body())
                .foregroundColor(color)
                .underline()
        }
    }
}

// MARK: - Simple tag (neutral)

struct WMSimpleTag: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(.wmTextSecondary)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color.wmBackground)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.wmBorder, lineWidth: 1))
    }
}
