import Foundation

/// The four things Mori can do with a piece of context.
enum ComposerMode: String, CaseIterable, Identifiable, Codable {
    case reply = "Reply"
    case rewrite = "Rewrite"
    case summarize = "Summarize"
    case recall = "Recall"

    var id: String { rawValue }

    var systemImage: String {
        switch self {
        case .reply: return "arrowshape.turn.up.left"
        case .rewrite: return "pencil.and.outline"
        case .summarize: return "text.append"
        case .recall: return "magnifyingglass"
        }
    }

    /// Placeholder shown in the context box for this mode.
    var contextPlaceholder: String {
        switch self {
        case .reply: return "Paste the message or thread you want to reply to…"
        case .rewrite: return "Paste the text you want to rewrite more clearly…"
        case .summarize: return "Paste the text you want summarized…"
        case .recall: return "Ask a question — Mori answers from your saved memories…"
        }
    }

    var actionTitle: String {
        switch self {
        case .reply: return "Draft reply"
        case .rewrite: return "Rewrite"
        case .summarize: return "Summarize"
        case .recall: return "Recall"
        }
    }

    /// Recall works off a question, so empty context is allowed.
    var requiresContext: Bool { self != .recall }
}
