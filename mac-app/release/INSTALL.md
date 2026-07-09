# Mori — Install & Packaging (Beta)

## Part 1 — For testers

**Requirements:** macOS 14 (Sonoma) or later, Apple Silicon or Intel, and an API
key for your AI provider (OpenAI-compatible or Anthropic).

### Install

1. Unzip `Mori-0.1.0-beta.zip`.
2. Drag **Mori.app** into your **Applications** folder.
3. This beta is **ad-hoc signed, not notarized**, so Gatekeeper will block the
   first open. Do one of these:
   - **Right-click Mori.app → Open**, then click **Open** in the dialog; **or**
   - Terminal:
     ```bash
     xattr -dr com.apple.quarantine /Applications/Mori.app
     open /Applications/Mori.app
     ```
4. Mori is a **menu-bar app** — look for the leaf/guardian icon at the top-right,
   not in the Dock. (A Dock icon appears only while a window like Preferences is open.)

### First run

- The 6-step onboarding walks you through the shortcut, API key, Accessibility,
  and memory.
- **Preferences → AI**: pick a provider, paste your API key, **Test connection**.
- **Grant Accessibility**: System Settings → Privacy & Security → Accessibility →
  enable **Mori**. This lets ⌥M read your selection and insert replies. You can
  skip it and paste context manually.

### Everyday use

- Select text anywhere → **⌥M**.
- **⌥⇧M** opens the actions palette. **Esc** closes. **⌘↩** generates.

### Update / uninstall

- **Update:** quit Mori (menu → Quit), replace the app, reopen. macOS may ask you
  to re-grant Accessibility (expected for unsigned/ad-hoc builds).
- **Uninstall:** quit Mori, move `Mori.app` to Trash. To remove data:
  ```bash
  rm -rf ~/Library/Application\ Support/Mori
  ```
  The API key lives in the Keychain — remove "Mori" under login.keychain if desired.

---

## Part 2 — For the developer (packaging)

### Build

```bash
cd mac-app
./build-app.sh          # → build/Mori.app  (Command Line Tools only, no Xcode needed)
```

### Package a zip (what testers get)

```bash
./package-app.sh        # → release/dist/Mori-0.1.0-beta.zip  (+ SHA256)
```

`package-app.sh` uses `ditto -c -k --sequesterRsrc --keepParent`, the correct way
to zip an `.app` so its bundle/symlinks survive. Send that zip to testers with
`RELEASE_NOTES.md` and `INSTALL.md`.

### (Optional) Make a .dmg

```bash
# Simple, no dependencies:
hdiutil create -volname "Mori" -srcfolder build/Mori.app -ov -format UDZO \
  release/dist/Mori-0.1.0-beta.dmg

# Nicer (background + /Applications alias), if you install it:
#   brew install create-dmg
#   create-dmg --volname "Mori" --app-drop-link 480 170 \
#     release/dist/Mori-0.1.0-beta.dmg build/Mori.app
```

### Make it install cleanly (Developer ID + notarization)

The ad-hoc build requires the right-click-Open workaround. To remove that for a
wider beta, sign with a **Developer ID Application** certificate and notarize.
This needs **Xcode / a paid Apple Developer account** (the license must be
accepted: `sudo xcodebuild -license accept`).

```bash
# 1) Sign with Developer ID + hardened runtime + the entitlements
codesign --deep --force --options runtime --timestamp \
  --entitlements Mori/Resources/Mori.entitlements \
  --sign "Developer ID Application: YOUR NAME (TEAMID)" \
  build/Mori.app

codesign --verify --strict --verbose=2 build/Mori.app

# 2) Zip for notarization
ditto -c -k --sequesterRsrc --keepParent build/Mori.app /tmp/Mori-notarize.zip

# 3) Submit to Apple (store credentials once with `notarytool store-credentials`)
xcrun notarytool submit /tmp/Mori-notarize.zip \
  --keychain-profile "MoriNotary" --wait

# 4) Staple the ticket to the app, then re-zip / build the dmg for distribution
xcrun stapler staple build/Mori.app
ditto -c -k --sequesterRsrc --keepParent build/Mori.app \
  release/dist/Mori-0.1.0-beta.zip
```

### Stop the repeating Keychain prompt (dev builds)

Ad-hoc signing (`-`) produces a **new signature every build**, so macOS re-asks
for Keychain access after each rebuild. To make **Always Allow** stick across
rebuilds, sign with a **stable identity**:

1. **Keychain Access → Certificate Assistant → Create a Certificate…**
   Name `Mori Dev`, Identity Type **Self Signed Root**, Type **Code Signing**.
2. Build with it:
   ```bash
   MORI_SIGN_IDENTITY="Mori Dev" ./build-app.sh
   ```

Now the Keychain ACL trusts Mori by its stable code-signing identity, so one
**Always Allow** lasts across rebuilds. For a public beta, use a real
**Developer ID Application** identity (and notarize) instead. Mori also caches
the key in memory, so it reads the Keychain at most once per launch.

Notes:
- Mori is intentionally **not sandboxed** (it needs cross-app Accessibility and
  to post ⌘V), so distribution is **Developer ID + notarization**, not the Mac
  App Store.
- The `Mori.entitlements` already sets `app-sandbox = false` and
  `network.client = true`; keep hardened runtime **on** for notarization.
- If you prefer an Xcode-managed project instead of `build-app.sh`, generate one
  with `brew install xcodegen && xcodegen generate` (see `../project.yml`).
