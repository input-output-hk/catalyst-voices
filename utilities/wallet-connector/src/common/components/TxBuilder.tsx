import { Disclosure } from "@headlessui/react";
import ArrowDropDownIcon from "@mui/icons-material/ArrowDropDown";
import ArrowDropUpIcon from "@mui/icons-material/ArrowDropUp";
import { cloneDeep, noop } from "lodash-es";
import { useForm } from "react-hook-form";

import type { TxBuilderArguments } from "types/cardano";

import Button from "./Button";
import Input from "./Input";

const PROTOCOL_PARAMS = {
  linearFee: {
    minFeeA: "44",
    minFeeB: "155381",
  },
  minUtxo: "34482",
  poolDeposit: "500000000",
  keyDeposit: "2000000",
  maxValSize: 5000,
  maxTxSize: 16384,
  priceMem: 0.0577,
  priceStep: 0.0000721,
  coinsPerUtxoWord: "34482",
} as const;

type FormValues = TxBuilderArguments;

type Props = {
  onSubmit?: (value: FormValues) => void;
};

function TxBuilder({ onSubmit: onPropSubmit = noop }: Props) {
  const { handleSubmit, register, reset } = useForm<FormValues>({
    defaultValues: {
      regAddress: "",
      regAmount: "",
      regText: "",
      regLabel: "",
      stakeCred: "",
      config: cloneDeep(PROTOCOL_PARAMS)
    },
  });

  function handleReset() {
    reset();
  }

  async function onSubmit(formValues: FormValues) {
    onPropSubmit(formValues);
  }

  return (
    <form className="grid gap-2" autoComplete="off">
      <Input
        type="text"
        label="Registration address"
        formRegister={register("regAddress", { required: true })}
      />
      <Input
        type="number"
        label="Registration amount"
        formRegister={register("regAmount", { required: true })}
      />
      <Input
        type="number"
        label="Registration label"
        formRegister={register("regLabel", { required: true })}
      />
      <Input
        type="text"
        label="Registration text"
        formRegister={register("regText", { required: true })}
      />
      <Disclosure>
        <Disclosure.Button className="flex gap-2 items-center text-left text-sm font-semibold">
          {({ open }) => (
            <>
              <div className="w-[16px]">
                {open ? <ArrowDropUpIcon /> : <ArrowDropDownIcon />}
              </div>
              <p>Advanced Configs</p>
            </>
          )}
        </Disclosure.Button>
        <Disclosure.Panel className="grid gap-2 grid-cols-2">
          <div className="grid gap-2 grid-cols-2">
            <Input
              type="number"
              label="Linear Fee Coeff."
              formRegister={register("config.linearFee.minFeeA")}
            />
            <Input
              type="number"
              label="Linear Fee Constant"
              formRegister={register("config.linearFee.minFeeB")}
            />
          </div>
          <Input
            type="number"
            label="Coins per UTXO word"
            formRegister={register("config.coinsPerUtxoWord")}
          />
          <Input
            type="number"
            label="Pool Deposit"
            formRegister={register("config.poolDeposit")}
          />
          <Input
            type="number"
            label="Key Deposit"
            formRegister={register("config.keyDeposit")}
          />
          <Input
            type="number"
            label="Max value size"
            formRegister={register("config.maxValSize", { valueAsNumber: true })}
          />
          <Input
            type="number"
            label="Max transaction size"
            formRegister={register("config.maxTxSize", { valueAsNumber: true })}
          />
        </Disclosure.Panel>
      </Disclosure>
      <div className="flex gap-2">
        <Button className="w-fit" onClick={handleSubmit(onSubmit)}>
          <p>Build</p>
        </Button>
        <Button className="w-fit" onClick={handleReset}>
          <p>Clear</p>
        </Button>
      </div>
    </form>
  );
}

export default TxBuilder;
