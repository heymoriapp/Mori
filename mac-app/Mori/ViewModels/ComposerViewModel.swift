import SwiftUI
import Combine

/// Drives the floating composer: capture context, generate, copy, insert, save.
/// Not @MainActor — all mutations happen on the main thread by convention, and
/// async provider results are hopped back to main via `MainActor.run`.
final class ComposerViewModel: ObservableObject {
    @Published var mode: ComposerMode
    @Published var contextText: String = ""
    @Published var draft: String = ""
    @Published var isGenerating: Bool = false
    @Published var status: String = ""
    @Published var sourceApp: String?
    @Published var needsSetup: Bool = false

    private let settings: AppSettings
    private let memory: MemoryStore

    init(settings: AppSettings = .shared, memory: MemoryStore = .shared) {
        self.settings = settings
        self.memory = memory
        self.mode = settings.defaultMode
    }

    /// Called by WindowManager each time the composer opens.
    func prepare(selection: String?, sourceApp: String?, preferredMode: ComposerMode? = nil) {
        self.sourceApp = sourceApp
        self.draft = ""
        self.isGenerating = false
        self.mode = preferredMode ?? settings.defaultMode
        self.needsSetup = !KeychainService.hasAPIKey

        if let selection, !selection.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            contextText = selection
            status = "Read selection from \(sourceApp ?? "the current app")."
        } else {
            status = needsSetup ? "" : "Paste or type context, then Generate."
        }
    }

    /// Generation needs an API key AND some context/question.
    var canGenerate: Bool {
        guard !isGenerating, KeychainService.hasAPIKey else { return false }
        return !contextText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var hasDraft: Bool {
        !draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    // MARK: Actions

    func pasteClipboard() {
        if let clip = ClipboardService.read(), !clip.isEmpty {
            contextText = clip
            status = "Pasted from clipboard."
        } else {
            status = "Clipboard is empty."
        }
    }

    func readSelection() {
        guard AccessibilityService.isTrusted else {
            status = "Enable Accessibility in Preferences → Privacy to read selections."
            return
        }
        if let selection = AccessibilityService.selectedText() {
            contextText = selection
            sourceApp = AccessibilityService.frontmostAppName
            status = "Read selection from \(sourceApp ?? "the current app")."
        } else {
            status = "No selected text found in the active app."
        }
    }

    func generate() {
        guard !isGenerating else { return }
        let context = contextText.trimmingCharacters(in: .whitespacesAndNewlines)
        if mode.requiresContext && context.isEmpty {
            status = "Add or paste some context first."
            return
        }
        guard let provider = AIProviderFactory.make(settings: settings) else {
            needsSetup = true
            status = "Add your API key in Preferences → AI to generate."
            return
        }

        isGenerating = true
        status = "Mori is thinking…"
        let currentMode = mode
        let tone = settings.userTone.isEmpty ? nil : settings.userTone

        let memories = currentMode == .reply ? relevantMemories(for: context) : memory.search(context)

        Task {
            do {
                let result: String
                switch currentMode {
                case .reply:
                    result = try await provider.generateReply(context: context, memories: memories, userTone: tone)
                case .rewrite:
                    result = try await provider.rewrite(text: context, instruction: nil)
                case .summarize:
                    result = try await provider.summarize(text: context)
                case .recall:
                    result = try await provider.recall(question: context, memories: memories)
                }
                await MainActor.run {
                    self.draft = result
                    self.isGenerating = false
                    self.status = "Draft ready."
                    HistoryStore.shared.record(actionName: currentMode.rawValue, input: context, output: result)
                }
            } catch {
                let message = (error as? AIError)?.errorDescription ?? error.localizedDescription
                await MainActor.run {
                    self.isGenerating = false
                    self.status = message
                }
            }
        }
    }

    func copyDraft() {
        guard !draft.isEmpty else { return }
        ClipboardService.write(draft)
        status = "Copied to clipboard."
    }

    func insertDraft() {
        guard !draft.isEmpty else { return }
        let inserted = WindowManager.shared.insertIntoPreviousApp(draft)
        status = inserted
            ? "Inserted into \(sourceApp ?? "the app")."
            : "Copied instead — enable Accessibility to insert directly."
    }

    func saveToMemory() {
        let content = draft.isEmpty ? contextText : draft
        guard !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            status = "Nothing to save yet."
            return
        }
        _ = memory.add(
            title: MemoryStore.derivedTitle(from: content),
            body: content,
            sourceType: draft.isEmpty ? .selectedText : .generated,
            sourceApp: sourceApp
        )
        status = "Saved to memory."
    }

    func forget() {
        draft = ""
        contextText = ""
        status = "Cleared."
    }

    func close() {
        WindowManager.shared.hideComposer()
    }

    // MARK: Helpers

    private func relevantMemories(for context: String) -> [MemoryItem] {
        let found = memory.search(context)
        return found.isEmpty ? memory.pinned : Array(found.prefix(6))
    }
}
