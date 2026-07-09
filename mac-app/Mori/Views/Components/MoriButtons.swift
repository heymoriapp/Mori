import SwiftUI

/// Primary forest-filled pill button.
struct MoriPrimaryButtonStyle: ButtonStyle {
    var disabled: Bool = false
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 13, weight: .medium))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .foregroundStyle(Theme.background)
            .background(disabled ? Theme.moss.opacity(0.5) : Theme.forest)
            .clipShape(Capsule())
            .opacity(configuration.isPressed ? 0.85 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

/// Bordered, quiet pill button.
struct MoriSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 13, weight: .medium))
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .foregroundStyle(Theme.ink)
            .background(Theme.card)
            .overlay(Capsule().stroke(Theme.border, lineWidth: 1))
            .clipShape(Capsule())
            .opacity(configuration.isPressed ? 0.7 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

/// A small keyboard-cap pill, e.g. ⌥M.
struct KeycapPill: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.system(size: 11, weight: .medium, design: .monospaced))
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .foregroundStyle(Theme.forest)
            .background(Theme.background)
            .overlay(RoundedRectangle(cornerRadius: 6, style: .continuous).stroke(Theme.border, lineWidth: 1))
            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
    }
}
