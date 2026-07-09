"use client";

/**
 * Lightweight, CSS-driven forest atmosphere: drifting spores/dust and falling
 * leaves. Deterministic (no Math.random) so it is SSR-safe and stable across
 * renders. All motion is paused under prefers-reduced-motion via globals.css.
 */

// Deterministic pseudo-scatter so particles feel organic without randomness.
const SPORES = Array.from({ length: 16 }, (_, i) => {
  const left = (i * 61) % 100;
  const size = 2 + ((i * 7) % 4);
  return {
    left,
    bottom: (i * 37) % 40,
    size,
    duration: 13 + ((i * 5) % 9),
    delay: -((i * 3.1) % 16),
    drift: (i % 2 === 0 ? 1 : -1) * (8 + ((i * 4) % 22)),
    opacity: 0.25 + ((i * 3) % 5) / 12,
  };
});

export function Spores({
  className = "",
  count = 16,
  color = "#9CAF88",
}: {
  className?: string;
  count?: number;
  color?: string;
}) {
  return (
    <div
      className={`pointer-events-none absolute inset-0 overflow-hidden ${className}`}
      aria-hidden="true"
    >
      {SPORES.slice(0, count).map((s, i) => (
        <span
          key={i}
          className="spore"
          style={
            {
              left: `${s.left}%`,
              bottom: `${s.bottom}%`,
              width: s.size,
              height: s.size,
              background: color,
              boxShadow: `0 0 ${s.size * 2}px ${color}`,
              "--spore-duration": `${s.duration}s`,
              "--spore-delay": `${s.delay}s`,
              "--spore-drift": `${s.drift}px`,
              "--spore-opacity": `${s.opacity}`,
            } as React.CSSProperties
          }
        />
      ))}
    </div>
  );
}

const LEAVES = Array.from({ length: 9 }, (_, i) => ({
  left: (i * 53) % 96,
  size: 12 + ((i * 5) % 10),
  duration: 15 + ((i * 4) % 12),
  delay: -((i * 2.7) % 18),
  x: (i % 2 === 0 ? 1 : -1) * (20 + ((i * 9) % 40)),
  tone: i % 3 === 0 ? "#9CAF88" : i % 3 === 1 ? "#C0AE6E" : "#7E9A6C",
}));

export function DriftingLeaves({
  className = "",
  count = 9,
}: {
  className?: string;
  count?: number;
}) {
  return (
    <div
      className={`pointer-events-none absolute inset-0 overflow-hidden ${className}`}
      aria-hidden="true"
    >
      {LEAVES.slice(0, count).map((l, i) => (
        <span
          key={i}
          className="leaf-fall"
          style={
            {
              left: `${l.left}%`,
              top: "-6%",
              "--leaf-duration": `${l.duration}s`,
              "--leaf-delay": `${l.delay}s`,
              "--leaf-x": `${l.x}px`,
            } as React.CSSProperties
          }
        >
          <svg width={l.size} height={l.size} viewBox="0 0 24 24" fill="none">
            <path
              d="M12 2c6 1 10 6 10 12-6-1-10-6-10-12z"
              fill={l.tone}
              opacity="0.75"
            />
            <path
              d="M12 3c-1 5-1 12 0 18"
              stroke={l.tone}
              strokeWidth="1"
              opacity="0.5"
            />
          </svg>
        </span>
      ))}
    </div>
  );
}

/**
 * A soft, layered forest-floor horizon: rolling hills + a few abstract tree
 * silhouettes. Purely decorative; anchors the bottom of atmospheric sections.
 */
export function ForestFloor({
  className = "",
}: {
  className?: string;
}) {
  return (
    <div
      className={`pointer-events-none absolute inset-x-0 bottom-0 ${className}`}
      aria-hidden="true"
    >
      <svg
        viewBox="0 0 1440 260"
        fill="none"
        preserveAspectRatio="xMidYMax slice"
        className="h-full w-full"
      >
        {/* far mist hills */}
        <path
          d="M0 180 C240 130 420 150 660 160 C900 170 1080 120 1440 150 L1440 260 L0 260 Z"
          fill="#CBD9BB"
          opacity="0.55"
        />
        {/* distant trees */}
        <g fill="#A9BD95" opacity="0.55">
          <path d="M210 168 C210 140 224 128 224 128 C224 128 238 140 238 168 Z" />
          <path d="M240 172 C240 138 258 122 258 122 C258 122 276 138 276 172 Z" />
          <path d="M1180 166 C1180 136 1196 122 1196 122 C1196 122 1212 136 1212 166 Z" />
          <path d="M1214 170 C1214 140 1228 128 1228 128 C1228 128 1242 140 1242 170 Z" />
        </g>
        {/* near hill */}
        <path
          d="M0 210 C260 175 520 200 760 205 C1000 210 1220 180 1440 200 L1440 260 L0 260 Z"
          fill="#B7C9A2"
          opacity="0.7"
        />
        {/* grassy foreground */}
        <path
          d="M0 240 C300 220 560 235 820 236 C1080 237 1260 224 1440 234 L1440 260 L0 260 Z"
          fill="#9CAF88"
          opacity="0.55"
        />
      </svg>
    </div>
  );
}
