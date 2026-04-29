import SwiftUI

// MARK: - Primary button

struct WMPrimaryButton: View {
    let title: String
    let action: () -> Void
    var isFullWidth: Bool = true
    var isLoading: Bool = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView().tint(.white)
                }
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

// MARK: - Secondary button

struct WMSecondaryButton: View {
    let title: String
    let action: () -> Void
    var isFullWidth: Bool = true

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(WMFont.subheading())
                .foregroundColor(Color.wmPrimary)
                .frame(maxWidth: isFullWidth ? .infinity : nil)
                .padding(.vertical, 16)
                .padding(.horizontal, 24)
                .background(Color.wmPrimaryLight.opacity(0.25))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color.wmPrimary.opacity(0.4), lineWidth: 1.5)
                )
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
    }
}

// MARK: - Icon action button (swipe actions)

struct WMCircleButton: View {
    let icon: String
    let color: Color
    let size: CGFloat
    let action: () -> Void

    init(_ icon: String, color: Color, size: CGFloat = 64, action: @escaping () -> Void) {
        self.icon = icon
        self.color = color
        self.size = size
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: size * 0.38, weight: .semibold))
                .foregroundColor(color)
                .frame(width: size, height: size)
                .background(color.opacity(0.12))
                .clipShape(Circle())
                .overlay(Circle().stroke(color.opacity(0.25), lineWidth: 1.5))
        }
    }
}

// MARK: - Tag / Chip

struct WMTag: View {
    let text: String
    var color: Color = .wmPrimary
    var fontSize: CGFloat = 12

    var body: some View {
        Text(text)
            .font(.system(size: fontSize, weight: .medium))
            .foregroundColor(color)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(color.opacity(0.12))
            .clipShape(Capsule())
    }
}

// MARK: - Industry pill

struct IndustryPill: View {
    let industry: Industry
    var showIcon: Bool = true

    var body: some View {
        HStack(spacing: 4) {
            if showIcon {
                Image(systemName: industry.icon)
                    .font(.system(size: 10, weight: .semibold))
            }
            Text(industry.rawValue)
                .font(.system(size: 12, weight: .semibold))
        }
        .foregroundColor(industry.color)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(industry.color.opacity(0.12))
        .clipShape(Capsule())
    }
}
