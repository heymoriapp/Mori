import SwiftUI

/// The floating composer — a compact, keyboard-first, Mac-native command
/// palette: paste/read context → Draft reply → edit → copy/insert.
struct ComposerView: View {
    @EnvironmentObject private var vm: ComposerViewModel
    @EnvironmentObject private var settings: AppSettings

    var body: some View {
        content
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(LinearGradient(colors: [Theme.card, Theme.background],
                                         startPoint: .top, endPoint: .bottom))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(Theme.border, lineWidth: 1)
            )
            .compositingGroup()
            .shadow(color: Color.black.opacity(0.22), radius: 16, x: 0, y: 8)
            .padding(22)
            .frame(width: 804, height: 584)
            .onExitCommand { vm.close() }
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 12) {
            header
            if vm.needsSetup { setupBanner }
            contextSection
            generateRow
            if vm.needsSetup {
                setupCard.frame(maxHeight: .infinity)
            } else {
                draftSection.frame(maxHeight: .infinity)
            }
            actionRow
            footer
        }
    }

    // MARK: Header

    private var header: some View {
        HStack(spacing: 10) {
            MoriMark(size: 18)
            Text("Mori")
                .font(.system(size: 14, weight: .semibold, design: .serif))
                .foregroundStyle(Theme.ink)

            Spacer(minLength: 12)

            modeTabs

            keycap("⌥M")
        }
    }

    private var modeTabs: some View {
        HStack(spacing: 2) {
            ForEach(ComposerMode.allCases) { mode in
                Button { vm.mode = mode } label: {
                    Text(mode.rawValue)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(vm.mode == mode ? Theme.background : Theme.ink.opacity(0.62))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .fill(vm.mode == mode ? Theme.forest : Color.clear)
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(2)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Theme.card)
                .overlay(RoundedRectangle(cornerRadius: 8, style: .continuous).stroke(Theme.border, lineWidth: 1))
        )
    }

    private func keycap(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 11, weight: .medium, design: .rounded))
            .foregroundStyle(Theme.ink)
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(LinearGradient(colors: [Color.white.opacity(0.85), Theme.card], startPoint: .top, endPoint: .bottom))
            )
            .overlay(RoundedRectangle(cornerRadius: 6, style: .continuous).stroke(Theme.border, lineWidth: 1))
            .shadow(color: Color.black.opacity(0.06), radius: 0.5, x: 0, y: 1)
    }

    // MARK: Setup (no API key)

    private var setupBanner: some View {
        HStack(spacing: 10) {
            Image(systemName: "key.fill").font(.system(size: 11)).foregroundStyle(Theme.clay)
            VStack(alignment: .leading, spacing: 1) {
                Text("API key required").font(.system(size: 12, weight: .semibold)).foregroundStyle(Theme.ink)
                Text("Add your provider key to generate drafts.")
                    .font(.system(size: 11)).foregroundStyle(Theme.ink.opacity(0.62))
            }
            Spacer()
            settingsButton()
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Theme.softClay.opacity(0.4))
                .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(Theme.clay.opacity(0.25), lineWidth: 1))
        )
    }

    /// Replaces the draft workspace until a key is configured — "set up AI first".
    private var setupCard: some View {
        VStack(spacing: 8) {
            Image(systemName: "sparkles").font(.system(size: 22)).foregroundStyle(Theme.forest)
            Text("Add an API key to start drafting.")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Theme.ink)
            Text("Your context stays local until you choose to generate with your selected provider.")
                .font(.system(size: 11))
                .foregroundStyle(Theme.muted)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 430)
            settingsButton().padding(.top, 2)
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Theme.card)
                .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Theme.border, lineWidth: 1))
        )
    }

    /// A clearly readable, important "Open AI Settings" button.
    private func settingsButton() -> some View {
        Button("Open AI Settings") { WindowManager.shared.showPreferences(selectTab: .ai) }
            .buttonStyle(.borderedProminent)
            .tint(Theme.forest)
            .controlSize(.small)
    }

    // MARK: Context

    private var contextSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                Text("Context").moriLabelStyle()
                if let app = vm.sourceApp, !app.isEmpty {
                    Text(app)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(Theme.forest)
                        .padding(.horizontal, 7).padding(.vertical, 1.5)
                        .background(Capsule().fill(Theme.softGreen.opacity(0.6)))
                }
                Spacer()
                linkButton("Paste") { vm.pasteClipboard() }
                if settings.enableSelectedTextCapture {
                    linkButton("Read selection") { vm.readSelection() }
                }
                if !vm.contextText.isEmpty {
                    linkButton("Clear") { vm.contextText = "" }
                }
            }
            editor(
                text: $vm.contextText,
                placeholder: "Paste a thread, message, or selected text…",
                minHeight: 60, maxHeight: 120
            )
        }
    }

    // MARK: Generate

    private var generateRow: some View {
        HStack(spacing: 10) {
            Button { vm.generate() } label: {
                HStack(spacing: 6) {
                    if vm.isGenerating {
                        ProgressView().controlSize(.small)
                    } else {
                        Image(systemName: vm.mode.systemImage)
                    }
                    Text(vm.isGenerating ? "Drafting…" : vm.mode.actionTitle)
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(Theme.forest)
            .controlSize(.regular)
            .disabled(!vm.canGenerate)
            .keyboardShortcut(.return, modifiers: .command)
            .help(vm.needsSetup ? "Add an API key to generate." : "")

            Text(vm.needsSetup ? "Add API key to generate" : "⌘↩ to generate")
                .font(.system(size: 11))
                .foregroundStyle(vm.needsSetup ? Theme.clay : Theme.muted)
            Spacer()
        }
    }

    // MARK: Draft

    private var draftSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Draft").moriLabelStyle()
            draftBox
        }
    }

    @ViewBuilder
    private var draftBox: some View {
        if vm.isGenerating {
            draftFillBox { DraftingIndicator() }
        } else if vm.hasDraft {
            editor(text: $vm.draft, placeholder: "", minHeight: 104, maxHeight: .infinity, serif: true)
        } else {
            draftFillBox {
                VStack(spacing: 3) {
                    Text("Mori's draft will appear here.")
                        .font(.system(size: 13)).foregroundStyle(Theme.ink.opacity(0.6))
                    Text("Generate a reply, then edit before inserting.")
                        .font(.system(size: 11)).foregroundStyle(Theme.muted)
                }
            }
        }
    }

    private func draftFillBox<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Theme.card)
                    .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Theme.border, lineWidth: 1))
            )
    }

    // MARK: Actions

    private var actionRow: some View {
        HStack(spacing: 8) {
            if vm.hasDraft {
                Button("Copy") { vm.copyDraft() }
                    .buttonStyle(.borderedProminent).tint(Theme.forest).controlSize(.small)
                    .keyboardShortcut("c", modifiers: .command)
                Button("Insert") { vm.insertDraft() }
                    .buttonStyle(.bordered).controlSize(.small)
                    .keyboardShortcut("i", modifiers: .command)
                Button("Save to Memory") { vm.saveToMemory() }
                    .buttonStyle(.bordered).controlSize(.small)
                Button("Forget") { vm.forget() }
                    .buttonStyle(.borderless).controlSize(.small)
                    .foregroundStyle(Theme.muted)
            }
            Spacer()
            Button { vm.close() } label: {
                Text("Close").font(.system(size: 12)).foregroundStyle(Theme.ink.opacity(0.75))
            }
            .buttonStyle(.bordered).controlSize(.small)
            .keyboardShortcut(.cancelAction)
        }
    }

    // MARK: Footer

    private var footer: some View {
        HStack(spacing: 6) {
            Circle().fill(Theme.moss).frame(width: 6, height: 6)
            Text(vm.status.isEmpty
                 ? "Private mode · Mori only sends context when you choose to generate."
                 : vm.status)
                .font(.system(size: 11))
                .foregroundStyle(Theme.muted)
                .lineLimit(1)
            Spacer()
        }
    }

    // MARK: Reusable bits

    private func linkButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title).font(.system(size: 11)).foregroundStyle(Theme.forest)
        }
        .buttonStyle(.plain)
    }

    private func editor(text: Binding<String>, placeholder: String, minHeight: CGFloat, maxHeight: CGFloat, serif: Bool = false) -> some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Theme.card)
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Theme.border, lineWidth: 1)
                )

            if text.wrappedValue.isEmpty && !placeholder.isEmpty {
                Text(placeholder)
                    .font(.system(size: serif ? 15 : 13, design: serif ? .serif : .default))
                    .foregroundStyle(Theme.muted.opacity(0.7))
                    .padding(.horizontal, 12)
                    .padding(.top, 10)
                    .allowsHitTesting(false)
            }

            TextEditor(text: text)
                .font(.system(size: serif ? 15 : 13, design: serif ? .serif : .default))
                .foregroundStyle(Theme.ink)
                .lineSpacing(2)
                .scrollContentBackground(.hidden)
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
        }
        .frame(minHeight: minHeight, maxHeight: maxHeight)
    }
}

/// A calm "Mori is drafting…" indicator with a breathing mark.
private struct DraftingIndicator: View {
    @State private var pulse = false
    var body: some View {
        HStack(spacing: 8) {
            MoriMark(size: 18)
                .scaleEffect(pulse ? 1.08 : 0.94)
                .opacity(pulse ? 1 : 0.7)
                .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: pulse)
            Text("Mori is drafting…")
                .font(.system(size: 13))
                .foregroundStyle(Theme.muted)
        }
        .onAppear { pulse = true }
    }
}
