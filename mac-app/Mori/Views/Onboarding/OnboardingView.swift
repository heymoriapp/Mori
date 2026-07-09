import SwiftUI

/// A calm, minimal first-run flow for the private beta. Six steps, keyboard-
/// friendly, skippable.
struct OnboardingView: View {
    let onFinish: () -> Void

    @State private var step = 0
    @State private var apiKey = ""
    @State private var keySaved = false

    private let lastStep = 5

    var body: some View {
        VStack(spacing: 0) {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 44)
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.25), value: step)

            footer
        }
        .frame(width: 560, height: 620)
        .background(Theme.background)
    }

    // MARK: Steps

    @ViewBuilder
    private var content: some View {
        switch step {
        case 0:
            OnboardStep(
                icon: { AnyView(MoriMark(size: 72)) },
                title: "Welcome to Mori",
                subtitle: "A little memory spirit for your Mac. Mori helps you draft, rewrite, summarize, and recall — right where you're already typing."
            )
        case 1:
            OnboardStep(
                icon: { AnyView(KeycapPill(text: "⌥M").scaleEffect(1.8)) },
                title: "Press ⌥M anywhere",
                subtitle: "Select text in any app and press ⌥M. Mori opens a small composer to draft, rewrite, summarize, or recall — then you copy or insert."
            )
        case 2:
            aiKeyStep
        case 3:
            accessibilityStep
        case 4:
            OnboardStep(
                icon: { AnyView(Image(systemName: "tray.full").font(.system(size: 46)).foregroundStyle(Theme.forest)) },
                title: "Save and recall memories",
                subtitle: "Save drafts or selections as simple local notes, then recall them later with the Recall mode. Memories are stored on this Mac by default."
            )
        default:
            OnboardStep(
                icon: { AnyView(MoriMark(size: 64)) },
                title: "You're all set",
                subtitle: "Press ⌥M anywhere to begin. You can reopen settings and this guide from the menu-bar leaf anytime."
            )
        }
    }

    private var aiKeyStep: some View {
        VStack(spacing: 14) {
            Image(systemName: "sparkles").font(.system(size: 44)).foregroundStyle(Theme.forest)
            Text("Add your AI provider key")
                .font(.system(size: 26, weight: .medium, design: .serif))
                .foregroundStyle(Theme.ink)
            Text("Mori uses your own API key, stored securely in your Mac's Keychain. AI processing depends on your selected provider and settings. Add it now or later in Preferences → AI.")
                .multilineTextAlignment(.center)
                .foregroundStyle(Theme.muted)
            SecureField("Paste your API key (optional)", text: $apiKey)
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: 320)
            Button(keySaved ? "Saved ✓" : "Save key") {
                KeychainService.apiKey = apiKey.trimmingCharacters(in: .whitespacesAndNewlines)
                keySaved = KeychainService.hasAPIKey
            }
            .buttonStyle(.borderedProminent).tint(Theme.forest).controlSize(.small)
            .disabled(apiKey.isEmpty)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var accessibilityStep: some View {
        VStack(spacing: 16) {
            Image(systemName: "hand.raised")
                .font(.system(size: 46)).foregroundStyle(Theme.forest)
            Text("Enable Accessibility")
                .font(.system(size: 26, weight: .medium, design: .serif))
                .foregroundStyle(Theme.ink)
            Text("Mori uses macOS Accessibility to read the text you've selected and to insert replies — only when you press ⌥M. You can skip this and paste context manually instead.")
                .multilineTextAlignment(.center)
                .foregroundStyle(Theme.muted)
            Button("Open System Settings") { AccessibilityService.openSystemSettings() }
                .buttonStyle(.borderedProminent).tint(Theme.forest).controlSize(.small)
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: Footer

    private var footer: some View {
        VStack(spacing: 12) {
            HStack(spacing: 6) {
                ForEach(0...lastStep, id: \.self) { i in
                    Circle()
                        .fill(i == step ? Theme.forest : Theme.border)
                        .frame(width: 6, height: 6)
                }
            }
            HStack {
                if step > 0 {
                    Button("Back") { step -= 1 }
                        .buttonStyle(.bordered).controlSize(.large)
                } else {
                    Button("Skip") { onFinish() }
                        .buttonStyle(.bordered).controlSize(.large)
                }
                Spacer()
                if step < lastStep {
                    Button("Continue") { step += 1 }
                        .buttonStyle(.borderedProminent).tint(Theme.forest).controlSize(.large)
                        .keyboardShortcut(.defaultAction)
                } else {
                    Button("Start using Mori") { onFinish() }
                        .buttonStyle(.borderedProminent).tint(Theme.forest).controlSize(.large)
                        .keyboardShortcut(.defaultAction)
                }
            }
        }
        .padding(20)
    }
}

/// A simple centered onboarding step: icon, big serif title, muted subtitle.
private struct OnboardStep: View {
    let icon: () -> AnyView
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 18) {
            icon()
            Text(title)
                .font(.system(size: 30, weight: .medium, design: .serif))
                .foregroundStyle(Theme.ink)
                .multilineTextAlignment(.center)
            Text(subtitle)
                .font(.system(size: 15))
                .foregroundStyle(Theme.muted)
                .multilineTextAlignment(.center)
                .lineSpacing(2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
