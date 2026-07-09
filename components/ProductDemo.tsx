"use client";

import { useEffect, useRef, useState } from "react";
import { AnimatePresence, motion, useInView } from "framer-motion";
import { Reveal } from "./AnimatedText";
import MoriMark from "./MoriMark";
import { usePrefersReducedMotion } from "@/lib/hooks";

const REPLY =
  "June 18 still works. I'll send the final partner brief after onboarding is wrapped, and I'll keep the investor notes aligned with the new date.";

const TABS = ["Reply", "Rewrite", "Recall", "Summarize"] as const;

type Phase = "idle" | "shortcut" | "panel" | "typing" | "done" | "inserted";

const STEPS = [
  { n: "01", label: "Incoming message" },
  { n: "02", label: "Press ⌥M" },
  { n: "03", label: "Mori drafts" },
];

function activeStep(phase: Phase): number {
  if (phase === "shortcut") return 1;
  if (phase === "panel" || phase === "typing") return 2;
  if (phase === "done" || phase === "inserted") return 2;
  return 0;
}

export default function ProductDemo() {
  const ref = useRef<HTMLDivElement>(null);
  const inView = useInView(ref, { once: false, amount: 0.45 });
  const reduced = usePrefersReducedMotion();

  const [phase, setPhase] = useState<Phase>("idle");
  const [typed, setTyped] = useState("");
  const [activeTab, setActiveTab] = useState<(typeof TABS)[number]>("Reply");
  const timers = useRef<ReturnType<typeof setTimeout>[]>([]);

  useEffect(() => {
    const clearAll = () => {
      timers.current.forEach(clearTimeout);
      timers.current = [];
    };

    if (!inView) {
      clearAll();
      setPhase("idle");
      setTyped("");
      return;
    }

    if (reduced) {
      setPhase("done");
      setTyped(REPLY);
      return;
    }

    const push = (fn: () => void, ms: number) =>
      timers.current.push(setTimeout(fn, ms));

    push(() => setPhase("shortcut"), 600);
    push(() => setPhase("panel"), 1500);
    push(() => {
      setPhase("typing");
      let i = 0;
      const type = () => {
        i += 1;
        setTyped(REPLY.slice(0, i));
        if (i < REPLY.length) {
          timers.current.push(setTimeout(type, 22));
        } else {
          timers.current.push(setTimeout(() => setPhase("done"), 450));
        }
      };
      type();
    }, 2000);

    return clearAll;
  }, [inView, reduced]);

  const step = activeStep(phase);
  const composerVisible =
    phase === "panel" || phase === "typing" || phase === "done" || phase === "inserted";
  const shortcutHot = phase === "shortcut" || phase === "panel";

  return (
    <section
      id="demo"
      className="relative mx-auto max-w-6xl px-5 py-28 sm:px-8 sm:py-36"
    >
      <div className="mb-12 max-w-2xl">
        <Reveal>
          <span className="label text-clay">the demo</span>
        </Reveal>
        <Reveal delay={0.05}>
          <h2 className="mt-5 font-serif text-4xl font-medium leading-tight tracking-tight text-ink sm:text-5xl">
            From blank reply to finished thought.
          </h2>
        </Reveal>
      </div>

      {/* step indicator */}
      <Reveal delay={0.1}>
        <div className="mb-6 flex flex-wrap items-center gap-x-3 gap-y-2">
          {STEPS.map((s, i) => {
            const on = step >= i;
            return (
              <div key={s.n} className="flex items-center gap-3">
                <span
                  className={`flex items-center gap-2 rounded-full border px-3 py-1.5 text-xs transition-colors duration-500 ${
                    on
                      ? "border-forest/30 bg-soft-green/50 text-forest"
                      : "border-border text-muted"
                  }`}
                >
                  <span className="font-mono">{s.n}</span>
                  {s.label}
                </span>
                {i < STEPS.length - 1 && (
                  <span className="hidden text-border sm:inline">→</span>
                )}
              </div>
            );
          })}
        </div>
      </Reveal>

      <Reveal delay={0.1}>
        <div
          ref={ref}
          className="grid items-center gap-4 rounded-3xl border border-border bg-gradient-to-b from-card to-background p-5 shadow-card sm:p-8 lg:grid-cols-[1fr_auto_1fr]"
        >
          {/* left: message thread + response field */}
          <div className="rounded-2xl border border-border bg-card p-5 shadow-soft">
            <span className="label text-muted">Messages · Sarah</span>
            <div className="mt-4 flex items-start gap-3">
              <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-full bg-soft-clay font-mono text-xs text-clay">
                S
              </div>
              <div className="rounded-2xl rounded-tl-sm bg-background px-4 py-3 text-[0.98rem] leading-relaxed text-ink">
                Can you confirm if June 18 still works for launch?
              </div>
            </div>

            {/* user response field */}
            <div className="mt-5">
              <span className="label text-muted">Your reply</span>
              <motion.div
                className="mt-2 min-h-[4.5rem] rounded-xl border bg-background px-4 py-3 text-[0.98rem] leading-relaxed"
                animate={{
                  borderColor: shortcutHot ? "#2F4A37" : "#E7E0D2",
                  boxShadow: shortcutHot
                    ? "0 0 0 3px rgba(47,74,55,0.12)"
                    : "0 0 0 0px rgba(47,74,55,0)",
                }}
                transition={{ duration: 0.4 }}
              >
                <AnimatePresence mode="wait">
                  {phase === "inserted" ? (
                    <motion.span
                      key="inserted"
                      initial={{ opacity: 0, y: 8 }}
                      animate={{ opacity: 1, y: 0 }}
                      className="text-ink"
                    >
                      {REPLY}
                    </motion.span>
                  ) : (
                    <motion.span
                      key="placeholder"
                      className="flex items-center gap-2 text-muted/60"
                    >
                      <span>Reply to Sarah…</span>
                      {shortcutHot && (
                        <motion.span
                          initial={{ scale: 0.6, opacity: 0 }}
                          animate={{ scale: 1, opacity: 1 }}
                          className="rounded-md border border-forest/30 bg-soft-green/50 px-2 py-0.5 font-mono text-xs text-forest"
                        >
                          ⌥M
                        </motion.span>
                      )}
                    </motion.span>
                  )}
                </AnimatePresence>
              </motion.div>
            </div>
          </div>

          {/* center: the ⌥M trigger */}
          <div className="flex items-center justify-center py-2 lg:flex-col lg:py-0">
            <div className="flex items-center gap-1.5 lg:flex-col">
              <motion.span
                className="rounded-lg border border-border bg-card px-3 py-2 font-mono text-sm text-forest shadow-soft"
                animate={
                  shortcutHot && !reduced
                    ? { y: [0, 3, 0], borderColor: ["#E7E0D2", "#2F4A37", "#E7E0D2"] }
                    : {}
                }
                transition={{ duration: 0.9, repeat: shortcutHot ? Infinity : 0 }}
              >
                ⌥
              </motion.span>
              <motion.span
                className="rounded-lg border border-border bg-card px-3 py-2 font-mono text-sm text-forest shadow-soft"
                animate={
                  shortcutHot && !reduced
                    ? { y: [0, 3, 0], borderColor: ["#E7E0D2", "#2F4A37", "#E7E0D2"] }
                    : {}
                }
                transition={{ duration: 0.9, repeat: shortcutHot ? Infinity : 0, delay: 0.12 }}
              >
                M
              </motion.span>
            </div>
            <motion.span
              className="mx-3 text-2xl text-moss lg:my-3 lg:mx-0"
              animate={composerVisible && !reduced ? { opacity: [0.4, 1, 0.4] } : { opacity: 0.5 }}
              transition={{ duration: 1.6, repeat: Infinity }}
            >
              <span className="lg:hidden">↓</span>
              <span className="hidden lg:inline">→</span>
            </motion.span>
          </div>

          {/* right: Mori composer */}
          <div className="relative min-h-[19rem]">
            <AnimatePresence>
              {composerVisible ? (
                <motion.div
                  key="composer"
                  initial={{ opacity: 0, y: 24, scale: 0.97 }}
                  animate={{ opacity: 1, y: 0, scale: 1 }}
                  exit={{ opacity: 0, y: 12 }}
                  transition={{ duration: 0.5, ease: [0.22, 1, 0.36, 1] }}
                  className="rounded-2xl border border-border bg-card p-5 shadow-float"
                >
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-2">
                      <span className="rounded-md border border-border bg-background px-2 py-1 font-mono text-xs text-forest">
                        ⌥M
                      </span>
                      <span className="flex items-center gap-2">
                        <span className="h-2 w-2 animate-pulse-dot rounded-full bg-forest" />
                        <span className="label text-muted">Drafting</span>
                      </span>
                    </div>
                    <MoriMark size={22} />
                  </div>

                  <div className="mt-4 flex gap-1 rounded-xl bg-background p-1">
                    {TABS.map((tab) => (
                      <button
                        key={tab}
                        onClick={() => setActiveTab(tab)}
                        className={`flex-1 rounded-lg px-2 py-1.5 text-xs font-medium transition-colors ${
                          activeTab === tab
                            ? "bg-card text-forest shadow-soft"
                            : "text-muted hover:text-ink"
                        }`}
                      >
                        {tab}
                      </button>
                    ))}
                  </div>

                  <div className="mt-4 min-h-[7.5rem] rounded-xl bg-background/70 p-4">
                    <p className="font-serif text-lg leading-relaxed text-ink">
                      {typed}
                      {(phase === "typing" || phase === "panel") && (
                        <span className="ml-0.5 inline-block h-[1.05em] w-[2px] translate-y-[0.12em] bg-clay align-middle animate-blink" />
                      )}
                    </p>
                  </div>

                  <button
                    onClick={() => setPhase("inserted")}
                    disabled={phase !== "done"}
                    className={`mt-4 w-full rounded-full py-2.5 text-sm font-medium transition-all duration-300 ${
                      phase === "done"
                        ? "bg-forest text-background hover:bg-[#263d2d]"
                        : phase === "inserted"
                        ? "bg-soft-green text-forest"
                        : "cursor-default bg-border/60 text-muted"
                    }`}
                  >
                    {phase === "inserted" ? "Inserted into your reply ✓" : "Insert reply"}
                  </button>
                </motion.div>
              ) : (
                <motion.div
                  key="waiting"
                  initial={{ opacity: 0 }}
                  animate={{ opacity: 1 }}
                  exit={{ opacity: 0 }}
                  className="flex min-h-[19rem] flex-col items-center justify-center rounded-2xl border border-dashed border-border bg-card/40 p-6 text-center"
                >
                  <MoriMark size={30} />
                  <p className="mt-3 max-w-[14rem] text-sm text-muted">
                    Press <span className="font-mono text-forest">⌥M</span> and Mori
                    opens right where you&rsquo;re typing.
                  </p>
                </motion.div>
              )}
            </AnimatePresence>
          </div>
        </div>
      </Reveal>

      <Reveal delay={0.1}>
        <p className="mt-6 text-center text-sm text-muted">
          Draft, rewrite, recall, or summarize — without leaving the conversation.
        </p>
      </Reveal>
    </section>
  );
}
