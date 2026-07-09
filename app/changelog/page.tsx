import type { Metadata } from "next";
import SubpageShell from "@/components/SubpageShell";

export const metadata: Metadata = {
  title: "Mori Changelog — what the spirit learned",
  description: "Release notes for every Mori beta build.",
};

const RELEASES = [
  {
    version: "0.1.0",
    date: "July 2026",
    tag: "First private beta",
    added: [
      "Menu-bar app with the Mori guardian icon",
      "⌥M — run your default action on selected text, or open the composer",
      "⌥⇧M — keyboard-driven actions palette (filter, ↑/↓, ↩)",
      "Composer with four modes: Reply · Rewrite · Summarize · Recall",
      "8 built-in actions plus custom actions with your own instructions",
      "Local memory: save, search, pin, edit, export/import JSON",
      "Bring-your-own AI key (OpenAI-compatible or Anthropic), stored in Keychain",
      "Preferences: General · Actions · AI · Privacy · Memory · About",
      "Six-screen onboarding, in-app feedback, history of recent results",
    ],
    known: [
      "Ad-hoc signed — right-click → Open on first launch",
      "Apple Silicon only",
      "Selection capture / insert vary by app; falls back to copy",
      "Keyword-based recall (no embeddings yet); no streaming yet",
      "Shortcuts fixed to ⌥M / ⌥⇧M",
    ],
  },
] as const;

export default function ChangelogPage() {
  return (
    <SubpageShell
      eyebrow="changelog"
      title="What the spirit learned."
      intro="Every Mori release, honestly documented — including what doesn't work yet."
    >
      <div className="space-y-12">
        {RELEASES.map((r) => (
          <article
            key={r.version}
            className="rounded-3xl border border-border bg-card p-8 shadow-soft"
          >
            <div className="flex flex-wrap items-baseline gap-3">
              <h2 className="font-serif text-3xl font-medium text-ink">
                v{r.version}
              </h2>
              <span className="rounded-full bg-soft-green/60 px-3 py-1 text-xs font-medium text-forest">
                {r.tag}
              </span>
              <span className="ml-auto font-mono text-xs text-muted">{r.date}</span>
            </div>

            <h3 className="label mt-6 text-forest">Added</h3>
            <ul className="mt-2 list-disc space-y-1 pl-5 text-[0.95rem] leading-relaxed text-muted">
              {r.added.map((item) => (
                <li key={item}>{item}</li>
              ))}
            </ul>

            <h3 className="label mt-6 text-clay">Known limitations</h3>
            <ul className="mt-2 list-disc space-y-1 pl-5 text-[0.95rem] leading-relaxed text-muted">
              {r.known.map((item) => (
                <li key={item}>{item}</li>
              ))}
            </ul>
          </article>
        ))}
      </div>

      <p className="mt-10 text-sm text-muted">
        Following along? The beta updates land here first — or watch the{" "}
        <a
          className="text-forest underline-offset-4 hover:underline"
          href="https://github.com/heymoriapp/Mori"
        >
          GitHub repo
        </a>
        .
      </p>
    </SubpageShell>
  );
}
