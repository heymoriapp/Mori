"use client";

import { useCallback, useEffect, useState } from "react";
import { AnimatePresence, motion } from "framer-motion";
import MoriMark from "./MoriMark";
import { SITE } from "@/lib/site";

const EVENT = "mori:download-modal";

/** Open the download popup from anywhere (buttons, links, easter eggs). */
export function openDownloadModal() {
  window.dispatchEvent(new CustomEvent(EVENT));
}

/**
 * The download popup. Mounted once (in the root layout). Opens via
 * openDownloadModal() or by pressing ⌥M anywhere on the site — the same
 * shortcut the app uses. Starts the download and walks through install.
 */
export default function DownloadModal() {
  const [open, setOpen] = useState(false);
  const [started, setStarted] = useState(false);

  const startDownload = useCallback(() => {
    const a = document.createElement("a");
    a.href = SITE.downloadUrl;
    a.download = "";
    document.body.appendChild(a);
    a.click();
    a.remove();
    setStarted(true);
  }, []);

  useEffect(() => {
    const onOpen = () => setOpen(true);
    const onKey = (e: KeyboardEvent) => {
      // ⌥M anywhere on the site mirrors the app's shortcut.
      if (e.altKey && e.code === "KeyM" && !e.metaKey && !e.ctrlKey) {
        e.preventDefault();
        setOpen(true);
      }
      if (e.key === "Escape") setOpen(false);
    };
    window.addEventListener(EVENT, onOpen);
    window.addEventListener("keydown", onKey);
    return () => {
      window.removeEventListener(EVENT, onOpen);
      window.removeEventListener("keydown", onKey);
    };
  }, []);

  // Auto-start the download when the modal opens.
  useEffect(() => {
    if (open && !started) {
      const t = setTimeout(startDownload, 600);
      return () => clearTimeout(t);
    }
  }, [open, started, startDownload]);

  useEffect(() => {
    if (!open) setStarted(false);
  }, [open]);

  return (
    <AnimatePresence>
      {open && (
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          transition={{ duration: 0.25 }}
          className="fixed inset-0 z-[100] flex items-center justify-center bg-ink/30 p-5 backdrop-blur-sm"
          onClick={() => setOpen(false)}
          role="dialog"
          aria-modal="true"
          aria-label="Download Mori beta"
        >
          <motion.div
            initial={{ opacity: 0, y: 24, scale: 0.97 }}
            animate={{ opacity: 1, y: 0, scale: 1 }}
            exit={{ opacity: 0, y: 16, scale: 0.98 }}
            transition={{ duration: 0.35, ease: [0.22, 1, 0.36, 1] }}
            className="relative w-full max-w-md rounded-3xl border border-border bg-background p-8 shadow-float"
            onClick={(e) => e.stopPropagation()}
          >
            <button
              onClick={() => setOpen(false)}
              aria-label="Close"
              className="absolute right-4 top-4 flex h-8 w-8 items-center justify-center rounded-full text-muted transition-colors hover:bg-card hover:text-ink"
            >
              ✕
            </button>

            <div className="flex flex-col items-center text-center">
              <motion.div
                animate={{ y: [0, -5, 0] }}
                transition={{ duration: 3, repeat: Infinity, ease: "easeInOut" }}
              >
                <MoriMark size={52} />
              </motion.div>

              <h3 className="mt-4 font-serif text-2xl font-medium text-ink">
                {started ? "Your download has started" : "Downloading Mori beta…"}
              </h3>
              <p className="mt-2 text-sm text-muted">
                v{SITE.version} · {SITE.requirements} · {SITE.downloadSize}
              </p>
            </div>

            <div className="mt-6 rounded-2xl border border-border bg-card p-4 text-left">
              <p className="label mb-2.5 text-forest">While it downloads</p>
              <ol className="space-y-1.5 text-sm leading-relaxed text-muted">
                <li>
                  <span className="font-medium text-ink">1.</span> Unzip and drag{" "}
                  <span className="text-ink">Mori.app</span> into Applications,
                  then open it.
                </li>
                <li>
                  <span className="font-medium text-ink">2.</span> macOS will say
                  it can&rsquo;t verify Mori — click{" "}
                  <span className="text-ink">Done</span> (not Move to Trash!).
                </li>
                <li>
                  <span className="font-medium text-ink">3.</span> Open{" "}
                  <span className="text-ink">
                    System Settings → Privacy &amp; Security
                  </span>
                  , scroll down, click{" "}
                  <span className="text-ink">Open Anyway</span>, and confirm.
                </li>
                <li>
                  <span className="font-medium text-ink">4.</span> Add your AI key
                  in Preferences → AI, then press{" "}
                  <span className="font-mono text-xs text-forest">⌥M</span>.
                </li>
              </ol>
              <p className="mt-3 border-t border-border pt-2.5 text-xs leading-relaxed text-muted/90">
                The warning appears because this beta isn&rsquo;t notarized with
                Apple yet — it&rsquo;s the standard dialog for early betas, not a
                malware verdict. One &ldquo;Open Anyway&rdquo; and macOS remembers.
              </p>
            </div>

            <div className="mt-5 flex items-center justify-center gap-4 text-sm">
              <button
                onClick={startDownload}
                className="text-forest underline-offset-4 transition-colors hover:text-ink hover:underline"
              >
                Restart download
              </button>
              <span className="text-border">·</span>
              <a
                href="/docs"
                className="text-forest underline-offset-4 transition-colors hover:text-ink hover:underline"
              >
                Read the docs
              </a>
            </div>

            <p className="mt-5 text-center text-xs text-muted/80">
              Fun fact: you just used ⌥M&rsquo;s home. Pressing ⌥M on this site
              opens this window too.
            </p>
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>
  );
}
