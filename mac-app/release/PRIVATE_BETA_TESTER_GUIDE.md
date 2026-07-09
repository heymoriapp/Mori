# Mori — Private Beta Tester Guide

_A little memory spirit for your Mac. Thanks for testing v0.1.0._

## What Mori is

Mori is a **menu-bar app** for macOS. Select text in any app, press **⌥M**, and
Mori opens a small composer to **draft a reply, rewrite, summarize, or recall**
from your saved notes — then you **copy or insert** the result. Your memory is
kept **on your Mac**; the AI runs through **your own provider key**.

## Who this beta is for

- Mac users who write a lot of replies, messages, and short docs.
- People comfortable pasting an API key from OpenAI (or an OpenAI-compatible
  gateway) or Anthropic.
- Testers who can tolerate rough edges and send honest feedback.

This is a **controlled ~5-person private beta**. Please don't reshare the build.

## Requirements

- **macOS 14 (Sonoma) or later**, Apple Silicon or Intel.
- An **API key** for your provider (OpenAI-compatible or Anthropic).
- ~2 minutes to set up.

## Download & install

1. Unzip `Mori-0.1.0-beta.zip`.
2. Drag **Mori.app** into **Applications**.
3. This beta is **not notarized yet**, so Gatekeeper blocks the first open. Either:
   - **Right-click Mori.app → Open**, then **Open** in the dialog, or
   - Terminal: `xattr -dr com.apple.quarantine /Applications/Mori.app && open /Applications/Mori.app`
4. Mori runs in the **menu bar** (top-right leaf/guardian icon) — not the Dock.

On first launch you'll see a short 6-screen intro.

## Set up your API key

1. Menu bar → **Preferences… → AI** (the composer's "Open AI Settings" jumps here too).
2. Pick a **Provider** (OpenAI-compatible or Anthropic).
3. Set the **Model** (defaults: `gpt-4o-mini` / `claude-3-5-sonnet-latest`) and,
   if you use a gateway, a **Base URL**.
4. Paste your **API key** → **Save key** → **Test connection**.
   - "Connected · … ready" = good. "Failed" shows the provider's message.
   - The key is stored in your **macOS Keychain**.

> **One-time Keychain prompt.** The first time Mori reads your saved key, macOS
> may ask "Mori wants to use your confidential information…". Click **Always
> Allow**. This is macOS protecting your key, not Mori sending it anywhere. On
> this beta build it can re-ask after you install an update (the app's signature
> changes) — just click **Always Allow** again.

## Grant Accessibility permission

Mori needs Accessibility to **read your selected text** and **insert** replies —
only when you press ⌥M.

1. Preferences → **Privacy** → **Open System Settings**, or
   System Settings → Privacy & Security → **Accessibility**.
2. Enable **Mori**.
3. You can skip this and **paste** context manually instead.

> After each new build you install, macOS may ask you to re-grant Accessibility
> (the beta's ad-hoc signature changes). That's expected.

## How to use ⌥M

- **Select text** in any app (a message, a paragraph, an email).
- Press **⌥M**. The composer opens with your context.
- With nothing selected, ⌥M just opens the composer so you can paste/type.
- **⌥⇧M** opens the **actions palette** — type to filter, ↑/↓ to move, ↩ to run
  an action (Rewrite, Fix grammar, Summarize, …) in place.
- **Esc** closes the composer.

## How to draft a reply

1. In the composer, pick a mode: **Reply · Rewrite · Summarize · Recall**.
2. Make sure the **Context** box has the text (Paste clipboard / Read selection
   if needed).
3. Press **Draft reply** (or **⌘↩**).
4. Watch "Mori is drafting…", then the draft appears — **edit it** if you like.

## How to copy / insert

- **Copy** (or **⌘C**) puts the draft on your clipboard.
- **Insert** (or **⌘I**) pastes it into the app you were in. If Accessibility
  isn't granted or the app rejects a synthetic paste, Mori **copies instead** and
  tells you.

## How to save memory

- In the composer, **Save to Memory** stores the draft/selection as a local note.
- **Preferences → Memory → Open Memory Library** to search, edit, pin, delete,
  and **Export / Import** as JSON.
- Later, use **Recall** mode (or ⌥⇧M → a Recall action) to answer from your notes.
- Memories live in `~/Library/Application Support/Mori/memories.json` on your Mac.

## Known limitations (please expect these)

- Not a background/OS-wide memory engine — Mori reads only the **current
  selection, on demand**.
- Selected-text capture depends on the app exposing it via Accessibility. Some
  apps (certain Electron/web views, secure fields) return nothing — **paste
  manually** there.
- **Insert** may fall back to **Copy** depending on the target app.
- Global shortcuts are **fixed** (⌥M, ⌥⇧M) in this build.
- Recall is **keyword-based** (no embeddings yet); no streaming yet.
- Ad-hoc signed (right-click → Open the first time).

## Privacy (short version)

- Mori is **user-triggered** — nothing happens until you press ⌥M and choose to act.
- **No keylogging, no background capture, no screen recording.**
- **Memories are stored locally on this Mac by default.**
- **AI processing depends on your selected provider and settings** — your chosen
  provider's policy applies to what you send when you generate.

Full details: `PRIVACY.md`.

## Feedback (this is the important part)

Menu bar → **Send Feedback…**, or email **hello@heymori.app** (subject "Mori Beta
Feedback"). Most useful:

- Apps where **selection** or **insert** didn't work (name the app).
- Anything confusing in setup or the composer.
- Draft quality for your real messages.
- Wording that feels off or overclaims.
- Crashes or freezes (roughly what you did before it happened).

Thank you — you're shaping the first version of Mori. 🌱
