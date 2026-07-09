"use client";

import { useId } from "react";
import {
  BODY,
  EAR_L,
  EAR_R,
  EYE_L,
  EYE_R,
  SPROUT_L,
  SPROUT_R,
  SPROUT_STEM,
} from "@/lib/moriGeometry";

/**
 * The pure single-colour Mori glyph — the guardian rendered in one flat colour
 * with the eyes knocked out as real transparent holes (via an SVG mask). This
 * is the most reduced, most iconic form: menu-bar template icon, monochrome
 * favicon, sticker die-cut, watermark. Works on any background.
 */
export default function MoriGlyph({
  size = 40,
  color = "currentColor",
  className = "",
  title,
}: {
  size?: number;
  color?: string;
  className?: string;
  title?: string;
}) {
  const uid = useId().replace(/:/g, "");
  const maskId = `glyph-mask-${uid}`;

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
      <mask id={maskId} maskUnits="userSpaceOnUse" x="0" y="0" width="100" height="100">
        <rect width="100" height="100" fill="black" />
        <g fill="white">
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
        {/* knockout eyes */}
        <g fill="black">
          <ellipse cx={EYE_L.cx} cy={EYE_L.cy} rx={EYE_L.rx} ry={EYE_L.ry} />
          <ellipse cx={EYE_R.cx} cy={EYE_R.cy} rx={EYE_R.rx} ry={EYE_R.ry} />
        </g>
      </mask>
      <rect width="100" height="100" fill={color} mask={`url(#${maskId})`} />
    </svg>
  );
}
