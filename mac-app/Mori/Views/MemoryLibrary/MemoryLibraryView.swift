import SwiftUI

/// Sidebar list + detail editor for local memories.
struct MemoryLibraryView: View {
    @EnvironmentObject private var store: MemoryStore
    @StateObject private var vm = MemoryLibraryViewModel()
    @State private var showClearConfirm = false

    var body: some View {
        NavigationSplitView {
            sidebar
                .navigationSplitViewColumnWidth(min: 240, ideal: 280, max: 340)
        } detail: {
            detail
        }
        .background(Theme.background)
        .onReceive(NotificationCenter.default.publisher(for: .moriCreateMemory)) { _ in
            vm.createMemory()
        }
    }

    // MARK: Sidebar

    private var sidebar: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Recent memory").moriLabelStyle()
                Spacer()
                Button { vm.createMemory() } label: { Image(systemName: "plus") }
                    .buttonStyle(.borderless)
                    .help("New memory")
            }
            .padding(.horizontal, 14)
            .padding(.top, 12)
            .padding(.bottom, 8)

            List(selection: $vm.selectedID) {
                ForEach(vm.results) { item in
                    MemoryRow(item: item)
                        .tag(item.id)
                        .contextMenu {
                            Button(item.isPinned ? "Unpin" : "Pin") { vm.togglePin(item.id) }
                            Button("Delete", role: .destructive) { vm.delete(item.id) }
                        }
                }
            }
            .listStyle(.sidebar)

            Divider()
            HStack {
                Button(role: .destructive) { showClearConfirm = true } label: {
                    Label("Clear all", systemImage: "trash")
                }
                .buttonStyle(.borderless)
                .font(.system(size: 11))
                Spacer()
                Text("\(store.items.count) saved")
                    .font(.system(size: 11))
                    .foregroundStyle(Theme.muted)
            }
            .padding(10)
        }
        .searchable(text: $vm.query, prompt: "Search memories")
        .confirmationDialog("Delete all memories? This cannot be undone.", isPresented: $showClearConfirm) {
            Button("Delete everything", role: .destructive) { vm.clearAll() }
            Button("Cancel", role: .cancel) {}
        }
    }

    // MARK: Detail

    @ViewBuilder
    private var detail: some View {
        if let selected = vm.selected {
            MemoryDetailView(
                item: selected,
                onSave: { vm.save($0) },
                onTogglePin: { vm.togglePin(selected.id) },
                onDelete: { vm.delete(selected.id) }
            )
            .id(selected.id)
        } else {
            VStack(spacing: 12) {
                MoriMark(size: 44)
                Text("Select a memory, or create a new one.")
                    .foregroundStyle(Theme.muted)
                HStack {
                    Button("Export JSON") { vm.exportMemories() }
                        .buttonStyle(MoriSecondaryButtonStyle())
                    Button("Import JSON") { vm.importMemories() }
                        .buttonStyle(MoriSecondaryButtonStyle())
                }
                .padding(.top, 6)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Theme.background)
        }
    }
}

private struct MemoryRow: View {
    let item: MemoryItem
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 6) {
                if item.isPinned {
                    Image(systemName: "pin.fill").font(.system(size: 9)).foregroundStyle(Theme.forest)
                }
                Text(item.title.isEmpty ? "Untitled" : item.title)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Theme.ink)
                    .lineLimit(1)
            }
            Text(item.preview)
                .font(.system(size: 11))
                .foregroundStyle(Theme.muted)
                .lineLimit(1)
        }
        .padding(.vertical, 2)
    }
}

/// Editable detail panel. Local @State mirrors the item and saves on change.
private struct MemoryDetailView: View {
    let item: MemoryItem
    let onSave: (MemoryItem) -> Void
    let onTogglePin: () -> Void
    let onDelete: () -> Void

    @State private var title: String
    @State private var body_: String
    @State private var tagText: String

    init(item: MemoryItem, onSave: @escaping (MemoryItem) -> Void, onTogglePin: @escaping () -> Void, onDelete: @escaping () -> Void) {
        self.item = item
        self.onSave = onSave
        self.onTogglePin = onTogglePin
        self.onDelete = onDelete
        _title = State(initialValue: item.title)
        _body_ = State(initialValue: item.body)
        _tagText = State(initialValue: item.tags.joined(separator: ", "))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                TextField("Title", text: $title)
                    .textFieldStyle(.plain)
                    .font(.system(size: 20, weight: .medium, design: .serif))
                    .foregroundStyle(Theme.ink)
                Spacer()
                Button { onTogglePin() } label: {
                    Image(systemName: item.isPinned ? "pin.fill" : "pin")
                }
                .buttonStyle(.borderless)
                .help(item.isPinned ? "Unpin" : "Pin")
            }

            HStack(spacing: 8) {
                Label(item.sourceType.label, systemImage: "tag")
                if let app = item.sourceApp { Text("· \(app)") }
                Spacer()
                Text(item.updatedAt.formatted(date: .abbreviated, time: .shortened))
            }
            .font(.system(size: 11))
            .foregroundStyle(Theme.muted)

            TextEditor(text: $body_)
                .font(.system(size: 14))
                .foregroundStyle(Theme.ink)
                .scrollContentBackground(.hidden)
                .padding(10)
                .background(Theme.card)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Theme.border, lineWidth: 1))

            HStack {
                Text("Tags").moriLabelStyle()
                TextField("comma, separated", text: $tagText)
                    .textFieldStyle(.roundedBorder)
            }

            HStack {
                Button("Save changes") { save() }
                    .buttonStyle(MoriPrimaryButtonStyle())
                Spacer()
                Button(role: .destructive) { onDelete() } label: { Label("Delete", systemImage: "trash") }
                    .buttonStyle(MoriSecondaryButtonStyle())
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Theme.background)
    }

    private func save() {
        var updated = item
        updated.title = title.isEmpty ? MemoryStore.derivedTitle(from: body_) : title
        updated.body = body_
        updated.tags = tagText
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        onSave(updated)
    }
}
