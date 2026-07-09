import AppKit
import Carbon.HIToolbox

/// Wires app lifecycle to the global hotkeys and first-run onboarding.
final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Menu-bar utility: no Dock icon until a real window opens.
        NSApp.setActivationPolicy(.accessory)

        // Keep launch-at-login in sync with the stored preference.
        LaunchAtLoginService.setEnabled(AppSettings.shared.launchAtLogin)

        registerHotkeys()

        // First run → onboarding.
        if !AppSettings.shared.hasCompletedOnboarding {
            WindowManager.shared.showOnboarding()
        }
    }

    private func registerHotkeys() {
        // ⌥M → run the default Action on the selection in place (or composer if nothing selected).
        HotkeyService.shared.register(
            .quickAction,
            keyCode: UInt32(kVK_ANSI_M),
            modifiers: UInt32(optionKey)
        ) {
            guard !AppSettings.shared.isPaused else { return }
            QuickActionService.shared.handleInstant()
        }

        // ⌥⇧M → Actions palette (or composer if nothing selected).
        HotkeyService.shared.register(
            .composer,
            keyCode: UInt32(kVK_ANSI_M),
            modifiers: UInt32(optionKey | shiftKey)
        ) {
            guard !AppSettings.shared.isPaused else { return }
            WindowManager.shared.showActionsPalette()
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        HotkeyService.shared.unregisterAll()
    }

    /// Reopen (e.g. clicking the app) opens the composer.
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        WindowManager.shared.toggleComposer()
        return true
    }
}
