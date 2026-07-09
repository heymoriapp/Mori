"use client";

import { motion } from "framer-motion";
import { Reveal } from "./AnimatedText";
import MoriMark from "./MoriMark";

function KeyPressVisual() {
  return (
    <div className="flex h-28 items-center justify-center gap-2">
      <motion.span
        className="rounded-lg border border-border bg-background px-3 py-2 font-mono text-sm text-forest shadow-soft"
        animate={{ y: [0, 4, 0], boxShadow: ["0 6px 0 -2px #E7E0D2", "0 2px 0 -2px #E7E0D2", "0 6px 0 -2px #E7E0D2"] }}
        transition={{ duration: 2.4, repeat: Infinity, ease: "easeInOut" }}
      >
        ⌥
      </motion.span>
      <motion.span
        className="rounded-lg border border-border bg-background px-3 py-2 font-mono text-sm text-forest shadow-soft"
        animate={{ y: [0, 4, 0] }}
        transition={{ duration: 2.4, repeat: Infinity, ease: "easeInOut", delay: 0.12 }}
      >
        M
      </motion.span>
    </div>
  );
}

function OrbitVisual() {
  const dots = [0, 1, 2, 3, 4];
  return (
    <div className="relative flex h-28 items-center justify-center">
      <motion.div
        className="relative h-24 w-24"
        animate={{ rotate: 360 }}
        transition={{ duration: 18, repeat: Infinity, ease: "linear" }}
      >
        {dots.map((i) => {
          const angle = (i / dots.length) * Math.PI * 2;
          return (
            <span
              key={i}
              className="absolute h-2.5 w-2.5 rounded-full bg-moss"
              style={{
                left: `calc(50% + ${Math.cos(angle) * 44}px - 5px)`,
                top: `calc(50% + ${Math.sin(angle) * 44}px - 5px)`,
                opacity: 0.4 + (i / dots.length) * 0.6,
              }}
            />
          );
        })}
      </motion.div>
      <div className="absolute flex h-10 w-10 items-center justify-center rounded-full border border-border bg-card shadow-soft">
        <MoriMark size={20} />
      </div>
    </div>
  );
}

function TypeVisual() {
  return (
    <div className="flex h-28 items-center justify-center">
      <div className="w-full max-w-[12rem] rounded-lg border border-border bg-background px-3 py-2.5">
        <motion.span
          className="font-serif text-sm text-ink"
          initial={{ width: 0 }}
        >
          <TypedLine />
        </motion.span>
      </div>
    </div>
  );
}

function TypedLine() {
  return (
    <motion.span
      className="inline-block overflow-hidden whitespace-nowrap align-middle"
      initial={{ maxWidth: "0ch" }}
      whileInView={{ maxWidth: "16ch" }}
      viewport={{ once: false, amount: 0.6 }}
      transition={{ duration: 2, ease: "linear", repeat: Infinity, repeatDelay: 1 }}
    >
      Sounds good — done.
    </motion.span>
  );
}

const CARDS = [
  {
    step: "01",
    title: "Press ⌥M",
    body: "Use Mori from any text field on your Mac.",
    visual: <KeyPressVisual />,
  },
  {
    step: "02",
    title: "Mori recalls context",
    body: "It checks recent work, people, projects, and pinned notes.",
    visual: <OrbitVisual />,
  },
  {
    step: "03",
    title: "Insert the reply",
    body: "Draft, rewrite, summarize, or recall without switching apps.",
    visual: <TypeVisual />,
  },
];

export default function HowItWorks() {
  return (
    <section
      id="how"
      className="relative mx-auto max-w-6xl scroll-mt-24 px-5 py-28 sm:px-8 sm:py-36"
    >
      <div className="mb-16 max-w-2xl">
        <Reveal>
          <span className="label text-clay">how it works</span>
        </Reveal>
        <Reveal delay={0.05}>
          <h2 className="mt-5 font-serif text-4xl font-medium leading-tight tracking-tight text-ink sm:text-5xl">
            Quietly helpful. Never in the way.
          </h2>
        </Reveal>
      </div>

      <div className="grid gap-5 md:grid-cols-3">
        {CARDS.map((card, i) => (
          <motion.div
            key={card.step}
            initial={{ opacity: 0, y: 30 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true, amount: 0.3 }}
            transition={{ duration: 0.7, delay: i * 0.12, ease: [0.22, 1, 0.36, 1] }}
            whileHover={{ y: -6 }}
            className="group flex flex-col rounded-2xl border border-border bg-card p-6 shadow-soft transition-shadow duration-300 hover:shadow-card"
          >
            <span className="label text-moss">{card.step}</span>
            <div className="my-4 rounded-xl bg-background/60 transition-colors group-hover:bg-soft-green/30">
              {card.visual}
            </div>
            <h3 className="font-serif text-2xl font-medium text-ink">
              {card.title}
            </h3>
            <p className="mt-2 text-[0.95rem] leading-relaxed text-muted">
              {card.body}
            </p>
          </motion.div>
        ))}
      </div>
    </section>
  );
}
