import Foundation
import Security

/// Minimal Keychain wrapper for the AI API key. Secrets never touch UserDefaults.
///
/// The value is **cached in memory** after the first read, so the Keychain is
/// touched at most once per launch. This matters because ad-hoc-signed dev/beta
/// builds get a new code signature each build, which makes macOS re-prompt for
/// authorization on every Keychain read — caching keeps that to a single prompt
/// per launch instead of one per SwiftUI re-render.
enum KeychainService {
    private static let service = "app.heymori.Mori"
    private static let account = "ai-api-key"

    // In-memory cache. `loaded` means we've read the Keychain once this launch.
    private static var loaded = false
    private static var cached: String?

    static var apiKey: String? {
        get {
            if !loaded {
                cached = read(account: account)
                loaded = true
            }
            return cached
        }
        set {
            let value = newValue?.trimmingCharacters(in: .whitespacesAndNewlines)
            if let value, !value.isEmpty {
                write(value, account: account)
                cached = value
            } else {
                delete(account: account)
                cached = nil
            }
            loaded = true
        }
    }

    static var hasAPIKey: Bool {
        !(apiKey ?? "").isEmpty
    }

    // MARK: - Generic helpers

    private static func write(_ value: String, account: String) {
        let data = Data(value.utf8)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
        ]
        // Upsert: try update first, then add.
        let attributes: [String: Any] = [kSecValueData as String: data]
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        if status == errSecItemNotFound {
            var addQuery = query
            addQuery[kSecValueData as String] = data
            addQuery[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock
            SecItemAdd(addQuery as CFDictionary, nil)
        }
    }

    private static func read(account: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess, let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }

    private static func delete(account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
        ]
        SecItemDelete(query as CFDictionary)
    }
}
