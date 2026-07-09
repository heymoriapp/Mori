import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./app/**/*.{ts,tsx}",
    "./components/**/*.{ts,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        background: "#FAF7EF",
        card: "#FFFDF8",
        ink: "#12110E",
        muted: "#706B63",
        forest: "#2F4A37",
        moss: "#9CAF88",
        clay: "#D96B3C",
        border: "#E7E0D2",
        "soft-green": "#DDE8D3",
        "soft-clay": "#F6D8C6",
      },
      fontFamily: {
        serif: ["var(--font-serif)", "Georgia", "serif"],
        sans: ["var(--font-sans)", "system-ui", "sans-serif"],
        mono: ["var(--font-mono)", "monospace"],
      },
      letterSpacing: {
        label: "0.18em",
      },
      boxShadow: {
        card: "0 1px 2px rgba(18,17,14,0.04), 0 12px 32px -12px rgba(18,17,14,0.12)",
        float: "0 2px 4px rgba(18,17,14,0.04), 0 30px 60px -20px rgba(18,17,14,0.20)",
        soft: "0 1px 2px rgba(18,17,14,0.03), 0 8px 24px -12px rgba(18,17,14,0.10)",
      },
      keyframes: {
        blink: {
          "0%, 49%": { opacity: "1" },
          "50%, 100%": { opacity: "0" },
        },
        "pulse-dot": {
          "0%, 100%": { opacity: "1", transform: "scale(1)" },
          "50%": { opacity: "0.5", transform: "scale(0.85)" },
        },
      },
      animation: {
        blink: "blink 1.1s step-end infinite",
        "pulse-dot": "pulse-dot 2.4s ease-in-out infinite",
      },
    },
  },
  plugins: [],
};

export default config;
