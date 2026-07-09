"use client";

import { useState } from "react";
import { motion } from "framer-motion";
import { Reveal } from "./AnimatedText";
import MoriIcon from "./MoriIcon";
import MoriGlyph from "./MoriGlyph";
import MoriLoader from "./MoriLoader";

type Variant = "forest" | "paper" | "clay";

const TONES: { key: Variant; label: string; swatch: string }[] = [
  { key: "forest", label: "Forest", swatch: "#2F4A37" },
  { key: "paper", label: "Paper", swatch: "#EFE6CF" },
  { key: "clay", label: "Clay", swatch: "#D96B3C" },
];

function Panel({
  children,
  label,
  className = "",
}: {
  children: React.ReactNode;
  label: string;
  className?: string;
}) {
  return (
    <div
      className={`relative flex flex-col overflow-hidden rounded-2xl border border-border bg-card p-5 shadow-soft ${className}`}
    >
      <span className="label mb-4 text-muted">{label}</span>
      <div className="flex flex-1 items-center justify-center">{children}</div>
    </div>
  );
}

export default function BrandIdentity() {
  const [tone, setTone] = useState<Variant>("forest");

  return (
    <section className="relative overflow-hidden bg-[#F3EFE4] py-28 sm:py-36">
      <div className="mx-auto max-w-6xl px-5 sm:px-8">
        <div className="mb-16 max-w-2xl">
          <Reveal>
            <span className="label text-clay">the mark</span>
          </Reveal>
          <Reveal delay={0.05}>
            <h2 className="mt-5 font-serif text-4xl font-medium leading-tight tracking-tight text-ink sm:text-5xl">
              One face. Everywhere it matters.
            </h2>
          </Reveal>
          <Reveal delay={0.1}>
            <p className="mt-6 max-w-xl text-lg leading-relaxed text-muted">
              The same little guardian in your dock, your menu bar, your browser
              tab — down to a 16&#8209;pixel favicon. A memory you recognise the
              moment you see it.
            </p>
          </Reveal>
        </div>

        <div className="grid gap-5 lg:grid-cols-[1.15fr_1fr]">
          {/* master app icon — interactive tone switch */}
          <Reveal>
            <div className="relative flex h-full flex-col items-center justify-center overflow-hidden rounded-3xl border border-border bg-gradient-to-b from-card to-background p-8 shadow-card sm:p-12">
              <span className="label absolute left-6 top-6 text-muted">
                App icon
              </span>

              <div className="relative mt-6">
                <motion.div
                  key={tone}
                  initial={{ scale: 0.92, opacity: 0, y: 8 }}
                  animate={{ scale: 1, opacity: 1, y: 0 }}
                  transition={{ duration: 0.5, ease: [0.22, 1, 0.36, 1] }}
                >
                  <MoriIcon
                    size={200}
                    variant={tone}
                    radius={46}
                    className="rounded-[46px] shadow-float"
                    title="Mori app icon"
                  />
                </motion.div>
                {/* soft pedestal reflection */}
                <div
                  className="mx-auto mt-3 h-6 w-40 rounded-[50%] bg-ink/10 blur-md"
                  aria-hidden="true"
                />
              </div>

              {/* tone switch */}
              <div className="mt-6 flex items-center gap-2">
                {TONES.map((t) => (
                  <button
                    key={t.key}
                    onClick={() => setTone(t.key)}
                    aria-label={`${t.label} icon`}
                    aria-pressed={tone === t.key}
                    className={`flex items-center gap-2 rounded-full border px-3 py-1.5 text-xs transition-colors ${
                      tone === t.key
                        ? "border-forest/40 bg-soft-green/50 text-forest"
                        : "border-border text-muted hover:text-ink"
                    }`}
                  >
                    <span
                      className="h-3 w-3 rounded-full ring-1 ring-black/10"
                      style={{ background: t.swatch }}
                    />
                    {t.label}
                  </button>
                ))}
              </div>
            </div>
          </Reveal>

          {/* surfaces grid */}
          <div className="grid gap-5 sm:grid-cols-2">
            {/* menu bar */}
            <Reveal delay={0.05}>
              <Panel label="Menu bar" className="h-full">
                <div className="w-full rounded-xl border border-border bg-background/70 px-3 py-2">
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-3 text-[0.7rem] text-muted">
                      <MoriGlyph size={16} color="#2F4A37" title="Mori" />
                      <span className="font-mono">⌥M</span>
                    </div>
                    <div className="flex items-center gap-2 text-[0.7rem] text-muted">
                      <span>100%</span>
                      <span className="font-mono">4:22</span>
                    </div>
                  </div>
                </div>
              </Panel>
            </Reveal>

            {/* browser tab */}
            <Reveal delay={0.1}>
              <Panel label="Browser tab" className="h-full">
                <div className="w-full">
                  <div className="flex items-center gap-2 rounded-t-lg border border-b-0 border-border bg-background px-3 py-2">
                    <MoriIcon size={16} variant="paper" radius={4} />
                    <span className="truncate text-xs text-ink">mori</span>
                    <span className="ml-auto text-muted">×</span>
                  </div>
                  <div className="rounded-b-lg border border-border bg-card px-3 py-1.5 text-[0.65rem] text-muted">
                    heymori.app
                  </div>
                </div>
              </Panel>
            </Reveal>

            {/* loader */}
            <Reveal delay={0.15}>
              <Panel label="Loader" className="h-full">
                <div className="flex flex-col items-center gap-3">
                  <MoriLoader size={60} variant="forest" />
                  <span className="label text-moss">recalling memory</span>
                </div>
              </Panel>
            </Reveal>

            {/* sticker */}
            <Reveal delay={0.2}>
              <Panel label="Sticker" className="h-full">
                <motion.div
                  initial={{ rotate: -6 }}
                  whileHover={{ rotate: 3, scale: 1.05 }}
                  transition={{ type: "spring", stiffness: 200, damping: 12 }}
                  className="relative"
                >
                  {/* die-cut white border */}
                  <div className="rounded-[28%] bg-card p-2 shadow-float ring-1 ring-black/5">
                    <MoriIcon size={72} variant="clay" radius={20} />
                  </div>
                </motion.div>
              </Panel>
            </Reveal>
          </div>
        </div>

        {/* scalability proof */}
        <Reveal delay={0.1}>
          <div className="mt-5 flex flex-col items-center gap-6 rounded-2xl border border-border bg-card px-6 py-7 shadow-soft sm:flex-row sm:justify-between">
            <span className="label text-muted">Holds at every size</span>
            <div className="flex items-end gap-6">
              {[16, 24, 32, 48, 64].map((s) => (
                <div key={s} className="flex flex-col items-center gap-2">
                  <MoriIcon size={s} variant="forest" radius={s * 0.23} />
                  <span className="font-mono text-[0.6rem] text-muted">{s}px</span>
                </div>
              ))}
            </div>
          </div>
        </Reveal>
      </div>
    </section>
  );
}
