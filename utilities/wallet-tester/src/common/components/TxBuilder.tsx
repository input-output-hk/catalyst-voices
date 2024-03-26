// cspell: words Lovelaces Coeff

import { Disclosure } from "@headlessui/react";
import ArrowDropDownIcon from "@mui/icons-material/ArrowDropDown";
import ArrowDropUpIcon from "@mui/icons-material/ArrowDropUp";
import { cloneDeep, noop } from "lodash-es";
import { useFieldArray, useForm } from "react-hook-form";

import { CertificateType, type TxBuilderArguments } from "types/cardano";

import Button from "./Button";
import Input from "./Input";
import TxBuilderMultiFieldsSection from "./TxBuilderMultiFieldsSection";
import TxBuilderSingleFieldSection from "./TxBuilderSingleFieldSection";
import Dropdown from "./Dropdown";

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
  const { handleSubmit, register, resetField, control, reset } = useForm<FormValues>({
    defaultValues: {
      txInputs: [],
      regAddress: "",
      regAmount: "",
      regText: "",
      regLabel: "",
      stakeCred: "",
      config: cloneDeep(PROTOCOL_PARAMS),
    },
  });

  const txInputFields = useFieldArray({ control, name: "txInputs" });
  const txOutputFields = useFieldArray({ control, name: "txOutputs" });
  const certificateFields = useFieldArray({ control, name: "certificates" });
  const requiredSignerFields = useFieldArray({ control, name: "requiredSigners" });

  function handleReset() {
    reset();
  }

  async function onSubmit(formValues: FormValues) {
    console.log(formValues);
    onPropSubmit(formValues);
  }

  return (
    <form className="grid gap-2" autoComplete="off">
      <TxBuilderMultiFieldsSection
        heading="Transaction Inputs"
        onAddClick={() => txInputFields.append({ hash: "", id: "" })}
        onRemoveClick={(i) => txInputFields.remove(i)}
        fields={txInputFields.fields}
        render={(i) => (
          <div className="grow grid grid-cols-2 gap-2">
            <Input
              type="text"
              label={`Hash #${i + 1}`}
              formRegister={register(`txInputs.${i}.hash`)}
            />
            <Input
              type="number"
              label={`ID #${i + 1}`}
              formRegister={register(`txInputs.${i}.id`)}
            />
          </div>
        )}
      />
      <TxBuilderMultiFieldsSection
        heading="Transaction Outputs"
        onAddClick={() => txOutputFields.append({ address: "", amount: "" })}
        onRemoveClick={(i) => txOutputFields.remove(i)}
        fields={txOutputFields.fields}
        render={(i) => (
          <div className="grow grid grid-cols-2 gap-2">
            <Input
              type="text"
              label={`Address #${i + 1}`}
              formRegister={register(`txOutputs.${i}.address`)}
            />
            <Input
              type="number"
              label={`Amount #${i + 1}`}
              formRegister={register(`txOutputs.${i}.amount`)}
            />
          </div>
        )}
      />
      <TxBuilderSingleFieldSection
        heading="Transaction Fee"
        onRemoveClick={() => resetField("transactionFee")}
        render={() => (
          <Input type="text" label="Transaction Fee" formRegister={register("transactionFee")} />
        )}
      />
      <TxBuilderSingleFieldSection
        heading="Time to Live (TTL)"
        onRemoveClick={() => resetField("timeToLive")}
        render={() => (
          <Input type="text" label="Time to Live (TTL)" formRegister={register("timeToLive")} />
        )}
      />
      <TxBuilderMultiFieldsSection
        heading="Certificates"
        onAddClick={() =>
          certificateFields.append({
            type: "stake_delegation",
            hashType: "addr_keyhash",
            hash: "",
            poolKeyhash: "",
          })
        }
        onRemoveClick={(i) => certificateFields.remove(i)}
        fields={certificateFields.fields}
        render={(i) => (
          <div className="grow flex gap-2">
            <Dropdown
              value={CertificateType.StakeDelegation}
              items={Object.values(CertificateType).map((item) => ({
                value: item,
                label: item,
              }))}
            />
            <div className="grow grid grid-cols-2 gap-2"></div>
          </div>
        )}
      />
      <TxBuilderSingleFieldSection
        heading="Auxilliary Data Hash"
        onRemoveClick={() => resetField("auxilliaryDataHash")}
        render={() => (
          <Input
            type="text"
            label="Auxilliary Data Hash"
            formRegister={register("auxilliaryDataHash")}
          />
        )}
      />
      <TxBuilderSingleFieldSection
        heading="Validity Interval Start"
        onRemoveClick={() => resetField("validityIntervalStart")}
        render={() => (
          <Input
            type="text"
            label="Validity Interval Start"
            formRegister={register("validityIntervalStart")}
          />
        )}
      />
      <TxBuilderMultiFieldsSection
        heading="Required Signers"
        onAddClick={() => requiredSignerFields.append({ hash: "" })}
        onRemoveClick={(i) => requiredSignerFields.remove(i)}
        fields={requiredSignerFields.fields}
        render={(i) => (
          <div className="grow grid grid-cols-2 gap-2">
            <Input
              type="text"
              label={`Required Signers #${i + 1}`}
              formRegister={register(`requiredSigners.${i}.hash`)}
            />
          </div>
        )}
      />
      <TxBuilderSingleFieldSection
        heading="Network ID"
        onRemoveClick={() => resetField("networkId")}
        render={() => <Input type="text" label="Network ID" formRegister={register("networkId")} />}
      />

      <div></div>
      <div></div>
      <div></div>
      <div></div>
      <div></div>
      <div></div>
      <Input
        type="text"
        label="Address where to send ADA"
        formRegister={register("regAddress", { required: true })}
      />
      <Input
        type="number"
        label="Lovelaces"
        formRegister={register("regAmount", { required: true })}
      />
      <Input type="number" label="Label" formRegister={register("regLabel", { required: true })} />
      <Input type="text" label="Text" formRegister={register("regText", { required: true })} />
      <Disclosure>
        <Disclosure.Button className="flex gap-2 items-center text-left text-sm font-semibold">
          {({ open }) => (
            <>
              <div className="w-[16px]">{open ? <ArrowDropUpIcon /> : <ArrowDropDownIcon />}</div>
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
          <Input type="number" label="Pool Deposit" formRegister={register("config.poolDeposit")} />
          <Input type="number" label="Key Deposit" formRegister={register("config.keyDeposit")} />
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
