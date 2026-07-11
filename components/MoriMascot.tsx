"use client";

import { useEffect } from "react";
import { motion, useMotionValue, useSpring } from "framer-motion";
import { usePrefersReducedMotion } from "@/lib/hooks";

/**
 * The real Mori mascot — the 3D forest-spirit render the brand is built around.
 * Served responsively (128 / 256 / 640) from a transparent PNG so it sits
 * cleanly on both the warm paper and the dark forest sections.
 *
 * Fluid by default: it fills its parent's width, so callers control size with a
 * width class (e.g. `w-[420px]`). Pass `size` for the small fixed spots (modal,
 * popup). Tiny chrome (header, favicon) keeps the crisp vector mark instead —
 * same character, sharper at 22px.
 */
const INTRINSIC_W = 637;
const INTRINSIC_H = 640;

export default function MoriMascot({
  size,
  className = "",
  sizes = "(max-width: 640px) 70vw, 440px",
  float = false,
  glow = false,
  parallax = false,
  priority = false,
  alt = "Mori — a little memory spirit for your Mac",
}: {
  size?: number;
  className?: string;
  sizes?: string;
  float?: boolean;
  glow?: boolean;
  parallax?: boolean;
  priority?: boolean;
  alt?: string;
}) {
  const reduced = usePrefersReducedMotion();
  const fixed = typeof size === "number";

  // Gentle cursor parallax — a few pixels of drift so the render feels alive.
  const mx = useMotionValue(0);
  const my = useMotionValue(0);
  const sx = useSpring(mx, { stiffness: 60, damping: 20, mass: 0.6 });
  const sy = useSpring(my, { stiffness: 60, damping: 20, mass: 0.6 });

  useEffect(() => {
    if (!parallax || reduced) return;
    const onMove = (e: MouseEvent) => {
      const cx = window.innerWidth / 2;
      const cy = window.innerHeight / 2;
      mx.set(((e.clientX - cx) / cx) * 12);
      my.set(((e.clientY - cy) / cy) * 9);
    };
    window.addEventListener("mousemove", onMove);
    return () => window.removeEventListener("mousemove", onMove);
  }, [parallax, reduced, mx, my]);

  return (
    <motion.div
      className={`relative ${fixed ? "mx-auto" : "w-full"} ${className}`}
      style={{
        ...(fixed ? { width: size, maxWidth: "100%" } : {}),
        ...(parallax ? { x: sx, y: sy } : {}),
      }}
    >
      <motion.div
        className="relative w-full"
        animate={float && !reduced ? { y: [0, -9, 0] } : undefined}
        transition={
          float
            ? { duration: 5.5, repeat: Infinity, ease: "easeInOut" }
            : undefined
        }
      >
        {glow && (
          <div
            aria-hidden="true"
            className="absolute left-1/2 top-1/2 -z-10 h-[86%] w-[86%] -translate-x-1/2 -translate-y-1/2 rounded-full bg-[radial-gradient(circle,rgba(47,74,55,0.22),transparent_70%)] blur-2xl"
          />
        )}
        <img
          src="/mori-mascot.png"
          srcSet="/mori-mascot-128.png 127w, /mori-mascot-256.png 255w, /mori-mascot.png 637w"
          sizes={fixed ? `${size}px` : sizes}
          width={INTRINSIC_W}
          height={INTRINSIC_H}
          alt={alt}
          draggable={false}
          loading={priority ? "eager" : "lazy"}
          {...(priority ? { fetchPriority: "high" as const } : {})}
          className="h-auto w-full select-none"
          style={{ filter: "drop-shadow(0 16px 28px rgba(47,74,55,0.20))" }}
        />
      </motion.div>
    </motion.div>
  );
}
