import SwiftUI

@main
struct MoriApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @ObservedObject private var settings = AppSettings.shared

    var body: some Scene {
        MenuBarExtra {
            MenuBarMenu()
        } label: {
            Image(nsImage: MenuBarIcon.image(paused: settings.isPaused))
        }
        .menuBarExtraStyle(.menu)
    }
}

/// Where beta feedback goes. Swap for a form URL if you prefer.
let moriFeedbackURL = URL(string: "mailto:hello@heymori.app?subject=Mori%20Beta%20Feedback")!

/// The menu shown from the menu-bar guardian.
struct MenuBarMenu: View {
    @Environment(\.openURL) private var openURL
    @ObservedObject private var settings = AppSettings.shared
    @ObservedObject private var actions = ActionStore.shared
    @ObservedObject private var history = HistoryStore.shared

    var body: some View {
        Button("Quick Action  ⌥M") { QuickActionService.shared.handleInstant() }

        Menu("Run Action") {
            ForEach(actions.enabled) { action in
                Button {
                    QuickActionService.shared.runFromMenu(action)
                } label: {
                    Label(action.name, systemImage: action.icon)
                }
            }
        }

        Button("Actions Palette  ⌥⇧M") { WindowManager.shared.showActionsPalette() }
        Button("Open Composer") { WindowManager.shared.toggleComposer() }

        Divider()

        Menu("Recent") {
            if history.items.isEmpty {
                Text("No recent results yet")
            } else {
                ForEach(history.items.prefix(8)) { item in
                    Button("\(item.actionName): \(item.shortTitle)") {
                        ClipboardService.write(item.output)
                    }
                }
                Divider()
                Button("Clear recent") { history.clear() }
            }
        }
        Button("Memory Library") { WindowManager.shared.showMemoryLibrary() }
        Button("New Memory") { WindowManager.shared.showMemoryLibrary(createNew: true) }

        Divider()

        Button(settings.isPaused ? "Resume Mori" : "Pause Mori") {
            settings.isPaused.toggle()
        }
        Button("Preferences…") { WindowManager.shared.showPreferences() }
        Button("Send Feedback…") { openURL(moriFeedbackURL) }

        Divider()

        Button("Quit Mori") { NSApplication.shared.terminate(nil) }
    }
}
