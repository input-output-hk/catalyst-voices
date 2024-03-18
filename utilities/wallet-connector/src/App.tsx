import "react-toastify/dist/ReactToastify.css";

import "./styles/global.css";

import { isEmpty, pickBy, xor } from "lodash-es";
import { useState } from "react";
import { QueryClient, QueryClientProvider } from "react-query";
import { ToastContainer, toast } from "react-toastify";

import WalletCard from "common/components/WalletCard";
import extractApiData from "common/helpers/extractApiData";
import getCardano from "common/helpers/getCardano";
import WalletActionsSection from "modules/WalletActionsSection";
import WalletInfoSection from "modules/WalletInfoSection";
import type { ExtensionArguments, ExtractedWalletApi } from "types/cardano";

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      retry: false,
      refetchOnWindowFocus: false,
    },
    mutations: {
      retry: false,
    },
  },
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
    setSelectedWallets((prev) => xor(prev, [walletName]));
  }

  async function handleEnableWallet(walletName: string, extArg: ExtensionArguments) {
    await handleEnableAllWallets([walletName], { [walletName]: extArg });
  }

  async function handleEnableAllWallets(
    wallets: string[],
    walletExtArg: Record<string, ExtensionArguments>
  ) {
    const mappedWalletProp = pickBy(getCardano(), (v, k) => wallets.includes(k));

    setEnablingWallets((prev) => [...prev, ...wallets]);

    try {
      const walletApis = await Promise.all(
        Object.entries(mappedWalletProp).map(async ([walletName, walletProps]) => {
          const api = isEmpty(walletExtArg[walletName])
            ? await walletProps.enable()
            : await walletProps.enable({ extensions: [walletExtArg[walletName]] });

          const extractedApi = await extractApiData(api);

          return [walletName, extractedApi];
        })
      );

      console.log("api", walletApis);

      setWalletApi((prev) => ({ ...prev, ...Object.fromEntries(walletApis) }));
    } catch (err) {
      toast.error(String(err));
    } finally {
      setEnablingWallets((prev) => prev.filter((wallet) => !wallets.includes(wallet)));
    }
  }

  return (
    <QueryClientProvider client={queryClient}>
      <ToastContainer />
      <div className="flex flex-col bg-background m-0 text-text min-h-screen">
        <div className="grow flex flex-col justify-between gap-8 py-8 px-4">
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
                  {Boolean(selectedWallets.length) && (
                    <WalletActionsSection selectedWallets={selectedWallets} walletApi={walletApi} />
                  )}
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
