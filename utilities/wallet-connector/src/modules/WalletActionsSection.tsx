import { Tab } from "@headlessui/react";
import ArrowRightIcon from '@mui/icons-material/ArrowRight';
import { Fragment } from "react/jsx-runtime";
import { twMerge } from "tailwind-merge";
import SignDataPanel from "./SignDataPanel";
import SignTxnPanel from "./SignTxnPanel";
import SubmitTxnPanel from "./SubmitTxnPanel";
import type { ExtractedWalletApi } from "types/cardano";

const ACTIONS = [
  "Sign Transaction",
  "Sign Data",
  "Submit Transaction"
];

type Props = {
  selectedWallets: string[];
  walletApis: Record<string, ExtractedWalletApi>;
}

function WalletActionsSection({
  walletApis,
  selectedWallets
}: Props) {
  return (
    <section className="grid gap-4">
      <h2 className="font-semibold">Wallet Actions:</h2>
      <div className="rounded-md border border-solid border-black/10 overflow-hidden">
        <Tab.Group as="div" className="grid grid-cols-[186px_1fr] min-h-[320px]">
          <Tab.List className="bg-background border-r border-solid border-black/10 overflow-y-auto">
            {ACTIONS.map((action) => (
              <Tab as={Fragment} key={action}>
                {({ selected }) => (
                  <div className={twMerge("flex gap-2 items-center p-4 cursor-pointer", selected && "text-white bg-secondary")}>
                    <p className="grow truncate">{action}</p>
                    {selected && <ArrowRightIcon />}
                  </div>
                )}
              </Tab>
            ))}
          </Tab.List>
          <Tab.Panels className="h-full overflow-auto">
            <Tab.Panel className="p-4 h-full">
              <SignTxnPanel
                selectedWallets={selectedWallets}
                walletApis={walletApis}
              />
            </Tab.Panel>
            <Tab.Panel className="p-4 h-full">
              <SignDataPanel

              />
            </Tab.Panel>
            <Tab.Panel className="p-4 h-full">
              <SubmitTxnPanel

              />
            </Tab.Panel>
          </Tab.Panels>
        </Tab.Group>
      </div>
    </section>
  )
}

export default WalletActionsSection;