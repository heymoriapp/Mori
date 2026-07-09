"use client";

import { useRef } from "react";
import { motion, MotionValue, useScroll, useTransform } from "framer-motion";
import MoriMark from "./MoriMark";
import MoriCharacter from "./MoriCharacter";
import { ForestFloor, Spores } from "./ForestAtmosphere";
import { usePrefersReducedMotion } from "@/lib/hooks";

const FRAGMENTS = [
  { text: "Sarah: launch is June 18", from: { x: -180, y: -60 }, r: -8 },
  { text: "you promised the brief", from: { x: 200, y: -30 }, r: 6 },
  { text: "notes due Thursday", from: { x: -160, y: 80 }, r: -5 },
  { text: "keep it warm + brief", from: { x: 180, y: 90 }, r: 7 },
];

function Leaf({
  delay,
  x,
  duration,
}: {
  delay: number;
  x: string;
  duration: number;
}) {
  return (
    <motion.svg
      className="absolute top-0"
      style={{ left: x }}
      width="18"
      height="18"
      viewBox="0 0 24 24"
      fill="none"
      initial={{ y: -40, opacity: 0, rotate: 0 }}
      animate={{
        y: ["-5%", "110%"],
        opacity: [0, 0.5, 0.5, 0],
        rotate: [0, 40, -20, 30],
      }}
      transition={{
        duration,
        delay,
        repeat: Infinity,
        ease: "easeInOut",
      }}
    >
      <path
        d="M12 3c5 0 9 3.5 9 9 0 5-4 9-9 9s-9-4-9-9c0-5.5 4-9 9-9z"
        fill="#9CAF88"
        opacity="0.6"
      />
    </motion.svg>
  );
}

function FragmentCard({
  frag,
  converge,
  reduced,
}: {
  frag: (typeof FRAGMENTS)[number];
  converge: MotionValue<number>;
  reduced: boolean;
}) {
  const x = useTransform(converge, (v) => v * frag.from.x);
  const y = useTransform(converge, (v) => v * frag.from.y);
  const opacity = useTransform(converge, [0, 0.6, 1], [0, 0.7, 0.9]);
  const rotate = useTransform(converge, (v) => v * frag.r);

  return (
    <motion.div
      style={reduced ? { opacity: 0.9 } : { x, y, opacity, rotate }}
      className="absolute left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2 whitespace-nowrap rounded-xl border border-border bg-card px-4 py-2 text-sm text-muted shadow-soft"
    >
      {frag.text}
    </motion.div>
  );
}

export default function NarrativeTransition() {
  const reduced = usePrefersReducedMotion();
  const ref = useRef<HTMLDivElement>(null);
  const { scrollYProgress } = useScroll({
    target: ref,
    offset: ["start end", "end start"],
  });

  // Fragments converge from 0.1 → 0.5 of the scroll.
  const converge = useTransform(scrollYProgress, [0.1, 0.55], [1, 0]);
  const answerOpacity = useTransform(converge, [0.4, 0], [0, 1]);

  // The guardian watches from the mist, rising very slightly as you scroll.
  const guardianY = useTransform(scrollYProgress, [0, 1], [40, -40]);

  return (
    <section
      ref={ref}
      className="relative overflow-hidden bg-gradient-to-b from-[#EEF2E6] via-[#E7EEDD] to-background py-40 sm:py-52"
    >
      {/* illustrated environment: forest floor + spores */}
      <ForestFloor className="h-64 opacity-90" />
      <Spores count={12} color="#8AA277" />

      {/* the guardian, watching softly from within the mist */}
      <motion.div
        style={reduced ? undefined : { y: guardianY }}
        className="pointer-events-none absolute bottom-10 left-1/2 -z-10 w-[340px] -translate-x-1/2 opacity-[0.14] sm:w-[460px]"
        aria-hidden="true"
      >
        <MoriCharacter silhouette size={460} className="h-auto w-full" silhouetteColor="#2F4A37" />
      </motion.div>

      {/* drifting leaves */}
      {!reduced && (
        <div className="pointer-events-none absolute inset-0" aria-hidden="true">
          <Leaf delay={0} x="12%" duration={14} />
          <Leaf delay={3} x="28%" duration={18} />
          <Leaf delay={6} x="68%" duration={16} />
          <Leaf delay={2} x="82%" duration={20} />
          <Leaf delay={8} x="48%" duration={15} />
        </div>
      )}

      <div className="relative mx-auto flex max-w-4xl flex-col items-center px-5 text-center sm:px-8">
        {/* converging fragments */}
        <div className="relative mb-4 h-56 w-full max-w-2xl">
          {FRAGMENTS.map((frag, i) => (
            <FragmentCard
              key={i}
              frag={frag}
              converge={converge}
              reduced={reduced}
            />
          ))}

          {/* final clean answer card at center */}
          <motion.div
            style={reduced ? { opacity: 1 } : { opacity: answerOpacity }}
            className="absolute left-1/2 top-1/2 w-full max-w-sm -translate-x-1/2 -translate-y-1/2 rounded-2xl border border-border bg-card p-5 shadow-float"
          >
            <div className="mb-2 flex items-center gap-2">
              <MoriMark size={18} />
              <span className="label text-forest">One clear reply</span>
            </div>
            <p className="text-left font-serif text-lg leading-snug text-ink">
              &ldquo;June 18 works — I&rsquo;ll send the brief after onboarding.&rdquo;
            </p>
          </motion.div>
        </div>

        <motion.h2
          initial={{ opacity: 0, y: 24 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true, amount: 0.5 }}
          transition={{ duration: 1, ease: [0.22, 1, 0.36, 1] }}
          className="mt-8 font-serif text-5xl font-medium leading-tight tracking-tight text-ink sm:text-6xl"
        >
          Stop re-explaining yourself.
        </motion.h2>
        <motion.p
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true, amount: 0.5 }}
          transition={{ duration: 1, delay: 0.2, ease: [0.22, 1, 0.36, 1] }}
          className="mt-6 max-w-md text-lg leading-relaxed text-muted"
        >
          Your context is already there. Mori simply helps you use it.
        </motion.p>
      </div>
    </section>
  );
}
