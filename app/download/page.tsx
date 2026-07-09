import type { Metadata } from "next";
import SubpageShell, { DocSection, Key } from "@/components/SubpageShell";
import DownloadHero from "./DownloadHero";
import { SITE } from "@/lib/site";

export const metadata: Metadata = {
  title: "Download Mori for Mac — private beta",
  description:
    "Download the Mori beta for macOS. Press ⌥M anywhere you type to draft, rewrite, summarize, and recall — with memory stored locally by default.",
};

export default function DownloadPage() {
  return (
    <SubpageShell
      eyebrow="download"
      title="Get Mori for your Mac."
      intro="The private beta is free to try. Bring your own AI provider key, grant the permissions you're comfortable with, and press ⌥M anywhere."
    >
      <DownloadHero />

      <div className="mt-16 space-y-10">
        <DocSection id="requirements" title="Requirements">
          <ul className="list-disc space-y-1.5 pl-5">
            <li>
              <strong>macOS 14 (Sonoma) or later</strong>, Apple Silicon (M1 or
              newer).
            </li>
            <li>
              An <strong>API key</strong> from OpenAI (or any OpenAI-compatible
              gateway) or Anthropic — Mori uses your key, stored in the macOS
              Keychain.
            </li>
            <li>About two minutes for setup.</li>
          </ul>
        </DocSection>

        <DocSection id="install" title="Install">
          <ol className="list-decimal space-y-2 pl-5">
            <li>
              Unzip <strong>Mori-{SITE.version}-beta.zip</strong> and drag{" "}
              <strong>Mori.app</strong> into your Applications folder.
            </li>
            <li>
              <strong>Right-click Mori.app → Open</strong>, then click Open in
              the dialog. The beta is not notarized yet, so macOS asks once.
            </li>
            <li>
              Look for the <strong>leaf icon in your menu bar</strong> — Mori is
              a menu-bar app, so there&rsquo;s no Dock icon until a window opens.
            </li>
            <li>
              Follow the six onboarding screens: shortcut, AI key, Accessibility
              permission, memory.
            </li>
          </ol>
        </DocSection>

        <DocSection id="verify" title="Verify your download (optional)">
          <p>
            Security-minded? Confirm the file is exactly what we published by
            comparing its SHA-256 checksum in Terminal:
          </p>
          <pre className="overflow-x-auto rounded-xl border border-border bg-card p-4 font-mono text-xs leading-relaxed text-ink">
            {`shasum -a 256 ~/Downloads/Mori-${SITE.version}-beta.zip\n# expected:\n# ${SITE.sha256}`}
          </pre>
        </DocSection>

        <DocSection id="honest" title="Honest beta notes">
          <ul className="list-disc space-y-1.5 pl-5">
            <li>
              This build is <strong>ad-hoc signed, not notarized</strong> — hence
              the one-time right-click → Open. A notarized build is on the
              roadmap.
            </li>
            <li>
              Selected-text capture and <Key>⌥M</Key> insert depend on the app
              you&rsquo;re in; some apps block them, and Mori falls back to
              copy/paste.
            </li>
            <li>
              AI processing depends on your selected provider and settings.
              Memories are stored locally by default.
            </li>
            <li>
              Something broken? <a className="text-forest underline-offset-4 hover:underline" href="/support">Tell us</a> — that&rsquo;s what the beta is for.
            </li>
          </ul>
        </DocSection>
      </div>
    </SubpageShell>
  );
}
