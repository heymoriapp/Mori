# mori

_A little memory spirit for your Mac._

The marketing site for **Mori** — a private, Mac-first memory companion. Press
`⌥M` anywhere you type; Mori recalls recent context and drafts a reply in your
tone.

## Stack

- **Next.js 15** (App Router) + **TypeScript**
- **Tailwind CSS** — custom warm-paper palette + editorial type scale
- **Framer Motion** — staggered reveals, magnetic buttons, scroll parallax
- **Lenis** — smooth scrolling (disabled under `prefers-reduced-motion`)
- Fonts: **Fraunces** (editorial serif), **Inter** (UI), **JetBrains Mono** (labels)

## Develop

```bash
npm install
npm run dev      # http://localhost:3000
npm run build    # production build
```

## Structure

```
app/
  layout.tsx        fonts, metadata, global styles
  page.tsx          section composition
  globals.css       palette vars, paper grain, reduced-motion
components/
  Header, HeroSection, FloatingReplyCard, ProblemSection,
  HowItWorks, ProductDemo, MemorySection, ControlsSection,
  PrivacySection, UseCases, MacFirstSection, NarrativeTransition,
  FAQ, FinalCTA, Footer
  MoriLogo / MoriMark / MoriSpirit   original forest-memory identity
  AnimatedText / MagneticButton / SmoothScroll   shared primitives
lib/
  hooks.ts          usePrefersReducedMotion, useIsMobile
```

## Notes

- All motion respects `prefers-reduced-motion`.
- Copy is intentionally careful about privacy ("designed local-first", "you
  control memory") — no overclaiming.
- Mori is an original app and is **not affiliated with Studio Ghibli**.
