import "react-toastify/dist/ReactToastify.css";

import "./styles/global.css";

import getCardano from "common/helpers/getCardano";
import WalletCard from "components/WalletCard";
import { xor } from "lodash-es";
import { useState } from "react";
import { QueryClient, QueryClientProvider } from "react-query";
import { ToastContainer } from "react-toastify";

import extractApiData from "common/helpers/extractApiData";
import WalletActionsSection from "modules/WalletActionsSection";
import WalletInfoSection from "modules/WalletInfoSection";
import type { ExtractedWalletApi } from "types/cardano";

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      retry: false,
      refetchOnWindowFocus: false
    },
    mutations: {
      retry: false
    }
  }
});

function App() {
  const [walletApis, setWalletApis] = useState<Record<string, ExtractedWalletApi>>({});
  const [enablingWallets, setEnablingWallets] = useState<string[]>([]);
  const [selectedWallets, setSelectedWallets] = useState<string[]>([]);

  console.log(getCardano());

  const isCardanoActivated = typeof getCardano() !== "undefined";

  function handleWalletCardClick(walletName: string) {
    setSelectedWallets((prev) => xor(prev, [walletName]))
  }

  async function enableWallet(walletName: string) {
    setEnablingWallets((prev) => [...prev, walletName]);

    const api = await getCardano(walletName).enable();

    const extractedApi = await extractApiData(api);

    console.log("api", extractedApi);

    setWalletApis((prev) => ({ ...prev, [walletName]: extractedApi }));
    setEnablingWallets((prev) => prev.filter((w) => w !== walletName));
  }

  async function enableAllWallets(walletNames: string[]) {
    /* const walletApis = await Promise.all(Object.entries(getCardano()).map(async ([walletName, walletProps]: any) => {
      const api = await walletProps.enable({ cip: 30 })

      return [walletName, api]
    })); */

    // setWalletApis(Object.fromEntries(walletApis));
  }

  return (
    <QueryClientProvider client={queryClient}>
      <ToastContainer />
      <div className="flex flex-col bg-background m-0 text-text min-h-screen">
        <div className="py-8 px-4">
          <main className="w-full max-w-[960px] my-0 mx-auto bg-white rounded-xl shadow">
            <div className="grid gap-8 p-8">
              {isCardanoActivated ? (
                <>
                  <section className="grid gap-4">
                    <h2 className="font-semibold">Select available wallets:</h2>
                    <div className="flex flex-wrap gap-4 bg-background px-4 py-2 rounded-md border border-solid border-black/10">
                      {Object.keys(getCardano()).map((walletName) => (
                        <WalletCard
                          key={walletName}
                          isChecked={selectedWallets.includes(walletName)}
                          isEnabled={Boolean(walletApis[walletName])}
                          name={walletName}
                          onClick={() => handleWalletCardClick(walletName)}
                        />
                      ))}
                    </div>
                  </section>
                  <WalletInfoSection
                    selectedWallets={selectedWallets}
                    enablingWallets={enablingWallets}
                    walletApis={walletApis}
                    onEnable={enableWallet}
                  />
                  <WalletActionsSection
                  
                  />
                </>
              ) : (
                <section className="grid gap-4">
                  <h2 className="font-bold">Cardano extension is not activated!</h2>
                </section>
              )}
            </div>
          </main>
        </div>
      </div>
    </QueryClientProvider>
  );
}

export default App;
