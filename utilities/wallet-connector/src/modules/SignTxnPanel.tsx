import type { SignTx } from '@cardano-sdk/cip30';
import RefreshIcon from '@mui/icons-material/Refresh';
import cleanHex from 'common/helpers/cleanHex';
import Button from "components/Button";
import CBOREditor from "components/CBOREditor";
import CheckBox from "components/CheckBox";
import InputBlock from "components/InputBlock";
import WalletResponseSelection from 'components/WalletResponseSelection';
import { useState } from 'react';
import { Controller, useForm } from "react-hook-form";
import { useMutation } from "react-query";
import { toast } from 'react-toastify';
import type { ExtractedWalletApi } from 'types/cardano';

type Props = {
  selectedWallets: string[];
  walletApis: Record<string, ExtractedWalletApi>;
}

type FormValues = {
  partialSign: boolean;
  tx: string;
}

function SignTxnPanel({
  selectedWallets,
  walletApis
}: Props) {
  const [selectedResponseWallet, setSelectedResponseWallet] = useState("");

  const { isLoading, mutateAsync, data } = useMutation({
    onError: (err) => void toast.error(String(err)),
    mutationFn: mutateFn
  });

  const payloadForm = useForm<FormValues>({
    defaultValues: {
      partialSign: false,
      tx: ""
    }
  });

  async function mutateFn(args: Parameters<SignTx>): Promise<Record<string, string>> {
    const responses = await Promise.all(selectedWallets.map(async (wallet) => [
      wallet,
      await walletApis[wallet]?.signTx(...args)
    ]));

    setSelectedResponseWallet(responses[0]?.[0] ?? "");

    return Object.fromEntries(responses);
  }

  function handleResponseWalletSelect(wallet: string) {
    setSelectedResponseWallet(wallet);
  }

  async function handleExecute(formValues: FormValues) {
    if (!selectedWallets.length) {
      return toast.error("Please select at least one wallet to execute.")
    }

    await mutateAsync([cleanHex(formValues.tx), formValues.partialSign]);
  }

  return (
    <div className="grid gap-4">
      <div className="grid gap-2">
        <div className="text-sm text-black/50">
          Requests that a user sign the unsigned portions of the supplied transaction.
          The wallet should ask the user for permission, and if given, try to sign the supplied body and return a signed transaction.
          If partialSign is true, the wallet only tries to sign what it can.
          If partialSign is false and the wallet could not sign the entire transaction, TxSignError shall be returned with the ProofGeneration code.
          Likewise if the user declined in either case it shall return the UserDeclined code.
          Only the portions of the witness set that were signed as a result of this call are returned to encourage dApps to verify the contents returned by this endpoint while building the final transaction.
        </div>
        <h2 className="font-semibold">Payload:</h2>
        <InputBlock variant="inline" name="partialSign">
          <Controller
            control={payloadForm.control}
            name="partialSign"
            render={({ field: { value, onChange } }) => (
              <CheckBox value={value} onChange={onChange} />
            )}
          />
        </InputBlock>
        <InputBlock variant="block" name="tx">
          <Controller
            control={payloadForm.control}
            name="tx"
            render={({ field: { value, onChange } }) => (
              <CBOREditor value={value} onChange={onChange} />
            )}
          />
        </InputBlock>
        <div className="flex">
          <div className="flex gap-2 items-center">
            <Button disabled={isLoading} onClick={payloadForm.handleSubmit(handleExecute)}>
              <p>Execute</p>
            </Button>
            {isLoading && <RefreshIcon className="animate-spin" />}
          </div>
          <div>

          </div>
        </div>
      </div>
      {true && (
        <>
          <div className="h-px bg-black/10"></div>
          <div className="grid gap-2">
            <WalletResponseSelection
              selectedWallet={selectedResponseWallet}
              wallets={Object.keys(data ?? {})}
              onSelect={handleResponseWalletSelect}
            />
            <h2 className="font-semibold">Response:</h2>
            <CBOREditor
              value={data?.[selectedResponseWallet] ?? ""}
              isReadOnly={true}
            />
          </div>
        </>
      )}
    </div>
  )
}

export default SignTxnPanel;