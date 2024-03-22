import type { SignTx } from "@cardano-sdk/cip30";
import { Transaction } from "@emurgo/cardano-serialization-lib-asmjs";
import RefreshIcon from "@mui/icons-material/Refresh";
import { decode, encode } from "cborg";
import { useState } from "react";
import { Controller, useForm } from "react-hook-form";
import { useMutation } from "react-query";
import { toast } from "react-toastify";

import Button from "common/components/Button";
import CBOREditor from "common/components/CBOREditor";
import CheckBox from "common/components/CheckBox";
import InputBlock from "common/components/InputBlock";
import TxBuilder from "common/components/TxBuilder";
import WalletResponseSelection from "common/components/WalletResponseSelection";
import bin2hex from "common/helpers/bin2hex";
import buildUnsingedReg from "common/helpers/buildUnsingedReg";
import hex2bin from "common/helpers/hex2bin";
import type { ExtractedWalletApi, TxBuilderArguments } from "types/cardano";

type Props = {
  selectedWallets: string[];
  walletApi: Record<string, ExtractedWalletApi>;
};

type FormValues = {
  partialSign: boolean;
  tx: string;
};

function SignTxPanel({ selectedWallets, walletApi }: Props) {
  const [selectedResponseWallet, setSelectedResponseWallet] = useState("");
  const [editorRefreshSignal, setEditorRefreshSignal] = useState(0);

  const { isLoading, mutateAsync, data } = useMutation({
    onError: (err) => {
      console.log(err);
      toast.error(String(err));
    },
    mutationFn: mutateFn,
  });

  const { control, handleSubmit, setValue } = useForm<FormValues>({
    defaultValues: {
      partialSign: false,
      tx: "",
    },
  });

  async function mutateFn(args: Parameters<SignTx>): Promise<Record<string, string>> {
    const responses = await Promise.all(
      selectedWallets.map(async (wallet) => [wallet, await walletApi[wallet]?.signTx(...args)])
    );

    setSelectedResponseWallet(responses[0]?.[0] ?? "");

    return Object.fromEntries(responses);
  }

  function handleResponseWalletSelect(wallet: string) {
    setSelectedResponseWallet(wallet);
  }

  async function handleTxBuilderSubmit(builderArgs: TxBuilderArguments) {
    try {
      const lace = walletApi["lace"];

      const tx = await buildUnsingedReg({
        regAddress: builderArgs.regAddress,
        regAmount: builderArgs.regAmount,
        regLabel: builderArgs.regLabel,
        regText: builderArgs.regText,
        usedAddresses: lace.info.usedAddresses.raw,
        changeAddress: lace.info.changeAddress.raw,
        rawUtxos: lace.info.utxos.raw,
        config: builderArgs.config,
      });

      setValue("tx", bin2hex(encode(tx.to_js_value())));
      setEditorRefreshSignal((prev) => (prev ? 0 : 1));
    } catch (err) {
      return void toast.error(String(err));
    }
  }

  async function handleExecute(formValues: FormValues) {
    if (!selectedWallets.length) {
      return void toast.error("Please select at least one wallet to execute.");
    }

    const tx = Transaction.from_json(JSON.stringify(decode(hex2bin(formValues.tx))));

    console.log(tx.to_js_value());

    // await mutateAsync([cleanHex(formValues.tx), formValues.partialSign]);
  }

  return (
    <div className="grid gap-4">
      <div className="grid gap-2">
        <div className="text-sm text-black/50">
          Requests that a user sign the unsigned portions of the supplied transaction. The wallet
          should ask the user for permission, and if given, try to sign the supplied body and return
          a signed transaction. If partialSign is true, the wallet only tries to sign what it can.
          If partialSign is false and the wallet could not sign the entire transaction, TxSignError
          shall be returned with the ProofGeneration code. Likewise if the user declined in either
          case it shall return the UserDeclined code. Only the portions of the witness set that were
          signed as a result of this call are returned to encourage dApps to verify the contents
          returned by this endpoint while building the final transaction.
        </div>
        <h2 className="font-semibold">Payload:</h2>
        <InputBlock variant="inline" name="partialSign">
          <Controller
            control={control}
            name="partialSign"
            render={({ field: { value, onChange } }) => (
              <CheckBox value={value} onChange={onChange} />
            )}
          />
        </InputBlock>
        <InputBlock variant="block" name="tx">
          <Controller
            control={control}
            name="tx"
            render={({ field: { value, onChange } }) => (
              <div className="grid gap-4">
                <TxBuilder onSubmit={handleTxBuilderSubmit} />
                <CBOREditor key={editorRefreshSignal} value={value} onChange={onChange} />
              </div>
            )}
          />
        </InputBlock>
        <div className="flex">
          <div className="flex gap-2 items-center">
            <Button disabled={isLoading} onClick={handleSubmit(handleExecute)}>
              <p>Execute</p>
            </Button>
            {isLoading && <RefreshIcon className="animate-spin" />}
          </div>
          <div></div>
        </div>
      </div>
      {data && (
        <>
          <div className="h-px bg-black/10"></div>
          <div className="grid gap-2">
            <WalletResponseSelection
              selectedWallet={selectedResponseWallet}
              wallets={Object.keys(data ?? {})}
              onSelect={handleResponseWalletSelect}
            />
            <h2 className="font-semibold">Response:</h2>
            <CBOREditor value={data?.[selectedResponseWallet] ?? ""} isReadOnly={true} />
          </div>
        </>
      )}
    </div>
  );
}

export default SignTxPanel;
