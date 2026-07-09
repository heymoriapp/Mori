"use client";

import { useEffect, useRef, useState } from "react";
import { motion, useInView } from "framer-motion";
import { Reveal } from "./AnimatedText";

const ITEMS = ["Sarah Reza", "Q3 Launch", "Investor prep", "Acme Corp", "Design review"];

const PANELS: Record<
  string,
  { body: string; meta: { label: string; value: string }[] }
> = {
  "Q3 Launch": {
    body: "Public launch moved to June 18. Sarah owns the partner brief. Investor notes are due Thursday.",
    meta: [
      { label: "Owner", value: "Sarah" },
      { label: "Ships", value: "June 18" },
      { label: "Status", value: "On track" },
      { label: "Last seen", value: "Today" },
    ],
  },
  "Sarah Reza": {
    body: "Leads partnerships. Prefers short async updates. Owns the Q3 partner brief and the investor intro thread.",
    meta: [
      { label: "Role", value: "Partnerships" },
      { label: "Threads", value: "3 open" },
      { label: "Tone", value: "Warm, brief" },
      { label: "Last seen", value: "Today" },
    ],
  },
};

export default function MemorySection() {
  const ref = useRef<HTMLDivElement>(null);
  const inView = useInView(ref, { once: false, amount: 0.4 });
  const [selected, setSelected] = useState("Q3 Launch");

  // Shift selection once while the section is in view for a living feel.
  useEffect(() => {
    if (!inView) return;
    const t = setTimeout(() => setSelected("Sarah Reza"), 2600);
    return () => clearTimeout(t);
  }, [inView]);

  const panel = PANELS[selected] ?? PANELS["Q3 Launch"];

  return (
    <section
      id="memory"
      className="relative mx-auto max-w-6xl scroll-mt-24 px-5 py-28 sm:px-8 sm:py-36"
    >
      <div className="mb-16 max-w-2xl">
        <Reveal>
          <span className="label text-clay">memory</span>
        </Reveal>
        <Reveal delay={0.05}>
          <h2 className="mt-5 font-serif text-4xl font-medium leading-tight tracking-tight text-ink sm:text-5xl">
            A small memory page for every person and project.
          </h2>
        </Reveal>
        <Reveal delay={0.1}>
          <p className="mt-6 max-w-xl text-lg leading-relaxed text-muted">
            Mori turns recent work into simple living notes: people, projects,
            decisions, dates, links, and loose threads.
          </p>
        </Reveal>
      </div>

      <Reveal delay={0.1}>
        <div
          ref={ref}
          className="grid overflow-hidden rounded-3xl border border-border bg-card shadow-card md:grid-cols-[240px_1fr]"
        >
          {/* sidebar */}
          <div className="border-b border-border bg-background/50 p-4 md:border-b-0 md:border-r">
            <span className="label text-muted">Recent memory</span>
            <div className="mt-4 space-y-1">
              {ITEMS.map((item) => {
                const active = item === selected;
                return (
                  <button
                    key={item}
                    onClick={() => setSelected(item)}
                    className={`flex w-full items-center gap-2 rounded-lg px-3 py-2 text-left text-sm transition-colors ${
                      active
                        ? "bg-soft-green/60 text-forest"
                        : "text-muted hover:bg-card hover:text-ink"
                    }`}
                  >
                    <span
                      className={`h-1.5 w-1.5 rounded-full ${
                        active ? "bg-forest" : "bg-border"
                      }`}
                    />
                    {item}
                  </button>
                );
              })}
            </div>
          </div>

          {/* right panel */}
          <div className="p-6 sm:p-8">
            <motion.div
              key={selected}
              initial={{ opacity: 0, y: 12 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.5, ease: [0.22, 1, 0.36, 1] }}
            >
              <div className="flex items-center gap-3">
                <h3 className="font-serif text-3xl font-medium text-ink">
                  {selected}
                </h3>
                <span className="flex items-center gap-1.5 rounded-full bg-background px-2.5 py-1">
                  <span className="h-1.5 w-1.5 animate-pulse-dot rounded-full bg-moss" />
                  <span className="label text-moss">written from your activity</span>
                </span>
              </div>

              <p className="mt-5 max-w-lg text-lg leading-relaxed text-ink">
                {panel.body}
              </p>

              <div className="mt-8 grid grid-cols-2 gap-4 sm:grid-cols-4">
                {panel.meta.map((m) => (
                  <div key={m.label}>
                    <span className="label text-muted">{m.label}</span>
                    <p className="mt-1 text-[0.95rem] text-ink">{m.value}</p>
                  </div>
                ))}
              </div>
            </motion.div>
          </div>
        </div>
      </Reveal>
    </section>
  );
}
