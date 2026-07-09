"use client";

import { useEffect, useId } from "react";
import {
  motion,
  useMotionValue,
  useSpring,
  useTransform,
} from "framer-motion";
import { usePrefersReducedMotion } from "@/lib/hooks";

/**
 * Mori — the forest guardian.
 *
 * An original woodland memory-spirit: a rounded, misty-edged body with heavy
 * sleepy eyes, leaf-shaped ears and a little sprout crown. Designed to read as
 * iconic even in silhouette. Not Totoro — no chevron belly, no whiskers, no
 * cat ears, no toothy grin. Just a calm, ancient, lovable guardian.
 */
export default function MoriCharacter({
  size = 320,
  className = "",
  breathing = true,
  glow = false,
  followCursor = false,
  eyesFollow = false,
  silhouette = false,
  silhouetteColor = "#2F4A37",
}: {
  size?: number;
  className?: string;
  breathing?: boolean;
  glow?: boolean;
  /** whole body drifts subtly toward the cursor */
  followCursor?: boolean;
  /** eye highlights + pupils track the cursor */
  eyesFollow?: boolean;
  /** render only the flat silhouette (for faded backgrounds) */
  silhouette?: boolean;
  silhouetteColor?: string;
}) {
  const reduced = usePrefersReducedMotion();
  const uid = useId().replace(/:/g, "");

  // cursor tracking (normalised -0.5..0.5)
  const mx = useMotionValue(0);
  const my = useMotionValue(0);
  const smx = useSpring(mx, { stiffness: 40, damping: 18, mass: 1 });
  const smy = useSpring(my, { stiffness: 40, damping: 18, mass: 1 });

  const bodyX = useTransform(smx, (v) => v * 22);
  const bodyY = useTransform(smy, (v) => v * 22);
  const eyeX = useTransform(smx, (v) => v * 7);
  const eyeY = useTransform(smy, (v) => v * 5);

  useEffect(() => {
    if (reduced || (!followCursor && !eyesFollow)) return;
    const onMove = (e: MouseEvent) => {
      mx.set(e.clientX / window.innerWidth - 0.5);
      my.set(e.clientY / window.innerHeight - 0.5);
    };
    window.addEventListener("mousemove", onMove);
    return () => window.removeEventListener("mousemove", onMove);
  }, [reduced, followCursor, eyesFollow, mx, my]);

  // shared geometry — kept in one place so silhouette + full share the outline
  const bodyPath =
    "M130 70 C185 70 222 108 228 165 C232 205 224 250 195 272 C172 289 88 289 65 272 C36 250 28 205 32 165 C38 108 75 70 130 70 Z";
  // leaf-horn ears — rounded tips, angled gently outward (not bunny ears)
  const earLeft =
    "M108 74 C94 58 85 40 90 27 C104 33 120 54 118 73 Z";
  const earRight =
    "M152 74 C166 58 175 40 170 27 C156 33 140 54 142 73 Z";
  const sproutLeafL = "M130 42 C120 43 113 51 116 61 C127 59 133 50 130 42 Z";
  const sproutLeafR = "M130 42 C140 43 147 51 144 61 C133 59 127 50 130 42 Z";

  if (silhouette) {
    return (
      <svg
        width={size}
        height={size * (300 / 260)}
        viewBox="0 0 260 300"
        fill="none"
        className={className}
        aria-hidden="true"
      >
        <g fill={silhouetteColor}>
          <path d={earLeft} />
          <path d={earRight} />
          <path d={sproutLeafL} />
          <path d={sproutLeafR} />
          <rect x="128" y="55" width="4" height="20" rx="2" />
          <path d={bodyPath} />
        </g>
      </svg>
    );
  }

  const character = (
    <motion.svg
      width={size}
      height={size * (300 / 260)}
      viewBox="0 0 260 300"
      fill="none"
      className={className}
      style={followCursor && !reduced ? { x: bodyX, y: bodyY } : undefined}
      aria-hidden="true"
    >
      <defs>
        <linearGradient id={`body-${uid}`} x1="0.2" y1="0" x2="0.8" y2="1">
          <stop offset="0%" stopColor="#B4C2A4" />
          <stop offset="42%" stopColor="#829674" />
          <stop offset="100%" stopColor="#41533B" />
        </linearGradient>
        <radialGradient id={`belly-${uid}`} cx="0.5" cy="0.4" r="0.7">
          <stop offset="0%" stopColor="#EEF3E6" />
          <stop offset="100%" stopColor="#D3E0C6" />
        </radialGradient>
        <radialGradient id={`glow-${uid}`} cx="0.5" cy="0.5" r="0.5">
          <stop offset="0%" stopColor="#DDE8D3" stopOpacity="0.85" />
          <stop offset="100%" stopColor="#DDE8D3" stopOpacity="0" />
        </radialGradient>
        <filter id={`soft-${uid}`} x="-40%" y="-40%" width="180%" height="180%">
          <feGaussianBlur stdDeviation="2" />
        </filter>
        <filter id={`mist-${uid}`} x="-60%" y="-60%" width="220%" height="220%">
          <feGaussianBlur stdDeviation="9" />
        </filter>
        <clipPath id={`bodyclip-${uid}`}>
          <path d={bodyPath} />
        </clipPath>
      </defs>

      {/* forest mist halo */}
      {glow && (
        <ellipse
          cx="130"
          cy="175"
          rx="150"
          ry="160"
          fill={`url(#glow-${uid})`}
        />
      )}

      {/* soft misty silhouette behind the body for a fuzzy edge */}
      <g filter={`url(#mist-${uid})`} opacity="0.5">
        <path d={bodyPath} fill="#9CAF88" />
        <path d={earLeft} fill="#9CAF88" />
        <path d={earRight} fill="#9CAF88" />
      </g>

      {/* sprout crown */}
      <g>
        <rect x="128" y="52" width="4" height="24" rx="2" fill="#3E5138" />
        <path d={sproutLeafL} fill="#9CAF88" />
        <path d={sproutLeafR} fill="#8AA277" />
      </g>

      {/* ears */}
      <path d={earLeft} fill="#728B63" />
      <path d={earRight} fill="#657E57" />
      <path
        d="M100 66 C93 54 88 42 91 32"
        stroke="#41533B"
        strokeWidth="2"
        strokeLinecap="round"
        opacity="0.4"
      />
      <path
        d="M160 66 C167 54 172 42 169 32"
        stroke="#41533B"
        strokeWidth="2"
        strokeLinecap="round"
        opacity="0.4"
      />

      {/* body */}
      <path d={bodyPath} fill={`url(#body-${uid})`} />

      {/* belly + brand seed, clipped inside body */}
      <g clipPath={`url(#bodyclip-${uid})`}>
        <ellipse cx="130" cy="210" rx="74" ry="82" fill={`url(#belly-${uid})`} />
        {/* rim light along the top-left */}
        <path
          d="M130 70 C90 70 55 100 44 150"
          stroke="#D6E2C8"
          strokeWidth="6"
          strokeLinecap="round"
          fill="none"
          opacity="0.35"
          filter={`url(#soft-${uid})`}
        />
        {/* subtle single-leaf brand seed on the belly */}
        <g opacity="0.5" transform="translate(130 236)">
          <path
            d="M0 -13 C9 -12 15 -4 13 6 C3 5 -4 -3 0 -13 Z"
            fill="#9CAF88"
          />
          <path d="M0 -9 L0 7" stroke="#5E7358" strokeWidth="1.6" strokeLinecap="round" />
        </g>
      </g>

      {/* cheeks */}
      <g filter={`url(#soft-${uid})`}>
        <ellipse cx="80" cy="196" rx="15" ry="9" fill="#E7B49A" opacity="0.32" />
        <ellipse cx="180" cy="196" rx="15" ry="9" fill="#E7B49A" opacity="0.32" />
      </g>

      {/* eyes — large, calm, gently sleepy. Pupils + catch-light drift w/ cursor */}
      <g>
        {/* soft heavy upper lid: a gentle down-curve caps each eye = serene */}
        <path
          d="M78 160 C88 156 112 156 122 160 C123 178 114 191 100 191 C86 191 77 178 78 160 Z"
          fill="#22281E"
        />
        <path
          d="M138 160 C148 156 172 156 182 160 C183 178 174 191 160 191 C146 191 137 178 138 160 Z"
          fill="#22281E"
        />
        <motion.g
          style={eyesFollow && !reduced ? { x: eyeX, y: eyeY } : undefined}
        >
          {/* pupils, centred low for a soft downward gaze */}
          <circle cx="100" cy="174" r="10" fill="#111310" />
          <circle cx="160" cy="174" r="10" fill="#111310" />
          {/* wet catch-light */}
          <circle cx="104.5" cy="169" r="3.4" fill="#FFFDF8" opacity="0.95" />
          <circle cx="164.5" cy="169" r="3.4" fill="#FFFDF8" opacity="0.95" />
          <circle cx="96" cy="178" r="1.7" fill="#FFFDF8" opacity="0.55" />
          <circle cx="156" cy="178" r="1.7" fill="#FFFDF8" opacity="0.55" />
        </motion.g>
      </g>

      {/* tiny soft nose */}
      <ellipse cx="130" cy="200" rx="3.6" ry="2.8" fill="#4C5F44" />
      {/* the faintest content curve of a mouth */}
      <path
        d="M123 208 C127 211 133 211 137 208"
        stroke="#4C5F44"
        strokeWidth="1.6"
        strokeLinecap="round"
        fill="none"
        opacity="0.55"
      />
    </motion.svg>
  );

  if (!breathing || reduced) return character;

  return (
    <motion.div
      className={followCursor ? "" : "inline-block"}
      animate={{ scale: [1, 1.025, 1] }}
      transition={{ duration: 5.5, repeat: Infinity, ease: "easeInOut" }}
      style={{ transformOrigin: "50% 65%" }}
    >
      {character}
    </motion.div>
  );
}
