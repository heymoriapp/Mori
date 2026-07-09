import SmoothScroll from "@/components/SmoothScroll";
import Header from "@/components/Header";
import HeroSection from "@/components/HeroSection";
import ProblemSection from "@/components/ProblemSection";
import HowItWorks from "@/components/HowItWorks";
import ProductDemo from "@/components/ProductDemo";
import MemorySection from "@/components/MemorySection";
import ControlsSection from "@/components/ControlsSection";
import PrivacySection from "@/components/PrivacySection";
import UseCases from "@/components/UseCases";
import MacFirstSection from "@/components/MacFirstSection";
import BrandIdentity from "@/components/BrandIdentity";
import NarrativeTransition from "@/components/NarrativeTransition";
import FAQ from "@/components/FAQ";
import FinalCTA from "@/components/FinalCTA";
import Footer from "@/components/Footer";

export default function Home() {
  return (
    <SmoothScroll>
      <Header />
      <main>
        <HeroSection />
        <ProblemSection />
        <HowItWorks />
        <ProductDemo />
        <MemorySection />
        <ControlsSection />
        <PrivacySection />
        <UseCases />
        <MacFirstSection />
        <BrandIdentity />
        <NarrativeTransition />
        <FAQ />
        <FinalCTA />
      </main>
      <Footer />
    </SmoothScroll>
  );
}
