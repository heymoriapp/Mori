import Foundation

/// Abstraction so a smarter search (embeddings / vectors) can drop in later
/// without touching the store or views.
protocol MemorySearchService {
    func search(_ query: String, in items: [MemoryItem]) -> [MemoryItem]
}

/// v1: simple, dependable keyword scoring. Pinned items win ties; recent wins after that.
struct KeywordMemorySearch: MemorySearchService {
    func search(_ query: String, in items: [MemoryItem]) -> [MemoryItem] {
        let active = items.filter { !$0.isArchived }
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        guard !trimmed.isEmpty else {
            return active.sorted { lhs, rhs in
                if lhs.isPinned != rhs.isPinned { return lhs.isPinned }
                return lhs.updatedAt > rhs.updatedAt
            }
        }

        let terms = trimmed.split(whereSeparator: { $0 == " " || $0 == "\n" }).map(String.init)

        func score(_ item: MemoryItem) -> Int {
            let haystackTitle = item.title.lowercased()
            let haystackBody = item.body.lowercased()
            let haystackTags = item.tags.joined(separator: " ").lowercased()
            var s = 0
            for term in terms {
                if haystackTitle.contains(term) { s += 3 }
                if haystackTags.contains(term) { s += 2 }
                if haystackBody.contains(term) { s += 1 }
            }
            if item.isPinned { s += 1 }
            return s
        }

        return active
            .map { ($0, score($0)) }
            .filter { $0.1 > 0 }
            .sorted { lhs, rhs in
                if lhs.1 != rhs.1 { return lhs.1 > rhs.1 }
                return lhs.0.updatedAt > rhs.0.updatedAt
            }
            .map { $0.0 }
    }
}
