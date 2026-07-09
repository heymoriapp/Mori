"use client";

import { useId } from "react";

/**
 * Compact Mori mark — a small, square-friendly head of the forest guardian.
 * Shares the guardian's language (leaf ears, sprout, heavy calm eyes) so the
 * logo and in-UI icons read as the same character. Used at small sizes.
 */
export default function MoriMark({
  size = 28,
  className = "",
  flat = false,
  flatColor = "#2F4A37",
}: {
  size?: number;
  className?: string;
  flat?: boolean;
  flatColor?: string;
}) {
  const uid = useId().replace(/:/g, "");

  const body =
    "M20 11 C29 11 35 17.5 35 26.5 C35 33.5 30 38 20 38 C10 38 5 33.5 5 26.5 C5 17.5 11 11 20 11 Z";
  const earL = "M14 12.5 C11 8.5 9.6 4.8 11 2.6 C14 4 16.4 8 16 12.2 Z";
  const earR = "M26 12.5 C29 8.5 30.4 4.8 29 2.6 C26 4 23.6 8 24 12.2 Z";

  if (flat) {
    return (
      <svg
        width={size}
        height={size}
        viewBox="0 0 40 40"
        fill="none"
        className={className}
        aria-hidden="true"
      >
        <g fill={flatColor}>
          <path d={earL} />
          <path d={earR} />
          <path d={body} />
        </g>
      </svg>
    );
  }

  return (
    <svg
      width={size}
      height={size}
      viewBox="0 0 40 40"
      fill="none"
      className={className}
      aria-hidden="true"
    >
      <defs>
        <linearGradient id={`m-${uid}`} x1="0.2" y1="0" x2="0.8" y2="1">
          <stop offset="0%" stopColor="#B4C2A4" />
          <stop offset="45%" stopColor="#7F9370" />
          <stop offset="100%" stopColor="#3E5138" />
        </linearGradient>
      </defs>

      {/* sprout */}
      <rect x="19" y="6.5" width="2" height="5.5" rx="1" fill="#3E5138" />
      <path d="M20 4.6 C16.4 5 14.6 7.4 15.4 10.4 C18.6 9.8 21 7.4 20 4.6 Z" fill="#9CAF88" />

      {/* ears */}
      <path d={earL} fill="#728B63" />
      <path d={earR} fill="#657E57" />

      {/* head */}
      <path d={body} fill={`url(#m-${uid})`} />

      {/* belly */}
      <ellipse cx="20" cy="27.5" rx="10.5" ry="10" fill="#E4EDD8" opacity="0.85" />

      {/* eyes */}
      <path d="M11.5 22.5 C12.4 21.2 16 21.2 16.8 22.5 C17 25 15.6 26.6 14 26.6 C12.4 26.6 11.2 25 11.5 22.5 Z" fill="#20261C" />
      <path d="M23.2 22.5 C24 21.2 27.6 21.2 28.5 22.5 C28.8 25 27.6 26.6 26 26.6 C24.4 26.6 23 25 23.2 22.5 Z" fill="#20261C" />
      <circle cx="14" cy="24" r="1.5" fill="#12140F" />
      <circle cx="26" cy="24" r="1.5" fill="#12140F" />
      <circle cx="14.6" cy="23.2" r="0.6" fill="#FFFDF8" />
      <circle cx="26.6" cy="23.2" r="0.6" fill="#FFFDF8" />
    </svg>
  );
}
