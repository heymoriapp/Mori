# Mori — Mac app (MVP)

_A little memory spirit for your Mac._

Mori is a private, menu-bar writing companion. Press **⌥M** from any text field,
and a small floating composer opens. It reads your selected text (or context you
paste/type), optionally pulls from your local memory, and drafts a reply in your
tone — then you copy or insert it. Nothing happens in the background; every
action is triggered by you.

This folder is the native macOS app. It is completely separate from the marketing
site in the repo root and does not touch it.

---

## What Mori does (MVP)

- **Menu-bar app** (no Dock icon) with a custom guardian icon, quick actions,
  an actions palette, memory, history, preferences, pause, quit.
- **⌥M — instant action in place.** With text selected in any app, ⌥M runs your
  **default Action** and pastes the result back **instantly**, with a small HUD —
  no window, no manual steps. With nothing selected, ⌥M opens the composer.
- **⌥⇧M — Actions palette.** A Spotlight-style, keyboard-driven picker: type to
  filter, ↑/↓ to move, ↩ to apply any Action to your selection in place. Includes
  an "Open full composer" entry.
- **Actions library.** A starter set (Rewrite · Fix spelling & grammar · Make
  shorter · Make clearer · Make friendlier · Make professional · Summarize · Draft
  reply) plus **your own custom actions** (name, icon, instruction) — enable,
  reorder, edit, or add in Preferences → Actions.
- **Composer (full control).** The floating window for Reply / Rewrite / Summarize
  / Recall, editing context, and reviewing a draft before inserting.
- **History.** Recent results are kept locally; re-copy any from the menu → Recent.
- **Four modes**: Reply · Rewrite · Summarize · Recall.
- **Context capture**: reads the current selection via Accessibility (user-triggered
  only), with clipboard-paste and manual-typing fallbacks.
- **AI drafting** through a swappable provider layer (OpenAI-compatible or Anthropic).
- **Local memory**: save drafts/selections, search, pin, edit, delete, import/export.
- **Preferences**: General, AI, Privacy, Memory, About.
- **Onboarding**: welcome → shortcut → privacy → permissions → AI setup.
- **Insert**: copies reliably; simulates ⌘V into the previous app when Accessibility
  is granted, otherwise falls back to "Copied instead."

---

## Requirements

- **macOS 14.0+**
- **Xcode 15+** (Swift 5.9+ toolchain)
- An API key for your chosen provider (OpenAI-compatible or Anthropic). You bring
  your own key; Mori never ships one.

---

## Build & run

### Option A — no Xcode, no Homebrew (fastest) ✅

If you only have the **Command Line Tools** (`xcode-select --install`), you can
build and run a real `Mori.app` today — no Xcode.app, no Homebrew:

```bash
cd mac-app
./build-app.sh
open build/Mori.app        # look for the leaf icon in your menu bar
```

`build-app.sh` compiles all sources with `swiftc`, assembles the `.app` bundle,
and ad-hoc code-signs it with the entitlements (so macOS can grant Accessibility).
Rebuild anytime by re-running it. This is the quickest way to try Mori.

> First launch: grant **Accessibility** when prompted (or in System Settings →
> Privacy & Security → Accessibility), then set your API key in **Preferences → AI**.
> Accessibility is what makes the ⌥M in-place rewrite work (reading the selection
> and pasting the result). Without it, ⌥M opens the composer instead.
> After each rebuild, macOS may ask you to re-approve Accessibility because the
> ad-hoc signature changes — that's expected for local dev builds.

For day-to-day development (editing, debugging, SwiftUI previews) you'll still
want **Xcode.app** from the Mac App Store — see the options below.

### Option B — XcodeGen (recommended once you have Xcode)

```bash
brew install xcodegen          # once
cd mac-app
xcodegen generate              # creates Mori.xcodeproj from project.yml
open Mori.xcodeproj
```

Then in Xcode: select the **Mori** scheme → set your signing Team under
Signing & Capabilities → **Run** (⌘R).

### Option C — plain Xcode, no extra tools

1. Xcode → File → New → Project → **macOS App** (SwiftUI). Name it `Mori`.
2. Delete the auto-generated `ContentView.swift` / `MoriApp.swift`.
3. Drag the entire `mac-app/Mori/` folder into the project (Copy items if needed,
   Create groups).
4. In the target's **Info** tab add `Application is agent (UIElement)` = `YES`
   (or use the provided `Resources/Info.plist`).
5. Signing & Capabilities: set your Team, and **turn App Sandbox OFF** (see below).
6. Run (⌘R).

A clean type-check/link of all sources is expected to succeed; verify with:

```bash
cd mac-app/Mori
swiftc -typecheck -parse-as-library \
  -sdk "$(xcrun --show-sdk-path --sdk macosx)" \
  -target arm64-apple-macos14.0 $(find . -name '*.swift')
```

---

## Required permissions

| Permission | Why | When |
|---|---|---|
| **Accessibility** (System Settings → Privacy & Security → Accessibility) | Read the selected text in other apps, and simulate ⌘V to insert. | Requested during onboarding; optional. Without it, use paste/manual context and Copy. |
| **Network** | Send your context to the AI provider you configured. | Only when you press Generate. |
| **Keychain** | Store your API key securely. | When you save a key. |

### Why the app is **not** sandboxed

Reading another app's selection (Accessibility) and posting a ⌘V key event are
blocked by the App Sandbox. Mori therefore ships **without** the sandbox
(`Resources/Mori.entitlements` sets `com.apple.security.app-sandbox = false`).
Distribution is via **Developer ID + notarization** (or local run), not the Mac
App Store.

---

## Setting your API key

1. Menu bar → **Preferences → AI**.
2. Pick a provider (OpenAI-compatible or Anthropic).
3. Set the model (defaults: `gpt-4o-mini` / `claude-3-5-sonnet-latest`) and,
   optionally, a custom base URL for OpenAI-compatible gateways.
4. Paste your key → **Save key** → **Test connection**.

The key is stored in the **login Keychain** (`app.heymori.Mori / ai-api-key`),
never in preferences or plain files. For development you can also paste it during
onboarding.

---

## Privacy model

- **User-triggered only.** Mori does nothing until you press ⌥M and click an action.
- **No background capture, no keylogging, no screen reading.**
- **Local-first memory.** Memories are a JSON file in
  `~/Library/Application Support/Mori/memories.json`. No cloud, no sync.
- **You control everything.** Pause Mori, disable selection capture, require
  manual paste, exclude apps (roadmap), delete any memory, or clear all.
- **AI processing depends on your provider.** When you Generate, your context (and
  any matched memories) are sent to the provider/model you configured. Choose a
  provider whose data policy you trust.
- Mori makes **no false "local-only AI"** claims — the drafting itself is a remote
  API call by design in this MVP.

---

## MVP limitations (honest list)

- Mori does **not** read every app automatically. It reads only the current
  selection, on demand.
- Selected-text capture depends on the app exposing it via Accessibility. Some
  apps (certain Electron/web views, secure fields) won't return a selection —
  paste manually there.
- **Insert** may fall back to **Copy** if Accessibility isn't granted or the target
  app doesn't accept a synthetic paste.
- The global shortcut is fixed to **⌥M** in v1 (custom shortcuts are roadmap).
- Memory search is **keyword-based** (a `MemorySearchService` protocol is in place
  so embeddings/vector search can drop in later).
- One provider request per generation; no streaming yet.

---

## Architecture

Clean MVVM, no third-party dependencies.

```
Mori/
  App/           MoriApp (MenuBarExtra) · AppDelegate · WindowManager
  Models/        MemoryItem · MoriAction · ComposerMode · AppSettings
  Services/      HotkeyService (Carbon, multi-hotkey) · AccessibilityService
                 ClipboardService · InsertTextService · KeychainService
                 LaunchAtLoginService · QuickActionService (in-place actions + HUD)
                 AIProvider (+ OpenAI / Anthropic / Factory + transform) · MoriPrompts
                 ActionStore (JSON) · MemoryStore (JSON) · MemorySearchService
                 HistoryStore (recent results)
  ViewModels/    ComposerViewModel · MemoryLibraryViewModel · PreferencesViewModel
  Views/
    Composer/    ComposerView · FloatingPanel (NSPanel)
    QuickAction/ QuickHUD · ActionsPalette (key panel + SwiftUI list)
    MemoryLibrary/ MemoryLibraryView
    Preferences/ PreferencesView (General/Actions/AI/Privacy/Memory/About)
    Onboarding/  OnboardingView
    Components/  Theme · MoriMark · MoriButtons · MenuBarIcon (template)
  Resources/     Info.plist · Mori.entitlements · Assets.xcassets
```

- The composer is an AppKit `NSPanel` (`FloatingPanel`) hosting SwiftUI, so it
  floats, becomes key for typing, and dismisses on Escape / click-away.
- The global hotkey uses the Carbon Hot Key API (reliable, low overhead).
- Providers sit behind the `AIProvider` protocol; add a backend by adding one type.

---

## App icon

The Dock / Finder / App Switcher icon is the Mori guardian on a forest tile —
rendered from the same design as the landing page's `app/icon.svg`.

- `Tools/MakeAppIcon.swift` draws it at every size; `Tools/gen-appicon.sh`
  assembles `Mori/Resources/Mori.icns` and `Assets.xcassets/AppIcon.appiconset`
  (Command Line Tools only — `swift` + `iconutil`, no Xcode needed).
- `build-app.sh` embeds `Mori.icns` and sets `CFBundleIconFile` / `CFBundleIconName`.
- Regenerate anytime: `./Tools/gen-appicon.sh`.

> Mori is a menu-bar app (`LSUIElement`), so it has no permanent Dock icon. The
> icon appears in the Dock when a real window opens (Preferences / Memory
> Library) and in Finder for `Mori.app`.

If macOS keeps showing the old/placeholder icon (aggressive icon cache):

```bash
touch build/Mori.app
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f build/Mori.app
killall Dock
# still stale? also: killall Finder   (or rename/move Mori.app once)
```

## Roadmap

- Custom / rebindable global shortcut.
- Per-app exclusion UI (model + settings scaffolding already present).
- Streaming responses in the composer.
- Embedding-based memory recall behind the existing `MemorySearchService`.
- Menu-bar quick actions and recent drafts.
- Signed + notarized distribution build.

---

## Acceptance checklist

- [x] Launches as a menu-bar app (no Dock icon)
- [x] ⌥M opens the floating composer
- [x] Paste / type / read-selection context
- [x] Generate a reply via the configured provider
- [x] Copy the generated text
- [x] Save generated text as a memory
- [x] Memory Library: search / edit / pin / delete / import / export
- [x] Preferences: set API key (Keychain), provider, model, tone
- [x] Onboarding flow
- [x] Does not crash when Accessibility is missing (falls back to paste/copy)
- [x] Privacy-first, user-triggered UX throughout

_Mori is not affiliated with Studio Ghibli._
