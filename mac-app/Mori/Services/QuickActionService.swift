import AppKit
import SwiftUI

/// The fast path. Runs a Mori Action on the current selection and pastes the
/// result back in place — no composer, no manual steps. A small HUD shows
/// progress. Falls back to opening the composer when there's no selection.
final class QuickActionService {
    static let shared = QuickActionService()

    private let hudState = QuickHUDState()
    private var hudPanel: QuickHUDPanel?
    private var dismissWork: DispatchWorkItem?
    private var isRunning = false

    private init() {}

    /// Routed from the ⌥M hotkey.
    func handleInstant() {
        let settings = AppSettings.shared

        // Read the current selection (only if quick action is on + Accessibility granted).
        var selection: String?
        if settings.enableQuickAction, AccessibilityService.isTrusted {
            selection = AccessibilityService.selectedText()
        }
        let trimmed = selection?.trimmingCharacters(in: .whitespacesAndNewlines)

        // No usable selection → open the composer, prefilled from the clipboard
        // if it has text (so text you just copied is already there to review).
        guard let selection = trimmed, !selection.isEmpty else {
            let clip = ClipboardService.read()?.trimmingCharacters(in: .whitespacesAndNewlines)
            WindowManager.shared.openComposer(
                prefill: (clip?.isEmpty == false) ? clip : nil,
                capturedApp: NSWorkspace.shared.frontmostApplication
            )
            return
        }

        let action = ActionStore.shared.defaultAction(settings: settings)

        // Preview-first (default): open the composer so the user can review,
        // edit, copy, or insert before applying — never auto-replaces.
        if settings.showComposerBeforeInsert {
            WindowManager.shared.openComposer(
                prefill: selection,
                capturedApp: NSWorkspace.shared.frontmostApplication,
                preferredMode: action.map { Self.composerMode(for: $0.kind) }
            )
            return
        }

        guard let action else {
            WindowManager.shared.toggleComposer()
            return
        }
        apply(action, selection: selection, previousApp: NSWorkspace.shared.frontmostApplication)
    }

    private static func composerMode(for kind: MoriAction.Kind) -> ComposerMode {
        switch kind {
        case .transform: return .rewrite
        case .summarize: return .summarize
        case .reply: return .reply
        }
    }

    /// Run a specific action from the menu bar (reads the current selection).
    func runFromMenu(_ action: MoriAction) {
        guard AccessibilityService.isTrusted,
              let selection = AccessibilityService.selectedText(),
              !selection.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else {
            showHUD(.error, title: "Select some text first", message: "Highlight text in any app, then run an action.")
            scheduleDismiss(after: 2.5)
            return
        }
        apply(action, selection: selection, previousApp: NSWorkspace.shared.frontmostApplication)
    }

    /// Run an action on a selection and paste the result in place.
    /// `previousApp` is captured by the caller *before* any Mori window took focus.
    func apply(_ action: MoriAction, selection: String, previousApp: NSRunningApplication?) {
        guard !isRunning else { return }

        guard let provider = AIProviderFactory.make() else {
            showHUD(.error, title: "Set up Mori first", message: "Add your API key in Preferences → AI.")
            scheduleDismiss(after: 3.0)
            return
        }

        isRunning = true
        showHUD(.working, title: "\(action.name)…", message: sourceLine(previousApp))

        let memories = MemoryStore.shared.search(selection)
        let tone = AppSettings.shared.userTone.isEmpty ? nil : AppSettings.shared.userTone

        Task {
            do {
                let result = try await run(provider, action: action, text: selection, memories: memories, tone: tone)
                await MainActor.run {
                    HistoryStore.shared.record(actionName: action.name, input: selection, output: result)
                    let inserted = InsertTextService.insert(
                        result,
                        into: previousApp,
                        restoreClipboard: AppSettings.shared.restoreClipboardAfterInsert
                    )
                    if inserted {
                        self.showHUD(.done, title: "\(action.name) applied", message: "")
                        self.scheduleDismiss(after: 1.1)
                    } else {
                        self.showHUD(.copied, title: "Copied to clipboard", message: "Enable Accessibility to replace text in place.")
                        self.scheduleDismiss(after: 3.0)
                    }
                    self.isRunning = false
                }
            } catch {
                let message = (error as? AIError)?.errorDescription ?? error.localizedDescription
                await MainActor.run {
                    self.showHUD(.error, title: "Mori couldn't finish", message: message)
                    self.scheduleDismiss(after: 4.0)
                    self.isRunning = false
                }
            }
        }
    }

    // MARK: - Running an action

    private func run(
        _ provider: AIProvider,
        action: MoriAction,
        text: String,
        memories: [MemoryItem],
        tone: String?
    ) async throws -> String {
        switch action.kind {
        case .transform:
            return try await provider.transform(text: text, instruction: action.instruction)
        case .summarize:
            return try await provider.summarize(text: text)
        case .reply:
            return try await provider.generateReply(context: text, memories: memories, userTone: tone)
        }
    }

    private func sourceLine(_ app: NSRunningApplication?) -> String {
        guard let name = app?.localizedName else { return "" }
        return "in \(name)"
    }

    // MARK: - HUD

    private func showHUD(_ phase: QuickHUDState.Phase, title: String, message: String) {
        hudState.phase = phase
        hudState.title = title
        hudState.message = message

        let panel = hudPanel ?? makeHUDPanel()
        hudPanel = panel
        positionHUD(panel)
        panel.orderFrontRegardless()
    }

    private func makeHUDPanel() -> QuickHUDPanel {
        let panel = QuickHUDPanel()
        let hosting = NSHostingView(rootView: QuickHUDView(state: hudState))
        hosting.frame = panel.contentLayoutRect
        hosting.autoresizingMask = [.width, .height]
        panel.contentView = hosting
        return panel
    }

    private func positionHUD(_ panel: NSPanel) {
        let mouse = NSEvent.mouseLocation
        let screen = NSScreen.screens.first { $0.frame.contains(mouse) } ?? NSScreen.main
        guard let visible = screen?.visibleFrame else { return }
        let size = panel.frame.size
        let x = visible.midX - size.width / 2
        let y = visible.maxY - size.height - 24
        panel.setFrameOrigin(NSPoint(x: x, y: y))
    }

    private func scheduleDismiss(after seconds: Double) {
        dismissWork?.cancel()
        let work = DispatchWorkItem { [weak self] in
            self?.hudPanel?.orderOut(nil)
        }
        dismissWork = work
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: work)
    }
}
