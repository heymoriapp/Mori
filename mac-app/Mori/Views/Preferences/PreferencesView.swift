import SwiftUI
import AppKit

enum PreferencesTab: Hashable {
    case general, actions, ai, privacy, memory, about
}

extension Notification.Name {
    static let moriSelectPreferencesTab = Notification.Name("moriSelectPreferencesTab")
}

struct PreferencesView: View {
    @State private var selection: PreferencesTab = .general

    var body: some View {
        TabView(selection: $selection) {
            GeneralPrefs().tabItem { Label("General", systemImage: "gearshape") }.tag(PreferencesTab.general)
            ActionsPrefs().tabItem { Label("Actions", systemImage: "wand.and.stars") }.tag(PreferencesTab.actions)
            AIPrefs().tabItem { Label("AI", systemImage: "sparkles") }.tag(PreferencesTab.ai)
            PrivacyPrefs().tabItem { Label("Privacy", systemImage: "lock.shield") }.tag(PreferencesTab.privacy)
            MemoryPrefs().tabItem { Label("Memory", systemImage: "tray.full") }.tag(PreferencesTab.memory)
            AboutPrefs().tabItem { Label("About", systemImage: "leaf") }.tag(PreferencesTab.about)
        }
        .frame(width: 580, height: 600)
        .background(Theme.background)
        .onReceive(NotificationCenter.default.publisher(for: .moriSelectPreferencesTab)) { note in
            if let tab = note.object as? PreferencesTab { selection = tab }
        }
    }
}

// MARK: - General

private struct GeneralPrefs: View {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject private var actionStore = ActionStore.shared

    private var defaultActionBinding: Binding<String> {
        Binding(
            get: { settings.defaultActionID ?? actionStore.defaultAction()?.id.uuidString ?? "" },
            set: { settings.defaultActionID = $0 }
        )
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                SettingsSection("Startup") {
                    SettingsCard {
                        settingRow("Launch Mori at login") {
                            Toggle("", isOn: $settings.launchAtLogin).labelsHidden().toggleStyle(.switch)
                        }
                    }
                }

                SettingsSection("Quick Action") {
                    SettingsCard {
                        settingRow("Prepare default action on ⌥M") {
                            Toggle("", isOn: $settings.enableQuickAction).labelsHidden().toggleStyle(.switch)
                        }
                        rowDivider
                        settingRow("Default action") {
                            Picker("", selection: defaultActionBinding) {
                                ForEach(actionStore.enabled) { Text($0.name).tag($0.id.uuidString) }
                            }
                            .labelsHidden().pickerStyle(.menu).fixedSize()
                            .disabled(!settings.enableQuickAction)
                        }
                        rowDivider
                        settingRow("Show composer before inserting") {
                            Toggle("", isOn: $settings.showComposerBeforeInsert).labelsHidden().toggleStyle(.switch)
                        }
                    }
                    helperText("With text selected, ⌥M prepares the default action. You can preview, edit, copy, or insert before applying.")
                }

                SettingsSection("Shortcuts", accessory: { MVPBadge() }) {
                    SettingsCard {
                        settingRow("Run default action") { KeyCombo(["⌥", "M"]) }
                        rowDivider
                        settingRow("Actions palette") { KeyCombo(["⇧", "⌥", "M"]) }
                    }
                }

                SettingsSection("Composer") {
                    SettingsCard {
                        settingRow("Default composer mode") {
                            Picker("", selection: $settings.defaultMode) {
                                ForEach(ComposerMode.allCases) { Text($0.rawValue).tag($0) }
                            }
                            .labelsHidden().pickerStyle(.menu).fixedSize()
                        }
                    }
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Theme.background)
    }

    @ViewBuilder
    private func settingRow<Control: View>(_ title: String, @ViewBuilder control: () -> Control) -> some View {
        HStack(spacing: 12) {
            Text(title)
                .font(.system(size: 13))
                .foregroundStyle(Theme.ink)
            Spacer(minLength: 12)
            control()
        }
        .padding(.horizontal, 14)
        .frame(minHeight: 42)
    }

    private var rowDivider: some View {
        Rectangle().fill(Theme.border).frame(height: 1).padding(.leading, 14)
    }

    private func helperText(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 12))
            .foregroundStyle(Theme.ink.opacity(0.55))
            .fixedSize(horizontal: false, vertical: true)
            .padding(.leading, 6)
            .padding(.top, 1)
    }
}

// MARK: - General tab building blocks

/// A titled group: small section title (with optional trailing accessory) over
/// a single soft card — matching the About tab's warm, native feel.
private struct SettingsSection<Accessory: View, Content: View>: View {
    let title: String
    let accessory: () -> Accessory
    let content: () -> Content

    init(_ title: String,
         @ViewBuilder content: @escaping () -> Content) where Accessory == EmptyView {
        self.title = title
        self.accessory = { EmptyView() }
        self.content = content
    }

    init(_ title: String,
         @ViewBuilder accessory: @escaping () -> Accessory,
         @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.accessory = accessory
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Theme.muted)
                Spacer()
                accessory()
            }
            .padding(.horizontal, 6)
            content()
        }
    }
}

private struct SettingsCard<Content: View>: View {
    @ViewBuilder let content: () -> Content
    var body: some View {
        VStack(spacing: 0) { content() }
            .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Theme.card))
            .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Theme.border, lineWidth: 1))
    }
}

/// A native-feeling keyboard keycap: off-white with a soft top highlight,
/// dark text, thin border, and a hint of depth.
private struct MacKeyCap: View {
    let label: String
    var body: some View {
        Text(label)
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(Theme.ink)
            .frame(minWidth: 22, minHeight: 22)
            .padding(.horizontal, 5)
            .background(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(LinearGradient(
                        colors: [Color.white.opacity(0.85), Theme.card],
                        startPoint: .top, endPoint: .bottom
                    ))
            )
            .overlay(RoundedRectangle(cornerRadius: 6, style: .continuous).stroke(Theme.border, lineWidth: 1))
            .shadow(color: Color.black.opacity(0.07), radius: 0.5, x: 0, y: 1)
    }
}

private struct KeyCombo: View {
    let keys: [String]
    init(_ keys: [String]) { self.keys = keys }
    var body: some View {
        HStack(spacing: 4) {
            ForEach(keys, id: \.self) { MacKeyCap(label: $0) }
        }
    }
}

private struct MVPBadge: View {
    var body: some View {
        Text("Fixed in MVP")
            .font(.system(size: 10, weight: .medium))
            .foregroundStyle(Theme.muted)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(Capsule().fill(Theme.background))
            .overlay(Capsule().stroke(Theme.border, lineWidth: 1))
    }
}

// MARK: - Actions

private struct ActionsPrefs: View {
    @ObservedObject private var store = ActionStore.shared
    @State private var selectedID: MoriAction.ID?
    @State private var showResetConfirm = false

    private var selectedAction: MoriAction? {
        store.actions.first { $0.id == selectedID }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            header

            if store.actions.isEmpty {
                emptyState
            } else {
                listCard
                if let action = selectedAction {
                    ActionDetails(
                        action: action,
                        store: store,
                        onSelect: { selectedID = $0 },
                        onDeleted: { selectedID = store.actions.first?.id }
                    )
                    .id(action.id)
                }
            }

            Spacer(minLength: 0)
            footerNote
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Theme.background)
        .onAppear {
            if selectedID == nil { selectedID = store.actions.first?.id }
        }
        .confirmationDialog("Reset actions to defaults?", isPresented: $showResetConfirm, titleVisibility: .visible) {
            Button("Reset Actions", role: .destructive) {
                store.resetToDefaults()
                selectedID = store.actions.first?.id
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This restores the built-in actions and removes any custom actions you've added.")
        }
    }

    private var header: some View {
        HStack(spacing: 8) {
            Text("Actions")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Theme.ink)
            Spacer()
            Button {
                let action = store.add()
                selectedID = action.id
            } label: {
                Label("Add", systemImage: "plus")
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.small)
            .tint(Theme.forest)

            Button("Reset") { showResetConfirm = true }
                .buttonStyle(.bordered)
                .controlSize(.small)
        }
    }

    private var listCard: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(Array(store.actions.enumerated()), id: \.element.id) { index, action in
                    ActionRow(
                        action: action,
                        selected: action.id == selectedID,
                        onSelect: { selectedID = action.id },
                        onToggle: { newValue in
                            var updated = action
                            updated.isEnabled = newValue
                            store.update(updated)
                        }
                    )
                    if index < store.actions.count - 1 {
                        Rectangle()
                            .fill(Theme.border.opacity(0.55))
                            .frame(height: 1)
                            .padding(.leading, 12)
                    }
                }
            }
        }
        .frame(height: 216)
        .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Theme.card))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Theme.border, lineWidth: 1))
    }

    private var emptyState: some View {
        VStack(spacing: 10) {
            Image(systemName: "wand.and.stars").font(.system(size: 30)).foregroundStyle(Theme.moss)
            Text("No actions yet.").font(.system(size: 14, weight: .medium)).foregroundStyle(Theme.ink)
            Text("Create your first Mori action.").font(.system(size: 12)).foregroundStyle(Theme.muted)
            Button {
                let action = store.add()
                selectedID = action.id
            } label: { Label("Add action", systemImage: "plus") }
                .buttonStyle(.borderedProminent).controlSize(.small).tint(Theme.forest)
                .padding(.top, 2)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Theme.card))
        .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Theme.border, lineWidth: 1))
    }

    private var footerNote: some View {
        Text("Actions decide what Mori does when you press ⌥M or open the actions palette.")
            .font(.system(size: 12))
            .foregroundStyle(Theme.ink.opacity(0.5))
            .fixedSize(horizontal: false, vertical: true)
            .padding(.leading, 2)
    }
}

/// A single row in the action list, with hover + selected states.
private struct ActionRow: View {
    let action: MoriAction
    let selected: Bool
    let onSelect: () -> Void
    let onToggle: (Bool) -> Void
    @State private var hovering = false

    var body: some View {
        HStack(spacing: 12) {
            Toggle("", isOn: Binding(get: { action.isEnabled }, set: onToggle))
                .labelsHidden()
                .toggleStyle(.switch)
                .controlSize(.small)

            Image(systemName: action.icon)
                .font(.system(size: 13))
                .foregroundStyle(action.isEnabled ? Theme.forest : Theme.moss.opacity(0.6))
                .frame(width: 20)

            VStack(alignment: .leading, spacing: 1) {
                Text(action.name)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(action.isEnabled ? Theme.ink : Theme.muted)
                Text(action.displaySummary)
                    .font(.system(size: 11.5))
                    .foregroundStyle(Theme.ink.opacity(0.48))
                    .lineLimit(1)
            }

            Spacer(minLength: 8)

            Image(systemName: "chevron.right")
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(Theme.muted.opacity(selected ? 0.7 : 0.35))
        }
        .padding(.horizontal, 12)
        .frame(minHeight: 44)
        .background(
            selected ? Theme.softGreen.opacity(0.5)
                : (hovering ? Theme.softGreen.opacity(0.2) : Color.clear)
        )
        .contentShape(Rectangle())
        .onTapGesture { onSelect() }
        .onHover { hovering = $0 }
    }
}

/// A small moss pill used only in the details panel.
private struct BuiltInPill: View {
    var body: some View {
        Text("Built-in")
            .font(.system(size: 10, weight: .medium))
            .foregroundStyle(Theme.forest)
            .padding(.horizontal, 7)
            .padding(.vertical, 2)
            .background(Capsule().fill(Theme.softGreen.opacity(0.6)))
    }
}

/// The details / editor panel for the selected action.
private struct ActionDetails: View {
    let action: MoriAction
    @ObservedObject var store: ActionStore
    let onSelect: (MoriAction.ID) -> Void
    let onDeleted: () -> Void

    @State private var name: String
    @State private var icon: String
    @State private var kind: MoriAction.Kind
    @State private var instruction: String
    @State private var testResult: String?
    @State private var testing = false

    private let sample = "hey, just checking if we're still on for the 3pm sync tomorrow — lmk if that time doesnt work for u"

    init(action: MoriAction, store: ActionStore, onSelect: @escaping (MoriAction.ID) -> Void, onDeleted: @escaping () -> Void) {
        self.action = action
        self.store = store
        self.onSelect = onSelect
        self.onDeleted = onDeleted
        _name = State(initialValue: action.name)
        _icon = State(initialValue: action.icon)
        _kind = State(initialValue: action.kind)
        _instruction = State(initialValue: action.instruction)
    }

    private var enabledBinding: Binding<Bool> {
        Binding(get: { action.isEnabled }, set: { v in
            var u = action; u.isEnabled = v; store.update(u)
        })
    }

    private var promptPreview: String {
        switch action.kind {
        case .transform: return action.instruction.isEmpty ? "—" : action.instruction
        case .summarize: return "Summarizes the selected text into short, useful notes."
        case .reply: return "Drafts a reply using the selected text as context."
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            headerRow

            if action.isBuiltIn {
                Text(action.displaySummary)
                    .font(.system(size: 13))
                    .foregroundStyle(Theme.ink.opacity(0.62))
                promptBox(promptPreview, editable: false)
                Text("Built-in actions can’t be edited, but you can duplicate one to customize it.")
                    .font(.system(size: 12))
                    .foregroundStyle(Theme.muted)
            } else {
                customFields
            }

            buttons

            if testing || testResult != nil { resultBox }
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Theme.card))
        .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Theme.border, lineWidth: 1))
    }

    private var headerRow: some View {
        HStack(spacing: 10) {
            Image(systemName: action.icon)
                .font(.system(size: 15))
                .foregroundStyle(Theme.forest)
                .frame(width: 22)
            Text(action.name)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Theme.ink)
            if action.isBuiltIn { BuiltInPill() }
            Spacer()
            Toggle("", isOn: enabledBinding)
                .labelsHidden()
                .toggleStyle(.switch)
                .controlSize(.small)
        }
    }

    private var customFields: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: icon.isEmpty ? "questionmark" : icon)
                    .foregroundStyle(Theme.forest).frame(width: 22)
                TextField("Name", text: $name).textFieldStyle(.roundedBorder)
            }
            HStack(spacing: 8) {
                TextField("SF Symbol (e.g. wand.and.stars)", text: $icon).textFieldStyle(.roundedBorder)
                Picker("", selection: $kind) {
                    ForEach(MoriAction.Kind.allCases, id: \.self) { Text($0.label).tag($0) }
                }
                .labelsHidden().pickerStyle(.menu).fixedSize()
            }
            if kind == .transform {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Prompt").moriLabelStyle()
                    TextEditor(text: $instruction)
                        .font(.system(size: 12))
                        .frame(minHeight: 58)
                        .scrollContentBackground(.hidden)
                        .padding(6)
                        .background(Theme.background)
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 8, style: .continuous).stroke(Theme.border, lineWidth: 1))
                }
            } else {
                Text(promptPreview).font(.system(size: 12)).foregroundStyle(Theme.muted)
            }
        }
    }

    private func promptBox(_ text: String, editable: Bool) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Prompt").moriLabelStyle()
            Text(text)
                .font(.system(size: 12))
                .foregroundStyle(Theme.ink.opacity(0.7))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                .background(Theme.background)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 8, style: .continuous).stroke(Theme.border, lineWidth: 1))
        }
    }

    private var buttons: some View {
        HStack(spacing: 8) {
            Button { runTest() } label: { Label("Test Action", systemImage: "play") }
                .buttonStyle(.bordered).controlSize(.small).disabled(testing)
            Button { let copy = store.duplicate(action); onSelect(copy.id) } label: {
                Label("Duplicate", systemImage: "plus.square.on.square")
            }
            .buttonStyle(.bordered).controlSize(.small)

            if !action.isBuiltIn {
                Button("Save") { save() }
                    .buttonStyle(.borderedProminent).controlSize(.small).tint(Theme.forest)
                Spacer()
                Button(role: .destructive) {
                    store.delete(action.id); onDeleted()
                } label: { Label("Delete", systemImage: "trash") }
                    .buttonStyle(.bordered).controlSize(.small)
            } else {
                Spacer()
            }
        }
    }

    private var resultBox: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("Result").moriLabelStyle()
                Spacer()
                if let testResult {
                    Button("Copy") { ClipboardService.write(testResult) }
                        .buttonStyle(.plain)
                        .font(.system(size: 11))
                        .foregroundStyle(Theme.forest)
                }
            }
            if testing {
                HStack(spacing: 6) {
                    ProgressView().controlSize(.small)
                    Text("Testing on a sample…").font(.system(size: 12)).foregroundStyle(Theme.muted)
                }
            } else if let testResult {
                Text(testResult)
                    .font(.system(size: 12))
                    .foregroundStyle(Theme.ink)
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(10)
        .background(Theme.background)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 8, style: .continuous).stroke(Theme.border, lineWidth: 1))
    }

    private func runTest() {
        guard let provider = AIProviderFactory.make() else {
            testResult = "Add an API key in the AI tab to test actions."
            return
        }
        let runKind = action.isBuiltIn ? action.kind : kind
        let runInstruction = action.isBuiltIn ? action.instruction : instruction
        testing = true
        testResult = nil
        Task {
            do {
                let out: String
                switch runKind {
                case .transform: out = try await provider.transform(text: sample, instruction: runInstruction)
                case .summarize: out = try await provider.summarize(text: sample)
                case .reply: out = try await provider.generateReply(context: sample, memories: [], userTone: nil)
                }
                await MainActor.run { testResult = out; testing = false }
            } catch {
                let message = (error as? AIError)?.errorDescription ?? error.localizedDescription
                await MainActor.run { testResult = message; testing = false }
            }
        }
    }

    private func save() {
        var updated = action
        updated.name = name.isEmpty ? "Untitled action" : name
        updated.icon = icon.isEmpty ? "wand.and.stars" : icon
        updated.kind = kind
        updated.instruction = instruction
        store.update(updated)
    }
}

// MARK: - AI

private struct AIPrefs: View {
    @EnvironmentObject private var settings: AppSettings
    @StateObject private var vm = PreferencesViewModel()
    @State private var showRemoveKeyConfirm = false

    private var modelName: String {
        settings.model.isEmpty ? settings.providerKind.defaultModel : settings.model
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                providerSection
                apiKeySection
                toneSection
                privacyNote
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Theme.background)
        .confirmationDialog("Remove API key?", isPresented: $showRemoveKeyConfirm, titleVisibility: .visible) {
            Button("Remove Key", role: .destructive) { vm.clearAPIKey() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This deletes your API key from the macOS Keychain. Mori won't be able to generate until you add a key again.")
        }
    }

    // MARK: Provider

    private var providerSection: some View {
        SettingsSection("Provider") {
            SettingsCard {
                fieldRow("Provider") {
                    Picker("", selection: $settings.providerKind) {
                        ForEach(AIProviderKind.allCases) { Text($0.displayName).tag($0) }
                    }
                    .labelsHidden().pickerStyle(.menu).fixedSize()
                    .onChange(of: settings.providerKind) { _, _ in
                        settings.resetModelToDefault()
                        vm.markUntested()
                    }
                    Spacer()
                }
                CardDivider()
                fieldRow("Model") {
                    TextField(settings.providerKind.defaultModel, text: $settings.model)
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: .infinity)
                        .onChange(of: settings.model) { _, _ in vm.markUntested() }
                }
                CardDivider()
                fieldRow("Base URL") {
                    TextField(settings.providerKind.defaultBaseURL, text: $settings.customBaseURL)
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: .infinity)
                }
            }
            helper("Use OpenAI or any OpenAI-compatible gateway.")
        }
    }

    // MARK: API key

    private var apiKeySection: some View {
        SettingsSection("API key") {
            SettingsCard {
                fieldRow("API key") {
                    SecureField(settings.providerKind.apiKeyHint, text: $vm.apiKey)
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: .infinity)
                }
                CardDivider()
                HStack(spacing: 8) {
                    Button("Save key") { vm.saveAPIKey() }
                        .buttonStyle(.borderedProminent).controlSize(.small).tint(Theme.forest)
                    Button(vm.isTesting ? "Testing…" : "Test connection") { vm.testConnection() }
                        .buttonStyle(.bordered).controlSize(.small).disabled(vm.isTesting)
                    Spacer()
                    SubtleDestructiveButton(title: "Remove") {
                        if vm.hasStoredKey { showRemoveKeyConfirm = true } else { vm.clearAPIKey() }
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                CardDivider()
                HStack(spacing: 8) {
                    Text("Status").font(.system(size: 12)).foregroundStyle(Theme.muted)
                    statusPill
                    Spacer()
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
            }
            helper("Stored securely in macOS Keychain.")
            if case .failed(let message) = vm.status {
                Text(message)
                    .font(.system(size: 11.5))
                    .foregroundStyle(Theme.clay)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.leading, 6)
            }
        }
    }

    @ViewBuilder
    private var statusPill: some View {
        if vm.isTesting {
            pill("Testing…", Theme.border.opacity(0.4), Theme.muted)
        } else {
            switch vm.status {
            case .notTested:
                pill("Not tested", Theme.border.opacity(0.45), Theme.muted)
            case .connected:
                pill("Connected · \(modelName) ready", Theme.softGreen.opacity(0.7), Theme.forest)
            case .failed:
                pill("Failed", Theme.softClay.opacity(0.7), Theme.clay)
            case .missingKey:
                pill("Missing API key", Theme.softClay.opacity(0.45), Theme.clay)
            }
        }
    }

    private func pill(_ text: String, _ bg: Color, _ fg: Color) -> some View {
        Text(text)
            .font(.system(size: 11, weight: .medium))
            .foregroundStyle(fg)
            .padding(.horizontal, 9)
            .padding(.vertical, 3)
            .background(Capsule().fill(bg))
    }

    // MARK: Your tone

    private var toneSection: some View {
        SettingsSection("Your tone") {
            SettingsCard {
                VStack(alignment: .leading, spacing: 10) {
                    ZStack(alignment: .topLeading) {
                        if settings.userTone.isEmpty {
                            Text("warm, brief, a little playful")
                                .font(.system(size: 13))
                                .foregroundStyle(Theme.muted.opacity(0.7))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 8)
                                .allowsHitTesting(false)
                        }
                        TextEditor(text: $settings.userTone)
                            .font(.system(size: 13))
                            .foregroundStyle(Theme.ink)
                            .scrollContentBackground(.hidden)
                            .frame(minHeight: 62)
                            .padding(4)
                    }
                    .background(Theme.background)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 8, style: .continuous).stroke(Theme.border, lineWidth: 1))

                    HStack(spacing: 6) {
                        ForEach(["Brief", "Friendly", "Professional"], id: \.self) { chip in
                            ToneChip(label: chip) { addTone(chip) }
                        }
                        Spacer()
                    }
                }
                .padding(14)
            }
            helper("Mori uses this when drafting replies. You can leave it blank.")
        }
    }

    private func addTone(_ word: String) {
        let lower = word.lowercased()
        let current = settings.userTone.trimmingCharacters(in: .whitespacesAndNewlines)
        if current.isEmpty {
            settings.userTone = lower
        } else if !current.lowercased().contains(lower) {
            settings.userTone = current + ", " + lower
        }
    }

    private var privacyNote: some View {
        Text("AI processing depends on your selected provider and settings. Mori only sends the context you choose to use.")
            .font(.system(size: 12))
            .foregroundStyle(Theme.ink.opacity(0.5))
            .fixedSize(horizontal: false, vertical: true)
            .padding(.leading, 2)
    }

    // MARK: Row + helper

    @ViewBuilder
    private func fieldRow<Control: View>(_ label: String, @ViewBuilder control: () -> Control) -> some View {
        HStack(spacing: 12) {
            Text(label)
                .font(.system(size: 13))
                .foregroundStyle(Theme.ink)
                .frame(width: 108, alignment: .leading)
            control()
        }
        .padding(.horizontal, 14)
        .frame(minHeight: 46)
    }

    private func helper(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 12))
            .foregroundStyle(Theme.ink.opacity(0.55))
            .fixedSize(horizontal: false, vertical: true)
            .padding(.leading, 6)
    }
}

// MARK: - AI tab building blocks

private struct CardDivider: View {
    var body: some View {
        Rectangle().fill(Theme.border.opacity(0.55)).frame(height: 1).padding(.leading, 14)
    }
}

/// A small rounded status/roadmap pill.
private struct StatusPill: View {
    enum Tone { case positive, warning, neutral }
    let text: String
    let tone: Tone

    var body: some View {
        let colors: (bg: Color, fg: Color) = {
            switch tone {
            case .positive: return (Theme.softGreen.opacity(0.7), Theme.forest)
            case .warning: return (Theme.softClay.opacity(0.65), Theme.clay)
            case .neutral: return (Theme.border.opacity(0.45), Theme.muted)
            }
        }()
        return Text(text)
            .font(.system(size: 11, weight: .medium))
            .foregroundStyle(colors.fg)
            .padding(.horizontal, 9)
            .padding(.vertical, 3)
            .background(Capsule().fill(colors.bg))
    }
}

/// A quiet text button that only turns clay/destructive on hover.
private struct SubtleDestructiveButton: View {
    let title: String
    let action: () -> Void
    @State private var hovering = false

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 12))
                .foregroundStyle(hovering ? Theme.clay : Theme.muted)
        }
        .buttonStyle(.plain)
        .onHover { hovering = $0 }
    }
}

/// A small tappable tone suggestion chip.
private struct ToneChip: View {
    let label: String
    let action: () -> Void
    @State private var hovering = false

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(Theme.forest)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Capsule().fill(Theme.softGreen.opacity(hovering ? 0.6 : 0.35)))
                .overlay(Capsule().stroke(Theme.border, lineWidth: 1))
        }
        .buttonStyle(.plain)
        .onHover { hovering = $0 }
    }
}

// MARK: - Privacy

private struct PrivacyPrefs: View {
    @EnvironmentObject private var settings: AppSettings
    @EnvironmentObject private var store: MemoryStore
    @StateObject private var libraryVM = MemoryLibraryViewModel()
    @State private var showClear = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                captureSection
                accessibilitySection
                excludedAppsSection
                localMemoriesSection
                contextSection
                privacyNote
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Theme.background)
        .confirmationDialog("Clear all local memories?", isPresented: $showClear, titleVisibility: .visible) {
            Button("Clear Memories", role: .destructive) { store.clearAll() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This permanently deletes Mori’s saved memories from this Mac. This cannot be undone.")
        }
    }

    // MARK: Capture

    private var captureSection: some View {
        SettingsSection("Capture") {
            SettingsCard {
                toggleRow("Pause Mori",
                          "Temporarily stop Mori from using selected text or memory.",
                          isOn: $settings.isPaused)
                CardDivider()
                toggleRow("Enable selected-text capture",
                          "Allow Mori to read selected text when you press ⌥M.",
                          isOn: $settings.enableSelectedTextCapture)
                CardDivider()
                toggleRow("Require manual paste only",
                          "Mori will only use text you paste into the composer.",
                          isOn: $settings.requireManualPasteOnly)
                CardDivider()
                toggleRow("Restore clipboard after insert",
                          "After inserting a draft, Mori restores your previous clipboard when possible.",
                          isOn: $settings.restoreClipboardAfterInsert)
            }
        }
    }

    // MARK: Accessibility

    private var accessibilitySection: some View {
        SettingsSection("Accessibility permission") {
            SettingsCard {
                HStack {
                    Text("Status").font(.system(size: 13)).foregroundStyle(Theme.ink)
                    Spacer()
                    StatusPill(
                        text: AccessibilityService.isTrusted ? "Granted" : "Not granted",
                        tone: AccessibilityService.isTrusted ? .positive : .warning
                    )
                }
                .padding(.horizontal, 14)
                .frame(minHeight: 44)
                CardDivider()
                HStack {
                    Button {
                        AccessibilityService.openSystemSettings()
                    } label: {
                        Label("Open System Settings", systemImage: "arrow.up.right.square")
                    }
                    .buttonStyle(.bordered).controlSize(.small)
                    Spacer()
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
            }
            helper("Accessibility permission lets Mori read selected text and insert replies when you explicitly trigger it.")
        }
    }

    // MARK: Excluded apps

    private var excludedAppsSection: some View {
        SettingsSection("Excluded apps") {
            SettingsCard {
                HStack {
                    Text("No apps excluded yet.").font(.system(size: 13)).foregroundStyle(Theme.ink)
                    Spacer()
                    StatusPill(text: "Soon", tone: .neutral)
                }
                .padding(.horizontal, 14)
                .frame(minHeight: 44)
                CardDivider()
                HStack {
                    Button {} label: { Label("Add app", systemImage: "plus") }
                        .buttonStyle(.bordered).controlSize(.small).disabled(true)
                    Spacer()
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
            }
            helper("Per-app exclusions are coming soon.")
        }
    }

    // MARK: Local memories

    private var localMemoriesSection: some View {
        SettingsSection("Local memories") {
            SettingsCard {
                HStack {
                    Text("Saved memories").font(.system(size: 13)).foregroundStyle(Theme.ink)
                    Spacer()
                    Text("\(store.items.count)").font(.system(size: 13)).foregroundStyle(Theme.muted)
                }
                .padding(.horizontal, 14)
                .frame(minHeight: 44)
                CardDivider()
                HStack(spacing: 8) {
                    Button { libraryVM.exportMemories() } label: {
                        Label("Export memories", systemImage: "square.and.arrow.up")
                    }
                    .buttonStyle(.bordered).controlSize(.small)
                    Spacer()
                    Button { showClear = true } label: {
                        Label("Clear all", systemImage: "trash")
                    }
                    .buttonStyle(.bordered).controlSize(.small).tint(Theme.clay)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
            }
            helper("Memories are stored locally on this Mac by default.")
        }
    }

    // MARK: How Mori handles context

    private var contextSection: some View {
        SettingsSection("How Mori handles context") {
            SettingsCard {
                contextRow("keyboard", "User-triggered shortcut",
                           "You press ⌥M — nothing happens on its own.")
                CardDivider()
                contextRow("doc.on.clipboard", "Selected text or manual paste",
                           "Mori uses only what you select or paste.")
                CardDivider()
                contextRow("tray.full", "Local memory library",
                           "Optional saved notes, kept on this Mac.")
                CardDivider()
                contextRow("sparkles", "Optional AI provider request",
                           "Sent only when you generate, to your chosen provider.")
            }
        }
    }

    private var privacyNote: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Mori does not keylog or continuously capture your screen. Memory is user-triggered and stored locally by default. AI processing depends on your selected provider and settings.")
            Text("Mori only sends the context you choose to use for drafting, rewriting, summarizing, or recall.")
        }
        .font(.system(size: 12))
        .foregroundStyle(Theme.ink.opacity(0.55))
        .fixedSize(horizontal: false, vertical: true)
        .padding(.leading, 2)
    }

    // MARK: Rows + helpers

    private func toggleRow(_ title: String, _ subtitle: String, isOn: Binding<Bool>) -> some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.system(size: 13)).foregroundStyle(Theme.ink)
                Text(subtitle)
                    .font(.system(size: 11.5))
                    .foregroundStyle(Theme.ink.opacity(0.55))
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 12)
            Toggle("", isOn: isOn).labelsHidden().toggleStyle(.switch)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 11)
    }

    private func contextRow(_ icon: String, _ title: String, _ subtitle: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 13))
                .foregroundStyle(Theme.forest)
                .frame(width: 22)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.system(size: 13, weight: .medium)).foregroundStyle(Theme.ink)
                Text(subtitle)
                    .font(.system(size: 11.5))
                    .foregroundStyle(Theme.ink.opacity(0.55))
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 8)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
    }

    private func helper(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 12))
            .foregroundStyle(Theme.ink.opacity(0.55))
            .fixedSize(horizontal: false, vertical: true)
            .padding(.leading, 6)
    }
}

// MARK: - Memory

private struct MemoryPrefs: View {
    @EnvironmentObject private var store: MemoryStore
    @StateObject private var vm = MemoryLibraryViewModel()
    @State private var showDeleteArchived = false

    private var archivedCount: Int { store.items.filter { $0.isArchived }.count }

    private var shortPath: String {
        let full = store.storageLocation
        let home = FileManager.default.homeDirectoryForCurrentUser.path
        return full.hasPrefix(home) ? "~" + full.dropFirst(home.count) : full
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                intro
                librarySection
                backupSection
                cleanupSection
                privacyNote
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Theme.background)
        .confirmationDialog("Delete archived memories?", isPresented: $showDeleteArchived, titleVisibility: .visible) {
            Button("Delete Archived", role: .destructive) { store.deleteArchived() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This permanently deletes archived memories from this Mac. Active memories will not be affected.")
        }
    }

    // MARK: Intro

    private var intro: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Local memory")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Theme.ink)
            Text("Mori keeps your saved memories on this Mac. You can review, export, import, or delete them anytime.")
                .font(.system(size: 12))
                .foregroundStyle(Theme.ink.opacity(0.55))
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: Memory library

    private var librarySection: some View {
        SettingsSection("Memory library") {
            SettingsCard {
                infoRow("Saved memories", "\(store.items.count)")
                CardDivider()
                infoRow("Storage", "Local JSON")
                CardDivider()
                infoRow("Location", shortPath, mono: true)
                CardDivider()
                HStack(spacing: 8) {
                    Button { revealInFinder() } label: { Label("Reveal in Finder", systemImage: "folder") }
                        .buttonStyle(.bordered).controlSize(.small)
                    Button { ClipboardService.write(store.storageLocation) } label: { Label("Copy Path", systemImage: "doc.on.doc") }
                        .buttonStyle(.bordered).controlSize(.small)
                    Spacer()
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
            }
            Button { WindowManager.shared.showMemoryLibrary() } label: {
                Label("Open Memory Library", systemImage: "tray.full")
            }
            .buttonStyle(.borderedProminent).controlSize(.small).tint(Theme.forest)
        }
    }

    // MARK: Backup

    private var backupSection: some View {
        SettingsSection("Backup") {
            SettingsCard {
                actionRow("Export memories as JSON", "Save a copy of your local memories.") {
                    Button { vm.exportMemories() } label: { Label("Export", systemImage: "square.and.arrow.up") }
                        .buttonStyle(.bordered).controlSize(.small)
                }
                CardDivider()
                actionRow("Import memories from JSON", "Restore or merge memories from a backup file.") {
                    Button { vm.importMemories() } label: { Label("Import", systemImage: "square.and.arrow.down") }
                        .buttonStyle(.bordered).controlSize(.small)
                }
            }
        }
    }

    // MARK: Cleanup

    private var cleanupSection: some View {
        SettingsSection("Cleanup") {
            SettingsCard {
                actionRow(
                    "Delete archived memories",
                    archivedCount > 0 ? "\(archivedCount) archived memory\(archivedCount == 1 ? "" : "s")." : "No archived memories to delete."
                ) {
                    Button { showDeleteArchived = true } label: { Label("Delete archived", systemImage: "trash") }
                        .buttonStyle(.bordered).controlSize(.small).tint(Theme.clay)
                        .disabled(archivedCount == 0)
                }
            }
        }
    }

    private var privacyNote: some View {
        Text("Memories are stored locally on this Mac by default. AI processing depends on your selected provider and settings.")
            .font(.system(size: 12))
            .foregroundStyle(Theme.ink.opacity(0.55))
            .fixedSize(horizontal: false, vertical: true)
            .padding(.leading, 2)
    }

    // MARK: Rows + helpers

    private func infoRow(_ label: String, _ value: String, mono: Bool = false) -> some View {
        HStack(spacing: 12) {
            Text(label).font(.system(size: 13)).foregroundStyle(Theme.ink)
            Spacer(minLength: 12)
            Text(value)
                .font(mono ? .system(size: 11.5, design: .monospaced) : .system(size: 13))
                .foregroundStyle(Theme.muted)
                .lineLimit(1)
                .truncationMode(.middle)
        }
        .padding(.horizontal, 14)
        .frame(minHeight: 44)
    }

    private func actionRow<B: View>(_ title: String, _ subtitle: String, @ViewBuilder button: () -> B) -> some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.system(size: 13)).foregroundStyle(Theme.ink)
                Text(subtitle)
                    .font(.system(size: 11.5))
                    .foregroundStyle(Theme.ink.opacity(0.55))
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 12)
            button()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 11)
    }

    private func revealInFinder() {
        let url = URL(fileURLWithPath: store.storageLocation)
        NSWorkspace.shared.activateFileViewerSelecting([url])
    }
}

// MARK: - About

private struct AboutPrefs: View {
    @Environment(\.openURL) private var openURL
    @State private var updateNote: String?

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.1.0"
    }
    private var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }

    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 8)
            VStack(spacing: 16) {
                heroCard
                metadata
                legal
            }
            Spacer(minLength: 8)
            footer
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.background)
    }

    // MARK: Hero

    private var heroCard: some View {
        VStack(spacing: 16) {
            appIcon

            VStack(spacing: 5) {
                Text("Mori")
                    .font(.system(size: 30, weight: .semibold, design: .serif))
                    .foregroundStyle(Theme.ink)
                Text("A little memory spirit for your Mac.")
                    .font(.system(size: 13))
                    .foregroundStyle(Theme.muted)
            }

            versionPill
            actionsGrid

            if let updateNote {
                Text(updateNote)
                    .font(.caption)
                    .foregroundStyle(Theme.forest)
            }
        }
        .padding(.vertical, 28)
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Theme.card)
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Theme.border, lineWidth: 1)
                )
        )
    }

    /// The real app icon (same as Dock/Finder), loaded from the bundled .icns.
    private var bundledAppIcon: NSImage? {
        if let url = Bundle.main.url(forResource: "Mori", withExtension: "icns"),
           let image = NSImage(contentsOf: url) {
            return image
        }
        let appIcon = NSApp.applicationIconImage
        return (appIcon?.size.width ?? 0) > 0 ? appIcon : nil
    }

    private var appIcon: some View {
        ZStack {
            // soft moss glow
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Theme.moss.opacity(0.28))
                .frame(width: 108, height: 108)
                .blur(radius: 16)

            if let icon = bundledAppIcon {
                // Match the Dock/Finder icon exactly.
                Image(nsImage: icon)
                    .resizable()
                    .interpolation(.high)
                    .frame(width: 92, height: 92)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .shadow(color: Theme.forest.opacity(0.18), radius: 12, x: 0, y: 8)
            } else {
                // Fallback: the mascot in a tile.
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(LinearGradient(colors: [Theme.card, Theme.softGreen.opacity(0.55)],
                                         startPoint: .top, endPoint: .bottom))
                    .frame(width: 92, height: 92)
                    .overlay(RoundedRectangle(cornerRadius: 22, style: .continuous).stroke(Theme.border, lineWidth: 1))
                    .shadow(color: Theme.forest.opacity(0.18), radius: 12, x: 0, y: 8)
                    .overlay(MoriMark(size: 62))
            }
        }
        .padding(.top, 2)
    }

    private var versionPill: some View {
        Text("Version \(appVersion)  ·  Build \(buildNumber)")
            .font(.system(size: 11, weight: .medium, design: .monospaced))
            .foregroundStyle(Theme.muted)
            .padding(.horizontal, 12)
            .padding(.vertical, 5)
            .background(Capsule().fill(Theme.background))
            .overlay(Capsule().stroke(Theme.border, lineWidth: 1))
    }

    private var actionsGrid: some View {
        LazyVGrid(
            columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)],
            spacing: 10
        ) {
            AboutActionButton(title: "Website", systemImage: "safari") {
                if let url = URL(string: "https://heymori.app") { openURL(url) }
            }
            AboutActionButton(title: "Privacy", systemImage: "lock.shield") {
                if let url = URL(string: "https://heymori.app/privacy") { openURL(url) }
            }
            AboutActionButton(title: "Contact", systemImage: "envelope") {
                if let url = URL(string: "mailto:hello@heymori.app") { openURL(url) }
            }
            AboutActionButton(title: "Copy Version", systemImage: "doc.on.doc") {
                ClipboardService.write("Mori \(appVersion) (Build \(buildNumber))")
                withAnimation(.easeInOut(duration: 0.2)) {
                    updateNote = "Copied version to clipboard."
                }
            }
        }
        .frame(maxWidth: 380)
        .padding(.top, 2)
    }

    // MARK: Metadata + legal

    private var metadata: some View {
        Text("macOS app  ·  Local-first memory companion")
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(Theme.muted)
    }

    private var legal: some View {
        VStack(spacing: 6) {
            Text("Mori stores memory locally unless you choose otherwise. AI processing depends on your selected provider and settings.")
            Text("Designed for user-triggered context only. No background keylogging.")
        }
        .font(.system(size: 12))
        .lineSpacing(2)
        .multilineTextAlignment(.center)
        .foregroundStyle(Theme.ink.opacity(0.62))
        .frame(maxWidth: 430)
    }

    private var footer: some View {
        Text("© 2026 Mori · heymori.app")
            .font(.system(size: 11))
            .foregroundStyle(Theme.muted.opacity(0.7))
    }
}

/// A subtle bordered action button with consistent hover + pressed states.
private struct AboutActionButton: View {
    let title: String
    let systemImage: String
    let action: () -> Void
    @State private var hovering = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: systemImage)
                    .font(.system(size: 13))
                    .foregroundStyle(Theme.forest)
                    .frame(width: 18, alignment: .center)
                Text(title)
                    .font(.system(size: 13))
                    .foregroundStyle(Theme.ink)
                Spacer(minLength: 0)
            }
        }
        .buttonStyle(AboutButtonStyle(hovering: hovering))
        .onHover { hovering = $0 }
    }
}

/// Shared look for About buttons: soft hover fill, subtle pressed feedback.
private struct AboutButtonStyle: ButtonStyle {
    let hovering: Bool

    func makeBody(configuration: Configuration) -> some View {
        let active = hovering || configuration.isPressed
        return configuration.label
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(configuration.isPressed
                          ? Theme.softGreen.opacity(0.6)
                          : (hovering ? Theme.softGreen.opacity(0.45) : Theme.card))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(active ? Theme.forest.opacity(0.35) : Theme.border, lineWidth: 1)
            )
            .animation(.easeOut(duration: 0.12), value: hovering)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}
