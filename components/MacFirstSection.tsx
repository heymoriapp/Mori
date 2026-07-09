"use client";

import { useRef } from "react";
import { motion, useInView, useScroll, useTransform } from "framer-motion";
import { Reveal } from "./AnimatedText";
import MagneticButton from "./MagneticButton";
import MoriMark from "./MoriMark";
import MoriGlyph from "./MoriGlyph";
import { usePrefersReducedMotion } from "@/lib/hooks";

function Toggle({ on, active }: { on: boolean; active: boolean }) {
  return (
    <span
      className={`relative flex h-5 w-9 items-center rounded-full transition-colors duration-500 ${
        active && on ? "bg-forest" : "bg-border"
      }`}
    >
      <motion.span
        className="absolute h-4 w-4 rounded-full bg-card shadow-soft"
        animate={{ x: active && on ? 18 : 2 }}
        transition={{ type: "spring", stiffness: 500, damping: 30 }}
      />
    </span>
  );
}

export default function MacFirstSection() {
  const reduced = usePrefersReducedMotion();
  const ref = useRef<HTMLDivElement>(null);
  const inView = useInView(ref, { once: true, amount: 0.35 });
  const { scrollYProgress } = useScroll({
    target: ref,
    offset: ["start end", "end start"],
  });
  const bgY = useTransform(scrollYProgress, [0, 1], [24, -24]);
  const prefsY = useTransform(scrollYProgress, [0, 1], [40, -14]);
  const composerY = useTransform(scrollYProgress, [0, 1], [60, -8]);

  return (
    <section className="relative mx-auto max-w-6xl px-5 py-28 sm:px-8 sm:py-36">
      <div className="mb-14 max-w-2xl">
        <Reveal>
          <span className="label text-clay">mac-native</span>
        </Reveal>
        <Reveal delay={0.05}>
          <h2 className="mt-5 font-serif text-4xl font-medium leading-tight tracking-tight text-ink sm:text-5xl">
            Made for the way your Mac already works.
          </h2>
        </Reveal>
        <Reveal delay={0.1}>
          <p className="mt-6 max-w-xl text-lg leading-relaxed text-muted">
            Not another AI website. Mori installs as a native menu-bar app — with
            a real keyboard shortcut, proper permissions, and memory that stays on
            your Mac.
          </p>
        </Reveal>
      </div>

      <Reveal delay={0.1}>
        <div
          ref={ref}
          className="relative overflow-hidden rounded-3xl border border-border bg-gradient-to-b from-[#EDE7D8] to-[#F3EFE4] shadow-card"
        >
          {/* menu bar */}
          <div className="relative z-20 flex items-center justify-between border-b border-border/60 bg-background/70 px-4 py-2 backdrop-blur-sm">
            <div className="flex items-center gap-3">
              <div className="mr-1 flex gap-1.5">
                <span className="h-3 w-3 rounded-full bg-[#E2CBBE]" />
                <span className="h-3 w-3 rounded-full bg-[#E7E0D2]" />
                <span className="h-3 w-3 rounded-full bg-soft-green" />
              </div>
              <span className="text-xs font-medium text-ink">Mori</span>
              <span className="hidden text-xs text-muted sm:inline">File</span>
              <span className="hidden text-xs text-muted sm:inline">Edit</span>
              <span className="hidden text-xs text-muted sm:inline">View</span>
            </div>
            <div className="flex items-center gap-3">
              <motion.span
                className="flex items-center gap-1.5 rounded-md px-1.5 py-0.5"
                animate={
                  reduced
                    ? undefined
                    : {
                        boxShadow: [
                          "0 0 0 0 rgba(156,175,136,0)",
                          "0 0 14px 2px rgba(156,175,136,0.55)",
                          "0 0 0 0 rgba(156,175,136,0)",
                        ],
                      }
                }
                transition={{ duration: 3, repeat: Infinity, ease: "easeInOut" }}
              >
                <MoriGlyph size={15} color="#2F4A37" title="Mori" />
                <span className="font-mono text-[0.6rem] text-forest">⌥M</span>
              </motion.span>
              <span className="text-xs text-muted">100%</span>
              <span className="text-xs text-muted">4:22</span>
            </div>
          </div>

          {/* desktop */}
          <div className="relative px-5 py-8 sm:px-10 sm:py-12">
            {/* background text lines */}
            <motion.div
              style={reduced ? undefined : { y: bgY }}
              className="pointer-events-none absolute inset-0 flex items-center justify-center opacity-40"
              aria-hidden="true"
            >
              <div className="w-full max-w-lg space-y-3">
                <div className="h-3 w-2/3 rounded-full bg-border" />
                <div className="h-3 w-full rounded-full bg-border" />
                <div className="h-3 w-4/5 rounded-full bg-border" />
                <div className="mt-8 h-3 w-1/2 rounded-full bg-border" />
                <div className="h-3 w-full rounded-full bg-border" />
              </div>
            </motion.div>

            {/* shortcut overlay */}
            <motion.div
              initial={{ opacity: 0, y: -10 }}
              animate={inView ? { opacity: 1, y: 0 } : {}}
              transition={{ duration: 0.6, delay: 0.2 }}
              className="relative z-10 mx-auto mb-8 flex w-fit items-center gap-3 rounded-full border border-border bg-card/90 px-4 py-2 shadow-float backdrop-blur-sm"
            >
              <span className="flex items-center gap-1">
                <kbd className="rounded-md border border-border bg-background px-2 py-1 font-mono text-xs text-forest">
                  ⌥
                </kbd>
                <span className="text-muted">+</span>
                <kbd className="rounded-md border border-border bg-background px-2 py-1 font-mono text-xs text-forest">
                  M
                </kbd>
              </span>
              <span className="text-sm text-ink">Summon Mori anywhere</span>
            </motion.div>

            {/* panels */}
            <div className="relative z-10 grid gap-5 md:grid-cols-2">
              {/* preferences / permissions */}
              <motion.div
                style={reduced ? undefined : { y: prefsY }}
                initial={{ opacity: 0, x: -20 }}
                animate={inView ? { opacity: 1, x: 0 } : {}}
                transition={{ duration: 0.7, delay: 0.25, ease: [0.22, 1, 0.36, 1] }}
                className="overflow-hidden rounded-2xl border border-border bg-card shadow-float"
              >
                <div className="border-b border-border bg-background/60 px-4 py-2.5">
                  <span className="label text-muted">Mori · Preferences</span>
                </div>
                <div className="divide-y divide-border px-4">
                  <div className="flex items-center justify-between py-3">
                    <span className="text-sm text-ink">Launch at login</span>
                    <Toggle on active={inView} />
                  </div>
                  <div className="flex items-center justify-between py-3">
                    <span className="text-sm text-ink">Global shortcut</span>
                    <kbd className="rounded-md border border-border bg-background px-2 py-0.5 font-mono text-xs text-forest">
                      ⌥M
                    </kbd>
                  </div>
                  <div className="flex items-center justify-between py-3">
                    <span className="text-sm text-ink">Memory storage</span>
                    <span className="flex items-center gap-1.5 rounded-full bg-soft-green/60 px-2.5 py-0.5 text-xs text-forest">
                      <span className="h-1.5 w-1.5 rounded-full bg-forest" />
                      On this Mac
                    </span>
                  </div>
                  <div className="py-3">
                    <span className="label text-muted">App access</span>
                    <div className="mt-2.5 space-y-2.5">
                      {[
                        { app: "Mail", state: "on" as const },
                        { app: "Notes", state: "on" as const },
                        { app: "Browser", state: "ask" as const },
                      ].map((r) => (
                        <div key={r.app} className="flex items-center justify-between">
                          <span className="text-sm text-ink">{r.app}</span>
                          {r.state === "ask" ? (
                            <span className="rounded-full border border-clay/40 bg-soft-clay/40 px-2.5 py-0.5 font-mono text-[0.6rem] uppercase tracking-wider text-clay">
                              ask
                            </span>
                          ) : (
                            <Toggle on active={inView} />
                          )}
                        </div>
                      ))}
                    </div>
                  </div>
                </div>
              </motion.div>

              {/* floating composer window */}
              <motion.div
                style={reduced ? undefined : { y: composerY }}
                initial={{ opacity: 0, y: 30, scale: 0.97 }}
                animate={inView ? { opacity: 1, y: 0, scale: 1 } : {}}
                transition={{ duration: 0.8, delay: 0.35, ease: [0.22, 1, 0.36, 1] }}
                className="self-start rounded-2xl border border-border bg-card shadow-float"
              >
                <div className="flex items-center justify-between border-b border-border px-4 py-2.5">
                  <div className="flex items-center gap-2">
                    <span className="rounded-md border border-border bg-background px-2 py-1 font-mono text-xs text-forest">
                      ⌥M
                    </span>
                    <span className="flex items-center gap-2">
                      <span className="h-2 w-2 animate-pulse-dot rounded-full bg-forest" />
                      <span className="label text-muted">Drafting reply</span>
                    </span>
                  </div>
                  <MoriMark size={20} />
                </div>
                <div className="p-4">
                  <div className="mb-3 flex flex-wrap items-center gap-1.5">
                    <span className="label mr-1 text-forest">Recalled</span>
                    {["Mail", "Calendar"].map((s) => (
                      <span
                        key={s}
                        className="rounded-full border border-border bg-background px-2.5 py-0.5 text-xs text-muted"
                      >
                        {s}
                      </span>
                    ))}
                  </div>
                  <p className="font-serif text-lg leading-relaxed text-ink">
                    Confirmed — June 18 works. Sending the brief right after
                    onboarding.
                    <span className="ml-0.5 inline-block h-[1.05em] w-[2px] translate-y-[0.12em] bg-clay align-middle animate-blink" />
                  </p>
                  <div className="mt-4 flex gap-2">
                    <span className="rounded-full bg-forest px-4 py-2 text-xs font-medium text-background">
                      Insert reply
                    </span>
                    <span className="rounded-full border border-border px-4 py-2 text-xs text-muted">
                      Rewrite
                    </span>
                  </div>
                </div>
              </motion.div>
            </div>
          </div>
        </div>
      </Reveal>

      <Reveal delay={0.1} className="mt-12 flex justify-center">
        <MagneticButton href="#beta" variant="primary">
          Join the Mac beta
        </MagneticButton>
      </Reveal>
    </section>
  );
}
