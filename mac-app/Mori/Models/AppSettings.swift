import Foundation
import Combine

/// Non-secret user preferences, persisted in UserDefaults.
/// The API key is NOT stored here — it lives in the Keychain (see KeychainService).
final class AppSettings: ObservableObject {
    static let shared = AppSettings()

    private let defaults = UserDefaults.standard

    // MARK: General
    @Published var defaultMode: ComposerMode {
        didSet { defaults.set(defaultMode.rawValue, forKey: Keys.defaultMode) }
    }
    @Published var launchAtLogin: Bool {
        didSet {
            defaults.set(launchAtLogin, forKey: Keys.launchAtLogin)
            LaunchAtLoginService.setEnabled(launchAtLogin)
        }
    }
    @Published var hasCompletedOnboarding: Bool {
        didSet { defaults.set(hasCompletedOnboarding, forKey: Keys.hasCompletedOnboarding) }
    }

    // MARK: AI
    @Published var providerKind: AIProviderKind {
        didSet { defaults.set(providerKind.rawValue, forKey: Keys.providerKind) }
    }
    @Published var model: String {
        didSet { defaults.set(model, forKey: Keys.model) }
    }
    /// Optional custom base URL (for OpenAI-compatible gateways). Empty = provider default.
    @Published var customBaseURL: String {
        didSet { defaults.set(customBaseURL, forKey: Keys.customBaseURL) }
    }
    @Published var userTone: String {
        didSet { defaults.set(userTone, forKey: Keys.userTone) }
    }

    // MARK: Quick action
    /// When true, ⌥M runs the default Action on the current selection in place
    /// (no composer) if text is selected. With nothing selected, ⌥M opens the
    /// composer instead.
    @Published var enableQuickAction: Bool {
        didSet { defaults.set(enableQuickAction, forKey: Keys.enableQuickAction) }
    }
    /// The Action ⌥M runs (UUID string). See ActionStore.defaultAction.
    @Published var defaultActionID: String? {
        didSet { defaults.set(defaultActionID, forKey: Keys.defaultActionID) }
    }
    /// Preview-first (default): ⌥M opens the composer so you can review, edit,
    /// copy, or insert before applying — rather than replacing text instantly.
    @Published var showComposerBeforeInsert: Bool {
        didSet { defaults.set(showComposerBeforeInsert, forKey: Keys.showComposerBeforeInsert) }
    }

    // MARK: Privacy
    @Published var isPaused: Bool {
        didSet { defaults.set(isPaused, forKey: Keys.isPaused) }
    }
    @Published var enableSelectedTextCapture: Bool {
        didSet { defaults.set(enableSelectedTextCapture, forKey: Keys.enableSelectedTextCapture) }
    }
    @Published var requireManualPasteOnly: Bool {
        didSet { defaults.set(requireManualPasteOnly, forKey: Keys.requireManualPasteOnly) }
    }
    @Published var restoreClipboardAfterInsert: Bool {
        didSet { defaults.set(restoreClipboardAfterInsert, forKey: Keys.restoreClipboardAfterInsert) }
    }
    @Published var excludedApps: [String] {
        didSet { defaults.set(excludedApps, forKey: Keys.excludedApps) }
    }

    private init() {
        let modeRaw = defaults.string(forKey: Keys.defaultMode) ?? ComposerMode.reply.rawValue
        defaultMode = ComposerMode(rawValue: modeRaw) ?? .reply
        launchAtLogin = defaults.bool(forKey: Keys.launchAtLogin)
        hasCompletedOnboarding = defaults.bool(forKey: Keys.hasCompletedOnboarding)

        let providerRaw = defaults.string(forKey: Keys.providerKind) ?? AIProviderKind.openAI.rawValue
        providerKind = AIProviderKind(rawValue: providerRaw) ?? .openAI
        model = defaults.string(forKey: Keys.model) ?? AIProviderKind.openAI.defaultModel
        customBaseURL = defaults.string(forKey: Keys.customBaseURL) ?? ""
        userTone = defaults.string(forKey: Keys.userTone) ?? ""

        enableQuickAction = defaults.object(forKey: Keys.enableQuickAction) as? Bool ?? true
        defaultActionID = defaults.string(forKey: Keys.defaultActionID)
        showComposerBeforeInsert = defaults.object(forKey: Keys.showComposerBeforeInsert) as? Bool ?? true

        isPaused = defaults.bool(forKey: Keys.isPaused)
        // Capture defaults ON but always user-triggered.
        enableSelectedTextCapture = defaults.object(forKey: Keys.enableSelectedTextCapture) as? Bool ?? true
        requireManualPasteOnly = defaults.object(forKey: Keys.requireManualPasteOnly) as? Bool ?? false
        restoreClipboardAfterInsert = defaults.object(forKey: Keys.restoreClipboardAfterInsert) as? Bool ?? true
        excludedApps = defaults.stringArray(forKey: Keys.excludedApps) ?? []
    }

    /// Reset the model field to the current provider's default.
    func resetModelToDefault() {
        model = providerKind.defaultModel
    }

    private enum Keys {
        static let defaultMode = "defaultMode"
        static let launchAtLogin = "launchAtLogin"
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let providerKind = "providerKind"
        static let model = "model"
        static let customBaseURL = "customBaseURL"
        static let userTone = "userTone"
        static let enableQuickAction = "enableQuickAction"
        static let defaultActionID = "defaultActionID"
        static let showComposerBeforeInsert = "showComposerBeforeInsert"
        static let isPaused = "isPaused"
        static let enableSelectedTextCapture = "enableSelectedTextCapture"
        static let requireManualPasteOnly = "requireManualPasteOnly"
        static let restoreClipboardAfterInsert = "restoreClipboardAfterInsert"
        static let excludedApps = "excludedApps"
    }
}
