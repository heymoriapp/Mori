import AppKit
import SwiftUI

/// Owns every window Mori shows: the floating composer panel plus the
/// onboarding, memory library and preferences windows. Centralising this keeps
/// a menu-bar (accessory) app's window behaviour deterministic.
final class WindowManager: NSObject {
    static let shared = WindowManager()

    /// Shared composer view-model so the panel and the hotkey can talk to it.
    let composerVM = ComposerViewModel()

    /// The app the user was in when they summoned Mori (for insert + capture).
    private(set) var previousApp: NSRunningApplication?

    private var composerPanel: FloatingPanel?
    private var palettePanel: ActionsPalettePanel?
    private var paletteModel: PaletteModel?
    private var onboardingWindow: NSWindow?
    private var memoryWindow: NSWindow?
    private var preferencesWindow: NSWindow?

    private override init() { super.init() }

    // MARK: - Composer

    func toggleComposer() {
        if let panel = composerPanel, panel.isVisible {
            hideComposer()
        } else {
            openComposer()
        }
    }

    func openComposer(prefill: String? = nil, capturedApp: NSRunningApplication? = nil, preferredMode: ComposerMode? = nil) {
        let prev = capturedApp ?? NSWorkspace.shared.frontmostApplication
        previousApp = prev

        let settings = AppSettings.shared
        var selection = prefill
        if selection == nil, settings.enableSelectedTextCapture, !settings.requireManualPasteOnly {
            selection = AccessibilityService.selectedText()
        }
        composerVM.prepare(selection: selection, sourceApp: prev?.localizedName ?? AccessibilityService.frontmostAppName, preferredMode: preferredMode)

        let panel = composerPanel ?? makeComposerPanel()
        composerPanel = panel
        panel.layoutIfNeeded()
        position(panel)
        NSApp.activate(ignoringOtherApps: true)
        panel.makeKeyAndOrderFront(nil)
    }

    func hideComposer() {
        composerPanel?.orderOut(nil)
    }

    // MARK: - Actions Palette

    /// ⌥⇧M: with a selection, show the palette; otherwise open the composer.
    func showActionsPalette() {
        let prev = NSWorkspace.shared.frontmostApplication

        guard AccessibilityService.isTrusted,
              let selection = AccessibilityService.selectedText(),
              !selection.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else {
            openComposer()
            return
        }

        let model = PaletteModel(actions: ActionStore.shared.enabled)
        model.onPick = { [weak self] action in
            self?.hideActionsPalette()
            QuickActionService.shared.apply(action, selection: selection, previousApp: prev)
        }
        model.onOpenComposer = { [weak self] in
            self?.hideActionsPalette()
            self?.openComposer(prefill: selection, capturedApp: prev)
        }
        model.onClose = { [weak self] in self?.hideActionsPalette() }

        let panel = makePalettePanel(model)
        palettePanel = panel
        paletteModel = model
        position(panel)
        NSApp.activate(ignoringOtherApps: true)
        panel.makeKeyAndOrderFront(nil)
    }

    func hideActionsPalette() {
        palettePanel?.orderOut(nil)
    }

    private func makePalettePanel(_ model: PaletteModel) -> ActionsPalettePanel {
        let hosting = NSHostingView(rootView: ActionsPaletteView(model: model))
        let panel = ActionsPalettePanel()
        hosting.frame = panel.contentLayoutRect
        hosting.autoresizingMask = [.width, .height]
        panel.contentView = hosting
        panel.model = model
        panel.delegate = self
        return panel
    }

    @discardableResult
    func insertIntoPreviousApp(_ text: String) -> Bool {
        hideComposer()
        return InsertTextService.insert(
            text,
            into: previousApp,
            restoreClipboard: AppSettings.shared.restoreClipboardAfterInsert
        )
    }

    private func makeComposerPanel() -> FloatingPanel {
        let root = ComposerView()
            .environmentObject(AppSettings.shared)
            .environmentObject(MemoryStore.shared)
            .environmentObject(composerVM)
        // Fixed-size hosting view. (Auto-resizing the panel from SwiftUI content
        // via NSHostingController.preferredContentSize can throw inside AppKit's
        // autolayout display cycle and crash — so we use a stable fixed size and
        // let the composer's draft area flex/scroll internally instead.)
        let hosting = NSHostingView(rootView: root)
        let panel = FloatingPanel(contentRect: NSRect(x: 0, y: 0, width: 804, height: 584))
        hosting.frame = panel.contentLayoutRect
        hosting.autoresizingMask = [.width, .height]
        panel.contentView = hosting
        panel.delegate = self
        return panel
    }

    private func position(_ panel: NSPanel) {
        let mouse = NSEvent.mouseLocation
        let screen = NSScreen.screens.first { $0.frame.contains(mouse) } ?? NSScreen.main
        guard let visible = screen?.visibleFrame else { return }
        let size = panel.frame.size
        let x = visible.midX - size.width / 2
        let y = visible.midY - size.height / 2 + visible.height * 0.12
        panel.setFrameOrigin(NSPoint(x: x, y: y))
    }

    // MARK: - Onboarding

    func showOnboarding() {
        if onboardingWindow == nil {
            let root = OnboardingView(onFinish: { [weak self] in
                AppSettings.shared.hasCompletedOnboarding = true
                self?.onboardingWindow?.close()
                self?.onboardingWindow = nil
            })
            .environmentObject(AppSettings.shared)
            onboardingWindow = makeWindow(
                title: "Welcome to Mori",
                size: NSSize(width: 560, height: 620),
                view: AnyView(root),
                resizable: false
            )
        }
        present(onboardingWindow)
    }

    // MARK: - Memory Library

    func showMemoryLibrary(createNew: Bool = false) {
        if memoryWindow == nil {
            let root = MemoryLibraryView()
                .environmentObject(MemoryStore.shared)
            memoryWindow = makeWindow(
                title: "Mori — Memory Library",
                size: NSSize(width: 820, height: 560),
                view: AnyView(root),
                resizable: true
            )
        }
        present(memoryWindow)
        if createNew {
            NotificationCenter.default.post(name: .moriCreateMemory, object: nil)
        }
    }

    // MARK: - Preferences

    func showPreferences(selectTab tab: PreferencesTab? = nil) {
        if preferencesWindow == nil {
            let root = PreferencesView()
                .environmentObject(AppSettings.shared)
                .environmentObject(MemoryStore.shared)
            preferencesWindow = makeWindow(
                title: "Mori — Preferences",
                size: NSSize(width: 580, height: 600),
                view: AnyView(root),
                resizable: false
            )
        }
        present(preferencesWindow)
        if let tab {
            // Defer so the window/TabView is live before switching tabs.
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .moriSelectPreferencesTab, object: tab)
            }
        }
    }

    // MARK: - Helpers

    private func makeWindow(title: String, size: NSSize, view: AnyView, resizable: Bool) -> NSWindow {
        var style: NSWindow.StyleMask = [.titled, .closable, .miniaturizable]
        if resizable { style.insert(.resizable) }
        let window = NSWindow(
            contentRect: NSRect(origin: .zero, size: size),
            styleMask: style,
            backing: .buffered,
            defer: false
        )
        window.title = title
        window.titlebarAppearsTransparent = true
        window.isReleasedWhenClosed = false
        window.delegate = self
        window.center()
        window.contentView = NSHostingView(rootView: view)
        return window
    }

    private func present(_ window: NSWindow?) {
        guard let window else { return }
        NSApp.setActivationPolicy(.regular) // show in Dock while a real window is open
        NSApp.activate(ignoringOtherApps: true)
        window.makeKeyAndOrderFront(nil)
    }
}

extension WindowManager: NSWindowDelegate {
    /// Click-away dismisses the composer / palette, Spotlight-style.
    func windowDidResignKey(_ notification: Notification) {
        guard let window = notification.object as? NSWindow else { return }
        if window == composerPanel { hideComposer() }
        if window == palettePanel { hideActionsPalette() }
    }

    /// When the last regular window closes, drop back to accessory (menu-bar only).
    func windowWillClose(_ notification: Notification) {
        DispatchQueue.main.async {
            let hasVisibleRegularWindow = [self.memoryWindow, self.preferencesWindow, self.onboardingWindow]
                .compactMap { $0 }
                .contains { $0.isVisible }
            if !hasVisibleRegularWindow {
                NSApp.setActivationPolicy(.accessory)
            }
        }
    }
}

extension Notification.Name {
    static let moriCreateMemory = Notification.Name("moriCreateMemory")
}
