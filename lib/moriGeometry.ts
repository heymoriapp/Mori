/**
 * The single source of truth for the Mori guardian silhouette.
 *
 * All brand surfaces — app icon, favicon, menu-bar glyph, loader, sticker and
 * the in-page character — are drawn from these paths on a 100×100 canvas so the
 * face is pixel-identical everywhere. The silhouette is deliberately simple:
 * a rounded seed body + a three-leaf crown (two leaf-horn ears and a centre
 * sprout) + two calm eyes. That crown is the signature notch that makes it
 * readable at 16px and instantly recognisable in pure silhouette.
 */

// body — a rounded seed, slightly bottom-weighted
export const BODY =
  "M50 22 C71 22 84 36 84 55 C84 74 71 87 50 87 C29 87 16 74 16 55 C16 36 29 22 50 22 Z";

// leaf-horn ears
export const EAR_L = "M39 24 C31 13 26 5 30 1 C38 5 46 15 45 24 Z";
export const EAR_R = "M61 24 C69 13 74 5 70 1 C62 5 54 15 55 24 Z";

// centre sprout (stem + two tiny leaves)
export const SPROUT_STEM = { x: 48.8, y: 12, w: 2.4, h: 11, rx: 1.2 };
export const SPROUT_L = "M50 8 C44 9 41 13 43 18 C48 17 51 13 50 8 Z";
export const SPROUT_R = "M50 8 C56 9 59 13 57 18 C52 17 49 13 50 8 Z";

// pale belly
export const BELLY = { cx: 50, cy: 61, rx: 25.5, ry: 24 };

// eyes (used as knockout holes in the mono glyph, and as dark eyes in colour)
export const EYE_L = { cx: 38, cy: 53, rx: 8, ry: 9 };
export const EYE_R = { cx: 62, cy: 53, rx: 8, ry: 9 };

// pupils + catch-lights for the full-colour face
export const PUPIL_L = { cx: 38, cy: 55, r: 5.5 };
export const PUPIL_R = { cx: 62, cy: 55, r: 5.5 };
export const CATCH = [
  { cx: 40.5, cy: 50.5, r: 2.2 },
  { cx: 64.5, cy: 50.5, r: 2.2 },
  { cx: 35.5, cy: 56, r: 1.1 },
  { cx: 59.5, cy: 56, r: 1.1 },
];

export const NOSE = { cx: 50, cy: 68, rx: 2.4, ry: 1.9 };
export const MOUTH = "M45.5 72 C47.8 74 52.2 74 54.5 72";

// cheeks (soft clay warmth)
export const CHEEK_L = { cx: 31, cy: 65, rx: 5.5, ry: 3.4 };
export const CHEEK_R = { cx: 69, cy: 65, rx: 5.5, ry: 3.4 };

/** Palette pulled from the brand tokens, for use in standalone SVG files. */
export const PALETTE = {
  background: "#FAF7EF",
  card: "#FFFDF8",
  ink: "#12110E",
  forest: "#2F4A37",
  forestDeep: "#233A2B",
  moss: "#9CAF88",
  mossLight: "#B4C2A4",
  clay: "#D96B3C",
  cream: "#F6EFDD",
  softClay: "#F6D8C6",
};
