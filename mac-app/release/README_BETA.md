# Mori — Private Beta

_A little memory spirit for your Mac._

Mori lives in your menu bar. Select text in any app, press **⌥M**, and Mori
drafts / rewrites / summarizes / recalls — then you copy or insert. Your memory
stays on your Mac; AI runs through your own provider key.

This folder is what you hand to beta testers.

## In this folder

| File | For | What it is |
|---|---|---|
| `README_BETA.md` | everyone | this overview |
| `INSTALL.md` | testers | install + first-run + packaging/notarization |
| `RELEASE_NOTES.md` | testers | what works, limitations, setup, feedback |
| `PRIVACY.md` | testers | plain-language privacy model |
| `BETA_CHECKLIST.md` | you | pre-ship QA checklist |
| `dist/Mori-0.1.0-beta.zip` | testers | the app (created by `../package-app.sh`) |

## 60-second start (testers)

1. Unzip `Mori-0.1.0-beta.zip`, move **Mori.app** to `/Applications`.
2. Open it → click **Done** on the "could not verify" notice → System Settings → Privacy & Security → **Open Anyway**
   (this build isn't notarized yet — see `INSTALL.md`).
3. Follow the 6 onboarding screens.
4. **Preferences → AI** → add your provider API key → **Test connection**.
5. **Grant Accessibility** when asked (lets ⌥M read selections and insert).
6. Select text anywhere → **⌥M**.

Shortcuts: **⌥M** quick action · **⌥⇧M** actions palette · **Esc** close ·
**⌘↩** generate.

## Build it yourself (developer)

```bash
cd ..                # mac-app/
./build-app.sh       # builds build/Mori.app (Command Line Tools only)
./package-app.sh     # → release/dist/Mori-0.1.0-beta.zip
```

## Honest scope

- Mori stores memories **locally by default**; **AI processing depends on your
  selected provider and settings**; Mori **only sends context when you choose to
  generate**.
- It is **not** a background/OS-wide memory engine and **not** fully-local AI.

Feedback: menu bar → **Send Feedback…**, or **hello@heymori.app**.
