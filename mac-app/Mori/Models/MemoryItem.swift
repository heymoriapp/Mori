import Foundation

/// Where a memory came from. Kept small and honest for v1.
enum MemorySourceType: String, Codable, CaseIterable {
    case manual        // typed by the user in the library
    case generated     // saved from a Mori draft
    case selectedText  // captured from another app's selection
    case note          // quick note

    var label: String {
        switch self {
        case .manual: return "Manual"
        case .generated: return "Generated"
        case .selectedText: return "Selection"
        case .note: return "Note"
        }
    }
}

/// A single local memory. Stored on-device as JSON.
struct MemoryItem: Identifiable, Codable, Hashable {
    var id: UUID
    var title: String
    var body: String
    var sourceApp: String?
    var sourceType: MemorySourceType
    var tags: [String]
    var createdAt: Date
    var updatedAt: Date
    var lastUsedAt: Date?
    var isPinned: Bool
    var isArchived: Bool

    init(
        id: UUID = UUID(),
        title: String,
        body: String,
        sourceApp: String? = nil,
        sourceType: MemorySourceType = .manual,
        tags: [String] = [],
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        lastUsedAt: Date? = nil,
        isPinned: Bool = false,
        isArchived: Bool = false
    ) {
        self.id = id
        self.title = title
        self.body = body
        self.sourceApp = sourceApp
        self.sourceType = sourceType
        self.tags = tags
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.lastUsedAt = lastUsedAt
        self.isPinned = isPinned
        self.isArchived = isArchived
    }

    /// A compact one-line preview for lists.
    var preview: String {
        let trimmed = body.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.replacingOccurrences(of: "\n", with: " ")
    }
}
