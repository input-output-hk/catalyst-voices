import "react-toastify/dist/ReactToastify.css";

import "./styles/global.css";

import getCardano from "common/helpers/getCardano";
import WalletCard from "common/components/WalletCard";
import { pickBy, xor } from "lodash-es";
import { useState } from "react";
import { QueryClient, QueryClientProvider } from "react-query";
import { ToastContainer } from "react-toastify";

import extractApiData from "common/helpers/extractApiData";
import WalletActionsSection from "modules/WalletActionsSection";
import WalletInfoSection from "modules/WalletInfoSection";
import type { ExtractedWalletApi } from "types/cardano";
import type { Cip30Wallet } from "@cardano-sdk/cip30";

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
  // enabled wallets with the API object
  const [walletApi, setWalletApi] = useState<Record<string, ExtractedWalletApi>>({});
  // list of wallet names that is being enabled
  const [enablingWallets, setEnablingWallets] = useState<string[]>([]);
  // wallet name selections
  const [selectedWallets, setSelectedWallets] = useState<string[]>([]);

  console.log(getCardano());

  const isCardanoActivated = typeof getCardano() !== "undefined";

  function handleWalletCardClick(walletName: string) {
    setSelectedWallets((prev) => xor(prev, [walletName]))
  }

  async function handleEnableWallet(walletName: string) {
    await handleEnableAllWallets([ walletName ]);
  }

  async function handleEnableAllWallets(wallets?: string[]) {
    const toBeEnabledWallets = (wallets ?? selectedWallets).filter((wallet) => !walletApi[wallet]);
    const mappedWalletProp = pickBy(getCardano(), (v, k) => toBeEnabledWallets.includes(k)) as Record<string, Cip30Wallet>;

    setEnablingWallets((prev) => [...prev, ...toBeEnabledWallets]);

    const walletApis = await Promise.all(Object.entries(mappedWalletProp).map(async ([walletName, walletProps]) => {
      const api = await walletProps.enable(/* { cip: 30 } */);

      const extractedApi = await extractApiData(api);

      return [walletName, extractedApi]
    }));

    console.log("api", walletApis);

    setWalletApi((prev) => ({ ...prev, ...Object.fromEntries(walletApis) }));
    setEnablingWallets((prev) => prev.filter((wallet) => !toBeEnabledWallets.includes(wallet)));
  }

  return (
    <QueryClientProvider client={queryClient}>
      <ToastContainer />
      <div className="flex flex-col bg-background m-0 text-text min-h-screen">
        <div className="grid gap-8 py-8 px-4">
          <main className="w-full max-w-[1024px] my-0 mx-auto bg-white rounded-xl shadow">
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
                          isEnabled={Boolean(walletApi[walletName])}
                          name={walletName}
                          isEnabledStatusDisplayed={true}
                          onClick={() => handleWalletCardClick(walletName)}
                        />
                      ))}
                    </div>
                  </section>
                  <WalletInfoSection
                    selectedWallets={selectedWallets}
                    enablingWallets={enablingWallets}
                    walletApi={walletApi}
                    onEnable={handleEnableWallet}
                    onEnableAll={handleEnableAllWallets}
                  />
                  <WalletActionsSection
                    selectedWallets={selectedWallets}
                    walletApi={walletApi}
                  />
                </>
              ) : (
                <section className="grid gap-4">
                  <h2 className="font-bold">Cardano extension is not activated!</h2>
                </section>
              )}
            </div>
          </main>
          <footer>
            <div className="text-center">Created by Catalyst Team</div>
          </footer>
        </div>
      </div>
    </QueryClientProvider>
  );
}

export default App;
