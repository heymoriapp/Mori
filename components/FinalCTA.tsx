"use client";

import { motion } from "framer-motion";
import WaitlistForm from "./WaitlistForm";
import { openDownloadModal } from "./DownloadModal";
import MoriMascot from "./MoriMascot";
import { ForestFloor, Spores, DriftingLeaves } from "./ForestAtmosphere";
import { usePrefersReducedMotion } from "@/lib/hooks";

export default function FinalCTA() {
  const reduced = usePrefersReducedMotion();

  return (
    <section
      id="beta"
      className="relative scroll-mt-24 overflow-hidden px-5 py-32 sm:px-8 sm:py-44"
    >
      {/* forest clearing background */}
      <div
        className="absolute inset-0 -z-20 bg-gradient-to-b from-[#DDE8D3] via-[#E7EEDD] to-background"
        aria-hidden="true"
      />
      {/* soft moving sunlight */}
      {!reduced && (
        <motion.div
          className="absolute -top-48 left-1/2 -z-20 h-[40rem] w-[40rem] -translate-x-1/2 rounded-full bg-[radial-gradient(circle,rgba(255,247,220,0.95),rgba(255,247,220,0)_70%)] blur-2xl"
          animate={{ opacity: [0.55, 1, 0.55], scale: [1, 1.09, 1], x: ["-52%", "-48%", "-52%"] }}
          transition={{ duration: 11, repeat: Infinity, ease: "easeInOut" }}
          aria-hidden="true"
        />
      )}
      {/* canopy shade */}
      <div
        className="absolute inset-x-0 top-0 -z-20 h-48 bg-[radial-gradient(ellipse_at_top,rgba(47,74,55,0.12),transparent_60%)]"
        aria-hidden="true"
      />

      <ForestFloor className="h-72 opacity-95" />
      <Spores count={14} color="#8AA277" />
      <DriftingLeaves count={6} />

      <motion.div
        initial={{ opacity: 0, y: 30 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true, amount: 0.4 }}
        transition={{ duration: 0.9, ease: [0.22, 1, 0.36, 1] }}
        animate={reduced ? undefined : { y: [0, -6, 0] }}
        className="relative mx-auto mt-32 max-w-2xl rounded-3xl border border-border bg-card/80 p-10 text-center shadow-float backdrop-blur-md sm:mt-40 sm:p-14"
      >
        {/* the guardian, met in the clearing — sits on the card's top edge */}
        <motion.div
          initial={{ opacity: 0, y: 20, scale: 0.9 }}
          whileInView={{ opacity: 1, y: 0, scale: 1 }}
          viewport={{ once: true, amount: 0.4 }}
          transition={{ duration: 0.9, delay: 0.2, ease: [0.22, 1, 0.36, 1] }}
          className="pointer-events-none absolute -top-[104px] left-1/2 z-10 w-[124px] -translate-x-1/2 sm:-top-[122px] sm:w-[146px]"
          aria-hidden="true"
        >
          <MoriMascot glow sizes="146px" />
        </motion.div>

        <span className="label text-moss">private beta</span>
        <h2 className="mt-5 font-serif text-4xl font-medium leading-tight tracking-tight text-ink sm:text-5xl">
          Try Mori for Mac.
        </h2>
        <p className="mx-auto mt-6 max-w-lg text-lg leading-relaxed text-muted">
          Mori is in private beta. Add your AI provider key, press{" "}
          <span className="font-mono text-sm text-forest">⌥M</span> anywhere you
          type, and draft replies with the context already there.
        </p>
        <div className="mt-9 flex flex-col items-center">
          {/* direct beta download */}
          <a
            href="/downloads/Mori-0.1.0-beta.zip"
            onClick={(e) => {
              e.preventDefault();
              openDownloadModal();
            }}
            className="group inline-flex items-center gap-2.5 rounded-full bg-forest px-7 py-3.5 text-base font-medium text-background shadow-soft transition-colors duration-300 hover:bg-[#263d2d]"
          >
            <svg width="15" height="16" viewBox="0 0 15 16" fill="none" aria-hidden="true">
              <path
                d="M7.5 1v9m0 0L4 6.7M7.5 10L11 6.7M2 12.5h11"
                stroke="currentColor"
                strokeWidth="1.6"
                strokeLinecap="round"
                strokeLinejoin="round"
              />
            </svg>
            Download Mori beta for macOS
          </a>
          <p className="mt-3 font-mono text-xs text-muted">
            v0.1.0 · macOS 14+ · Apple Silicon · 1.3 MB
          </p>

          {/* install steps */}
          <div className="mt-6 w-full max-w-md rounded-2xl border border-border bg-background/70 p-4 text-left">
            <p className="label mb-2.5 text-forest">Install in 60 seconds</p>
            <ol className="space-y-1.5 text-sm leading-relaxed text-muted">
              <li>
                <span className="font-medium text-ink">1.</span> Unzip, drag{" "}
                <span className="text-ink">Mori.app</span> into Applications, open
                it — macOS shows a &ldquo;not verified&rdquo; notice. Click{" "}
                <span className="text-ink">Done</span>.
              </li>
              <li>
                <span className="font-medium text-ink">2.</span>{" "}
                <span className="text-ink">
                  System Settings → Privacy &amp; Security → Open Anyway
                </span>{" "}
                (standard for early betas — notarized build coming).
              </li>
              <li>
                <span className="font-medium text-ink">3.</span> Add your AI key in
                Preferences, then press{" "}
                <span className="font-mono text-xs text-forest">⌥M</span> anywhere.
              </li>
            </ol>
          </div>

          <div className="mt-7 w-full max-w-md border-t border-border pt-6">
            <p className="mb-3 text-sm text-muted">
              Or get updates as the beta evolves:
            </p>
            <div className="flex justify-center">
              <WaitlistForm buttonLabel="Join beta" />
            </div>
          </div>

          <p className="mt-5 text-sm text-muted">
            Mac-first. Memories stored locally by default. AI processing depends
            on your selected provider.
          </p>
          <p className="mt-4 inline-block rounded-full border border-border bg-background/70 px-3.5 py-1.5 text-xs text-muted">
            Mori 0.1.0 is an early beta. Selected-text capture and insert behavior
            may vary by app.
          </p>
        </div>
      </motion.div>
    </section>
  );
}
