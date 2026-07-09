"use client";

import { useRef } from "react";
import { motion, useInView } from "framer-motion";
import { Reveal } from "./AnimatedText";

const ROWS = [
  "Stored locally on your Mac",
  "App-level memory controls",
  "Pause or exclude any app",
  "One-click forget",
  "Review memory anytime",
];

function LockLeaf({ active }: { active: boolean }) {
  return (
    <div className="relative h-12 w-12">
      {/* lock */}
      <motion.svg
        className="absolute inset-0"
        viewBox="0 0 24 24"
        fill="none"
        animate={{ opacity: active ? 0 : 1, scale: active ? 0.8 : 1 }}
        transition={{ duration: 0.6 }}
      >
        <rect x="5" y="10" width="14" height="10" rx="2" fill="#2F4A37" />
        <path
          d="M8 10V8a4 4 0 118 0v2"
          stroke="#2F4A37"
          strokeWidth="1.6"
          fill="none"
        />
      </motion.svg>
      {/* leaf */}
      <motion.svg
        className="absolute inset-0"
        viewBox="0 0 24 24"
        fill="none"
        initial={{ opacity: 0, scale: 0.8 }}
        animate={{ opacity: active ? 1 : 0, scale: active ? 1 : 0.8 }}
        transition={{ duration: 0.6, delay: active ? 0.3 : 0 }}
      >
        <path
          d="M12 3c5 0 9 3.5 9 9 0 5-4 9-9 9s-9-4-9-9c0-5.5 4-9 9-9z"
          fill="#9CAF88"
        />
        <path
          d="M12 5v14"
          stroke="#2F4A37"
          strokeWidth="1.4"
          strokeLinecap="round"
        />
      </motion.svg>
    </div>
  );
}

export default function PrivacySection() {
  const ref = useRef<HTMLDivElement>(null);
  const inView = useInView(ref, { once: true, amount: 0.4 });

  return (
    <section
      id="privacy"
      className="relative mx-auto max-w-6xl scroll-mt-24 px-5 py-28 sm:px-8 sm:py-36"
    >
      <div className="grid items-center gap-14 lg:grid-cols-2 lg:gap-20">
        <div>
          <Reveal>
            <span className="label text-clay">privacy</span>
          </Reveal>
          <Reveal delay={0.05}>
            <h2 className="mt-5 font-serif text-4xl font-medium leading-tight tracking-tight text-ink sm:text-5xl">
              Your memory should not live in someone else&rsquo;s cloud.
            </h2>
          </Reveal>
          <Reveal delay={0.1}>
            <p className="mt-6 max-w-md text-lg leading-relaxed text-muted">
              Mori is designed local-first. Your memory starts on your Mac, and
              you stay in control of what is remembered, paused, or forgotten.
            </p>
          </Reveal>
          <Reveal delay={0.15}>
            <p className="mt-4 max-w-md text-sm leading-relaxed text-muted/80">
              AI calls depend on your selected provider and settings. Mori is
              built to keep you in control of where your memory lives.
            </p>
          </Reveal>
        </div>

        {/* feature card */}
        <motion.div
          ref={ref}
          initial={{ opacity: 0, y: 30, boxShadow: "0 0 0 rgba(0,0,0,0)" }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true, amount: 0.3 }}
          transition={{ duration: 0.8, ease: [0.22, 1, 0.36, 1] }}
          className="rounded-3xl border border-border bg-card p-8 shadow-card"
        >
          <div className="flex items-center gap-4">
            <LockLeaf active={inView} />
            <div>
              <h3 className="font-serif text-2xl font-medium text-ink">
                Private by design
              </h3>
              <span className="label text-moss">local-first memory</span>
            </div>
          </div>

          <div className="mt-8 space-y-3">
            {ROWS.map((row, i) => (
              <motion.div
                key={row}
                initial={{ opacity: 0, x: 16 }}
                animate={inView ? { opacity: 1, x: 0 } : {}}
                transition={{ delay: 0.3 + i * 0.1, duration: 0.5 }}
                className="flex items-center gap-3"
              >
                <span className="flex h-5 w-5 shrink-0 items-center justify-center rounded-full bg-soft-green">
                  <svg width="11" height="11" viewBox="0 0 12 12" fill="none">
                    <path
                      d="M2.5 6.2l2.2 2.2 4.8-5"
                      stroke="#2F4A37"
                      strokeWidth="1.6"
                      strokeLinecap="round"
                      strokeLinejoin="round"
                    />
                  </svg>
                </span>
                <span className="text-[0.98rem] text-ink">{row}</span>
              </motion.div>
            ))}
          </div>
        </motion.div>
      </div>
    </section>
  );
}
