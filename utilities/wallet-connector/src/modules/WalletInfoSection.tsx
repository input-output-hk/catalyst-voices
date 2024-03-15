import { Tab } from "@headlessui/react";
import getCardano from "common/helpers/getCardano";
import { noop } from "lodash-es";
import { Fragment } from "react/jsx-runtime";
import { twMerge } from "tailwind-merge";
import ArrowRightIcon from '@mui/icons-material/ArrowRight';
import InfoItem from "components/InfoItem";
import type { ExtractedWalletApi } from "types/cardano";
import Button from "components/Button";

type Props = {
  selectedWallets: string[];
  enablingWallets: string[];
  walletApi: Record<string, ExtractedWalletApi>;
  onEnable?: (walletName: string) => void;
  onEnableAll?: () => void;
}

function WalletInfoSection({
  selectedWallets,
  enablingWallets,
  walletApi,
  onEnable = noop,
  onEnableAll = noop,
}: Props) {
  const allEnabled = selectedWallets.every((wallet) => walletApi[wallet]);

  return (
    <section className="grid gap-4">
      <h2 className="font-semibold">Wallet Information:</h2>
      {selectedWallets.length ? (
        <div className="rounded-md border border-solid border-black/10 overflow-hidden">
          <div className="border-b border-solid border-black/10">
            <div className="flex justify-between px-4 py-2">
              <div className="flex items-center">
                <p className="font-semibold">Selected wallets: {selectedWallets.length}</p>
              </div>
              <div className="flex items-center">
                <Button className={twMerge(allEnabled && "invisible")} onClick={() => onEnableAll()}>
                  <p>Enable all wallets</p>
                </Button>
              </div>
            </div>
          </div>
          <Tab.Group as="div" className="grid grid-cols-[186px_1fr] h-[320px]">
            <Tab.List className="bg-background border-r border-solid border-black/10 overflow-y-auto">
              {selectedWallets.map((wallet) => (
                <Tab as={Fragment} key={wallet}>
                  {({ selected }) => (
                    <div className={twMerge("flex gap-2 items-center p-4 cursor-pointer", selected && "text-white bg-secondary")}>
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
                  {walletApi[wallet] ? (
                    <div className="grid gap-2 pb-4">
                      <InfoItem
                        heading="Balance Lovelace"
                        value={walletApi[wallet]?.balance ?? null}
                      />
                      <InfoItem
                        heading="UTXOs"
                        value={walletApi[wallet]?.utxos ?? null}
                      />
                      <InfoItem
                        heading="Network ID (0 = testnet; 1 = mainnet)"
                        value={walletApi[wallet]?.networkId?.toString() ?? null}
                      />
                      <InfoItem
                        heading="Collateral"
                        value={walletApi[wallet]?.collateral ?? null}
                      />
                      <InfoItem
                        heading="Used Addresses"
                        value={walletApi[wallet]?.usedAddresses ?? null}
                      />
                      <InfoItem
                        heading="Unused Addresses"
                        value={walletApi[wallet]?.unusedAddresses ?? null}
                      />
                      <InfoItem
                        heading="Change Address"
                        value={walletApi[wallet]?.changeAddress ?? null}
                      />
                      <InfoItem
                        heading="Reward Address"
                        value={walletApi[wallet]?.rewardAddresses ?? null}
                      />
                    </div>
                  ) : (
                    <div className="flex items-center justify-center w-full h-full">
                      <Button disabled={enablingWallets.includes(wallet)} onClick={() => onEnable(wallet)}>
                        <p>Enable</p>
                      </Button>
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
  )
}

export default WalletInfoSection;