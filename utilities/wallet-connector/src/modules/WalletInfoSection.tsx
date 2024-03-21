import { Tab } from "@headlessui/react";
import ArrowRightIcon from "@mui/icons-material/ArrowRight";
import WarningIcon from "@mui/icons-material/Warning";
import { capitalize, noop, pickBy, upperCase } from "lodash-es";
import { Fragment } from "react/jsx-runtime";
import { useForm } from "react-hook-form";
import { twMerge } from "tailwind-merge";

import Button from "common/components/Button";
import InfoItem from "common/components/InfoItem";
import { BASE_INPUT_STYLE } from "common/constants";
import getCardano from "common/helpers/getCardano";
import type { ExtensionArguments, ExtractedWalletApi } from "types/cardano";

type Props = {
  selectedWallets: string[];
  enablingWallets: string[];
  walletApi: Record<string, ExtractedWalletApi>;
  onEnable?: (walletName: string, extArg: ExtensionArguments) => void;
  onEnableAll?: (walletNames: string[], walletExtArg: Record<string, ExtensionArguments>) => void;
};

type FormValues = {
  [walletName: string]: ExtensionArguments;
};

function WalletInfoSection({
  selectedWallets,
  enablingWallets,
  walletApi,
  onEnable = noop,
  onEnableAll = noop,
}: Props) {
  const { register, getValues } = useForm<FormValues>();

  const disabledWallets = selectedWallets.filter((wallet) => !walletApi[wallet]);
  const allEnabled = !disabledWallets.length;

  function handleEnableWallet(wallet: string) {
    const arg = getValues(wallet);

    onEnable(wallet, pickBy(arg, Boolean));
  }

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
                <Button
                  className={twMerge(allEnabled && "invisible")}
                  disabled={Boolean(enablingWallets.length)}
                  onClick={() => onEnableAll(disabledWallets, {})}
                >
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
                    <div
                      className={twMerge(
                        "flex gap-2 items-center p-4 cursor-pointer",
                        selected && "text-white bg-secondary"
                      )}
                    >
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
                <Tab.Panel key={wallet} className="grid gap-4 p-4 h-full">
                  <div className="grid gap-2">
                    <InfoItem
                      heading="API version"
                      value={getCardano(wallet).apiVersion}
                      from="base"
                    />
                    <InfoItem
                      heading="Supported extensions"
                      value={getCardano(wallet).supportedExtensions ?? null}
                      from="base"
                    />
                  </div>
                  {Boolean(walletApi[wallet]) && (
                    <div className="grid gap-2">
                      {Object.entries(walletApi[wallet]?.["info"] ?? {}).map(
                        ([key, { from, value, raw }]: [string, any]) => (
                          <InfoItem
                            key={key}
                            heading={capitalize(upperCase(key))}
                            value={value ?? null}
                            raw={raw}
                            from={from}
                          />
                        )
                      )}
                    </div>
                  )}
                  <div className="h-px bg-black/10"></div>
                  <div className="flex flex-col gap-2 items-center justify-center pb-4">
                    <Button
                      disabled={enablingWallets.includes(wallet)}
                      onClick={() => handleEnableWallet(wallet)}
                    >
                      <p>{walletApi[wallet] ? "Re-Enable" : "Enable"}</p>
                    </Button>
                    <h2 className="font-semibold">Extension</h2>
                    <input
                      className={BASE_INPUT_STYLE}
                      type="number"
                      placeholder="cip (optional)"
                      {...register(`${wallet}.cip`, { valueAsNumber: true })}
                    />
                  </div>
                </Tab.Panel>
              ))}
            </Tab.Panels>
          </Tab.Group>
        </div>
      ) : (
        <div className="p-4 rounded-md bg-amber-100 border border-solid border-amber-500 overflow-hidden">
          <div className="flex gap-4">
            <WarningIcon className="text-amber-500" />
            <p>Please select at least one wallet to view the information.</p>
          </div>
        </div>
      )}
    </section>
  );
}

export default WalletInfoSection;
