"use client";

import { useId } from "react";
import MoriGlyph from "./MoriGlyph";
import {
  BELLY,
  BODY,
  CATCH,
  CHEEK_L,
  CHEEK_R,
  EAR_L,
  EAR_R,
  EYE_L,
  EYE_R,
  MOUTH,
  NOSE,
  PUPIL_L,
  PUPIL_R,
  SPROUT_L,
  SPROUT_R,
  SPROUT_STEM,
} from "@/lib/moriGeometry";

type Variant = "forest" | "paper" | "clay";

/**
 * The Mori app icon — a rounded-square (squircle-feel) tile with the guardian
 * centred. This is the master mark: app icon, dock icon, favicon, showcase.
 *
 *  - "forest": deep forest tile + cream spirit with knockout eyes (bold, merch)
 *  - "paper":  warm cream tile + full-colour spirit (soft, editorial)
 *  - "clay":   warm accent tile + cream spirit
 */
export default function MoriIcon({
  size = 96,
  variant = "forest",
  radius = 23,
  className = "",
  title,
}: {
  size?: number;
  variant?: Variant;
  radius?: number;
  className?: string;
  title?: string;
}) {
  const uid = useId().replace(/:/g, "");

  const tile: Record<Variant, [string, string]> = {
    forest: ["#3A5A43", "#233A2B"],
    paper: ["#FBF5E6", "#EFE6CF"],
    clay: ["#E48A5C", "#C9542A"],
  };
  const [c0, c1] = tile[variant];

  return (
    <svg
      width={size}
      height={size}
      viewBox="0 0 100 100"
      fill="none"
      className={className}
      role={title ? "img" : undefined}
      aria-hidden={title ? undefined : true}
      aria-label={title}
    >
      {title ? <title>{title}</title> : null}
      <defs>
        <linearGradient id={`tile-${uid}`} x1="0" y1="0" x2="0" y2="1">
          <stop offset="0%" stopColor={c0} />
          <stop offset="100%" stopColor={c1} />
        </linearGradient>
        <linearGradient id={`spirit-${uid}`} x1="0.2" y1="0.1" x2="0.8" y2="1">
          <stop offset="0%" stopColor="#B4C2A4" />
          <stop offset="45%" stopColor="#7F9370" />
          <stop offset="100%" stopColor="#3E5138" />
        </linearGradient>
        <radialGradient id={`sheen-${uid}`} cx="0.32" cy="0.2" r="0.9">
          <stop offset="0%" stopColor="#FFFFFF" stopOpacity="0.16" />
          <stop offset="55%" stopColor="#FFFFFF" stopOpacity="0" />
        </radialGradient>
      </defs>

      {/* tile */}
      <rect width="100" height="100" rx={radius} fill={`url(#tile-${uid})`} />
      <rect width="100" height="100" rx={radius} fill={`url(#sheen-${uid})`} />

      {variant === "paper" ? (
        <PaperSpirit uid={uid} />
      ) : (
        <CreamSpirit tileTop={c0} />
      )}

      {/* subtle inner border for depth */}
      <rect
        x="0.6"
        y="0.6"
        width="98.8"
        height="98.8"
        rx={radius - 0.6}
        fill="none"
        stroke="#000000"
        strokeOpacity="0.06"
      />
    </svg>
  );
}

/** Flat cream spirit with knockout eyes — for forest/clay tiles. */
function CreamSpirit({ tileTop }: { tileTop: string }) {
  return (
    <g>
      {/* soft ground glow */}
      <ellipse cx="50" cy="60" rx="34" ry="34" fill="#FFFFFF" opacity="0.06" />
      <g fill="#F4EDDA">
        <rect
          x={SPROUT_STEM.x}
          y={SPROUT_STEM.y}
          width={SPROUT_STEM.w}
          height={SPROUT_STEM.h}
          rx={SPROUT_STEM.rx}
        />
        <path d={SPROUT_L} />
        <path d={SPROUT_R} />
        <path d={EAR_L} />
        <path d={EAR_R} />
        <path d={BODY} />
      </g>
      {/* belly shade for a hint of dimension */}
      <ellipse
        cx={BELLY.cx}
        cy={BELLY.cy + 2}
        rx={BELLY.rx - 3}
        ry={BELLY.ry - 3}
        fill="#000000"
        opacity="0.04"
      />
      {/* eyes = tile colour showing through */}
      <ellipse cx={EYE_L.cx} cy={EYE_L.cy} rx={EYE_L.rx} ry={EYE_L.ry} fill={tileTop} />
      <ellipse cx={EYE_R.cx} cy={EYE_R.cy} rx={EYE_R.rx} ry={EYE_R.ry} fill={tileTop} />
      {/* pupils darker than tile + catch-light */}
      <circle cx={PUPIL_L.cx} cy={PUPIL_L.cy} r={PUPIL_L.r} fill="#1B2A20" />
      <circle cx={PUPIL_R.cx} cy={PUPIL_R.cy} r={PUPIL_R.r} fill="#1B2A20" />
      {CATCH.map((c, i) => (
        <circle key={i} cx={c.cx} cy={c.cy} r={c.r} fill="#F4EDDA" opacity={i < 2 ? 0.95 : 0.5} />
      ))}
      {/* nose + mouth */}
      <ellipse cx={NOSE.cx} cy={NOSE.cy} rx={NOSE.rx} ry={NOSE.ry} fill="#B9A784" />
      <path d={MOUTH} stroke="#B9A784" strokeWidth="1.4" strokeLinecap="round" fill="none" opacity="0.7" />
    </g>
  );
}

/** Full-colour spirit — for the warm paper tile. */
function PaperSpirit({ uid }: { uid: string }) {
  return (
    <g>
      <rect
        x={SPROUT_STEM.x}
        y={SPROUT_STEM.y}
        width={SPROUT_STEM.w}
        height={SPROUT_STEM.h}
        rx={SPROUT_STEM.rx}
        fill="#3E5138"
      />
      <path d={SPROUT_L} fill="#9CAF88" />
      <path d={SPROUT_R} fill="#8AA277" />
      <path d={EAR_L} fill="#728B63" />
      <path d={EAR_R} fill="#657E57" />
      <path d={BODY} fill={`url(#spirit-${uid})`} />
      <ellipse cx={BELLY.cx} cy={BELLY.cy} rx={BELLY.rx} ry={BELLY.ry} fill="#E9F0DF" opacity="0.9" />
      <ellipse cx={CHEEK_L.cx} cy={CHEEK_L.cy} rx={CHEEK_L.rx} ry={CHEEK_L.ry} fill="#E7B49A" opacity="0.4" />
      <ellipse cx={CHEEK_R.cx} cy={CHEEK_R.cy} rx={CHEEK_R.rx} ry={CHEEK_R.ry} fill="#E7B49A" opacity="0.4" />
      <ellipse cx={EYE_L.cx} cy={EYE_L.cy} rx={EYE_L.rx} ry={EYE_L.ry} fill="#22281E" />
      <ellipse cx={EYE_R.cx} cy={EYE_R.cy} rx={EYE_R.rx} ry={EYE_R.ry} fill="#22281E" />
      {CATCH.map((c, i) => (
        <circle key={i} cx={c.cx} cy={c.cy} r={c.r} fill="#FFFDF8" opacity={i < 2 ? 0.95 : 0.5} />
      ))}
      <ellipse cx={NOSE.cx} cy={NOSE.cy} rx={NOSE.rx} ry={NOSE.ry} fill="#4C5F44" />
      <path d={MOUTH} stroke="#4C5F44" strokeWidth="1.4" strokeLinecap="round" fill="none" opacity="0.6" />
    </g>
  );
}

export { MoriGlyph };
