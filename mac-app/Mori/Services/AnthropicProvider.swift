import Foundation

/// Talks to the Anthropic Messages API. Included to prove the provider layer
/// is swappable; the app ships with OpenAI-compatible selected by default.
struct AnthropicProvider: AIProvider {
    let apiKey: String
    let model: String
    let baseURL: String

    func generateReply(context: String, memories: [MemoryItem], userTone: String?) async throws -> String {
        try await complete(
            system: MoriPrompts.reply + MoriPrompts.toneClause(userTone),
            user: MoriPrompts.replyUserMessage(context: context, memories: memories)
        )
    }

    func rewrite(text: String, instruction: String?) async throws -> String {
        try await complete(
            system: MoriPrompts.rewrite,
            user: MoriPrompts.rewriteUserMessage(text: text, instruction: instruction)
        )
    }

    func summarize(text: String) async throws -> String {
        try await complete(system: MoriPrompts.summarize, user: "TEXT:\n\(text)")
    }

    func transform(text: String, instruction: String) async throws -> String {
        try await complete(
            system: MoriPrompts.transform,
            user: MoriPrompts.transformUserMessage(text: text, instruction: instruction)
        )
    }

    func recall(question: String, memories: [MemoryItem]) async throws -> String {
        try await complete(
            system: MoriPrompts.recall,
            user: MoriPrompts.recallUserMessage(question: question, memories: memories)
        )
    }

    func testConnection() async throws -> Bool {
        let reply = try await complete(system: "You are a health check.", user: "Reply with the single word: ok")
        return !reply.isEmpty
    }

    private func complete(system: String, user: String) async throws -> String {
        guard !apiKey.isEmpty else { throw AIError.missingAPIKey }
        guard let url = URL(string: baseURL.trimmedSlash + "/v1/messages") else { throw AIError.badURL }

        let payload = MessagesRequest(
            model: model,
            max_tokens: 1024,
            system: system,
            messages: [.init(role: "user", content: user)]
        )

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        request.httpBody = try JSONEncoder().encode(payload)
        request.timeoutInterval = 60

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw AIError.network(error.localizedDescription)
        }

        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw AIError.http(http.statusCode, String(data: data, encoding: .utf8) ?? "")
        }

        do {
            let decoded = try JSONDecoder().decode(MessagesResponse.self, from: data)
            let text = decoded.content
                .compactMap { $0.text }
                .joined()
                .trimmingCharacters(in: .whitespacesAndNewlines)
            guard !text.isEmpty else { throw AIError.emptyResponse }
            return text
        } catch let error as AIError {
            throw error
        } catch {
            throw AIError.decoding(error.localizedDescription)
        }
    }

    private struct MessagesRequest: Encodable {
        let model: String
        let max_tokens: Int
        let system: String
        let messages: [Message]
        struct Message: Encodable {
            let role: String
            let content: String
        }
    }

    private struct MessagesResponse: Decodable {
        let content: [Block]
        struct Block: Decodable {
            let type: String
            let text: String?
        }
    }
}
