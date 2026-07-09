# Mori — Privacy (Beta)

_Last updated for v0.1.0. Plain-language summary of how Mori handles your data.
This is a beta; wording is intentionally careful and avoids overclaiming._

## The short version

- Mori is **user-triggered**. It does nothing until you press ⌥M and choose an action.
- **No keylogging. No background capture. No screen recording.**
- **Your memories are stored locally on this Mac by default.**
- **AI processing depends on your selected provider and settings.** When you
  generate, the context you choose is sent to that provider.
- Mori is **not** "fully local AI" and is **not** a background memory engine.

## What Mori reads, and when

Mori only ever looks at:

1. **The text you select**, and only at the moment you press ⌥M — via the macOS
   Accessibility API, which you explicitly grant. If you don't grant it, Mori
   can't read selections; use **Paste** instead.
2. **Text you paste or type** into the composer yourself.
3. **Memories you chose to save** (see below).

Mori does **not** monitor your keystrokes, watch your screen, or scan apps in
the background.

## Where your data lives

- **Memories** are stored in a local JSON file on this Mac:
  `~/Library/Application Support/Mori/memories.json`.
  Mori does not sync this file anywhere. You can export, import, or delete it
  anytime (Preferences → Memory, or the Memory Library).
- **Your API key** is stored in the **macOS Keychain**, not in preferences or
  plain files.
- **Preferences** (provider, model, toggles) are stored in standard macOS user
  defaults on this Mac.

## What gets sent to your AI provider

When — and only when — you press Generate / run an action:

- The **context** you provided (selected or pasted text), plus
- Any **local memories** Mori matched for that request, plus
- Your optional **tone** description.

This is sent to the **provider and model you configured** (e.g. OpenAI-compatible
or Anthropic) over HTTPS, using **your** API key. Mori does not add its own
servers or telemetry. **Your provider's privacy and data-retention policies
apply to that request** — please choose a provider you trust.

## Your controls

- **Pause Mori** — stop it using selection or memory.
- **Enable selected-text capture** / **Require manual paste only** — limit input.
- **Restore clipboard after insert** — put your clipboard back after a paste.
- **Delete** any memory, **Clear all** memories, or **delete archived** — all
  with confirmation.
- **Remove API key** from the Keychain — with confirmation.

## Not claimed

To stay honest, Mori does **not** claim:

- that it "never sends anything to the cloud" (generation is a remote API call),
- that AI runs fully on-device,
- that it captures or remembers everything across your Mac.

## Contact

Questions or concerns: **hello@heymori.app**.
