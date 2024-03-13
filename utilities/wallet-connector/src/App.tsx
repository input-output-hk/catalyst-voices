import { QueryClient, QueryClientProvider } from "react-query";
import { ToastContainer } from "react-toastify";
import { xor } from "lodash-es";

import "react-toastify/dist/ReactToastify.css";

import "./styles/global.css";
import WalletCard from "components/WalletCard";
import { useEffect, useState } from "react";

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
  const [isInit, setIsInit] = useState(false);
  const [walletApis, setWalletApis] = useState({});
  const [enablingWallets, setEnablingWallets] = useState([]);
  const [selectingWallets, setSelectingWallets] = useState<string[]>([]);

  console.log(globalThis.cardano);

  useEffect(() => {
    init();
  }, []);

  const isCardanoActivated = typeof globalThis.cardano !== "undefined";

  async function init() {
    console.log("testing")

    const walletApis = await Promise.all(Object.entries(globalThis.cardano).map(async ([walletName, walletProps]: any) => {
      const api = await walletProps.enable({ cip: 30 })

      return [walletName, api]
    }));

    console.log("apis", walletApis)

    setIsInit(true);
    setWalletApis(Object.fromEntries(walletApis));
  }

  function handleWalletCardClick(walletName: string) {
    setSelectingWallets((prev) => xor(prev, [ walletName ]))
  }

  if (!isInit) {
    return <div>Loading</div>
  }

  return (
    <QueryClientProvider client={queryClient}>
      <ToastContainer />
      <div className="flex flex-col bg-background m-0 text-text min-h-screen">
        <div className="py-8 px-4">
          <main className="w-full max-w-[800px] my-0 mx-auto bg-white rounded-xl shadow">
            <div className="p-8">
              {isCardanoActivated ? (
                <section className="grid gap-4">
                  <h2 className="font-semibold">Select available wallets:</h2>
                  <div className="flex flex-wrap gap-4 bg-background px-4 py-2 rounded-md border border-solid border-black/10">
                    {Object.keys(globalThis.cardano).map((walletName) => (
                      <WalletCard
                        key={walletName}
                        isChecked={selectingWallets.includes(walletName)}
                        isEnabled={false}
                        name={walletName}
                        onClick={() => handleWalletCardClick(walletName)}
                      />
                    ))}
                  </div>
                </section>
              ) : (
                <section className="grid gap-4">
                  <div className="font-bold">Cardano extension is not activated!</div>
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
