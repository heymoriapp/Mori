import Foundation
import Combine

struct HistoryItem: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var actionName: String
    var input: String
    var output: String
    var createdAt: Date = Date()

    var shortTitle: String {
        let base = output.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "\n", with: " ")
        return String(base.prefix(48))
    }
}

/// A small ring buffer of recent results, so nothing Mori writes is ever lost.
/// Local JSON, capped, newest first.
final class HistoryStore: ObservableObject {
    static let shared = HistoryStore()

    @Published private(set) var items: [HistoryItem] = []

    private let cap = 30
    private let fileURL: URL

    init() {
        let base = FileManager.default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
            .appendingPathComponent("Mori", isDirectory: true)
        try? FileManager.default.createDirectory(at: base, withIntermediateDirectories: true)
        fileURL = base.appendingPathComponent("history.json")
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([HistoryItem].self, from: data) {
            items = decoded
        }
    }

    func record(actionName: String, input: String, output: String) {
        let item = HistoryItem(actionName: actionName, input: input, output: output)
        items.insert(item, at: 0)
        if items.count > cap { items = Array(items.prefix(cap)) }
        persist()
    }

    func clear() {
        items.removeAll()
        persist()
    }

    private func persist() {
        let snapshot = items
        DispatchQueue.global(qos: .utility).async { [fileURL] in
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(snapshot) {
                try? data.write(to: fileURL, options: .atomic)
            }
        }
    }
}
