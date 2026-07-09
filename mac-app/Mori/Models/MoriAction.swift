import Foundation

/// A single AI action Mori can run on selected text — built-in or user-made.
struct MoriAction: Identifiable, Codable, Hashable {
    enum Kind: String, Codable, CaseIterable {
        case transform   // apply `instruction` to the text (rewrite/fix/translate/…)
        case summarize   // summarize the text
        case reply       // draft a reply to the text (uses memories + tone)

        var label: String {
            switch self {
            case .transform: return "Transform"
            case .summarize: return "Summarize"
            case .reply: return "Reply"
            }
        }
    }

    var id: UUID
    var name: String
    var icon: String          // SF Symbol name
    var kind: Kind
    var instruction: String   // used when kind == .transform
    var summary: String?      // short human description shown in the UI
    var isBuiltIn: Bool
    var isEnabled: Bool

    init(
        id: UUID = UUID(),
        name: String,
        icon: String,
        kind: Kind = .transform,
        instruction: String = "",
        summary: String? = nil,
        isBuiltIn: Bool = false,
        isEnabled: Bool = true
    ) {
        self.id = id
        self.name = name
        self.icon = icon
        self.kind = kind
        self.instruction = instruction
        self.summary = summary
        self.isBuiltIn = isBuiltIn
        self.isEnabled = isEnabled
    }

    /// The subtitle to show — falls back to the built-in default, then the
    /// instruction, so older saved actions (without a summary) still read well.
    var displaySummary: String {
        if let summary, !summary.isEmpty { return summary }
        if let match = MoriAction.builtIns.first(where: { $0.id == id }), let s = match.summary, !s.isEmpty {
            return s
        }
        if kind == .transform, !instruction.isEmpty { return instruction }
        return kind.label
    }
}

extension MoriAction {
    /// Stable IDs so a chosen default action survives edits and relaunches.
    private static func id(_ s: String) -> UUID { UUID(uuidString: s)! }

    static let rewriteID = id("00000000-0000-0000-0000-000000000001")

    /// The shipped starter set. Users can edit, disable, reorder, or add more.
    static let builtIns: [MoriAction] = [
        MoriAction(id: rewriteID, name: "Rewrite", icon: "pencil.and.outline", kind: .transform,
                   instruction: "Rewrite this to be clearer and more natural while preserving the meaning and tone.",
                   summary: "Rewrite selected text in a cleaner tone.", isBuiltIn: true),
        MoriAction(id: id("00000000-0000-0000-0000-000000000002"), name: "Fix spelling & grammar", icon: "checkmark.seal", kind: .transform,
                   instruction: "Fix spelling, grammar, and punctuation. Keep the original meaning, tone, and formatting. Return only the corrected text.",
                   summary: "Correct grammar, spelling, and punctuation.", isBuiltIn: true),
        MoriAction(id: id("00000000-0000-0000-0000-000000000003"), name: "Make shorter", icon: "arrow.down.right.and.arrow.up.left", kind: .transform,
                   instruction: "Make this shorter and tighter without losing the key meaning.",
                   summary: "Condense text while preserving meaning.", isBuiltIn: true),
        MoriAction(id: id("00000000-0000-0000-0000-000000000004"), name: "Make clearer", icon: "sun.max", kind: .transform,
                   instruction: "Make this clearer and easier to understand. Simplify awkward phrasing.",
                   summary: "Improve clarity without changing the intent.", isBuiltIn: true),
        MoriAction(id: id("00000000-0000-0000-0000-000000000005"), name: "Make friendlier", icon: "face.smiling", kind: .transform,
                   instruction: "Make this warmer and friendlier while keeping the meaning and staying professional.",
                   summary: "Soften the tone and make it warmer.", isBuiltIn: true),
        MoriAction(id: id("00000000-0000-0000-0000-000000000006"), name: "Make professional", icon: "briefcase", kind: .transform,
                   instruction: "Rewrite this in a polished, professional tone suitable for work.",
                   summary: "Make the text polished and work-appropriate.", isBuiltIn: true),
        MoriAction(id: id("00000000-0000-0000-0000-000000000007"), name: "Summarize", icon: "text.append", kind: .summarize,
                   instruction: "", summary: "Turn long text into short useful notes.", isBuiltIn: true),
        MoriAction(id: id("00000000-0000-0000-0000-000000000008"), name: "Draft reply", icon: "arrowshape.turn.up.left", kind: .reply,
                   instruction: "", summary: "Create a reply using the provided context.", isBuiltIn: true),
    ]
}
