import { Address, AuxiliaryData, BigNum, Ed25519KeyHash, GeneralTransactionMetadata, Transaction, TransactionBuilder, TransactionMetadatum, TransactionOutput, TransactionWitnessSet, Value } from "@emurgo/cardano-serialization-lib-asmjs";
import { useForm } from "react-hook-form";

import { BASE_INPUT_STYLE } from "common/constants";

type FormValues = {
  regAddress: string;
  regAmount: string;
  regText: string;
  regLabel: string;
  stakeCred: string;
};

type Props = {

};

function TxBuilder({ }: Props) {
  const { handleSubmit, register } = useForm<FormValues>({
    defaultValues: {

    }
  });

  async function buildTx(formValues: FormValues) {
    // Initialize builder with protocol parameters
    const txBuilder = new TransactionBuilder();

    // Set address to send ada to
    const registrationAddress = Address.from_bech32(formValues.regAddress);
    // Set amount to send
    const registrationAmount = Value.new(BigNum.from_str(formValues.regAmount));

    // Set transactional metadatum message
    const regMessageMetadatum = TransactionMetadatum.new_text(formValues.regText);
    const regMessageMetadatumLabel = BigNum.from_str(formValues.regLabel);

    // Create Tx metadata object and parse into auxiliary data
    const txMetadata = (GeneralTransactionMetadata.new());
    txMetadata.insert(regMessageMetadatumLabel, regMessageMetadatum);
    const auxMetadata = AuxiliaryData.new();
    auxMetadata.set_metadata(txMetadata);

    // Add metadatum to transaction builder, so it can be included in the transaction balancing
    txBuilder.set_auxiliary_data(auxMetadata);

    // Add extra signature witness to transaction builder
    txBuilder.add_required_signer(Ed25519KeyHash.from_hex(formValues.stakeCred));

    // Add outputs to the transaction builder
    txBuilder.add_output(
      TransactionOutput.new(
        registrationAddress,
        registrationAmount
      ),
    );

    // Find the available UTxOs in the wallet and use them as Inputs for the transaction
    const txUnspentOutputs = await this.getTxUnspentOutputs();
    // Use UTxO selection strategy RandomImproveMultiAsset aka 3
    txBuilder.add_inputs_from(txUnspentOutputs, 3);

    // Set change address, incase too much ADA provided for fee
    const shelleyChangeAddress = Address.from_bech32(this.state.changeAddress);
    txBuilder.add_change_if_needed(shelleyChangeAddress);

    // Make a full transaction, passing in empty witness set
    const txBody = txBuilder.build();
    const transactionWitnessSet = TransactionWitnessSet.new();
    const tx = Transaction.new(
        txBody,
        TransactionWitnessSet.from_bytes(transactionWitnessSet.to_bytes()),
        auxMetadata
    );

    // console.log("UnsignedTx: ", Buffer.from(tx.to_bytes(), "utf8").toString("hex"))
  }

  async function onSubmit(formValues: FormValues) {

  }

  return (
    <form className="grid gap-2" onSubmit={handleSubmit(onSubmit)}>
      <input
        className={BASE_INPUT_STYLE}
        type="text"
        placeholder="registration address"
        {...register("regAddress")}
      />
      <input
        className={BASE_INPUT_STYLE}
        type="text"
        placeholder="registration amount"
        {...register("regAmount")}
      />
      <input
        className={BASE_INPUT_STYLE}
        type="text"
        placeholder="registration text"
        {...register("regText")}
      />
      <input
        className={BASE_INPUT_STYLE}
        type="text"
        placeholder="registration label"
        {...register("regLabel")}
      />
    </form>
  );
}

export default TxBuilder;