import { ConnectButton } from "@rainbow-me/rainbowkit";
import Sismo from "./components/Sismo";

export default function Home() {
  return (
    <main className="flex flex-col items-center gap-8 pt-12 relative">
      <div className="absolute top-5 right-12">
        <ConnectButton />
      </div>
      <h2 className="text-2xl font-bold">Sismo Walkthrough</h2>
      <Sismo />
    </main>
  );
}
