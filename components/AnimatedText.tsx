"use client";

import { ReactNode } from "react";
import { motion, Variants } from "framer-motion";
import { usePrefersReducedMotion } from "@/lib/hooks";

/**
 * Reveals text word-by-word with a soft upward stagger.
 * Accepts either a plain string or an array of "segments" so individual
 * words can be styled (e.g. the italic clay "every conversation").
 */
export type Segment = {
  text: string;
  className?: string;
};

const container: Variants = {
  hidden: {},
  visible: (stagger: number) => ({
    transition: { staggerChildren: stagger, delayChildren: 0.05 },
  }),
};

const word: Variants = {
  hidden: { opacity: 0, y: "0.4em", filter: "blur(6px)" },
  visible: {
    opacity: 1,
    y: "0em",
    filter: "blur(0px)",
    transition: { duration: 0.8, ease: [0.22, 1, 0.36, 1] },
  },
};

export default function AnimatedText({
  segments,
  as: Tag = "h1",
  className = "",
  stagger = 0.09,
  once = true,
}: {
  segments: Segment[] | string;
  as?: keyof JSX.IntrinsicElements;
  className?: string;
  stagger?: number;
  once?: boolean;
}) {
  const reduced = usePrefersReducedMotion();
  const parts: Segment[] =
    typeof segments === "string" ? [{ text: segments }] : segments;

  // Flatten into words while keeping segment styling.
  const words: { text: string; className?: string }[] = [];
  parts.forEach((seg) => {
    seg.text.split(" ").forEach((w) => {
      if (w.length) words.push({ text: w, className: seg.className });
    });
  });

  const MotionTag = motion[Tag as keyof typeof motion] as typeof motion.h1;

  if (reduced) {
    const Static = Tag as "h1";
    return (
      <Static className={className}>
        {parts.map((seg, i) => (
          <span key={i} className={seg.className}>
            {seg.text}
            {i < parts.length - 1 ? " " : ""}
          </span>
        ))}
      </Static>
    );
  }

  return (
    <MotionTag
      className={className}
      variants={container}
      custom={stagger}
      initial="hidden"
      whileInView="visible"
      viewport={{ once, amount: 0.4 }}
    >
      {words.map((w, i) => (
        <span
          key={i}
          className="inline-block overflow-hidden align-baseline"
          style={{ paddingBottom: "0.06em" }}
        >
          <motion.span
            variants={word}
            className={`inline-block ${w.className ?? ""}`}
          >
            {w.text}
            {i < words.length - 1 ? " " : ""}
          </motion.span>
        </span>
      ))}
    </MotionTag>
  );
}

/** Simple fade-and-rise wrapper for blocks (subheads, paragraphs, cards). */
export function Reveal({
  children,
  delay = 0,
  y = 24,
  className = "",
  once = true,
}: {
  children: ReactNode;
  delay?: number;
  y?: number;
  className?: string;
  once?: boolean;
}) {
  const reduced = usePrefersReducedMotion();
  if (reduced) return <div className={className}>{children}</div>;

  return (
    <motion.div
      className={className}
      initial={{ opacity: 0, y }}
      whileInView={{ opacity: 1, y: 0 }}
      viewport={{ once, amount: 0.3 }}
      transition={{ duration: 0.8, ease: [0.22, 1, 0.36, 1], delay }}
    >
      {children}
    </motion.div>
  );
}
