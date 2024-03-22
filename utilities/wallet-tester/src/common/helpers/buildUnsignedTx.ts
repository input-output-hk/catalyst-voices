// cspell: words Metadatum metadatum keyhash

import {
  Address,
  AuxiliaryData,
  BaseAddress,
  BigNum,
  Ed25519KeyHash,
  GeneralTransactionMetadata,
  LinearFee,
  Transaction,
  TransactionBuilder,
  TransactionBuilderConfigBuilder,
  TransactionMetadatum,
  TransactionOutput,
  TransactionUnspentOutput,
  TransactionUnspentOutputs,
  TransactionWitnessSet,
  Value,
} from "@emurgo/cardano-serialization-lib-asmjs";

import type { TxBuilderArguments } from "types/cardano";

type Payload = {
  /** Raw registration address in hex string. */
  regAddress: string;
  /** String number in lovelace unit. */
  regAmount: string;
  /** Transaction metadatum text, e.g., Cardano Wallet Tester. */
  regText: string;
  /** Transaction metadatum label, e.g., 98117105100108. */
  regLabel: string;
  /** Raw hex string address from `API.getUsedAddresses()`. */
  usedAddresses: string[];
  /** Raw hex string address from `API.getChangeAddress()`. */
  changeAddress: string;
  /** Raw hex string UTXOs directed from calling `API.getUtxos()`. */
  rawUtxos: string[];
  /** Transaction config */
  config: TxBuilderArguments["config"];
};

export default async function buildUnsignedTx(payload: Payload): Promise<Transaction> {
  // Initialize builder with protocol parameters
  const txBuilder = TransactionBuilder.new(
    TransactionBuilderConfigBuilder.new()
      .fee_algo(
        LinearFee.new(
          BigNum.from_str(payload.config.linearFee.minFeeA),
          BigNum.from_str(payload.config.linearFee.minFeeB)
        )
      )
      .pool_deposit(BigNum.from_str(payload.config.poolDeposit))
      .key_deposit(BigNum.from_str(payload.config.keyDeposit))
      .coins_per_utxo_word(BigNum.from_str(payload.config.coinsPerUtxoWord))
      .max_value_size(payload.config.maxValSize)
      .max_tx_size(payload.config.maxTxSize)
      .prefer_pure_change(true)
      .build()
  );

  // Set address to send ada to
  const registrationAddress = Address.from_bech32(payload.regAddress);

  // Set amount to send
  const registrationAmount = Value.new(BigNum.from_str(payload.regAmount));

  // Set transactional metadatum message
  const regMessageMetadatum = TransactionMetadatum.new_text(payload.regText);
  const regMessageMetadatumLabel = BigNum.from_str(payload.regLabel);

  // Create Tx metadata object and parse into auxiliary data
  const txMetadata = GeneralTransactionMetadata.new();
  txMetadata.insert(regMessageMetadatumLabel, regMessageMetadatum);
  const auxMetadata = AuxiliaryData.new();
  auxMetadata.set_metadata(txMetadata);

  // Add metadatum to transaction builder, so it can be included in the transaction balancing
  txBuilder.set_auxiliary_data(auxMetadata);

  // Add extra signature witness to transaction builder
  if (!payload.usedAddresses[0]) {
    throw new Error("cannot find any used address");
  }

  const stakeCred = BaseAddress.from_address(Address.from_hex(payload.usedAddresses[0]))
    ?.stake_cred()
    .to_keyhash()
    ?.to_hex();

  if (!stakeCred) {
    throw new Error("cannot create a stake credential");
  }

  txBuilder.add_required_signer(Ed25519KeyHash.from_hex(stakeCred));

  // Add outputs to the transaction builder
  txBuilder.add_output(TransactionOutput.new(registrationAddress, registrationAmount));

  // Find the available UTxOs in the wallet and use them as Inputs for the transaction
  const txUnspentOutputs = payload.rawUtxos.reduce((acc, utxo) => {
    acc.add(TransactionUnspentOutput.from_hex(utxo));
    return acc;
  }, TransactionUnspentOutputs.new());
  // Use UTxO selection strategy RandomImproveMultiAsset aka 3
  txBuilder.add_inputs_from(txUnspentOutputs, 3);

  // Set change address, incase too much ADA provided for fee
  const shelleyChangeAddress = Address.from_hex(payload.changeAddress);
  txBuilder.add_change_if_needed(shelleyChangeAddress);

  // Make a full transaction, passing in empty witness set
  const txBody = txBuilder.build();
  const transactionWitnessSet = TransactionWitnessSet.new();
  const unsignedTx = Transaction.new(
    txBody,
    TransactionWitnessSet.from_bytes(transactionWitnessSet.to_bytes()),
    auxMetadata
  );

  return unsignedTx;
}
