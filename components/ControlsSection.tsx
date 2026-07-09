"use client";

import { useRef } from "react";
import { motion, useInView } from "framer-motion";
import { Reveal } from "./AnimatedText";
import MoriCharacter from "./MoriCharacter";

type Row = {
  app: string;
  state: "on" | "off" | "ask";
  desc: string;
};

const ROWS: Row[] = [
  { app: "Mail", state: "on", desc: "enabled" },
  { app: "Notes", state: "on", desc: "enabled" },
  { app: "Slack", state: "on", desc: "enabled" },
  { app: "Browser", state: "ask", desc: "ask first" },
  { app: "Private apps", state: "off", desc: "excluded" },
  { app: "Sensitive mode", state: "on", desc: "on" },
];

function Toggle({ state, active }: { state: Row["state"]; active: boolean }) {
  if (state === "ask") {
    return (
      <motion.span
        initial={{ opacity: 0 }}
        animate={active ? { opacity: 1 } : {}}
        transition={{ duration: 0.4 }}
        className="rounded-full border border-clay/40 bg-soft-clay/40 px-2.5 py-0.5 font-mono text-[0.65rem] uppercase tracking-wider text-clay"
      >
        ask
      </motion.span>
    );
  }
  const on = state === "on";
  return (
    <span
      className={`relative flex h-6 w-11 items-center rounded-full transition-colors duration-500 ${
        active && on ? "bg-forest" : "bg-border"
      }`}
    >
      <motion.span
        className="absolute h-5 w-5 rounded-full bg-card shadow-soft"
        animate={{ x: active && on ? 22 : 2 }}
        transition={{ type: "spring", stiffness: 500, damping: 30 }}
      />
    </span>
  );
}

export default function ControlsSection() {
  const ref = useRef<HTMLDivElement>(null);
  const inView = useInView(ref, { once: true, amount: 0.4 });

  return (
    <section className="relative overflow-hidden bg-[#F3EFE4] py-28 sm:py-36">
      {/* faded guardian keeping watch over your settings */}
      <MoriCharacter
        silhouette
        size={520}
        silhouetteColor="#2F4A37"
        className="pointer-events-none absolute -bottom-20 -right-16 h-auto w-[360px] opacity-[0.05] sm:w-[520px]"
      />
      <div className="relative mx-auto grid max-w-6xl items-center gap-14 px-5 sm:px-8 lg:grid-cols-2 lg:gap-20">
        <div>
          <Reveal>
            <span className="label text-clay">controls</span>
          </Reveal>
          <Reveal delay={0.05}>
            <h2 className="mt-5 font-serif text-4xl font-medium leading-tight tracking-tight text-ink sm:text-5xl">
              You choose what Mori remembers.
            </h2>
          </Reveal>
          <Reveal delay={0.1}>
            <p className="mt-6 max-w-md text-lg leading-relaxed text-muted">
              Give Mori access only where it helps. Pause capture, exclude apps,
              delete memories, or keep sensitive work private.
            </p>
          </Reveal>
          <Reveal delay={0.2}>
            <motion.span
              initial={{ opacity: 0, y: 10 }}
              animate={inView ? { opacity: 1, y: 0 } : {}}
              transition={{ delay: 0.8, duration: 0.5 }}
              className="mt-8 inline-flex items-center gap-2 rounded-full border border-forest/20 bg-soft-green/50 px-4 py-2"
            >
              <span className="h-2 w-2 animate-pulse-dot rounded-full bg-forest" />
              <span className="label text-forest">Private mode</span>
            </motion.span>
          </Reveal>
        </div>

        {/* settings card */}
        <Reveal delay={0.1}>
          <div
            ref={ref}
            className="overflow-hidden rounded-2xl border border-border bg-card shadow-card"
          >
            <div className="flex items-center gap-2 border-b border-border bg-background/60 px-5 py-3">
              <span className="h-3 w-3 rounded-full bg-[#E2CBBE]" />
              <span className="h-3 w-3 rounded-full bg-[#E7E0D2]" />
              <span className="h-3 w-3 rounded-full bg-soft-green" />
              <span className="ml-3 label text-muted">Mori · Memory access</span>
            </div>
            <div className="divide-y divide-border">
              {ROWS.map((row, i) => (
                <motion.div
                  key={row.app}
                  initial={{ opacity: 0, x: 12 }}
                  animate={inView ? { opacity: 1, x: 0 } : {}}
                  transition={{ delay: 0.1 + i * 0.08, duration: 0.5 }}
                  className="flex items-center justify-between px-5 py-4"
                >
                  <div>
                    <p className="text-[0.95rem] font-medium text-ink">
                      {row.app}
                    </p>
                    <p className="text-xs text-muted">{row.desc}</p>
                  </div>
                  <Toggle state={row.state} active={inView} />
                </motion.div>
              ))}
            </div>
          </div>
        </Reveal>
      </div>
    </section>
  );
}
