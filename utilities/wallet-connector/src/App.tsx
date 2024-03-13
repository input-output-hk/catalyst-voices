import { QueryClient, QueryClientProvider } from "react-query";
import { ToastContainer } from "react-toastify";

import "react-toastify/dist/ReactToastify.css";

import "./styles/global.css";

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
  console.log(globalThis.cardano);

  const isCardanoActivated = typeof globalThis.cardano !== "undefined";

  return (
    <QueryClientProvider client={queryClient}>
      <ToastContainer />
      <div className="flex flex-col bg-background m-0 text-text min-h-screen">
        <div className="py-8 px-4">
          <main className="w-full max-w-[800px] my-0 mx-auto bg-white rounded-xl shadow">
            <div className="p-8">
              {isCardanoActivated ? (
                <section>
                  <div className="text-blue">hello world</div>
                </section>
              ) : (
                <section>
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
