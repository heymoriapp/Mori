import Foundation

/// Central home for Mori's system prompts and prompt formatting.
/// Keeping these together makes the product's "voice" easy to tune.
enum MoriPrompts {
    static let reply = """
    You are Mori, a private Mac writing companion. Draft a concise, natural reply \
    in the user's tone. Use only the provided context and relevant memories. \
    Do not invent facts, names, dates, or commitments. If something is unknown, \
    leave it out rather than guessing. Return only the reply text — no preamble.
    """

    static let rewrite = """
    You are Mori. Rewrite the text to be clearer and more natural while preserving \
    its meaning and intent. Keep it roughly the same length unless the instruction \
    says otherwise. Return only the rewritten text.
    """

    static let summarize = """
    You are Mori. Summarize the text into short, useful notes. Prefer a few tight \
    bullet points over prose. Capture decisions, dates, owners, and open questions. \
    Return only the summary.
    """

    static let recall = """
    You are Mori. Answer the user's question using ONLY their local memories below. \
    If the memories don't contain enough information, say so plainly and do not guess. \
    Cite the memory titles you used when helpful.
    """

    static let transform = """
    You are Mori, a private Mac writing companion. Apply the user's instruction to \
    the text and return ONLY the resulting text — no preamble, no quotes, no \
    explanation. Preserve the user's meaning and any important details, names, and \
    numbers. Match the language of the text unless the instruction says otherwise.
    """

    static func transformUserMessage(text: String, instruction: String) -> String {
        """
        INSTRUCTION: \(instruction)

        TEXT:
        \(text)
        """
    }

    static func toneClause(_ tone: String?) -> String {
        guard let tone, !tone.trimmingCharacters(in: .whitespaces).isEmpty else { return "" }
        return "\n\nThe user describes their tone as: \(tone)."
    }

    /// Render memories as a compact, bounded block for the prompt.
    static func memoriesBlock(_ memories: [MemoryItem], limit: Int = 8, maxBodyChars: Int = 400) -> String {
        let usable = memories.filter { !$0.isArchived }.prefix(limit)
        guard !usable.isEmpty else { return "(no saved memories)" }
        return usable.map { item in
            let body = item.body.count > maxBodyChars
                ? String(item.body.prefix(maxBodyChars)) + "…"
                : item.body
            return "• \(item.title): \(body)"
        }.joined(separator: "\n")
    }

    static func replyUserMessage(context: String, memories: [MemoryItem]) -> String {
        """
        CONTEXT TO REPLY TO:
        \(context.isEmpty ? "(none provided)" : context)

        RELEVANT MEMORIES:
        \(memoriesBlock(memories))
        """
    }

    static func rewriteUserMessage(text: String, instruction: String?) -> String {
        let instr = (instruction?.isEmpty == false) ? "\nINSTRUCTION: \(instruction!)" : ""
        return "TEXT:\n\(text)\(instr)"
    }

    static func recallUserMessage(question: String, memories: [MemoryItem]) -> String {
        """
        QUESTION:
        \(question)

        MEMORIES:
        \(memoriesBlock(memories, limit: 12))
        """
    }
}
