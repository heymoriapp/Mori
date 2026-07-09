import type { Metadata } from "next";
import SubpageShell, { DocSection } from "@/components/SubpageShell";
import { SITE } from "@/lib/site";

export const metadata: Metadata = {
  title: "Mori Privacy Policy",
  description:
    "How Mori handles your data: user-triggered capture, local-first memory, your own AI provider key, and no tracking we don't disclose.",
};

export default function PrivacyPage() {
  return (
    <SubpageShell
      eyebrow="legal"
      title="Privacy Policy"
      intro="Plain language, no dark patterns. This covers both the Mori Mac app and this website. Last updated July 2026 for Mori 0.1.0 (beta)."
    >
      <div className="space-y-10">
        <DocSection id="summary" title="The short version">
          <ul className="list-disc space-y-1.5 pl-5">
            <li>The Mori app is <strong>user-triggered</strong> — it does nothing until you press ⌥M and choose an action.</li>
            <li><strong>No keylogging, no background capture, no screen recording.</strong></li>
            <li><strong>Memories are stored locally on your Mac by default.</strong> We run no memory sync service.</li>
            <li>AI drafting goes to <strong>the provider you configure, with your key</strong>. Their policies apply to those requests.</li>
            <li>We don&rsquo;t sell data. There&rsquo;s no advertising. There are no fake claims of &ldquo;fully local AI&rdquo; either — generation is a network call to your provider.</li>
          </ul>
        </DocSection>

        <DocSection id="app-reads" title="What the app reads, and when">
          <p>Mori only ever accesses:</p>
          <ul className="list-disc space-y-1.5 pl-5">
            <li><strong>Text you select</strong>, at the moment you press ⌥M, via macOS Accessibility — a permission you explicitly grant and can revoke anytime.</li>
            <li><strong>Text you paste or type</strong> into the composer.</li>
            <li><strong>Memories you chose to save.</strong></li>
          </ul>
          <p>It does not monitor keystrokes, scan your apps, or watch your screen.</p>
        </DocSection>

        <DocSection id="app-stores" title="What the app stores, and where">
          <ul className="list-disc space-y-1.5 pl-5">
            <li><strong>Memories &amp; action settings</strong> — JSON files in <code>~/Library/Application Support/Mori/</code> on your Mac. Export, import, or delete them anytime.</li>
            <li><strong>Your API key</strong> — in the macOS Keychain, never in plain files or preferences.</li>
            <li><strong>Preferences</strong> — standard macOS user defaults on your Mac.</li>
          </ul>
          <p>The app sends us no telemetry, analytics, or crash reports in this beta.</p>
        </DocSection>

        <DocSection id="app-sends" title="What gets sent to your AI provider">
          <p>
            When — and only when — you generate: the context you provided, any
            local memories Mori matched for that request, and your optional tone
            description. It travels over HTTPS directly to the provider and
            model <strong>you configured</strong> (e.g. OpenAI-compatible or
            Anthropic), authenticated with <strong>your</strong> key. We operate
            no middle server, so we never see that content. Your provider&rsquo;s
            privacy and retention policies govern those requests — choose one
            you trust.
          </p>
        </DocSection>

        <DocSection id="website" title="This website">
          <ul className="list-disc space-y-1.5 pl-5">
            <li>We use <strong>no advertising trackers and no third-party analytics scripts</strong>.</li>
            <li>Our hosting provider (Vercel) processes standard server logs (IP address, user agent, requested pages) to serve and protect the site.</li>
            <li>If you join the <strong>beta waitlist</strong>, we use your email only to contact you about Mori — never to sell, share, or spam. Unsubscribe by replying &ldquo;stop.&rdquo;</li>
            <li>A small <code>localStorage</code> flag remembers that you dismissed our beta popup so we don&rsquo;t show it again. That&rsquo;s it — no cookies for tracking.</li>
          </ul>
        </DocSection>

        <DocSection id="rights" title="Your controls & rights">
          <ul className="list-disc space-y-1.5 pl-5">
            <li>Delete any memory, all memories, or the whole app — everything the app stores is on your machine and under your control.</li>
            <li>Revoke Accessibility permission at any time in System Settings.</li>
            <li>Remove your API key from the Keychain via Preferences → AI.</li>
            <li>Ask us what we hold about you (for the website, it&rsquo;s at most your waitlist email): <a className="text-forest underline-offset-4 hover:underline" href={`mailto:${SITE.email}`}>{SITE.email}</a>.</li>
          </ul>
        </DocSection>

        <DocSection id="changes" title="Changes & contact">
          <p>
            If this policy changes materially, we&rsquo;ll update the date above
            and note it in the{" "}
            <a className="text-forest underline-offset-4 hover:underline" href="/changelog">changelog</a>. Questions:{" "}
            <a className="text-forest underline-offset-4 hover:underline" href={`mailto:${SITE.email}`}>{SITE.email}</a>.
          </p>
        </DocSection>
      </div>
    </SubpageShell>
  );
}
