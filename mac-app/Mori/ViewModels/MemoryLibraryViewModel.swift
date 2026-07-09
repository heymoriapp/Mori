import SwiftUI
import Combine
import UniformTypeIdentifiers

/// Drives the Memory Library window: search, select, edit, import/export.
final class MemoryLibraryViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var selectedID: MemoryItem.ID?

    private let store: MemoryStore

    init(store: MemoryStore = .shared) {
        self.store = store
    }

    var results: [MemoryItem] {
        store.search(query)
    }

    var selected: MemoryItem? {
        guard let selectedID else { return nil }
        return store.items.first { $0.id == selectedID }
    }

    // MARK: Mutations

    func createMemory() {
        let item = store.add(title: "New memory", body: "", sourceType: .manual)
        selectedID = item.id
    }

    func save(_ item: MemoryItem) {
        store.update(item)
    }

    func togglePin(_ id: MemoryItem.ID) {
        store.togglePin(id)
    }

    func delete(_ id: MemoryItem.ID) {
        store.delete(id)
        if selectedID == id { selectedID = nil }
    }

    func clearAll() {
        store.clearAll()
        selectedID = nil
    }

    // MARK: Import / Export

    func exportMemories() {
        let panel = NSSavePanel()
        panel.allowedContentTypes = [.json]
        panel.nameFieldStringValue = "mori-memories.json"
        panel.begin { response in
            guard response == .OK, let url = panel.url else { return }
            do {
                let data = try self.store.exportJSON()
                try data.write(to: url)
            } catch {
                Self.showError("Couldn't export memories", error.localizedDescription)
            }
        }
    }

    func importMemories() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.json]
        panel.allowsMultipleSelection = false
        panel.begin { response in
            guard response == .OK, let url = panel.url else { return }
            do {
                let data = try Data(contentsOf: url)
                try self.store.importJSON(data, merge: true)
            } catch {
                Self.showError("Couldn't import memories", "The file couldn't be read as a valid Mori backup.")
            }
        }
    }

    private static func showError(_ title: String, _ message: String) {
        let alert = NSAlert()
        alert.alertStyle = .warning
        alert.messageText = title
        alert.informativeText = message
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
}
