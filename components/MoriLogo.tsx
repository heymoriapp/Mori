"use client";

import MoriMark from "./MoriMark";

/**
 * The full Mori wordmark: the creature mark + lowercase serif "mori",
 * where the dot of the "i" is a tiny leaf. Uses a dotless "ı" so the leaf
 * reads as the intentional i-dot.
 */
export default function MoriLogo({
  markSize = 26,
  className = "",
}: {
  markSize?: number;
  className?: string;
}) {
  return (
    <span className={`inline-flex items-center gap-2 ${className}`}>
      <MoriMark size={markSize} />
      <span className="relative font-serif text-2xl font-medium leading-none tracking-tight text-ink">
        {/* dotless i (ı) so the leaf below is the only dot */}
        morı
        <svg
          className="absolute -top-[0.05em] right-[0.02em]"
          width="9"
          height="9"
          viewBox="0 0 12 12"
          fill="none"
          aria-hidden="true"
        >
          <path
            d="M6 1c2.6 0 4.6 2 4.6 4.6C10.6 8.6 8.6 11 6 11 3.4 11 1.4 8.6 1.4 5.6 1.4 3 3.4 1 6 1z"
            fill="#9CAF88"
          />
          <path
            d="M6 2.2v7.4"
            stroke="#2F4A37"
            strokeWidth="0.8"
            strokeLinecap="round"
          />
        </svg>
      </span>
    </span>
  );
}
