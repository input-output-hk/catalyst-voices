import RefreshIcon from "@mui/icons-material/Refresh";
import { compact, isEmpty, pickBy, uniq } from "lodash-es";
import { Fragment, useState } from "react";
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
import cleanHex from "common/helpers/cleanHex";
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
  walletTx: Record<string, string>;
};

function SignTxPanel({ selectedWallets, walletApi }: Props) {
  const [isLoading, setIsLoading] = useState(false);
  const [response, setResponse] = useState<Response>({});
  const [selectedTxWallet, setSelectedTxWallet] = useState("");
  const [selectedResponseWallet, setSelectedResponseWallet] = useState("");
  const [editorRefreshSignal, setEditorRefreshSignal] = useState(0);

  const { control, handleSubmit, setValue } = useForm<FormValues>({
    defaultValues: {
      partialSign: false,
      walletTx: {},
    },
  });

  const selectedWalletApi = pickBy(walletApi, (v, k) => selectedWallets.includes(k));
  const utxos = uniq([...Object.values(walletApi).flatMap((api) => api.info["utxos"]?.raw ?? [])]);
  const addresses = uniq([
    ...Object.values(walletApi).flatMap((api) => api.info["usedAddresses"]?.value ?? []),
    ...Object.values(walletApi).flatMap((api) => api.info["unusedAddresses"]?.value ?? []),
    ...Object.values(walletApi).flatMap((api) => compact([api.info["changeAddress"]?.value])),
    ...Object.values(walletApi).flatMap((api) =>
      compact(api.info["utxos"]?.value?.map?.((x: any) => x?.["output"]?.["address"] ?? null) ?? [])
    ),
    ...Object.values(walletApi).flatMap((api) =>
      compact(
        api.info["collateral"]?.value?.map?.((x: any) => x?.["output"]?.["address"] ?? null) ?? []
      )
    ),
  ]);

  async function handleTxBuilderSubmit(builderArgs: TxBuilderArguments) {
    try {
      const activeWallets = pickBy(walletApi, (v, k) => selectedWallets.includes(k));

      const resTx: FormValues["walletTx"] = {};
      for (const walletName of Object.keys(activeWallets)) {
        const tmpChange = walletApi[walletName]?.info["changeAddress"]?.raw;

        const tx = await buildUnsignedTx(builderArgs, tmpChange);

        resTx[walletName] = bin2hex(tx.to_bytes());
      }

      setValue("walletTx", resTx);
      setEditorRefreshSignal((prev) => (prev ? 0 : 1));
      setSelectedTxWallet((prev) => prev || (Object.keys(activeWallets)[0] ?? ""));
    } catch (err) {
      return void toast.error(String(err));
    }
  }

  async function handleExecute(formValues: FormValues) {
    setIsLoading(true);

    const activeApi = Object.entries(walletApi).filter(([w]) => selectedWallets.includes(w));

    const response: Response = {};
    for (const [walletName] of activeApi) {
      if (!walletName) {
        continue;
      }

      try {
        const res = await walletApi[walletName]?.signTx(
          cleanHex(formValues.walletTx[walletName] ?? ""),
          formValues.partialSign
        );

        response[walletName] = {
          isError: !res,
          data: String(res),
        };
      } catch (err) {
        response[walletName] = {
          isError: true,
          data: String(err),
        };
      }
    }

    setResponse(response);
    setSelectedResponseWallet(Object.keys(response)[0] ?? "");
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
            name="walletTx"
            render={({ field: { value, onChange } }) => (
              <div className="grid gap-2">
                {/* TODO: add empty */}
                <TxBuilder utxos={utxos} addresses={addresses} onSubmit={handleTxBuilderSubmit} />
                {isEmpty(selectedWalletApi) ? (
                  <Badge variant="warn" text="Enable at least one wallet to execute" />
                ) : (
                  <>
                    <WalletViewSelection
                      selectedWallet={selectedTxWallet}
                      wallets={Object.keys(selectedWalletApi)}
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
                )}
              </div>
            )}
          />
        </InputBlock>
        {!isEmpty(selectedWalletApi) && (
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
