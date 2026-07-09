# Mori — Manual QA Script (v0.1.0)

Run this on a real Mac (macOS 14+) before each beta hand-off. ~15 minutes.
Mark each step **PASS / FAIL** and note the app/context for any failure.

**Prep:** have an API key ready. Ideally test on a Mac that has **never** run
Mori (or reset state — see the last section) to exercise first-run.

---

## A. Fresh install
1. Unzip `Mori-0.1.0-beta.zip`; move `Mori.app` to `/Applications`. → app present
2. Double-click → Gatekeeper blocks it. → block shown (expected, unsigned)
3. Right-click → **Open** → **Open**. → app launches
4. Confirm a **menu-bar** icon appears (top-right), no Dock icon. → menu-bar icon shows

## B. Onboarding
5. First launch shows the intro. Step through all **6 screens**. → all render, no clipping
6. On "Add your AI provider key", paste a key → **Save key** shows "Saved ✓". → saved
7. On "Enable Accessibility", **Open System Settings** opens the Accessibility pane. → opens
8. Finish with **Start using Mori**. → onboarding closes, doesn't reappear on relaunch

## C. API key + connection
9. Menu bar → Preferences → **AI**. Key field shows dots (masked). → masked
10. Change provider → model resets to default; status returns to **Not tested**. → resets
11. **Test connection** with a valid key → **Connected · <model> ready**. → real success
12. Break the key (edit a char) → Save → Test → **Failed** with a message. → real failure
13. Fix the key, Save, Test → Connected again. → recovers

## D. Composer open
14. Select a sentence in Notes/TextEdit → press **⌥M**. → composer opens, centered, floats
15. Composer shows the selection in **Context** and the source app pill. → context present
16. Press **⌥M** again → does not spawn a second window. → single window
17. Press **Esc** → composer closes. → closes

## E. Clipboard + selection
18. Copy some text elsewhere → in composer click **Paste** → context fills. → paste works
19. Select text in a supported app → composer → **Read selection** → context updates. → read works
20. Try **Read selection** in an app that blocks it → helpful message, no crash. → graceful

## F. Generate
21. With context + valid key, press **Draft reply** (or **⌘↩**). → "Mori is drafting…"
22. Draft appears; edit a word in the draft box. → editable
23. Switch mode to **Rewrite** / **Summarize** and generate again. → works per mode

## G. Copy / insert
24. Click **Copy** (or **⌘C**) → paste elsewhere → matches draft. → copy works
25. Put the cursor in a text field in another app → composer **Insert** (⌘I). → draft pastes in
26. Revoke Accessibility → try Insert → "Copied instead." message + draft on clipboard. → fallback

## H. Memory
27. In composer, **Save to Memory** → status confirms. → saved
28. Preferences → **Memory** → count increased by 1. → count updates
29. **Open Memory Library** → the new memory is listed. → appears
30. **Search** for a word in it → it filters. → search works
31. **Edit** its title/body → Save → change persists. → edit works
32. **Pin**, then **Delete** a memory (context menu) → removed. → delete works

## I. Export / import
33. Preferences → Memory → **Export memories** → save a `.json`. → file written
34. **Import memories** → pick that file → count unchanged (merge, no dupes). → import works
35. Import a non-JSON file → **error alert** appears, no crash. → error surfaced

## J. Destructive confirmations
36. Preferences → Privacy → **Clear all local memories** → confirmation dialog. → confirm required
37. Preferences → Memory → **Delete archived** (disabled if none) → confirmation when enabled. → confirm
38. Preferences → AI → **Remove** key → confirmation dialog. → confirm required
39. Preferences → Actions → **Reset** → confirmation dialog. → confirm required

## K. Quit / relaunch
40. Menu bar → **Quit Mori**. → quits cleanly
41. Reopen `Mori.app` → onboarding does **not** reappear; key + memories persist. → state persists
42. Press **⌥M** → still works after relaunch. → shortcut persists

## L. Permission-missing state
43. Remove Mori from Accessibility → press ⌥M → composer still opens. → no crash
44. **Read selection** → clear "enable Accessibility" style message. → guided
45. Draft still works via **Paste**; Insert falls back to Copy. → usable without permission

## M. No-API-key state
46. Preferences → AI → **Remove** key (confirm).
47. Press ⌥M → composer shows the **"API key required"** setup state; **Draft reply**
    disabled with "Add API key to generate". → gated correctly
48. **Open AI Settings** button opens Preferences on the **AI tab**. → correct tab
49. Add a valid key → reopen composer → drafting is enabled again. → restored

---

## Reset state (to re-test first-run)
```bash
# quit Mori first
defaults delete app.heymori.Mori 2>/dev/null || true
rm -rf ~/Library/Application\ Support/Mori
# remove the "Mori" / "app.heymori.Mori" item from login.keychain if testing key setup
```

## Sign-off
- Tester: ____________________  macOS: __________  Date: __________
- Blocking failures: ____________________________________________
- Ship? ☐ yes  ☐ no
