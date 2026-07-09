import Foundation
import Combine

/// Stores the user's Actions (built-in + custom) as an ordered list in a local
/// JSON file. Seeded with the built-in starter set on first launch.
final class ActionStore: ObservableObject {
    static let shared = ActionStore()

    @Published private(set) var actions: [MoriAction] = []

    private let fileURL: URL
    private let queue = DispatchQueue(label: "app.heymori.Mori.actions", qos: .utility)

    init() {
        let base = FileManager.default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
            .appendingPathComponent("Mori", isDirectory: true)
        try? FileManager.default.createDirectory(at: base, withIntermediateDirectories: true)
        fileURL = base.appendingPathComponent("actions.json")
        load()
    }

    var enabled: [MoriAction] { actions.filter { $0.isEnabled } }

    /// The action ⌥M runs, resolved from settings (falls back to Rewrite / first).
    func defaultAction(settings: AppSettings = .shared) -> MoriAction? {
        if let idString = settings.defaultActionID, let uuid = UUID(uuidString: idString),
           let match = enabled.first(where: { $0.id == uuid }) {
            return match
        }
        return enabled.first(where: { $0.id == MoriAction.rewriteID }) ?? enabled.first
    }

    // MARK: Mutations

    @discardableResult
    func add(name: String = "New action", icon: String = "wand.and.stars", instruction: String = "") -> MoriAction {
        let action = MoriAction(name: name, icon: icon, kind: .transform, instruction: instruction, isBuiltIn: false)
        actions.append(action)
        persist()
        return action
    }

    func update(_ action: MoriAction) {
        guard let i = actions.firstIndex(where: { $0.id == action.id }) else { return }
        actions[i] = action
        persist()
    }

    /// Duplicate any action into an editable custom copy, placed right after it.
    @discardableResult
    func duplicate(_ action: MoriAction) -> MoriAction {
        let copy = MoriAction(
            name: action.name + " copy",
            icon: action.icon,
            kind: action.kind,
            instruction: action.instruction,
            summary: action.summary,
            isBuiltIn: false,
            isEnabled: true
        )
        if let idx = actions.firstIndex(where: { $0.id == action.id }) {
            actions.insert(copy, at: idx + 1)
        } else {
            actions.append(copy)
        }
        persist()
        return copy
    }

    func delete(_ id: MoriAction.ID) {
        actions.removeAll { $0.id == id && !$0.isBuiltIn }
        persist()
    }

    func move(from source: IndexSet, to destination: Int) {
        actions.move(fromOffsets: source, toOffset: destination)
        persist()
    }

    func resetToDefaults() {
        actions = MoriAction.builtIns
        persist()
    }

    // MARK: Persistence

    private func load() {
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([MoriAction].self, from: data),
           !decoded.isEmpty {
            actions = decoded
        } else {
            actions = MoriAction.builtIns
            persist()
        }
    }

    private func persist() {
        let snapshot = actions
        queue.async { [fileURL] in
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            if let data = try? encoder.encode(snapshot) {
                try? data.write(to: fileURL, options: .atomic)
            }
        }
    }
}
