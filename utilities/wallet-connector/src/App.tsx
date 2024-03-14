import { Tab } from "@headlessui/react";
import ArrowRightIcon from '@mui/icons-material/ArrowRight';
import getCardano from "common/helpers/getCardano";
import WalletCard from "components/WalletCard";
import { xor } from "lodash-es";
import { Fragment, useState } from "react";
import { QueryClient, QueryClientProvider } from "react-query";
import { ToastContainer } from "react-toastify";
import { twMerge } from "tailwind-merge";

import "react-toastify/dist/ReactToastify.css";

import extractApiData from "common/helpers/extractApiData";
import { ExtractedWalletApi } from "types/cardano";
import "./styles/global.css";
import InfoItem from "components/InfoItem";
import WalletActionsSection from "modules/WalletActionsSection";

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
                  <section className="grid gap-4">
                    <h2 className="font-semibold">Wallet Informatmion:</h2>
                    {selectedWallets.length ? (
                      <div className="rounded-md border border-solid border-black/10 overflow-hidden">
                        <div className="border-b border-solid border-black/10">
                          <div className="flex justify-between px-4 py-2">
                            <div className="flex items-center">
                              <p className="font-semibold">Selected wallets: {selectedWallets.length}</p>
                            </div>
                            <div className="flex items-center">
                              <button type="button" className="bg-primary rounded-md px-4 py-2 text-white">
                                <p>Enable all wallets</p>
                              </button>
                            </div>
                          </div>
                        </div>
                        <Tab.Group as="div" className="grid grid-cols-[186px_1fr] h-[320px]">
                          <Tab.List className="bg-background border-r border-solid border-black/10 overflow-y-auto">
                            {selectedWallets.map((wallet) => (
                              <Tab as={Fragment} key={wallet}>
                                {({ selected }) => (
                                  <div className={twMerge("flex gap-2 items-center p-4", selected && "text-white bg-secondary")}>
                                    <img src={getCardano(wallet).icon} width={20} height={20} alt="icon" />
                                    <p className="grow truncate">{wallet}</p>
                                    {selected && <ArrowRightIcon />}
                                  </div>
                                )}
                              </Tab>
                            ))}
                          </Tab.List>
                          <Tab.Panels className="h-full overflow-auto">
                            {selectedWallets.map((wallet) => (
                              <Tab.Panel key={wallet} className="p-4 h-full">
                                {walletApis[wallet] ? (
                                  <div className="grid gap-2 pb-4">
                                    <InfoItem
                                      heading="Balance Lovelace"
                                      value={walletApis[wallet]?.balance}
                                    />
                                    <InfoItem
                                      heading="UTXOs"
                                      value={walletApis[wallet]?.utxos}
                                    />
                                    <InfoItem
                                      heading="Network ID (0 = testnet; 1 = mainnet)"
                                      value={walletApis[wallet]?.networkId?.toString()}
                                    />
                                    <InfoItem
                                      heading="Collateral"
                                      value={walletApis[wallet]?.collateral}
                                    />
                                    <InfoItem
                                      heading="Used Addresses"
                                      value={walletApis[wallet]?.usedAddresses}
                                    />
                                    <InfoItem
                                      heading="Unused Addresses"
                                      value={walletApis[wallet]?.unusedAddresses}
                                    />
                                    <InfoItem
                                      heading="Change Address"
                                      value={walletApis[wallet]?.changeAddress}
                                    />
                                    <InfoItem
                                      heading="Reward Address"
                                      value={walletApis[wallet]?.rewardAddresses}
                                    />
                                  </div>
                                ) : (
                                  <div className="flex items-center justify-center w-full h-full">
                                    <button type="button" className="bg-primary rounded-md px-4 py-2 text-white" disabled={enablingWallets.includes(wallet)} onClick={() => enableWallet(wallet)}>
                                      <p>Enable</p>
                                    </button>
                                  </div>
                                )}
                              </Tab.Panel>
                            ))}
                          </Tab.Panels>
                        </Tab.Group>
                      </div>
                    ) : (
                      <div>
                        <p>Please select at least one wallet to view the information.</p>
                      </div>
                    )}
                  </section>
                  <WalletActionsSection />
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
