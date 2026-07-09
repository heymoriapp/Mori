import type { Metadata } from "next";
import SubpageShell, { DocSection } from "@/components/SubpageShell";
import { SITE } from "@/lib/site";

export const metadata: Metadata = {
  title: "Mori Support — we actually read these",
  description:
    "Get help with the Mori beta: install issues, permissions, API keys, and feedback. Email us or use Send Feedback in the app.",
};

const CHANNELS = [
  {
    title: "Email us",
    body: "The fastest way. A human reads every message during the beta.",
    action: "hello@heymori.app",
    href: `mailto:${SITE.email}?subject=Mori%20Beta%20Support`,
  },
  {
    title: "In-app feedback",
    body: "Menu bar → Send Feedback… opens a pre-addressed email with the subject filled in.",
    action: "Open Mori → menu bar",
    href: null,
  },
  {
    title: "GitHub",
    body: "Browse the source, file issues, or follow development.",
    action: "github.com/heymoriapp/Mori",
    href: SITE.github,
  },
] as const;

export default function SupportPage() {
  return (
    <SubpageShell
      eyebrow="support"
      title="Stuck? A human will help."
      intro="Mori is a small beta and every report genuinely shapes it. Tell us what broke, what confused you, or what you wish it did."
    >
      {/* channels */}
      <div className="grid gap-4 sm:grid-cols-3">
        {CHANNELS.map((c) => (
          <div
            key={c.title}
            className="flex flex-col rounded-2xl border border-border bg-card p-5 shadow-soft"
          >
            <h3 className="font-serif text-xl font-medium text-ink">{c.title}</h3>
            <p className="mt-1.5 flex-1 text-sm leading-relaxed text-muted">{c.body}</p>
            {c.href ? (
              <a
                href={c.href}
                className="mt-4 text-sm font-medium text-forest underline-offset-4 hover:underline"
              >
                {c.action} →
              </a>
            ) : (
              <span className="mt-4 text-sm font-medium text-muted">{c.action}</span>
            )}
          </div>
        ))}
      </div>

      <div className="mt-14 space-y-10">
        <DocSection id="report" title="What makes a great bug report">
          <ul className="list-disc space-y-1.5 pl-5">
            <li>
              <strong>Which app</strong> you were in when ⌥M / selection / insert
              misbehaved (this matters most — behavior varies per app).
            </li>
            <li>What you expected, and what happened instead.</li>
            <li>Your macOS version and Mori version ({SITE.version} — copy it from Preferences → About → Copy Version).</li>
            <li>
              If Mori crashed: the newest file from{" "}
              <code>~/Library/Logs/DiagnosticReports/</code> starting with
              &ldquo;Mori&rdquo; is gold. Attach it.
            </li>
          </ul>
        </DocSection>

        <DocSection id="quick" title="Quick answers">
          <ul className="space-y-3">
            <li>
              <strong>Gatekeeper blocks the app</strong> → right-click Mori.app →
              Open → Open. One time only.
            </li>
            <li>
              <strong>Generate is greyed out</strong> → add an API key in
              Preferences → AI, then Test connection.
            </li>
            <li>
              <strong>Selection isn&rsquo;t captured</strong> → grant
              Accessibility in System Settings → Privacy &amp; Security, or use
              Paste.
            </li>
            <li>
              <strong>Want everything gone?</strong> → quit Mori, delete the app,
              and remove <code>~/Library/Application Support/Mori</code>. Your
              API key lives in Keychain Access under &ldquo;Mori.&rdquo;
            </li>
            <li>
              More in the{" "}
              <a className="text-forest underline-offset-4 hover:underline" href="/docs#troubleshooting">docs troubleshooting section</a>.
            </li>
          </ul>
        </DocSection>

        <DocSection id="response" title="What to expect from us">
          <p>
            This is a private beta run by a tiny team, so no ticket numbers and
            no bots — but also no 5-business-day boilerplate. We aim to reply
            within a couple of days, faster for crashes and data-loss reports.
            Feature requests are welcome; we&rsquo;ll be honest about what
            we&rsquo;re building and what we&rsquo;re not.
          </p>
        </DocSection>
      </div>
    </SubpageShell>
  );
}
