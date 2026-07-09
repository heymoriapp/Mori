import AppKit

/// Thin wrapper over NSPasteboard. All clipboard use in Mori is user-triggered.
enum ClipboardService {
    static func read() -> String? {
        NSPasteboard.general.string(forType: .string)
    }

    static func write(_ text: String) {
        let pb = NSPasteboard.general
        pb.clearContents()
        pb.setString(text, forType: .string)
    }
}
