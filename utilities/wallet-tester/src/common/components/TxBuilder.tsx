// cspell: words Lovelaces Coeff keyhash Keyhash scripthash Metadatum

import { TransactionUnspentOutput } from "@emurgo/cardano-serialization-lib-asmjs";
import { Disclosure } from "@headlessui/react";
import ArrowDropDownIcon from "@mui/icons-material/ArrowDropDown";
import ArrowDropUpIcon from "@mui/icons-material/ArrowDropUp";
import { capitalize, cloneDeep, noop, upperCase } from "lodash-es";
import { useState } from "react";
import { Controller, useFieldArray, useForm } from "react-hook-form";
import { twMerge } from "tailwind-merge";

import { CertificateType, MetadataValueType, type TxBuilderArguments } from "types/cardano";

import Button from "./Button";
import CBOREditor from "./CBOREditor";
import Combobox from "./Combobox";
import Dropdown from "./Dropdown";
import Input from "./Input";
import TxBuilderMultiFieldsSection from "./TxBuilderMultiFieldsSection";
import TxBuilderSingleFieldSection from "./TxBuilderSingleFieldSection";
import WalletViewSelection from "./WalletViewSelection";

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
  /* Hex UTXOs. */
  utxos: string[];
  /* Bech32 Addresses. */
  addresses: string[];
  onSubmit?: (value: FormValues) => void;
};

function TxBuilder({ utxos, addresses, onSubmit: onPropSubmit = noop }: Props) {
  const [resetSignal, setResetSignal] = useState(0);

  const { handleSubmit, register, resetField, control, reset } = useForm<FormValues>({
    defaultValues: {
      txInputs: [],
      txOutputs: [],
      certificates: [],
      requiredSigners: [],
      rewardWithdrawals: [],
      auxMetadata: {
        metadata: [],
      },
      config: cloneDeep(PROTOCOL_PARAMS),
    },
  });

  const txInputFields = useFieldArray({ control, name: "txInputs" });
  const txOutputFields = useFieldArray({ control, name: "txOutputs" });
  const certificateFields = useFieldArray({ control, name: "certificates" });
  const rewardWithdrawalFields = useFieldArray({ control, name: "rewardWithdrawals" });
  const requiredSignerFields = useFieldArray({ control, name: "requiredSigners" });
  const metadataFields = useFieldArray({ control, name: "auxMetadata.metadata" });

  function handleReset() {
    reset();
    setResetSignal((prev) => (prev ? 0 : 1));
  }

  async function onSubmit(formValues: FormValues) {
    onPropSubmit(formValues);
  }

  function formatUtxoAmount(utxoHex: string): string {
    try {
      const json = TransactionUnspentOutput.from_hex(utxoHex).to_js_value();

      return String(json.output.amount.coin);
    } catch (error) {
      return "";
    }
  }

  return (
    <form key={resetSignal} className="grid gap-2" autoComplete="off">
      <TxBuilderMultiFieldsSection
        heading="Transaction Inputs"
        onAddClick={() => txInputFields.append({ hex: "" })}
        onRemoveClick={(i) => txInputFields.remove(i)}
        fields={txInputFields.fields}
        render={(i) => (
          <div className="grow grid grid-cols-4 gap-2">
            <Controller
              control={control}
              name={`txInputs.${i}.hex`}
              render={({ field: { value, onChange } }) => (
                <>
                  <div className="col-span-3">
                    <Combobox
                      value={value}
                      label={`UTXO Hex #${i + 1}`}
                      items={utxos.map((v) => ({
                        label: v,
                        value: v,
                      }))}
                      onInput={onChange}
                      onSelect={onChange}
                    />
                  </div>
                  <Input
                    type="number"
                    disabled={true}
                    value={formatUtxoAmount(value)}
                    label={`Amount #${i + 1}`}
                  />
                </>
              )}
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
              <Controller
                control={control}
                name={`txOutputs.${i}.address`}
                render={({ field: { value, onChange } }) => (
                  <Combobox
                    value={value}
                    label={`Address #${i + 1}`}
                    items={addresses.map((v) => ({
                      label: v,
                      value: v,
                    }))}
                    onInput={onChange}
                    onSelect={onChange}
                  />
                )}
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
            network: "",
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
                    type: value as any /* TODO: support default values for each type */,
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
                      (certificateFields.fields[i] as any)?.hashType === "addr_keyhash" &&
                      "bg-black text-white"
                    )}
                    onClick={() =>
                      certificateFields.update(i, {
                        ...certificateFields.fields[i]!,
                        hashType: "addr_keyhash",
                      } as any)
                    }
                  >
                    <p className="text-[10px]">addr_keyhash</p>
                  </button>
                  <button
                    type="button"
                    className={twMerge(
                      "w-full rounded px-1 border border-solid border-black",
                      (certificateFields.fields[i] as any)?.hashType === "scripthash" &&
                      "bg-black text-white"
                    )}
                    onClick={() =>
                      certificateFields.update(i, {
                        ...certificateFields.fields[i]!,
                        hashType: "scripthash",
                      } as any)
                    }
                  >
                    <p className="text-[10px]">scripthash</p>
                  </button>
                </div>
                <div className="grow grid grid-cols-2 gap-2">
                  <Input
                    type="text"
                    label={`Hash #${i + 1}`}
                    minLength={56}
                    maxLength={56}
                    formRegister={register(`certificates.${i}.hash`, { required: true })}
                  />
                  <Input
                    type="text"
                    label={`Pool Keyhash #${i + 1}`}
                    minLength={56}
                    maxLength={56}
                    formRegister={register(`certificates.${i}.poolKeyhash`, { required: true })}
                  />
                </div>
              </div>
            ) : null}
          </div>
        )}
      />
      <TxBuilderMultiFieldsSection
        heading="Reward Withdrawals"
        onAddClick={() => rewardWithdrawalFields.append({ address: "", value: "", network: "" })}
        onRemoveClick={(i) => rewardWithdrawalFields.remove(i)}
        fields={rewardWithdrawalFields.fields}
        render={(i) => (
          <div className="grow grid grid-cols-5 gap-2">
            <div className="col-span-3">
              <Controller
                control={control}
                name={`rewardWithdrawals.${i}.address`}
                render={({ field: { value, onChange } }) => (
                  <Combobox
                    value={value}
                    label={`Address #${i + 1}`}
                    items={addresses.map((v) => ({
                      label: v,
                      value: v,
                    }))}
                    onInput={onChange}
                    onSelect={onChange}
                  />
                )}
              />
            </div>
            <Input
              type="number"
              label={`Coin #${i + 1}`}
              formRegister={register(`rewardWithdrawals.${i}.value`)}
            />
            <Input
              type="number"
              label={`Net. #${i + 1}`}
              formRegister={register(`rewardWithdrawals.${i}.network`)}
            />
          </div>
        )}
      />
      <TxBuilderSingleFieldSection
        heading="Auxiliary Data Hash"
        onRemoveClick={() => resetField("auxiliaryDataHash")}
        render={() => (
          <Input
            type="text"
            label="Auxiliary Data Hash"
            placeholder="Auto generated"
            disabled={true}
            formRegister={register("auxiliaryDataHash")}
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
            <Controller
              control={control}
              name={`requiredSigners.${i}.address`}
              render={({ field: { value, onChange } }) => (
                <Combobox
                  value={value}
                  label={`Signer Address #${i + 1}`}
                  items={addresses.map((v) => ({
                    label: v,
                    value: v,
                  }))}
                  onInput={onChange}
                  onSelect={onChange}
                />
              )}
            />
          </div>
        )}
      />
      <TxBuilderSingleFieldSection
        heading="Network ID"
        onRemoveClick={() => resetField("networkId")}
        render={() => (
          <Input
            type="number"
            min={0}
            max={1}
            placeholder="0: testnet, 1: mainnet"
            label="Network ID"
            formRegister={register("networkId")}
          />
        )}
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
              <p>Auxiliary Metadata</p>
            </>
          )}
        </Disclosure.Button>
        <Disclosure.Panel className="grid gap-2">
          <TxBuilderMultiFieldsSection
            heading="Transaction Metadata"
            onAddClick={() =>
              metadataFields.append({ key: "", valueType: MetadataValueType.Text, value: "" })
            }
            onRemoveClick={(i) => metadataFields.remove(i)}
            fields={metadataFields.fields}
            render={(i) => (
              <div className="grow grid gap-4">
                <Controller
                  control={control}
                  name={`auxMetadata.metadata.${i}`}
                  render={({ field: { value, onChange } }) => (
                    <>
                      <WalletViewSelection
                        selectedWallet={value.valueType}
                        wallets={Object.values(MetadataValueType).filter(
                          (x) => ![MetadataValueType.List, MetadataValueType.Map].includes(x)
                        )}
                        onSelect={(valueType) => onChange({ ...value, valueType, value: "" })}
                      />
                      <div
                        className={twMerge(
                          "grid gap-2",
                          value.valueType !== MetadataValueType.Cbor && "grid-cols-2"
                        )}
                      >
                        <Input
                          type="number"
                          min={0}
                          label={`Label #${i + 1}`}
                          formRegister={register(`auxMetadata.metadata.${i}.key`)}
                        />
                        {value.valueType === MetadataValueType.Cbor ? (
                          <CBOREditor
                            value={value.value}
                            onChange={(val) => onChange({ ...value, value: val })}
                          />
                        ) : (
                          <Input
                            type="text"
                            label={`Metadatum #${i + 1}`}
                            value={value.value}
                            onChange={(e) => onChange({ ...value, value: e.target.value })}
                          />
                        )}
                      </div>
                    </>
                  )}
                />
              </div>
            )}
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
