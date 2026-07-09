# Mori — Beta Release Notes

**Version 0.1.0 (build 1) · Private Mac beta**
_A little memory spirit for your Mac._

Thanks for trying the first Mori beta. It's small on purpose — the goal is to
prove the core loop: **select text → ⌥M → draft/rewrite/summarize/recall →
copy or insert**, with your memory kept on your Mac.

## What works

- **Menu-bar app** (no Dock clutter) with a custom Mori icon.
- **⌥M quick action** on the selected text; **⌥⇧M actions palette** to pick any action.
- **Composer** with four modes: Reply · Rewrite · Summarize · Recall.
- **Actions** — a starter set (Rewrite, Fix spelling & grammar, Make shorter/
  clearer/friendlier/professional, Summarize, Draft reply) plus your own custom
  actions (name, icon, instruction). Test any action on a sample.
- **Bring-your-own AI key** — OpenAI-compatible or Anthropic. Stored in the
  macOS Keychain. Real "Test connection".
- **Copy** always works; **Insert** pastes into your previous app when
  Accessibility is granted, otherwise it copies and tells you.
- **Local memory** — save drafts/selections as notes; search, edit, pin, delete,
  export/import as JSON.
- **Preferences** — General, Actions, AI, Privacy, Memory, About.
- **Send Feedback** from the menu bar.

## Setup (2 minutes)

1. Open Mori (right-click → Open the first time — see `INSTALL.md`).
2. First launch walks you through 6 quick screens.
3. **Preferences → AI**: choose a provider, paste your API key, **Test connection**.
4. **Grant Accessibility** when prompted (needed to read selections and insert).
5. Select some text anywhere and press **⌥M**.

## Privacy model (please read)

- Mori is **user-triggered** — nothing happens until you press ⌥M and choose an action.
- **No background capture, no keylogging, no screen reading.**
- **Memories are stored locally on this Mac by default** (a JSON file in
  Application Support). Mori does not sync them.
- **AI processing depends on your selected provider and settings.** When you
  generate, the context you chose (and any matched memories) is sent to the
  provider/model you configured. Choose a provider whose data policy you trust.
- Mori makes **no "fully local AI"** claim — drafting is a remote API call by design.

## Known limitations

- **Not** a full background/OS-wide memory engine. It reads only the current
  selection, on demand.
- Selected-text capture depends on the app exposing it via Accessibility. Some
  apps (certain Electron/web views, secure fields) won't return a selection —
  paste manually there.
- **Insert** may fall back to **Copy** if Accessibility isn't granted or the
  target app rejects a synthetic paste.
- Global shortcuts are fixed (**⌥M**, **⌥⇧M**) in this build.
- Memory recall is **keyword-based** (embeddings are on the roadmap).
- One request per generation; **no streaming** yet.
- This build is **ad-hoc signed** (not notarized) — Gatekeeper needs a
  right-click → Open the first time.
- After each rebuild, macOS may ask you to **re-grant Accessibility** (the
  ad-hoc signature changes).

## Feedback

Menu bar → **Send Feedback…**, or email **hello@heymori.app** with subject
"Mori Beta Feedback". Crashes, confusing moments, apps where selection/insert
fails, and wording that feels off are all especially useful.

## Roadmap (post-beta)

Custom/rebindable shortcuts · per-app exclusions · streaming responses ·
embedding-based recall · Developer ID signing + notarization.
