"use client";

import { useEffect, useRef, useState } from "react";
import { AnimatePresence, motion } from "framer-motion";
import MoriMark from "./MoriMark";
import WaitlistForm from "./WaitlistForm";
import { openDownloadModal } from "./DownloadModal";

const SEEN_KEY = "mori-popup-seen";
const SEEN_DAYS = 7;

/**
 * A gentle marketing nudge: a small card that slides in bottom-right after a
 * while (or on exit intent). Shows at most once per visitor per week, never
 * shows again once dismissed or joined. Deliberately not a takeover.
 */
export default function MarketingPopup() {
  const [show, setShow] = useState(false);
  const [joined, setJoined] = useState(false);
  const fired = useRef(false);

  useEffect(() => {
    try {
      const seen = localStorage.getItem(SEEN_KEY);
      if (seen && Date.now() - Number(seen) < SEEN_DAYS * 864e5) return;
    } catch {
      /* private mode — just skip persistence */
    }

    const trigger = () => {
      if (fired.current) return;
      fired.current = true;
      setShow(true);
    };

    const timer = setTimeout(trigger, 24000);
    const onLeave = (e: MouseEvent) => {
      if (e.clientY <= 0) trigger();
    };
    document.addEventListener("mouseleave", onLeave);
    return () => {
      clearTimeout(timer);
      document.removeEventListener("mouseleave", onLeave);
    };
  }, []);

  const dismiss = () => {
    setShow(false);
    try {
      localStorage.setItem(SEEN_KEY, String(Date.now()));
    } catch {
      /* ignore */
    }
  };

  return (
    <AnimatePresence>
      {show && (
        <motion.aside
          initial={{ opacity: 0, y: 40, scale: 0.97 }}
          animate={{ opacity: 1, y: 0, scale: 1 }}
          exit={{ opacity: 0, y: 24 }}
          transition={{ duration: 0.5, ease: [0.22, 1, 0.36, 1] }}
          className="fixed bottom-5 right-5 z-[90] w-[calc(100%-2.5rem)] max-w-sm rounded-3xl border border-border bg-background p-6 shadow-float"
          role="complementary"
          aria-label="Join the Mori beta"
        >
          <button
            onClick={dismiss}
            aria-label="Dismiss"
            className="absolute right-3.5 top-3.5 flex h-7 w-7 items-center justify-center rounded-full text-muted transition-colors hover:bg-card hover:text-ink"
          >
            ✕
          </button>

          <div className="flex items-start gap-3.5">
            <motion.div
              animate={{ y: [0, -4, 0] }}
              transition={{ duration: 3.5, repeat: Infinity, ease: "easeInOut" }}
              className="shrink-0"
            >
              <MoriMark size={40} />
            </motion.div>
            <div>
              <p className="font-serif text-lg font-medium leading-snug text-ink">
                Take the memory spirit home.
              </p>
              <p className="mt-1 text-sm leading-relaxed text-muted">
                The Mac beta is free to try — bring your own AI key.
              </p>
            </div>
          </div>

          {joined ? (
            <p className="mt-4 rounded-xl bg-soft-green/50 px-4 py-3 text-sm text-forest">
              You&rsquo;re on the list — see you in the forest. 🌱
            </p>
          ) : (
            <div className="mt-4">
              <WaitlistForm
                buttonLabel="Join beta"
                onSubmit={() => {
                  setJoined(true);
                  try {
                    localStorage.setItem(SEEN_KEY, String(Date.now()));
                  } catch {
                    /* ignore */
                  }
                }}
              />
            </div>
          )}

          <div className="mt-3 flex items-center justify-between text-xs">
            <button
              onClick={() => {
                dismiss();
                openDownloadModal();
              }}
              className="text-forest underline-offset-4 hover:underline"
            >
              Or download the beta now →
            </button>
            <button onClick={dismiss} className="text-muted hover:text-ink">
              No thanks
            </button>
          </div>
        </motion.aside>
      )}
    </AnimatePresence>
  );
}
