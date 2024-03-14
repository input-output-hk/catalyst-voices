import InputIcon from "@mui/icons-material/Input";
import Button from "components/Button";
import CBOREditor from "components/CBOREditor";
import CheckBox from "components/CheckBox";
import InputBlock from "components/InputBlock";
import { Controller, useForm } from "react-hook-form";

type Props = {

}

type FormValues = {
  partialSign: boolean;
  tx: string;
}

function SignTxnPanel({ }: Props) {
  const payloadForm = useForm<FormValues>({
    defaultValues: {
      partialSign: false,
      tx: ""
    }
  });

  function handleExecute() {

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
          <Button onClick={handleExecute}>
            <p>Execute</p>
          </Button>
        </div>
      </div>
      <div className="grid gap-2">

      </div>
    </div>
  )
}

export default SignTxnPanel;