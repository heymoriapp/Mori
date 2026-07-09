import type { Metadata, Viewport } from "next";
import { Fraunces, Inter, JetBrains_Mono } from "next/font/google";
import DownloadModal from "@/components/DownloadModal";
import "./globals.css";

const serif = Fraunces({
  subsets: ["latin"],
  variable: "--font-serif",
  display: "swap",
  axes: ["opsz", "SOFT", "WONK"],
});

const sans = Inter({
  subsets: ["latin"],
  variable: "--font-sans",
  display: "swap",
});

const mono = JetBrains_Mono({
  subsets: ["latin"],
  variable: "--font-mono",
  display: "swap",
  weight: ["400", "500"],
});

export const metadata: Metadata = {
  metadataBase: new URL("https://heymori.app"),
  title: {
    default: "mori — a little memory spirit for your Mac",
    template: "%s · mori",
  },
  description:
    "Press ⌥M anywhere you type. Mori recalls your recent work, understands the thread, and drafts a reply in your tone. Private by design. Mac-first.",
  keywords: [
    "Mac AI",
    "memory app",
    "AI writing assistant",
    "menu bar app",
    "private AI",
    "local-first",
  ],
  openGraph: {
    title: "mori — a little memory spirit for your Mac",
    description:
      "One key to remember every conversation. Private by design. Mac-first.",
    url: "https://heymori.app",
    siteName: "mori",
    type: "website",
  },
};

export const viewport: Viewport = {
  themeColor: "#FAF7EF",
  width: "device-width",
  initialScale: 1,
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html
      lang="en"
      className={`${serif.variable} ${sans.variable} ${mono.variable}`}
    >
      <body className="paper-grain antialiased">
        {children}
        <DownloadModal />
      </body>
    </html>
  );
}
