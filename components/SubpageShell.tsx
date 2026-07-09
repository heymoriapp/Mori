import { ReactNode } from "react";
import Header from "./Header";
import Footer from "./Footer";

/**
 * Shared frame for secondary pages (docs, download, support, legal…):
 * sticky header, calm editorial title block, content column, footer.
 */
export default function SubpageShell({
  eyebrow,
  title,
  intro,
  children,
  wide = false,
}: {
  eyebrow: string;
  title: string;
  intro?: string;
  children: ReactNode;
  wide?: boolean;
}) {
  return (
    <>
      <Header />
      <main className="min-h-screen">
        <div
          className={`mx-auto ${wide ? "max-w-5xl" : "max-w-3xl"} px-5 pb-28 pt-36 sm:px-8`}
        >
          <span className="label text-clay">{eyebrow}</span>
          <h1 className="mt-4 font-serif text-4xl font-medium leading-tight tracking-tight text-ink sm:text-5xl">
            {title}
          </h1>
          {intro && (
            <p className="mt-5 max-w-2xl text-lg leading-relaxed text-muted">
              {intro}
            </p>
          )}
          <div className="mt-12">{children}</div>
        </div>
      </main>
      <Footer />
    </>
  );
}

/** A titled content section with consistent rhythm, linkable by id. */
export function DocSection({
  id,
  title,
  children,
}: {
  id: string;
  title: string;
  children: ReactNode;
}) {
  return (
    <section id={id} className="scroll-mt-28 border-t border-border pt-10 [&+&]:mt-10">
      <h2 className="font-serif text-2xl font-medium text-ink sm:text-3xl">
        {title}
      </h2>
      <div className="prose-mori mt-4 space-y-4 text-[0.98rem] leading-relaxed text-muted [&_strong]:font-medium [&_strong]:text-ink">
        {children}
      </div>
    </section>
  );
}

/** Inline keycap for shortcut mentions in docs. */
export function Key({ children }: { children: ReactNode }) {
  return (
    <kbd className="rounded-md border border-border bg-card px-1.5 py-0.5 font-mono text-[0.8em] text-forest">
      {children}
    </kbd>
  );
}
