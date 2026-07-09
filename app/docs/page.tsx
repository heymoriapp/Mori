import type { Metadata } from "next";
import SubpageShell, { DocSection, Key } from "@/components/SubpageShell";
import { SITE } from "@/lib/site";

export const metadata: Metadata = {
  title: "Mori Docs — everything about your Mac memory companion",
  description:
    "Learn how to install Mori, set up your AI key, use ⌥M and the actions palette, manage local memory, and control privacy.",
};

const TOC = [
  ["getting-started", "Getting started"],
  ["api-key", "API key"],
  ["shortcuts", "Shortcuts"],
  ["composer", "The composer"],
  ["actions", "Actions"],
  ["memory", "Memory"],
  ["privacy", "Privacy controls"],
  ["troubleshooting", "Troubleshooting"],
] as const;

export default function DocsPage() {
  return (
    <SubpageShell
      eyebrow="documentation"
      title="How to live with a memory spirit."
      intro="Everything you need to install Mori, wire up your AI provider, and make ⌥M a habit. Five minutes, start to finish."
    >
      {/* jump nav */}
      <nav aria-label="On this page" className="mb-2 flex flex-wrap gap-2">
        {TOC.map(([id, label]) => (
          <a
            key={id}
            href={`#${id}`}
            className="rounded-full border border-border bg-card px-3.5 py-1.5 text-xs text-muted transition-colors hover:border-forest/40 hover:text-forest"
          >
            {label}
          </a>
        ))}
      </nav>

      <div className="space-y-10">
        <DocSection id="getting-started" title="Getting started">
          <p>
            Mori is a <strong>menu-bar app</strong> — after install you&rsquo;ll
            find a small leaf icon at the top-right of your screen, not a Dock
            icon. The core loop is:
          </p>
          <ol className="list-decimal space-y-1.5 pl-5">
            <li>Select text in any app (a message, an email, a paragraph).</li>
            <li>
              Press <Key>⌥M</Key>. The composer opens with your context already
              in it.
            </li>
            <li>Draft, rewrite, summarize, or recall — then copy or insert.</li>
          </ol>
          <p>
            <strong>Install:</strong> download the beta from the{" "}
            <a className="text-forest underline-offset-4 hover:underline" href="/download">download page</a>, unzip, drag{" "}
            <strong>Mori.app</strong> to Applications, and{" "}
            <strong>right-click → Open</strong> the first time (the beta
            isn&rsquo;t notarized yet). The six onboarding screens walk you
            through the rest.
          </p>
          <p>
            <strong>Accessibility permission</strong> (System Settings → Privacy
            &amp; Security → Accessibility) is what lets Mori read your selection
            and insert replies — only when you press the shortcut. You can skip
            it and paste context manually instead.
          </p>
        </DocSection>

        <DocSection id="api-key" title="Setting up your AI key">
          <p>
            Mori brings no server of its own — it drafts through{" "}
            <strong>your</strong> AI provider. In{" "}
            <strong>Preferences → AI</strong>:
          </p>
          <ol className="list-decimal space-y-1.5 pl-5">
            <li>
              Choose a provider: <strong>OpenAI-compatible</strong> (OpenAI or
              any gateway with the same API) or <strong>Anthropic</strong>.
            </li>
            <li>
              Set the model — defaults are <code>gpt-4o-mini</code> and{" "}
              <code>claude-3-5-sonnet-latest</code>. A custom base URL is
              supported for gateways.
            </li>
            <li>
              Paste your key → <strong>Save key</strong> →{" "}
              <strong>Test connection</strong>. &ldquo;Connected&rdquo; means
              you&rsquo;re ready.
            </li>
          </ol>
          <p>
            Your key is stored in the <strong>macOS Keychain</strong>, never in
            plain files. The first time Mori reads it, macOS may ask you to
            allow access — click <strong>Always Allow</strong>. You can also
            describe your writing tone (e.g. &ldquo;warm, brief, a little
            playful&rdquo;) and Mori will match it when drafting replies.
          </p>
        </DocSection>

        <DocSection id="shortcuts" title="Shortcuts">
          <ul className="space-y-2">
            <li>
              <Key>⌥M</Key> — the main shortcut. With text selected, it prepares
              your default action; with nothing selected, it opens the composer
              (prefilled from your clipboard if there&rsquo;s text on it).
            </li>
            <li>
              <Key>⌥⇧M</Key> — the <strong>actions palette</strong>: type to
              filter, <Key>↑</Key>/<Key>↓</Key> to move, <Key>↩</Key> to apply
              an action to your selection in place.
            </li>
            <li>
              <Key>⌘↩</Key> — generate, inside the composer.
            </li>
            <li>
              <Key>⌘C</Key> / <Key>⌘I</Key> — copy / insert the draft.
            </li>
            <li>
              <Key>Esc</Key> — close any Mori window.
            </li>
          </ul>
          <p>Shortcuts are fixed in the beta; custom bindings are on the roadmap.</p>
        </DocSection>

        <DocSection id="composer" title="The composer">
          <p>
            The floating window that opens on <Key>⌥M</Key>. Four modes across
            the top:
          </p>
          <ul className="list-disc space-y-1.5 pl-5">
            <li>
              <strong>Reply</strong> — drafts a response to the context, using
              your tone and any matching memories.
            </li>
            <li>
              <strong>Rewrite</strong> — makes the text clearer and more natural,
              preserving meaning.
            </li>
            <li>
              <strong>Summarize</strong> — turns long text into short, useful
              notes.
            </li>
            <li>
              <strong>Recall</strong> — answers a question from your saved local
              memories only.
            </li>
          </ul>
          <p>
            The context box fills from your selection automatically, or use{" "}
            <strong>Paste</strong> / <strong>Read selection</strong>. Every draft
            is editable before you <strong>Copy</strong>, <strong>Insert</strong>{" "}
            (pastes into the app you came from), or{" "}
            <strong>Save to Memory</strong>. If inserting isn&rsquo;t possible in
            the target app, Mori copies instead and says so.
          </p>
        </DocSection>

        <DocSection id="actions" title="Actions">
          <p>
            Actions are one-keystroke transformations. Mori ships with eight:
            Rewrite, Fix spelling &amp; grammar, Make shorter, Make clearer, Make
            friendlier, Make professional, Summarize, and Draft reply.
          </p>
          <p>
            In <strong>Preferences → Actions</strong> you can enable, reorder,
            and <strong>create your own</strong> — a name, an icon, and a plain
            instruction like &ldquo;Translate to Spanish&rdquo; or &ldquo;Turn
            into bullet points.&rdquo; Built-ins can&rsquo;t be edited, but you
            can duplicate one and customize the copy. The{" "}
            <strong>Test Action</strong> button runs any action on a sample so
            you can check the result before trusting it with real text.
          </p>
          <p>
            Pick which action <Key>⌥M</Key> runs in{" "}
            <strong>Preferences → General → Quick Action</strong>. By default
            Mori previews in the composer before inserting; turn off
            &ldquo;Show composer before inserting&rdquo; for instant in-place
            replacement.
          </p>
        </DocSection>

        <DocSection id="memory" title="Memory">
          <p>
            Memories are small local notes — a saved draft, a selection, a fact
            you want Mori to recall later. They live in a JSON file on your Mac
            (<code>~/Library/Application Support/Mori/</code>), and nothing syncs
            anywhere.
          </p>
          <ul className="list-disc space-y-1.5 pl-5">
            <li>
              <strong>Save</strong> from the composer (&ldquo;Save to
              Memory&rdquo;) or create notes directly in the Memory Library.
            </li>
            <li>
              <strong>Recall</strong> mode searches them by keyword and answers
              only from what it finds.
            </li>
            <li>
              <strong>Manage</strong> in Preferences → Memory: open the library,
              export/import JSON backups, reveal the file in Finder, or delete
              everything (with confirmation).
            </li>
          </ul>
        </DocSection>

        <DocSection id="privacy" title="Privacy controls">
          <p>
            Mori is user-triggered by design — no keylogging, no background
            capture, no screen recording. In{" "}
            <strong>Preferences → Privacy</strong>:
          </p>
          <ul className="list-disc space-y-1.5 pl-5">
            <li>
              <strong>Pause Mori</strong> — temporarily stop it from using
              selection or memory.
            </li>
            <li>
              <strong>Selected-text capture</strong> — turn off to make Mori
              paste-only.
            </li>
            <li>
              <strong>Require manual paste only</strong> — strictest mode.
            </li>
            <li>
              <strong>Clear all local memories</strong> — one click, confirmed,
              gone.
            </li>
          </ul>
          <p>
            When you generate, the context you chose (plus matched memories and
            your tone) goes to <strong>your selected provider</strong> over
            HTTPS with your key. Their data policy applies to that request. Full
            details on the{" "}
            <a className="text-forest underline-offset-4 hover:underline" href="/privacy">privacy page</a>.
          </p>
        </DocSection>

        <DocSection id="troubleshooting" title="Troubleshooting">
          <ul className="space-y-3">
            <li>
              <strong>&ldquo;Mori.app can&rsquo;t be opened&rdquo;</strong> —
              right-click the app → Open → Open. This is macOS Gatekeeper on
              non-notarized betas, expected for now.
            </li>
            <li>
              <strong>⌥M doesn&rsquo;t read my selection</strong> — check
              Accessibility is granted (Preferences → Privacy shows the status),
              and note some apps (certain web views, secure fields) don&rsquo;t
              expose selections — paste instead.
            </li>
            <li>
              <strong>Insert didn&rsquo;t paste</strong> — some apps reject
              synthetic paste; Mori copies instead and tells you. ⌘V finishes the
              job.
            </li>
            <li>
              <strong>&ldquo;Failed&rdquo; on Test connection</strong> — check
              the key, the model name, and (for gateways) the base URL. The
              error message shown is the provider&rsquo;s own.
            </li>
            <li>
              <strong>Keychain prompt after updating</strong> — the beta&rsquo;s
              signature changes between builds, so macOS re-asks. Click Always
              Allow.
            </li>
            <li>
              Still stuck? <a className="text-forest underline-offset-4 hover:underline" href="/support">Get support</a> — include the app you were
              using and what you expected.
            </li>
          </ul>
        </DocSection>
      </div>

      <p className="mt-14 rounded-2xl border border-border bg-card p-5 text-sm leading-relaxed text-muted">
        Docs current as of Mori {SITE.version}. Mori stores memories locally by
        default; AI processing depends on your selected provider and settings.
      </p>
    </SubpageShell>
  );
}
