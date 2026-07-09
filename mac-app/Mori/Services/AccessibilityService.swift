import AppKit
import ApplicationServices

/// Reads the *currently selected text* from the frontmost app via the
/// Accessibility API — only when the user triggers Mori, never in the background.
enum AccessibilityService {

    /// Whether Mori is trusted for Accessibility (System Settings → Privacy → Accessibility).
    static var isTrusted: Bool {
        AXIsProcessTrusted()
    }

    /// Ask macOS to show the Accessibility prompt for Mori.
    static func requestTrust() {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary
        _ = AXIsProcessTrustedWithOptions(options)
    }

    /// Open the Accessibility pane in System Settings directly.
    static func openSystemSettings() {
        let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!
        NSWorkspace.shared.open(url)
    }

    static var frontmostAppName: String? {
        NSWorkspace.shared.frontmostApplication?.localizedName
    }

    /// Best-effort read of the selected text in the focused UI element.
    /// Returns nil if Accessibility is not granted or the app doesn't expose a selection.
    static func selectedText() -> String? {
        guard isTrusted else { return nil }

        let systemWide = AXUIElementCreateSystemWide()
        var focused: AnyObject?
        guard AXUIElementCopyAttributeValue(systemWide, kAXFocusedUIElementAttribute as CFString, &focused) == .success,
              let focusedElement = focused
        else { return nil }

        let element = focusedElement as! AXUIElement

        // 1) Try the direct selected-text attribute.
        var selected: AnyObject?
        if AXUIElementCopyAttributeValue(element, kAXSelectedTextAttribute as CFString, &selected) == .success,
           let text = selected as? String,
           !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return text
        }

        // 2) Fall back to selected range within the value string.
        var rangeValue: AnyObject?
        var valueObject: AnyObject?
        if AXUIElementCopyAttributeValue(element, kAXSelectedTextRangeAttribute as CFString, &rangeValue) == .success,
           AXUIElementCopyAttributeValue(element, kAXValueAttribute as CFString, &valueObject) == .success,
           let full = valueObject as? String,
           let axValue = rangeValue,
           CFGetTypeID(axValue) == AXValueGetTypeID() {
            var cfRange = CFRange()
            if AXValueGetValue(axValue as! AXValue, .cfRange, &cfRange), cfRange.length > 0 {
                let ns = full as NSString
                if cfRange.location >= 0, cfRange.location + cfRange.length <= ns.length {
                    let sub = ns.substring(with: NSRange(location: cfRange.location, length: cfRange.length))
                    if !sub.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return sub }
                }
            }
        }

        return nil
    }
}
