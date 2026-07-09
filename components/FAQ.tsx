"use client";

import { useState } from "react";
import { AnimatePresence, motion } from "framer-motion";
import { Reveal } from "./AnimatedText";

const FAQS = [
  {
    q: "Is Mori available now?",
    a: "Mori is opening a private Mac beta soon.",
  },
  {
    q: "Is Mori Mac-only?",
    a: "Yes. Mori starts as a Mac-first app because the experience depends on native text fields, shortcuts, and local memory.",
  },
  {
    q: "Does Mori read everything on my Mac?",
    a: "No. Mori is designed around permissions, app controls, and user-approved memory. You choose what it can remember.",
  },
  {
    q: "Can I delete what Mori remembers?",
    a: "Yes. You can forget individual memories, people, projects, apps, or everything.",
  },
  {
    q: "How is this different from ChatGPT or Claude?",
    a: "ChatGPT and Claude are powerful, but they usually wait for you to explain context. Mori brings recent context to the place you are already typing.",
  },
  {
    q: "Is Mori affiliated with Studio Ghibli?",
    a: "No. Mori is an original Mac app inspired by calm forest minimalism. It is not affiliated with Studio Ghibli.",
  },
];

function Item({
  q,
  a,
  isOpen,
  onToggle,
}: {
  q: string;
  a: string;
  isOpen: boolean;
  onToggle: () => void;
}) {
  return (
    <div className="border-b border-border">
      <button
        onClick={onToggle}
        aria-expanded={isOpen}
        className="flex w-full items-center justify-between gap-4 py-6 text-left"
      >
        <span className="font-serif text-xl font-medium text-ink sm:text-2xl">
          {q}
        </span>
        <span className="relative flex h-6 w-6 shrink-0 items-center justify-center">
          <span className="absolute h-[1.5px] w-4 bg-forest" />
          <motion.span
            className="absolute h-4 w-[1.5px] bg-forest"
            animate={{ rotate: isOpen ? 90 : 0, opacity: isOpen ? 0 : 1 }}
            transition={{ duration: 0.3 }}
          />
        </span>
      </button>
      <AnimatePresence initial={false}>
        {isOpen && (
          <motion.div
            initial={{ height: 0, opacity: 0 }}
            animate={{ height: "auto", opacity: 1 }}
            exit={{ height: 0, opacity: 0 }}
            transition={{ duration: 0.4, ease: [0.22, 1, 0.36, 1] }}
            className="overflow-hidden"
          >
            <p className="max-w-2xl pb-6 text-[1.02rem] leading-relaxed text-muted">
              {a}
            </p>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}

export default function FAQ() {
  const [open, setOpen] = useState<number | null>(0);

  return (
    <section
      id="faq"
      className="relative mx-auto max-w-3xl scroll-mt-24 px-5 py-28 sm:px-8 sm:py-36"
    >
      <div className="mb-12">
        <Reveal>
          <span className="label text-clay">questions</span>
        </Reveal>
        <Reveal delay={0.05}>
          <h2 className="mt-5 font-serif text-4xl font-medium leading-tight tracking-tight text-ink sm:text-5xl">
            Frequently asked questions
          </h2>
        </Reveal>
      </div>

      <Reveal delay={0.1}>
        <div>
          {FAQS.map((faq, i) => (
            <Item
              key={faq.q}
              q={faq.q}
              a={faq.a}
              isOpen={open === i}
              onToggle={() => setOpen(open === i ? null : i)}
            />
          ))}
        </div>
      </Reveal>
    </section>
  );
}
