import Foundation
import Combine

/// Local memory store. Persists to a JSON file in Application Support and does
/// no networking itself — memories stay on this Mac unless the user exports them.
final class MemoryStore: ObservableObject {
    static let shared = MemoryStore()

    @Published private(set) var items: [MemoryItem] = []

    private let search: MemorySearchService = KeywordMemorySearch()
    private let fileURL: URL
    private let queue = DispatchQueue(label: "app.heymori.Mori.memory", qos: .utility)

    init(searchService: MemorySearchService = KeywordMemorySearch()) {
        let fm = FileManager.default
        let base = fm.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
            .appendingPathComponent("Mori", isDirectory: true)
        try? fm.createDirectory(at: base, withIntermediateDirectories: true)
        self.fileURL = base.appendingPathComponent("memories.json")
        load()
    }

    /// Human-readable path shown in Preferences → Memory.
    var storageLocation: String { fileURL.path }

    // MARK: - Queries

    func search(_ query: String) -> [MemoryItem] {
        search.search(query, in: items)
    }

    var pinned: [MemoryItem] { items.filter { $0.isPinned && !$0.isArchived } }

    // MARK: - Mutations

    @discardableResult
    func add(
        title: String,
        body: String,
        sourceType: MemorySourceType = .manual,
        sourceApp: String? = nil,
        tags: [String] = []
    ) -> MemoryItem {
        let item = MemoryItem(
            title: title.isEmpty ? Self.derivedTitle(from: body) : title,
            body: body,
            sourceApp: sourceApp,
            sourceType: sourceType,
            tags: tags
        )
        items.insert(item, at: 0)
        persist()
        return item
    }

    func update(_ item: MemoryItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        var updated = item
        updated.updatedAt = Date()
        items[index] = updated
        persist()
    }

    func markUsed(_ id: UUID) {
        guard let index = items.firstIndex(where: { $0.id == id }) else { return }
        items[index].lastUsedAt = Date()
        persist()
    }

    func togglePin(_ id: UUID) {
        guard let index = items.firstIndex(where: { $0.id == id }) else { return }
        items[index].isPinned.toggle()
        items[index].updatedAt = Date()
        persist()
    }

    func delete(_ id: UUID) {
        items.removeAll { $0.id == id }
        persist()
    }

    func clearAll() {
        items.removeAll()
        persist()
    }

    func deleteArchived() {
        items.removeAll { $0.isArchived }
        persist()
    }

    // MARK: - Import / Export

    func exportJSON() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        return try encoder.encode(items)
    }

    func importJSON(_ data: Data, merge: Bool = true) throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let imported = try decoder.decode([MemoryItem].self, from: data)
        if merge {
            let existingIDs = Set(items.map { $0.id })
            items.append(contentsOf: imported.filter { !existingIDs.contains($0.id) })
        } else {
            items = imported
        }
        persist()
    }

    // MARK: - Persistence

    private func load() {
        guard let data = try? Data(contentsOf: fileURL) else { return }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        if let decoded = try? decoder.decode([MemoryItem].self, from: data) {
            items = decoded
        }
    }

    private func persist() {
        let snapshot = items
        queue.async { [fileURL] in
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            encoder.dateEncodingStrategy = .iso8601
            if let data = try? encoder.encode(snapshot) {
                try? data.write(to: fileURL, options: .atomic)
            }
        }
    }

    // MARK: - Helpers

    static func derivedTitle(from body: String) -> String {
        let firstLine = body
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: "\n")
            .first
            .map(String.init) ?? "Untitled memory"
        return String(firstLine.prefix(60))
    }
}
