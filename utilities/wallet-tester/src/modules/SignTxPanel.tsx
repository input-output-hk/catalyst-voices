import { Transaction, TransactionWitnessSet } from "@emurgo/cardano-serialization-lib-asmjs";
import RefreshIcon from "@mui/icons-material/Refresh";
import { decode, encode } from "cborg";
import { isEmpty } from "lodash-es";
import { Fragment, useEffect, useState } from "react";
import { Controller, useForm } from "react-hook-form";
import { toast } from "react-toastify";

import Badge from "common/components/Badge";
import Button from "common/components/Button";
import CBOREditor from "common/components/CBOREditor";
import CheckBox from "common/components/CheckBox";
import InputBlock from "common/components/InputBlock";
import TxBuilder from "common/components/TxBuilder";
import WalletViewSelection from "common/components/WalletViewSelection";
import bin2hex from "common/helpers/bin2hex";
import buildUnsignedTx from "common/helpers/buildUnsignedTx";
import hex2bin from "common/helpers/hex2bin";
import type { ExtractedWalletApi, TxBuilderArguments } from "types/cardano";

type Props = {
  selectedWallets: string[];
  walletApi: Record<string, ExtractedWalletApi>;
};

type Response = {
  [walletName: string]: {
    isError: boolean;
    data: string;
  };
};

type FormValues = {
  partialSign: boolean;
  tx: {
    [walletName: string]: string;
  };
};

function SignTxPanel({ selectedWallets, walletApi }: Props) {
  const [selectedTxWallet, setSelectedTxWallet] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const [response, setResponse] = useState<Response>({});
  const [selectedResponseWallet, setSelectedResponseWallet] = useState("");
  const [editorRefreshSignal, setEditorRefreshSignal] = useState(0);

  useEffect(() => {
    const walletNames = Object.keys(walletApi).filter((w) => selectedWallets.includes(w));

    setSelectedTxWallet((prev) => (selectedWallets.includes(prev) ? prev : walletNames[0] ?? ""));
  }, [walletApi, selectedWallets]);

  const { control, handleSubmit, setValue } = useForm<FormValues>({
    defaultValues: {
      partialSign: false,
      tx: {},
    },
  });

  async function handleTxBuilderSubmit(builderArgs: TxBuilderArguments) {
    try {
      const activeWallets = Object.entries(walletApi).filter(([w]) => selectedWallets.includes(w));

      const resTx: FormValues["tx"] = {};
      for (const [walletName, api] of activeWallets) {
        const tx = await buildUnsignedTx({
          regAddress: builderArgs.regAddress,
          regAmount: builderArgs.regAmount,
          regLabel: builderArgs.regLabel,
          regText: builderArgs.regText,
          usedAddresses: api.info["usedAddresses"]?.raw,
          changeAddress: api.info["changeAddress"]?.raw,
          rawUtxos: api.info["utxos"]?.raw,
          config: builderArgs.config,
        });

        resTx[walletName] = bin2hex(encode(tx.to_js_value()));
      }

      setValue("tx", resTx);
      setEditorRefreshSignal((prev) => (prev ? 0 : 1));
    } catch (err) {
      return void toast.error(String(err));
    }
  }

  async function handleExecute(formValues: FormValues) {
    setIsLoading(true);

    const activeTx = Object.entries(formValues.tx).filter(([w]) => selectedWallets.includes(w));

    const response: Response = {};
    for (const [walletName, cborHex] of activeTx) {
      if (!walletName) {
        continue;
      }

      const jsonTx = JSON.stringify(decode(hex2bin(cborHex)));
      const tx = Transaction.from_json(jsonTx);

      try {
        const res = await walletApi[walletName]?.signTx(tx.to_hex(), formValues.partialSign);
        const resFmt = TransactionWitnessSet.from_hex(res ?? "").to_js_value();

        response[walletName] = {
          isError: !res,
          data: bin2hex(encode(resFmt)),
        };
      } catch (err) {
        response[walletName] = {
          isError: true,
          data: String(err),
        };
      }
    }

    setResponse(response);
    setSelectedResponseWallet(Object.keys(formValues.tx)[0] ?? "");
    setIsLoading(false);
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
              <div className="grid gap-2">
                <TxBuilder onSubmit={handleTxBuilderSubmit} />
                {selectedTxWallet ? (
                  <>
                    <WalletViewSelection
                      selectedWallet={selectedTxWallet}
                      wallets={Object.keys(walletApi).filter((w) => selectedWallets.includes(w))}
                      onSelect={setSelectedTxWallet}
                    />
                    <Fragment key={selectedTxWallet}>
                      <CBOREditor
                        key={editorRefreshSignal}
                        value={value[selectedTxWallet] ?? ""}
                        onChange={(v) => onChange({ ...value, [selectedTxWallet]: v })}
                      />
                    </Fragment>
                  </>
                ) : (
                  <Badge variant="warn" text="Please enable at least one wallet." />
                )}
              </div>
            )}
          />
        </InputBlock>
        {selectedTxWallet && (
          <div className="flex">
            <div className="flex gap-2 items-center">
              <Button disabled={isLoading} onClick={handleSubmit(handleExecute)}>
                <p>Execute</p>
              </Button>
              {isLoading && <RefreshIcon className="animate-spin" />}
            </div>
          </div>
        )}
      </div>
      {!isEmpty(response) && (
        <>
          <div className="h-px bg-black/10"></div>
          <div className="grid gap-2">
            <WalletViewSelection
              selectedWallet={selectedResponseWallet}
              wallets={Object.keys(response)}
              onSelect={setSelectedResponseWallet}
            />
            <h2 className="font-semibold">Response:</h2>
            {response[selectedResponseWallet]?.isError ? (
              <Badge
                variant="error"
                text={response[selectedResponseWallet]?.data ?? "Empty response."}
              />
            ) : (
              <CBOREditor value={response[selectedResponseWallet]?.data ?? ""} isReadOnly={true} />
            )}
          </div>
        </>
      )}
    </div>
  );
}

export default SignTxPanel;
