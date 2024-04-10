import { Tab } from "@headlessui/react";
import ArrowRightIcon from "@mui/icons-material/ArrowRight";
import RefreshIcon from "@mui/icons-material/Refresh";
import { capitalize, noop, pickBy, upperCase } from "lodash-es";
import { Fragment } from "react/jsx-runtime";
import { useForm } from "react-hook-form";
import { twMerge } from "tailwind-merge";

import Badge from "common/components/Badge";
import Button from "common/components/Button";
import InfoItem from "common/components/InfoItem";
import Input from "common/components/Input";
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
              {selectedWallets.map((walletName) => (
                <Tab as={Fragment} key={walletName}>
                  {({ selected }) => (
                    <div
                      className={twMerge(
                        "flex gap-2 items-center p-4 cursor-pointer",
                        selected && "text-white bg-secondary"
                      )}
                    >
                      {enablingWallets.includes(walletName) ? (
                        <div className="flex items-center justify-center w-[20px] h-[20px]">
                          <RefreshIcon className="animate-spin" />
                        </div>
                      ) : (
                        <img src={getCardano(walletName).icon} width={20} height={20} alt="icon" />
                      )}
                      <p className="grow truncate">{walletName}</p>
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
                        ([key, { from, value, raw }]) => (
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
                    <Input
                      type="number"
                      label="CIP (optional)"
                      formRegister={register(`${wallet}.cip`, { valueAsNumber: true })}
                    />
                  </div>
                </Tab.Panel>
              ))}
            </Tab.Panels>
          </Tab.Group>
        </div>
      ) : (
        <Badge variant="warn" text="Please select at least one wallet to view the information." />
      )}
    </section>
  );
}

export default WalletInfoSection;
