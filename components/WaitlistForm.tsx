"use client";

import { FormEvent, useState } from "react";
import { AnimatePresence, motion } from "framer-motion";
import MoriMark from "./MoriMark";

/**
 * Beta waitlist capture. Client-side only — validates the address and shows a
 * calm confirmation. No data leaves the page; wire `onSubmit` to a real
 * endpoint when the backend exists.
 */
export default function WaitlistForm({
  buttonLabel = "Join beta",
  placeholder = "Enter your email",
  size = "md",
  className = "",
  onSubmit,
}: {
  buttonLabel?: string;
  placeholder?: string;
  size?: "md" | "lg";
  className?: string;
  onSubmit?: (email: string) => void;
}) {
  const [email, setEmail] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [done, setDone] = useState(false);

  const pad = size === "lg" ? "py-3.5 text-base" : "py-3 text-[0.95rem]";

  const handle = (e: FormEvent) => {
    e.preventDefault();
    const value = email.trim();
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)) {
      setError("Please enter a valid email.");
      return;
    }
    setError(null);
    onSubmit?.(value);
    setDone(true);
  };

  return (
    <div className={`w-full max-w-md ${className}`}>
      <AnimatePresence mode="wait" initial={false}>
        {done ? (
          <motion.div
            key="done"
            initial={{ opacity: 0, y: 8 }}
            animate={{ opacity: 1, y: 0 }}
            className={`flex items-center gap-3 rounded-full border border-forest/25 bg-soft-green/50 px-5 ${pad}`}
          >
            <MoriMark size={22} />
            <span className="text-forest">
              You&rsquo;re on the list. We&rsquo;ll send your invite soon.
            </span>
          </motion.div>
        ) : (
          <motion.form
            key="form"
            initial={{ opacity: 0, y: 8 }}
            animate={{ opacity: 1, y: 0 }}
            onSubmit={handle}
            noValidate
            className="flex flex-col gap-2.5 sm:flex-row"
          >
            <div className="relative flex-1">
              <input
                type="email"
                inputMode="email"
                autoComplete="email"
                value={email}
                onChange={(e) => {
                  setEmail(e.target.value);
                  if (error) setError(null);
                }}
                placeholder={placeholder}
                aria-label="Email address"
                aria-invalid={!!error}
                className={`w-full rounded-full border border-border bg-card px-5 text-ink placeholder:text-muted/70 transition-colors focus:border-forest/50 focus:outline-none focus:ring-2 focus:ring-forest/15 ${pad}`}
              />
            </div>
            <button
              type="submit"
              className={`shrink-0 rounded-full bg-forest px-6 font-medium text-background transition-colors duration-300 hover:bg-[#263d2d] ${pad}`}
            >
              {buttonLabel}
            </button>
          </motion.form>
        )}
      </AnimatePresence>

      <AnimatePresence>
        {error && (
          <motion.p
            initial={{ opacity: 0, y: -4 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0 }}
            className="mt-2 pl-5 text-sm text-clay"
          >
            {error}
          </motion.p>
        )}
      </AnimatePresence>
    </div>
  );
}
