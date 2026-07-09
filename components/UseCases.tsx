"use client";

import { motion } from "framer-motion";
import { Reveal } from "./AnimatedText";

const CASES = [
  {
    title: "Reply faster",
    body: "Turn messy context into a clean response.",
    snippet: "Drafted from your last 3 threads with Sarah.",
  },
  {
    title: "Remember decisions",
    body: "Ask what changed, who said what, and when.",
    snippet: "Launch moved June 11 → June 18. Sarah's call.",
  },
  {
    title: "Rewrite in your tone",
    body: "Make rough text sound more like you.",
    snippet: "Matched to your usual warm, brief style.",
  },
  {
    title: "Summarize threads",
    body: "Catch up without rereading everything.",
    snippet: "42 messages → 3 decisions, 1 open question.",
  },
  {
    title: "Prepare follow-ups",
    body: "Never lose the small details after calls or chats.",
    snippet: "Reminder: send partner brief after onboarding.",
  },
];

function Card({
  data,
  index,
}: {
  data: (typeof CASES)[number];
  index: number;
}) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 24 }}
      whileInView={{ opacity: 1, y: 0 }}
      viewport={{ once: true, amount: 0.3 }}
      transition={{ duration: 0.7, delay: (index % 3) * 0.08, ease: [0.22, 1, 0.36, 1] }}
      className="group relative flex h-full flex-col overflow-hidden rounded-2xl border border-border bg-card p-6 shadow-soft transition-shadow duration-300 hover:shadow-card"
    >
      <span className="label text-moss">0{index + 1}</span>
      <h3 className="mt-4 font-serif text-2xl font-medium text-ink">
        {data.title}
      </h3>
      <p className="mt-2 text-[0.95rem] leading-relaxed text-muted">
        {data.body}
      </p>

      {/* hover memory snippet */}
      <div className="mt-4 max-h-0 overflow-hidden opacity-0 transition-all duration-500 group-hover:max-h-24 group-hover:opacity-100">
        <div className="rounded-lg border border-border bg-background px-3 py-2">
          <span className="label text-forest">recalled</span>
          <p className="mt-1 text-sm text-ink">{data.snippet}</p>
        </div>
      </div>
    </motion.div>
  );
}

export default function UseCases() {
  return (
    <section className="relative mx-auto max-w-6xl px-5 py-28 sm:px-8 sm:py-36">
      <div className="mb-16 max-w-2xl">
        <Reveal>
          <span className="label text-clay">use cases</span>
        </Reveal>
        <Reveal delay={0.05}>
          <h2 className="mt-5 font-serif text-4xl font-medium leading-tight tracking-tight text-ink sm:text-5xl">
            For the tabs, threads, and people you keep juggling.
          </h2>
        </Reveal>
      </div>

      <div className="grid auto-rows-fr gap-5 sm:grid-cols-2 lg:grid-cols-3">
        {CASES.map((c, i) => (
          <Card key={c.title} data={c} index={i} />
        ))}
        {/* closing note card */}
        <Reveal className="h-full">
          <div className="flex h-full items-center rounded-2xl border border-dashed border-border bg-background/40 p-6">
            <p className="font-serif text-2xl leading-snug text-forest">
              One shortcut. The whole thread, remembered.
            </p>
          </div>
        </Reveal>
      </div>
    </section>
  );
}
