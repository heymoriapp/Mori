# Mori — Private Beta Release Checklist (v0.1.0)

Run through this before sending a build to testers. Check each item on the
actual built app (`./build-app.sh && open build/Mori.app`).

## Build & packaging
- [x] App builds cleanly (`./build-app.sh`, exit 0)
- [x] App is ad-hoc code-signed; `codesign --verify --strict` passes on a fresh build
- [x] App launches without crashing
- [x] Version is `0.1.0`, build `1`, name `Mori`, bundle id `app.heymori.Mori`
- [x] `./package-app.sh` produces `release/dist/Mori-0.1.0-beta.zip`

## Icon
- [x] App icon (`Mori.icns`) embedded in the bundle
- [ ] Dock icon shows the Mori guardian (open Preferences to reveal the Dock icon)
- [ ] Finder shows the Mori icon for `Mori.app`
- [ ] App Switcher shows the Mori icon (while a window is open)
- [x] About tab icon matches the app icon
- [x] Menu-bar icon renders sharply (light + dark menu bar)

## API key flow
- [x] Composer "Open AI Settings" opens Preferences on the AI tab
- [x] Save key → stored in macOS Keychain
- [x] Remove key → asks for confirmation, then removes
- [x] Test connection → shows real Connected / Failed (never faked)
- [x] Generate disabled with no key; helper "Add API key to generate"
- [x] Generate enabled after a valid key is saved (reopen composer)

## Shortcut & composer
- [x] ⌥M opens the composer / preview-first flow
- [x] ⌥⇧M opens the actions palette (or composer with no selection)
- [x] Escape closes the composer
- [x] Composer is centered on the active screen and floats above windows
- [x] No duplicate composer windows (single reused panel)
- [x] ⌘↩ generates · ⌘C copies draft · ⌘I inserts

## Selected text & clipboard
- [ ] Read Selection works when Accessibility is granted
- [x] Helpful fallback message when selection can't be read
- [x] Paste Clipboard works
- [ ] Insert pastes the draft into the previous app (Accessibility granted)
- [x] Insert falls back to "Copied instead." without Accessibility

## Permissions
- [x] Accessibility status pill is accurate on the Privacy tab
- [x] "Open System Settings" opens the Accessibility pane
- [x] App does not crash when permission is missing

## Memory
- [x] Save to Memory works; count updates
- [x] Memory Library opens; search & delete work
- [x] Export JSON works (error alert on failure)
- [x] Import JSON works (error alert on invalid file)
- [x] Clear all local memories requires confirmation
- [x] Delete archived memories requires confirmation

## Destructive confirmations
- [x] Clear all local memories
- [x] Delete archived memories
- [x] Remove API key
- [x] Reset actions

## Privacy wording (honest — no overclaims)
- [x] "Mori stores memories locally by default."
- [x] "AI processing depends on your selected provider and settings."
- [x] "Mori only sends context when you choose to generate."
- [x] No "never syncs to the cloud" / "fully local AI" claims anywhere

## Onboarding & feedback
- [x] First launch shows the 6-step beta onboarding
- [x] Menu bar → "Send Feedback…" opens the feedback address

> Items left unchecked (`[ ]`) require a human on a real Mac with Accessibility
> granted — they can't be verified headlessly. Confirm them before shipping.
