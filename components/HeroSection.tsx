"use client";

import { useRef } from "react";
import { motion, useScroll, useTransform } from "framer-motion";
import AnimatedText from "./AnimatedText";
import FloatingReplyCard from "./FloatingReplyCard";
import WaitlistForm from "./WaitlistForm";
import { openDownloadModal } from "./DownloadModal";
import MoriCharacter from "./MoriCharacter";
import { Spores } from "./ForestAtmosphere";
import { usePrefersReducedMotion } from "@/lib/hooks";

export default function HeroSection() {
  const reduced = usePrefersReducedMotion();
  const ref = useRef<HTMLElement>(null);
  const { scrollYProgress } = useScroll({
    target: ref,
    offset: ["start start", "end start"],
  });

  // Hero card gently scales down + fades as you scroll into the next section.
  const cardScale = useTransform(scrollYProgress, [0, 1], [1, 0.9]);
  const cardY = useTransform(scrollYProgress, [0, 1], [0, 60]);
  const cardOpacity = useTransform(scrollYProgress, [0, 0.8], [1, 0.3]);

  return (
    <section
      id="top"
      ref={ref}
      className="relative flex min-h-screen flex-col items-center justify-center overflow-hidden px-5 pb-24 pt-32 sm:px-8"
    >
      {/* morning mist wash */}
      <div
        className="absolute inset-0 -z-20 bg-[radial-gradient(ellipse_60%_50%_at_20%_45%,rgba(221,232,211,0.6),transparent_70%)]"
        aria-hidden="true"
      />
      <Spores className="-z-10" count={14} />

      {/* the forest guardian — the emotional anchor of the page */}
      <div
        className="pointer-events-none absolute left-1/2 top-[8%] -z-10 w-[320px] -translate-x-1/2 opacity-40 sm:left-[2%] sm:top-[56%] sm:w-[390px] sm:-translate-x-0 sm:-translate-y-1/2 sm:opacity-95 lg:w-[440px] lg:left-[0%]"
        aria-hidden="true"
      >
        <MoriCharacter
          size={460}
          breathing
          glow
          followCursor
          eyesFollow
          className="h-auto w-full"
        />
      </div>

      {/* eyebrow */}
      <motion.p
        initial={{ opacity: 0, y: 16 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.8, ease: [0.22, 1, 0.36, 1] }}
        className="label mb-8 text-forest"
      >
        a little memory spirit that lives on your Mac
      </motion.p>

      {/* headline */}
      <AnimatedText
        as="h1"
        className="max-w-4xl text-center font-serif text-[3.4rem] font-medium leading-[0.98] tracking-[-0.02em] text-ink sm:text-7xl lg:text-[5.6rem]"
        segments={[
          { text: "One key to remember " },
          {
            text: "every conversation.",
            className: "italic text-clay",
          },
        ]}
        stagger={0.08}
      />

      {/* subheadline */}
      <motion.p
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.9, delay: 0.5, ease: [0.22, 1, 0.36, 1] }}
        className="mt-8 max-w-xl text-center text-lg leading-relaxed text-muted"
      >
        Press <span className="font-mono text-sm text-forest">⌥M</span> anywhere
        you type. Mori recalls your recent work, understands the thread, and
        drafts a reply in your tone.
      </motion.p>

      {/* waitlist + secondary link */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.9, delay: 0.65, ease: [0.22, 1, 0.36, 1] }}
        className="mt-10 flex w-full flex-col items-center gap-4"
      >
        <WaitlistForm buttonLabel="Join beta" />
        <div className="flex items-center gap-5">
          <a
            href="/downloads/Mori-0.1.0-beta.zip"
            onClick={(e) => {
              e.preventDefault();
              openDownloadModal();
            }}
            className="inline-flex items-center gap-1.5 text-sm font-medium text-forest transition-colors hover:text-ink"
          >
            <svg width="12" height="13" viewBox="0 0 15 16" fill="none" aria-hidden="true">
              <path
                d="M7.5 1v9m0 0L4 6.7M7.5 10L11 6.7M2 12.5h11"
                stroke="currentColor"
                strokeWidth="1.8"
                strokeLinecap="round"
                strokeLinejoin="round"
              />
            </svg>
            Download beta for macOS
          </a>
          <span className="text-border">·</span>
          <a
            href="#how"
            className="group inline-flex items-center gap-1.5 text-sm text-muted transition-colors hover:text-ink"
          >
            See how it works
            <span className="transition-transform duration-300 group-hover:translate-y-0.5">
              ↓
            </span>
          </a>
        </div>
      </motion.div>

      {/* microcopy */}
      <motion.p
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ duration: 1, delay: 0.9 }}
        className="mt-6 text-sm text-muted/80"
      >
        Private by design. Mac-first. No browser tab required.
      </motion.p>

      {/* floating card */}
      <motion.div
        style={
          reduced ? undefined : { scale: cardScale, y: cardY, opacity: cardOpacity }
        }
        className="relative mt-16 w-full sm:mt-20"
      >
        <FloatingReplyCard />
      </motion.div>
    </section>
  );
}
