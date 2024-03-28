// cspell: words Lovelaces Coeff

import { Disclosure } from "@headlessui/react";
import ArrowDropDownIcon from "@mui/icons-material/ArrowDropDown";
import ArrowDropUpIcon from "@mui/icons-material/ArrowDropUp";
import { capitalize, cloneDeep, noop, upperCase } from "lodash-es";
import { useFieldArray, useForm } from "react-hook-form";
import { twMerge } from "tailwind-merge";

import { CertificateType, type TxBuilderArguments } from "types/cardano";

import Button from "./Button";
import Dropdown from "./Dropdown";
import Input from "./Input";
import TxBuilderMultiFieldsSection from "./TxBuilderMultiFieldsSection";
import TxBuilderSingleFieldSection from "./TxBuilderSingleFieldSection";

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
  txIds: string[];
  addrs: string[];
  onSubmit?: (value: FormValues) => void;
};

function TxBuilder({ txIds, addrs, onSubmit: onPropSubmit = noop }: Props) {
  const { handleSubmit, register, resetField, control, reset } = useForm<FormValues>({
    defaultValues: {
      txInputs: [],
      txOutputs: [], 
      config: cloneDeep(PROTOCOL_PARAMS),
    },
  });

  const txInputFields = useFieldArray({ control, name: "txInputs" });
  const txOutputFields = useFieldArray({ control, name: "txOutputs" });
  const certificateFields = useFieldArray({ control, name: "certificates" });
  const rewardWithdrawalFields = useFieldArray({ control, name: "rewardWithdrawals" });
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
        onAddClick={() => txInputFields.append({ hex: "" })}
        onRemoveClick={(i) => txInputFields.remove(i)}
        fields={txInputFields.fields}
        render={(i) => (
          <div className="grow grid gap-2">
            <Input
              type="text"
              label={`UTXO Hex #${i + 1}`}
              minLength={32}
              maxLength={32}
              formRegister={register(`txInputs.${i}.hex`)}
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
          <div className="grow grid grid-cols-4 gap-2">
            <div className="col-span-3">
              <Input
                type="text"
                label={`Address #${i + 1}`}
                formRegister={register(`txOutputs.${i}.address`)}
              />
            </div>
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
        onRemoveClick={() => resetField("txFee")}
        render={() => (
          <Input type="text" label="Transaction Fee" formRegister={register("txFee")} />
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
            type: CertificateType.StakeDelegation,
            hashType: "addr_keyhash",
            hash: "",
            poolKeyhash: "",
          })
        }
        onRemoveClick={(i) => certificateFields.remove(i)}
        fields={certificateFields.fields}
        render={(i) => (
          <div className="grow grid gap-2 grid-cols-[168px_1fr]">
            <Dropdown
              value={certificateFields.fields[i]?.type ?? ""}
              items={Object.entries(CertificateType).map(([key, value]) => ({
                value: value,
                label: capitalize(upperCase(key)),
                // TODO: add more type support
                disabled: value !== CertificateType.StakeDelegation,
              }))}
              onSelect={(value) =>
                certificateFields.fields[i]?.type === value
                  ? null
                  : certificateFields.replace({
                    type: value /* TODO: support default values for each type */,
                  })
              }
            />
            {certificateFields.fields[i]?.type === CertificateType.StakeDelegation ? (
              <div className="grow flex gap-2">
                <div className="flex flex-col items-center justify-evenly gap-1">
                  <button
                    type="button"
                    className={twMerge(
                      "w-full rounded px-1 border border-solid border-black",
                      certificateFields.fields[i]?.hashType === "addr_keyhash" &&
                      "bg-black text-white"
                    )}
                    onClick={() =>
                      certificateFields.update(i, {
                        ...certificateFields.fields[i]!,
                        hashType: "addr_keyhash",
                      })
                    }
                  >
                    <p className="text-[10px]">addr_keyhash</p>
                  </button>
                  <button
                    type="button"
                    className={twMerge(
                      "w-full rounded px-1 border border-solid border-black",
                      certificateFields.fields[i]?.hashType === "scripthash" &&
                      "bg-black text-white"
                    )}
                    onClick={() =>
                      certificateFields.update(i, {
                        ...certificateFields.fields[i]!,
                        hashType: "scripthash",
                      })
                    }
                  >
                    <p className="text-[10px]">scripthash</p>
                  </button>
                </div>
                <div className="grow grid grid-cols-2 gap-2">
                  <Input
                    type="text"
                    label={`Hash #${i + 1}`}
                    minLength={28}
                    maxLength={28}
                    formRegister={register(`certificates.${i}.hash`)}
                  />
                  <Input
                    type="text"
                    label={`Pool Keyhash #${i + 1}`}
                    minLength={28}
                    maxLength={28}
                    formRegister={register(`certificates.${i}.poolKeyhash`)}
                  />
                </div>
              </div>
            ) : null}
          </div>
        )}
      />
      <TxBuilderMultiFieldsSection
        heading="Reward Withdrawals"
        onAddClick={() => rewardWithdrawalFields.append({ address: "", value: "" })}
        onRemoveClick={(i) => rewardWithdrawalFields.remove(i)}
        fields={rewardWithdrawalFields.fields}
        render={(i) => (
          <div className="grow grid grid-cols-4 gap-2">
            <div className="col-span-3">
              <Input
                type="text"
                label={`Address #${i + 1}`}
                formRegister={register(`rewardWithdrawals.${i}.address`)}
              />
            </div>
            <Input
              type="number"
              label={`Coin #${i + 1}`}
              formRegister={register(`rewardWithdrawals.${i}.value`)}
            />
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
        onAddClick={() => requiredSignerFields.append({ address: "" })}
        onRemoveClick={(i) => requiredSignerFields.remove(i)}
        fields={requiredSignerFields.fields}
        render={(i) => (
          <div className="grow grid gap-2">
            <Input
              type="text"
              label={`Required Signers #${i + 1}`}
              formRegister={register(`requiredSigners.${i}.address`)}
            />
          </div>
        )}
      />
      <TxBuilderSingleFieldSection
        heading="Network ID"
        onRemoveClick={() => resetField("networkId")}
        render={() => <Input type="text" label="Network ID" formRegister={register("networkId")} />}
      />
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
      <Disclosure>
        <Disclosure.Button className="flex gap-2 items-center text-left text-sm font-semibold">
          {({ open }) => (
            <>
              <div className="w-[16px]">{open ? <ArrowDropUpIcon /> : <ArrowDropDownIcon />}</div>
              <p>Auxillary Metadata</p>
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
