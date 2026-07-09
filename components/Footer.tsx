"use client";

import { motion } from "framer-motion";
import MoriLogo from "./MoriLogo";
import MoriCharacter from "./MoriCharacter";

const COLUMNS = [
  {
    title: "Product",
    links: [
      { label: "How it works", href: "/#how" },
      { label: "Memory", href: "/#memory" },
      { label: "Download beta", href: "/download" },
      { label: "Changelog", href: "/changelog" },
      { label: "FAQ", href: "/#faq" },
    ],
  },
  {
    title: "Resources",
    links: [
      { label: "Documentation", href: "/docs" },
      { label: "Support", href: "/support" },
      { label: "Contact", href: "mailto:hello@heymori.app" },
      { label: "GitHub", href: "https://github.com/heymoriapp/Mori" },
    ],
  },
  {
    title: "Legal",
    links: [
      { label: "Privacy Policy", href: "/privacy" },
      { label: "Terms of Use", href: "/terms" },
      { label: "Privacy by design", href: "/#privacy" },
    ],
  },
];

export default function Footer() {
  return (
    <footer className="relative overflow-hidden border-t border-border bg-background pt-20">
      <div className="mx-auto max-w-6xl px-5 sm:px-8">
        <div className="grid gap-12 pb-16 md:grid-cols-[1.5fr_1fr_1fr_1fr]">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true, amount: 0.4 }}
            transition={{ duration: 0.7 }}
          >
            <MoriLogo markSize={26} />
            <p className="mt-4 max-w-xs text-[0.95rem] leading-relaxed text-muted">
              A little memory spirit for your Mac.
            </p>
          </motion.div>

          {COLUMNS.map((col, i) => (
            <motion.div
              key={col.title}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true, amount: 0.4 }}
              transition={{ duration: 0.7, delay: 0.1 + i * 0.08 }}
            >
              <span className="label text-muted">{col.title}</span>
              <ul className="mt-4 space-y-2.5">
                {col.links.map((link) => (
                  <li key={link.label}>
                    <a
                      href={link.href}
                      className="text-[0.95rem] text-ink/80 transition-colors hover:text-forest"
                    >
                      {link.label}
                    </a>
                  </li>
                ))}
              </ul>
            </motion.div>
          ))}
        </div>

        <div className="flex flex-col gap-2 border-t border-border py-8 text-sm text-muted sm:flex-row sm:items-center sm:justify-between">
          <p>© {2026} Mori. Made quietly for Mac.</p>
          <p>Mori is not affiliated with Studio Ghibli.</p>
        </div>
      </div>

      {/* faint oversized wordmark + guardian silhouette peeking from behind */}
      <div
        className="pointer-events-none relative select-none overflow-hidden"
        aria-hidden="true"
      >
        <MoriCharacter
          silhouette
          size={160}
          silhouetteColor="#2F4A37"
          className="absolute bottom-0 left-1/2 h-auto w-[130px] -translate-x-1/2 opacity-[0.06] sm:w-[160px]"
        />
        <p className="relative -mb-4 text-center font-serif text-[14vw] font-medium leading-none text-forest/[0.05] sm:-mb-6">
          mori
        </p>
      </div>
    </footer>
  );
}
