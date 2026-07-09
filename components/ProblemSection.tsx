"use client";

import { useRef } from "react";
import { motion, useInView } from "framer-motion";
import { Reveal } from "./AnimatedText";
import MoriMark from "./MoriMark";

const QUESTIONS = [
  { text: "what did Sarah say?", x: "-4rem", y: "-1rem", delay: 0 },
  { text: "where is the launch date?", x: "0rem", y: "1.5rem", delay: 0.15 },
  { text: "make this sound like me", x: "4rem", y: "-0.5rem", delay: 0.3 },
];

export default function ProblemSection() {
  const ref = useRef<HTMLDivElement>(null);
  const inView = useInView(ref, { once: true, amount: 0.3 });

  return (
    <section
      id="problem"
      className="relative mx-auto max-w-6xl px-5 py-28 sm:px-8 sm:py-36"
    >
      <div className="grid items-center gap-14 lg:grid-cols-2 lg:gap-20">
        <div>
          <Reveal>
            <span className="label text-clay">the problem</span>
          </Reveal>
          <Reveal delay={0.05}>
            <h2 className="mt-5 font-serif text-4xl font-medium leading-tight tracking-tight text-ink sm:text-5xl">
              AI still starts from zero.
            </h2>
          </Reveal>
          <Reveal delay={0.1}>
            <p className="mt-6 max-w-md text-lg leading-relaxed text-muted">
              Every reply makes you rebuild the same context: who this person is,
              what happened earlier, what you promised, and what tone to use.
              Mori keeps the recent memory close, so writing feels natural again.
            </p>
          </Reveal>
        </div>

        {/* memory flow visual */}
        <div ref={ref} className="relative min-h-[26rem]">
          <svg
            className="absolute inset-0 h-full w-full"
            viewBox="0 0 400 400"
            fill="none"
            aria-hidden="true"
          >
            {[
              "M120 90 C 200 120, 220 180, 200 250",
              "M200 150 C 210 190, 205 220, 200 255",
              "M280 110 C 220 150, 210 200, 200 250",
            ].map((d, i) => (
              <motion.path
                key={i}
                d={d}
                stroke="#2F4A37"
                strokeWidth="1"
                strokeDasharray="3 4"
                fill="none"
                initial={{ pathLength: 0, opacity: 0 }}
                animate={inView ? { pathLength: 1, opacity: 0.35 } : {}}
                transition={{ duration: 1.2, delay: 0.5 + i * 0.15 }}
              />
            ))}
          </svg>

          {/* question cards */}
          <div className="relative flex flex-col items-center gap-4">
            {QUESTIONS.map((q, i) => (
              <motion.div
                key={q.text}
                initial={{ opacity: 0, y: 20, x: 0 }}
                animate={
                  inView
                    ? { opacity: 1, y: 0, x: q.x }
                    : { opacity: 0, y: 20 }
                }
                transition={{
                  duration: 0.7,
                  delay: q.delay,
                  ease: [0.22, 1, 0.36, 1],
                }}
                className="rounded-xl border border-border bg-card px-4 py-2.5 text-sm text-muted shadow-soft"
                style={{ marginTop: i === 0 ? 0 : undefined }}
              >
                {q.text}
              </motion.div>
            ))}

            {/* Mori answer card */}
            <motion.div
              initial={{ opacity: 0, y: 30, scale: 0.95 }}
              animate={inView ? { opacity: 1, y: 0, scale: 1 } : {}}
              transition={{ duration: 0.8, delay: 0.9, ease: [0.22, 1, 0.36, 1] }}
              className="mt-10 w-full max-w-sm rounded-2xl border border-border bg-card p-5 shadow-float"
            >
              <div className="mb-3 flex items-center gap-2">
                <MoriMark size={20} />
                <span className="label text-forest">Remembered</span>
              </div>
              <p className="font-serif text-lg leading-snug text-ink">
                Remembered from Mail, Notes, Calendar, and your pinned context.
              </p>
            </motion.div>
          </div>
        </div>
      </div>
    </section>
  );
}
