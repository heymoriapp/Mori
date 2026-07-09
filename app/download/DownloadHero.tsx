"use client";

import { motion } from "framer-motion";
import MoriIcon from "@/components/MoriIcon";
import { openDownloadModal } from "@/components/DownloadModal";
import { SITE } from "@/lib/site";

/** The download card at the top of /download — opens the guided popup. */
export default function DownloadHero() {
  return (
    <motion.div
      initial={{ opacity: 0, y: 24 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.7, ease: [0.22, 1, 0.36, 1] }}
      className="flex flex-col items-center gap-6 rounded-3xl border border-border bg-card p-10 text-center shadow-card sm:flex-row sm:text-left"
    >
      <motion.div
        animate={{ y: [0, -6, 0] }}
        transition={{ duration: 4, repeat: Infinity, ease: "easeInOut" }}
        className="shrink-0"
      >
        <MoriIcon size={96} variant="forest" radius={22} title="Mori app icon" />
      </motion.div>

      <div className="flex-1">
        <h2 className="font-serif text-2xl font-medium text-ink">
          Mori {SITE.version} — private beta
        </h2>
        <p className="mt-1 text-sm text-muted">
          {SITE.requirements} · {SITE.downloadSize} · free during beta
        </p>
        <div className="mt-5 flex flex-col items-center gap-3 sm:flex-row">
          <button
            onClick={openDownloadModal}
            className="inline-flex items-center gap-2.5 rounded-full bg-forest px-7 py-3.5 text-base font-medium text-background shadow-soft transition-colors duration-300 hover:bg-[#263d2d]"
          >
            <svg width="15" height="16" viewBox="0 0 15 16" fill="none" aria-hidden="true">
              <path
                d="M7.5 1v9m0 0L4 6.7M7.5 10L11 6.7M2 12.5h11"
                stroke="currentColor"
                strokeWidth="1.6"
                strokeLinecap="round"
                strokeLinejoin="round"
              />
            </svg>
            Download for macOS
          </button>
          <span className="text-xs text-muted">
            or press <kbd className="rounded-md border border-border bg-background px-1.5 py-0.5 font-mono text-[0.7rem] text-forest">⌥M</kbd> right now — it works here too
          </span>
        </div>
      </div>
    </motion.div>
  );
}
