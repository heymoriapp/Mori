import AppKit
import Carbon.HIToolbox

/// Inserts text into the previously-focused app by placing it on the clipboard
/// and simulating Cmd+V. This ONLY happens on an explicit user click, and only
/// when Accessibility is granted. Otherwise we leave the text on the clipboard
/// and tell the user we copied instead.
enum InsertTextService {

    /// - Returns: true if a paste was simulated, false if we could only copy.
    @discardableResult
    static func insert(_ text: String, into app: NSRunningApplication?, restoreClipboard: Bool) -> Bool {
        guard AccessibilityService.isTrusted else {
            ClipboardService.write(text)
            return false
        }

        let previousClipboard = restoreClipboard ? ClipboardService.read() : nil

        // Return focus to the app the user was in, then paste.
        app?.activate(options: [])
        ClipboardService.write(text)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
            postCommandV()
            if let previousClipboard {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    ClipboardService.write(previousClipboard)
                }
            }
        }
        return true
    }

    private static func postCommandV() {
        let source = CGEventSource(stateID: .combinedSessionState)
        let vKey = CGKeyCode(kVK_ANSI_V)

        let keyDown = CGEvent(keyboardEventSource: source, virtualKey: vKey, keyDown: true)
        keyDown?.flags = .maskCommand
        let keyUp = CGEvent(keyboardEventSource: source, virtualKey: vKey, keyDown: false)
        keyUp?.flags = .maskCommand

        keyDown?.post(tap: .cgAnnotatedSessionEventTap)
        keyUp?.post(tap: .cgAnnotatedSessionEventTap)
    }
}
