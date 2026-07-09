import SwiftUI

/// Mori's calm forest-memory palette, mirrored from the brand tokens.
enum Theme {
    static let background = Color(hex: 0xFAF7EF)
    static let card = Color(hex: 0xFFFDF8)
    static let ink = Color(hex: 0x12110E)
    static let muted = Color(hex: 0x706B63)
    static let forest = Color(hex: 0x2F4A37)
    static let moss = Color(hex: 0x9CAF88)
    static let clay = Color(hex: 0xD96B3C)
    static let border = Color(hex: 0xE7E0D2)
    static let softGreen = Color(hex: 0xDDE8D3)
    static let softClay = Color(hex: 0xF6D8C6)

    static let cornerRadius: CGFloat = 16
    static let composerWidth: CGFloat = 680
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }
}

/// A soft rounded card surface used across the app.
struct MoriCard: ViewModifier {
    var padding: CGFloat = 16
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(Theme.card)
            .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cornerRadius, style: .continuous)
                    .stroke(Theme.border, lineWidth: 1)
            )
    }
}

extension View {
    func moriCard(padding: CGFloat = 16) -> some View {
        modifier(MoriCard(padding: padding))
    }

    /// A tiny uppercase mono label used for section captions and pills.
    func moriLabelStyle() -> some View {
        self
            .font(.system(size: 10, weight: .medium, design: .monospaced))
            .tracking(1.6)
            .textCase(.uppercase)
            .foregroundStyle(Theme.muted)
    }
}
