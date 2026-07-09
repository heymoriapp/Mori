"use client";

import { motion } from "framer-motion";
import MoriIcon from "./MoriIcon";
import { usePrefersReducedMotion } from "@/lib/hooks";

/**
 * The Mori loader — the guardian, breathing, ringed by three orbiting spores
 * and a soft pulse of forest light. A calm "the spirit is remembering" moment
 * rather than a spinner. Falls back to a still icon under reduced motion.
 */
export default function MoriLoader({
  size = 72,
  variant = "forest",
  className = "",
}: {
  size?: number;
  variant?: "forest" | "paper" | "clay";
  className?: string;
}) {
  const reduced = usePrefersReducedMotion();
  const ring = size * 0.74;

  return (
    <div
      className={`relative inline-flex items-center justify-center ${className}`}
      style={{ width: size * 1.5, height: size * 1.5 }}
      role="status"
      aria-label="Loading"
    >
      {/* pulsing halo */}
      {!reduced && (
        <motion.span
          className="absolute rounded-full bg-moss/30 blur-xl"
          style={{ width: size, height: size }}
          animate={{ opacity: [0.35, 0.7, 0.35], scale: [0.9, 1.15, 0.9] }}
          transition={{ duration: 2.6, repeat: Infinity, ease: "easeInOut" }}
        />
      )}

      {/* orbiting spores */}
      {!reduced && (
        <motion.div
          className="absolute"
          style={{ width: ring, height: ring }}
          animate={{ rotate: 360 }}
          transition={{ duration: 6, repeat: Infinity, ease: "linear" }}
        >
          {[0, 1, 2].map((i) => {
            const angle = (i / 3) * Math.PI * 2;
            return (
              <span
                key={i}
                className="absolute h-2 w-2 rounded-full bg-moss"
                style={{
                  left: `calc(50% + ${Math.cos(angle) * (ring / 2)}px - 4px)`,
                  top: `calc(50% + ${Math.sin(angle) * (ring / 2)}px - 4px)`,
                  opacity: 0.4 + i * 0.25,
                }}
              />
            );
          })}
        </motion.div>
      )}

      {/* breathing guardian */}
      <motion.div
        animate={reduced ? undefined : { scale: [1, 1.06, 1] }}
        transition={
          reduced ? undefined : { duration: 2.6, repeat: Infinity, ease: "easeInOut" }
        }
        style={{ transformOrigin: "50% 55%" }}
      >
        <MoriIcon size={size} variant={variant} className="shadow-soft" />
      </motion.div>
    </div>
  );
}
