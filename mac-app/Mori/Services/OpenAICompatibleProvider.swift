import Foundation

/// Talks to the OpenAI Chat Completions API (or any OpenAI-compatible gateway).
struct OpenAICompatibleProvider: AIProvider {
    let apiKey: String
    let model: String
    let baseURL: String

    // MARK: AIProvider

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

    // MARK: Networking

    private func complete(system: String, user: String) async throws -> String {
        guard !apiKey.isEmpty else { throw AIError.missingAPIKey }
        guard let url = URL(string: baseURL.trimmedSlash + "/chat/completions") else { throw AIError.badURL }

        let payload = ChatRequest(
            model: model,
            messages: [
                .init(role: "system", content: system),
                .init(role: "user", content: user),
            ],
            temperature: 0.5
        )

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
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
            let decoded = try JSONDecoder().decode(ChatResponse.self, from: data)
            let text = decoded.choices.first?.message.content?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            guard !text.isEmpty else { throw AIError.emptyResponse }
            return text
        } catch let error as AIError {
            throw error
        } catch {
            throw AIError.decoding(error.localizedDescription)
        }
    }

    // MARK: Codable

    private struct ChatRequest: Encodable {
        let model: String
        let messages: [Message]
        let temperature: Double
        struct Message: Encodable {
            let role: String
            let content: String
        }
    }

    private struct ChatResponse: Decodable {
        let choices: [Choice]
        struct Choice: Decodable {
            let message: Message
        }
        struct Message: Decodable {
            let content: String?
        }
    }
}

extension String {
    /// Trim a single trailing slash so base URLs concatenate cleanly.
    var trimmedSlash: String {
        hasSuffix("/") ? String(dropLast()) : self
    }
}
