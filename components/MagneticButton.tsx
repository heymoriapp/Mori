"use client";

import { ReactNode, useRef } from "react";
import { motion, useMotionValue, useSpring } from "framer-motion";
import { usePrefersReducedMotion } from "@/lib/hooks";

type Variant = "primary" | "secondary" | "ghost";

const base =
  "relative inline-flex items-center justify-center gap-2 rounded-full px-6 py-3 text-[0.95rem] font-medium transition-colors duration-300 select-none";

const variants: Record<Variant, string> = {
  primary:
    "bg-forest text-background hover:bg-[#263d2d] shadow-soft",
  secondary:
    "bg-transparent text-ink border border-border hover:border-forest/40 hover:bg-card",
  ghost: "bg-transparent text-forest hover:text-ink",
};

export default function MagneticButton({
  children,
  href,
  onClick,
  variant = "primary",
  className = "",
  strength = 22,
  ariaLabel,
}: {
  children: ReactNode;
  href?: string;
  onClick?: () => void;
  variant?: Variant;
  className?: string;
  strength?: number;
  ariaLabel?: string;
}) {
  const reduced = usePrefersReducedMotion();
  const ref = useRef<HTMLDivElement>(null);

  const x = useMotionValue(0);
  const y = useMotionValue(0);
  const sx = useSpring(x, { stiffness: 220, damping: 18, mass: 0.3 });
  const sy = useSpring(y, { stiffness: 220, damping: 18, mass: 0.3 });

  const handleMove = (e: React.MouseEvent) => {
    if (reduced || !ref.current) return;
    const rect = ref.current.getBoundingClientRect();
    const relX = e.clientX - (rect.left + rect.width / 2);
    const relY = e.clientY - (rect.top + rect.height / 2);
    x.set((relX / rect.width) * strength);
    y.set((relY / rect.height) * strength);
  };

  const reset = () => {
    x.set(0);
    y.set(0);
  };

  const content = (
    <motion.span
      className={`${base} ${variants[variant]} ${className}`}
      style={{ x: sx, y: sy }}
    >
      {children}
    </motion.span>
  );

  return (
    <motion.div
      ref={ref}
      onMouseMove={handleMove}
      onMouseLeave={reset}
      className="inline-block"
    >
      {href ? (
        <a href={href} aria-label={ariaLabel}>
          {content}
        </a>
      ) : (
        <button type="button" onClick={onClick} aria-label={ariaLabel}>
          {content}
        </button>
      )}
    </motion.div>
  );
}
