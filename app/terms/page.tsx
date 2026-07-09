import type { Metadata } from "next";
import SubpageShell, { DocSection } from "@/components/SubpageShell";
import { SITE } from "@/lib/site";

export const metadata: Metadata = {
  title: "Mori Terms of Use",
  description:
    "The terms for using the Mori beta: personal use, your own API keys and costs, as-is beta software, and plain-language expectations.",
};

export default function TermsPage() {
  return (
    <SubpageShell
      eyebrow="legal"
      title="Terms of Use"
      intro="Short, readable terms for the Mori beta. Last updated July 2026 for Mori 0.1.0."
    >
      <div className="space-y-10">
        <DocSection id="acceptance" title="1. Agreement">
          <p>
            By downloading or using the Mori app or this website
            (&ldquo;Mori&rdquo;), you agree to these terms. If you don&rsquo;t
            agree, don&rsquo;t use Mori. &ldquo;We&rdquo; is the Mori team
            reachable at {SITE.email}.
          </p>
        </DocSection>

        <DocSection id="beta" title="2. This is beta software">
          <p>
            Mori {SITE.version} is an early beta provided{" "}
            <strong>&ldquo;as is&rdquo; and &ldquo;as available,&rdquo;</strong>{" "}
            free of charge, for evaluation. It may contain bugs, may change or
            break between versions, and features (including selected-text
            capture and insert) vary by app and macOS configuration. Back up
            anything important; export your memories before updating if they
            matter to you.
          </p>
        </DocSection>

        <DocSection id="license" title="3. License">
          <p>
            We grant you a personal, non-exclusive, non-transferable,
            revocable license to install and use the Mori app on Macs you own
            or control, for the duration of the beta. You may not resell,
            rent, or redistribute the app, or misrepresent it as your own.
          </p>
        </DocSection>

        <DocSection id="byok" title="4. Your AI provider, your key, your costs">
          <ul className="list-disc space-y-1.5 pl-5">
            <li>Mori connects to an AI provider <strong>you</strong> choose using <strong>your</strong> API key.</li>
            <li><strong>You are responsible for any usage fees</strong> your provider charges for requests you make through Mori.</li>
            <li>Your use of that provider is governed by their terms and policies. Content you generate is between you and them; we run no intermediary server.</li>
            <li>You&rsquo;re responsible for what you send: don&rsquo;t submit content you don&rsquo;t have the right to process.</li>
          </ul>
        </DocSection>

        <DocSection id="acceptable" title="5. Acceptable use">
          <p>
            Don&rsquo;t use Mori to break the law, to violate others&rsquo;
            privacy or rights, or to attempt to reverse the app&rsquo;s security
            protections (Keychain storage, permissions) other than for good-faith
            security research — which we welcome; please report findings to{" "}
            {SITE.email}.
          </p>
        </DocSection>

        <DocSection id="warranty" title="6. No warranty; limitation of liability">
          <p>
            To the maximum extent permitted by law, Mori is provided without
            warranties of any kind, express or implied — including fitness for a
            particular purpose and non-infringement. We are not liable for lost
            data, lost profits, provider fees, or any indirect, incidental, or
            consequential damages arising from beta use. Where liability cannot
            be excluded, it is limited to the amount you paid for Mori (during
            the free beta: zero).
          </p>
        </DocSection>

        <DocSection id="feedback" title="7. Feedback">
          <p>
            Feedback you send us may be used to improve Mori without obligation
            or compensation — that&rsquo;s the deal of a beta, and we&rsquo;re
            grateful for it.
          </p>
        </DocSection>

        <DocSection id="termination" title="8. Changes & termination">
          <p>
            We may update these terms (noted in the{" "}
            <a className="text-forest underline-offset-4 hover:underline" href="/changelog">changelog</a>) or end the beta at any time. You can stop
            using Mori at any time; deleting the app and{" "}
            <code>~/Library/Application Support/Mori</code> removes everything it
            stored.
          </p>
        </DocSection>

        <DocSection id="misc" title="9. The small print">
          <p>
            Mori is not affiliated with Studio Ghibli, Apple, OpenAI, or
            Anthropic. Trademarks belong to their owners. If any clause of these
            terms is unenforceable, the rest still applies. Questions:{" "}
            <a className="text-forest underline-offset-4 hover:underline" href={`mailto:${SITE.email}`}>{SITE.email}</a>.
          </p>
        </DocSection>
      </div>
    </SubpageShell>
  );
}
