import SwiftUI
import Combine

/// Drives the AI tab: reads/writes the API key to Keychain and tests the
/// connection, exposing an honest connection status (never faked).
final class PreferencesViewModel: ObservableObject {
    enum ConnectionStatus: Equatable {
        case notTested
        case connected
        case failed(String)
        case missingKey
    }

    @Published var apiKey: String = ""
    @Published var isTesting: Bool = false
    @Published var status: ConnectionStatus

    private let settings: AppSettings

    init(settings: AppSettings = .shared) {
        self.settings = settings
        self.apiKey = KeychainService.apiKey ?? ""
        self.status = KeychainService.hasAPIKey ? .notTested : .missingKey
    }

    var hasStoredKey: Bool { KeychainService.hasAPIKey }

    func saveAPIKey() {
        KeychainService.apiKey = apiKey.trimmingCharacters(in: .whitespacesAndNewlines)
        status = KeychainService.hasAPIKey ? .notTested : .missingKey
    }

    func clearAPIKey() {
        apiKey = ""
        KeychainService.apiKey = nil
        status = .missingKey
    }

    /// Reset to untested when the provider/model changes.
    func markUntested() {
        status = KeychainService.hasAPIKey ? .notTested : .missingKey
    }

    func testConnection() {
        saveAPIKey()
        guard let provider = AIProviderFactory.make(settings: settings) else {
            status = .missingKey
            return
        }
        isTesting = true
        Task {
            do {
                let ok = try await provider.testConnection()
                await MainActor.run {
                    self.isTesting = false
                    self.status = ok ? .connected : .failed("No response from the provider.")
                }
            } catch {
                let message = (error as? AIError)?.errorDescription ?? error.localizedDescription
                await MainActor.run {
                    self.isTesting = false
                    self.status = .failed(message)
                }
            }
        }
    }
}
