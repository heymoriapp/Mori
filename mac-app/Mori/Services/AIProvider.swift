import Foundation

/// Which backend a provider talks to. Adding a new one = new enum case + new type.
enum AIProviderKind: String, CaseIterable, Identifiable {
    case openAI = "openai"
    case anthropic = "anthropic"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .openAI: return "OpenAI-compatible"
        case .anthropic: return "Anthropic"
        }
    }

    var defaultModel: String {
        switch self {
        case .openAI: return "gpt-4o-mini"
        case .anthropic: return "claude-3-5-sonnet-latest"
        }
    }

    var defaultBaseURL: String {
        switch self {
        case .openAI: return "https://api.openai.com/v1"
        case .anthropic: return "https://api.anthropic.com"
        }
    }

    var apiKeyHint: String {
        switch self {
        case .openAI: return "sk-…  (OpenAI or any OpenAI-compatible gateway)"
        case .anthropic: return "sk-ant-…"
        }
    }
}

/// The single abstraction every mode goes through. Swap implementations freely.
protocol AIProvider {
    func generateReply(context: String, memories: [MemoryItem], userTone: String?) async throws -> String
    func rewrite(text: String, instruction: String?) async throws -> String
    func summarize(text: String) async throws -> String
    func recall(question: String, memories: [MemoryItem]) async throws -> String
    /// Apply an arbitrary instruction to text — the engine behind custom Actions.
    func transform(text: String, instruction: String) async throws -> String
    func testConnection() async throws -> Bool
}

enum AIError: LocalizedError {
    case missingAPIKey
    case badURL
    case http(Int, String)
    case emptyResponse
    case decoding(String)
    case network(String)

    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "No API key set. Add one in Preferences → AI."
        case .badURL:
            return "The provider base URL looks invalid."
        case .http(let code, let message):
            return "Provider error \(code): \(message)"
        case .emptyResponse:
            return "The provider returned an empty response."
        case .decoding(let detail):
            return "Couldn't read the provider response. \(detail)"
        case .network(let detail):
            return "Network error: \(detail)"
        }
    }
}

/// Builds the AIProvider for the current settings + Keychain key, or nil if unset.
enum AIProviderFactory {
    static func make(settings: AppSettings = .shared) -> AIProvider? {
        guard let key = KeychainService.apiKey, !key.isEmpty else { return nil }
        let base = settings.customBaseURL.trimmingCharacters(in: .whitespaces)
        let baseURL = base.isEmpty ? settings.providerKind.defaultBaseURL : base
        let model = settings.model.isEmpty ? settings.providerKind.defaultModel : settings.model

        switch settings.providerKind {
        case .openAI:
            return OpenAICompatibleProvider(apiKey: key, model: model, baseURL: baseURL)
        case .anthropic:
            return AnthropicProvider(apiKey: key, model: model, baseURL: baseURL)
        }
    }
}
