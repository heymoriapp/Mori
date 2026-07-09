import AppKit
import SwiftUI

/// Backing model for the palette. Keyboard input is fed in from the panel's
/// `keyDown` (AppKit) so navigation is 100% reliable — no SwiftUI focus dance.
final class PaletteModel: ObservableObject {
    enum Row: Hashable {
        case action(MoriAction)
        case composer
    }

    @Published var query: String = ""
    @Published var index: Int = 0

    let allActions: [MoriAction]
    var onPick: (MoriAction) -> Void = { _ in }
    var onOpenComposer: () -> Void = {}
    var onClose: () -> Void = {}

    init(actions: [MoriAction]) {
        self.allActions = actions
    }

    var filteredActions: [MoriAction] {
        guard !query.isEmpty else { return allActions }
        return allActions.filter {
            $0.name.localizedCaseInsensitiveContains(query)
                || $0.instruction.localizedCaseInsensitiveContains(query)
        }
    }

    var rows: [Row] {
        filteredActions.map { Row.action($0) } + [.composer]
    }

    // MARK: Keyboard

    func moveDown() { index = min(index + 1, rows.count - 1) }
    func moveUp() { index = max(index - 1, 0) }

    func append(_ s: String) {
        query += s
        index = 0
    }

    func backspace() {
        guard !query.isEmpty else { return }
        query.removeLast()
        index = 0
    }

    func submit() {
        guard rows.indices.contains(index) else { return }
        switch rows[index] {
        case .action(let action): onPick(action)
        case .composer: onOpenComposer()
        }
    }
}

/// Spotlight-style key panel. Feeds keystrokes to the model.
final class ActionsPalettePanel: NSPanel {
    weak var model: PaletteModel?

    init() {
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 420),
            styleMask: [.titled, .fullSizeContentView, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        isFloatingPanel = true
        level = .floating
        titleVisibility = .hidden
        titlebarAppearsTransparent = true
        standardWindowButton(.closeButton)?.isHidden = true
        standardWindowButton(.miniaturizeButton)?.isHidden = true
        standardWindowButton(.zoomButton)?.isHidden = true
        backgroundColor = .clear
        isOpaque = false
        hasShadow = true
        collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .transient]
        animationBehavior = .utilityWindow
    }

    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { false }

    override func cancelOperation(_ sender: Any?) {
        model?.onClose()
    }

    override func keyDown(with event: NSEvent) {
        guard let model else { super.keyDown(with: event); return }
        switch Int(event.keyCode) {
        case 53: // esc
            model.onClose()
        case 125: // down
            model.moveDown()
        case 126: // up
            model.moveUp()
        case 36, 76: // return / keypad enter
            model.submit()
        case 51: // delete / backspace
            model.backspace()
        default:
            // Ignore when a command/control chord is held.
            if event.modifierFlags.intersection([.command, .control]).isEmpty,
               let chars = event.charactersIgnoringModifiers, !chars.isEmpty,
               chars.first.map({ $0.isLetter || $0.isNumber || $0 == " " || $0.isPunctuation }) == true {
                model.append(chars)
            } else {
                super.keyDown(with: event)
            }
        }
    }
}

/// The palette UI: a search line + a keyboard-highlighted list of actions.
struct ActionsPaletteView: View {
    @ObservedObject var model: PaletteModel

    var body: some View {
        VStack(spacing: 0) {
            searchRow
            Divider().overlay(Theme.border)
            list
        }
        .frame(width: 480)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Theme.background)
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Theme.border, lineWidth: 1)
                )
        )
        .padding(12)
    }

    private var searchRow: some View {
        HStack(spacing: 10) {
            MoriMark(size: 20)
            ZStack(alignment: .leading) {
                if model.query.isEmpty {
                    Text("Search actions…")
                        .foregroundStyle(Theme.muted.opacity(0.7))
                }
                Text(model.query)
                    .foregroundStyle(Theme.ink)
            }
            .font(.system(size: 15))
            Spacer()
            KeycapPill(text: "⌥⇧M")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    private var list: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 2) {
                    ForEach(Array(model.rows.enumerated()), id: \.offset) { pair in
                        row(for: pair.element, selected: pair.offset == model.index)
                            .id(pair.offset)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                model.index = pair.offset
                                model.submit()
                            }
                    }
                }
                .padding(8)
            }
            .frame(height: 320)
            .onChange(of: model.index) { _, newValue in
                withAnimation(.easeOut(duration: 0.12)) { proxy.scrollTo(newValue, anchor: .center) }
            }
        }
    }

    @ViewBuilder
    private func row(for element: PaletteModel.Row, selected: Bool) -> some View {
        switch element {
        case .action(let action):
            paletteRow(icon: action.icon, title: action.name, subtitle: action.kind.label, selected: selected)
        case .composer:
            paletteRow(icon: "square.and.pencil", title: "Open full composer…", subtitle: "Reply · Recall · edit context", selected: selected)
        }
    }

    private func paletteRow(icon: String, title: String, subtitle: String, selected: Bool) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(selected ? Theme.forest : Theme.muted)
                .frame(width: 22)
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Theme.ink)
            Spacer()
            Text(subtitle)
                .font(.system(size: 11))
                .foregroundStyle(Theme.muted)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(selected ? Theme.softGreen.opacity(0.6) : Color.clear)
        )
    }
}
