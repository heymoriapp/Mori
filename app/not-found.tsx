import Link from "next/link";
import Header from "@/components/Header";
import Footer from "@/components/Footer";
import MoriMascot from "@/components/MoriMascot";

export default function NotFound() {
  return (
    <>
      <Header />
      <main className="flex min-h-screen flex-col items-center justify-center px-5 pb-24 pt-32 text-center">
        <MoriMascot size={188} float glow alt="A lost little Mori spirit" />
        <p className="label mt-8 text-clay">404</p>
        <h1 className="mt-4 font-serif text-4xl font-medium leading-tight tracking-tight text-ink sm:text-5xl">
          This path is lost in the forest.
        </h1>
        <p className="mt-4 max-w-md text-lg leading-relaxed text-muted">
          Even a memory spirit forgets a trail sometimes. Let&rsquo;s head back
          to somewhere familiar.
        </p>
        <div className="mt-8 flex flex-wrap items-center justify-center gap-4 text-sm">
          <Link
            href="/"
            className="rounded-full bg-forest px-6 py-3 font-medium text-background transition-colors hover:bg-[#263d2d]"
          >
            Back home
          </Link>
          <Link
            href="/docs"
            className="text-forest underline-offset-4 hover:underline"
          >
            Read the docs
          </Link>
          <Link
            href="/download"
            className="text-forest underline-offset-4 hover:underline"
          >
            Download the beta
          </Link>
        </div>
      </main>
      <Footer />
    </>
  );
}
