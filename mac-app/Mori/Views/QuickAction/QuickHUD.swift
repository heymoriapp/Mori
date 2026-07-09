import AppKit
import SwiftUI

/// Shared state for the quick-action HUD.
final class QuickHUDState: ObservableObject {
    enum Phase {
        case working
        case done
        case copied
        case error
    }

    @Published var phase: Phase = .working
    @Published var title: String = ""
    @Published var message: String = ""
}

/// A tiny, calm heads-up display shown while ⌥M works on a selection in place.
struct QuickHUDView: View {
    @ObservedObject var state: QuickHUDState

    var body: some View {
        HStack(spacing: 12) {
            icon
            VStack(alignment: .leading, spacing: 1) {
                Text(state.title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Theme.ink)
                if !state.message.isEmpty {
                    Text(state.message)
                        .font(.system(size: 11))
                        .foregroundStyle(Theme.muted)
                        .lineLimit(2)
                }
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(width: 300, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Theme.background)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Theme.border, lineWidth: 1)
                )
        )
        .padding(10)
    }

    @ViewBuilder
    private var icon: some View {
        switch state.phase {
        case .working:
            ZStack {
                MoriMark(size: 26)
                ProgressView()
                    .controlSize(.small)
                    .offset(x: 18, y: 14)
            }
        case .done:
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 22))
                .foregroundStyle(Theme.forest)
        case .copied:
            Image(systemName: "doc.on.clipboard.fill")
                .font(.system(size: 20))
                .foregroundStyle(Theme.forest)
        case .error:
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 20))
                .foregroundStyle(Theme.clay)
        }
    }
}

/// Non-activating panel: shows the HUD without ever stealing keyboard focus,
/// so the user's app keeps its selection for the in-place paste.
final class QuickHUDPanel: NSPanel {
    init() {
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 320, height: 72),
            styleMask: [.titled, .fullSizeContentView, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        isFloatingPanel = true
        level = .statusBar
        titleVisibility = .hidden
        titlebarAppearsTransparent = true
        standardWindowButton(.closeButton)?.isHidden = true
        standardWindowButton(.miniaturizeButton)?.isHidden = true
        standardWindowButton(.zoomButton)?.isHidden = true
        backgroundColor = .clear
        isOpaque = false
        hasShadow = true
        ignoresMouseEvents = true
        collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .transient, .ignoresCycle]
        animationBehavior = .utilityWindow
    }

    override var canBecomeKey: Bool { false }
    override var canBecomeMain: Bool { false }
}
