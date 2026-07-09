"use client";

import { motion } from "framer-motion";
import MoriMark from "./MoriMark";
import { usePrefersReducedMotion } from "@/lib/hooks";

/**
 * The hero's floating Mori composer — the core product visual. Reads top to
 * bottom as the whole flow: press ⌥M → Mori recalls context → Mori drafts the
 * reply. Larger and more legible than a decorative card; floats gently with a
 * blinking cursor and pulsing status.
 */
export default function FloatingReplyCard() {
  const reduced = usePrefersReducedMotion();

  return (
    <div className="mx-auto w-full max-w-2xl">
      <motion.div
        className="relative"
        animate={reduced ? undefined : { y: [0, -10, 0] }}
        transition={
          reduced ? undefined : { duration: 7, repeat: Infinity, ease: "easeInOut" }
        }
      >
        {/* soft glow behind card */}
        <div
          className="absolute -inset-10 -z-10 rounded-[2.5rem] bg-soft-green/50 blur-3xl"
          aria-hidden="true"
        />

        <div className="rounded-[1.75rem] border border-border bg-card/95 p-6 shadow-float backdrop-blur-sm sm:p-8">
          {/* top row */}
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3.5">
              <span className="rounded-lg border border-border bg-background px-2.5 py-1.5 font-mono text-sm font-medium text-forest">
                ⌥M
              </span>
              <span className="flex items-center gap-2">
                <span className="relative flex h-2.5 w-2.5">
                  <span className="absolute inline-flex h-full w-full animate-pulse-dot rounded-full bg-moss" />
                  <span className="relative inline-flex h-2.5 w-2.5 rounded-full bg-forest" />
                </span>
                <span className="label text-muted">Drafting reply</span>
              </span>
            </div>
            <MoriMark size={26} />
          </div>

          <div className="my-5 h-px w-full bg-border" />

          {/* recall step — what Mori pulled context from */}
          <div className="mb-5 flex flex-wrap items-center gap-2">
            <span className="label mr-1 text-forest">Recalled from</span>
            {["Mail", "Notes", "Calendar"].map((src) => (
              <span
                key={src}
                className="rounded-full border border-border bg-background px-3 py-1 text-xs text-muted"
              >
                {src}
              </span>
            ))}
          </div>

          {/* the draft */}
          <p className="font-serif text-xl leading-relaxed text-ink sm:text-[1.6rem] sm:leading-relaxed">
            yes, Thursday works. I&rsquo;ll send the updated investor notes after
            the call — also Sarah moved launch to June 18, so we&rsquo;re aligned.
            <span
              className="ml-1 inline-block h-[1.05em] w-[3px] translate-y-[0.15em] bg-clay align-middle animate-blink"
              aria-hidden="true"
            />
          </p>

          {/* actions */}
          <div className="mt-7 flex items-center gap-2.5">
            <span className="rounded-full bg-forest px-5 py-2.5 text-sm font-medium text-background">
              Insert reply
            </span>
            <span className="rounded-full border border-border px-5 py-2.5 text-sm text-muted">
              Rewrite
            </span>
            <span className="ml-auto flex items-center gap-1.5 label text-moss">
              <span className="h-1.5 w-1.5 rounded-full bg-moss" />
              Private mode
            </span>
          </div>
        </div>
      </motion.div>

      {/* caption */}
      <p className="mt-5 text-center text-sm text-muted">
        Works anywhere you type on your Mac.
      </p>
    </div>
  );
}
