// cspell: words Metadatum metadatum keyhash

import {
  Address,
  AuxiliaryData,
  BaseAddress,
  BigNum,
  Certificate,
  Certificates,
  Ed25519KeyHash,
  GeneralTransactionMetadata,
  LinearFee,
  RewardAddress,
  StakeCredential,
  StakeDelegation,
  Transaction,
  TransactionBuilder,
  TransactionBuilderConfigBuilder,
  TransactionMetadatum,
  TransactionOutput,
  TransactionUnspentOutput,
  TransactionUnspentOutputs,
  TransactionWitnessSet,
  Value,
  Withdrawals,
} from "@emurgo/cardano-serialization-lib-asmjs";

import { CertificateType, type TxBuilderArguments } from "types/cardano";

export default async function buildUnsignedTx(payload: TxBuilderArguments): Promise<Transaction> {
  const { config, ...builder } = payload;

  // Initialize builder with protocol parameters
  const txBuilder = TransactionBuilder.new(
    TransactionBuilderConfigBuilder.new()
      .fee_algo(
        LinearFee.new(
          BigNum.from_str(config.linearFee.minFeeA),
          BigNum.from_str(config.linearFee.minFeeB)
        )
      )
      .pool_deposit(BigNum.from_str(config.poolDeposit))
      .key_deposit(BigNum.from_str(config.keyDeposit))
      .coins_per_utxo_word(BigNum.from_str(config.coinsPerUtxoWord))
      .max_value_size(config.maxValSize)
      .max_tx_size(config.maxTxSize)
      .prefer_pure_change(true)
      .build()
  );

  // #0 add inputs
  const utxos = TransactionUnspentOutputs.new();
  for (const item of builder.txInputs.filter((x) => Boolean(x.hex))) {
    const utxo = TransactionUnspentOutput.from_hex(item.hex);
    utxos.add(utxo);
  }

  if (utxos.len()) {
    txBuilder.add_inputs_from(utxos, 3);
  }

  // #1 add outputs
  for (const item of builder.txOutputs.filter((x) => Boolean(x.address) && Boolean(x.amount))) {
    const address = Address.from_bech32(item.address);
    const amount = Value.new(BigNum.from_str(item.amount));
    txBuilder.add_output(TransactionOutput.new(address, amount));
  }

  // #2 add fee
  if (builder.txFee) {
    const val = BigNum.from_str(builder.txFee);
    txBuilder.set_fee(val);
  }

  // #3 add ttl
  if (builder.timeToLive) {
    const val = BigNum.from_str(builder.timeToLive);
    txBuilder.set_ttl_bignum(val);
  }

  // #4 add certs
  const certs = Certificates.new();
  for (const item of builder.certificates) {
    // TODO: add other types
    if (item.type === CertificateType.StakeDelegation) {
      let cred: StakeCredential;
      if (item.hashType === "addr_keyhash") {
        cred = StakeCredential.from_keyhash(Ed25519KeyHash.from_hex(item.hash));
      } else if (item.hashType === "scripthash") {
        cred = StakeCredential.from_scripthash(Ed25519KeyHash.from_hex(item.hash));
      } else {
        throw new Error("certificate hash type is not defined");
      }

      const poolKeyhash = Ed25519KeyHash.from_hex(item.poolKeyhash);
      const value = StakeDelegation.new(cred, poolKeyhash);
      const cert = Certificate.new_stake_delegation(value);
      certs.add(cert);
    } else {
      throw new Error("cannot build a certificate");
    }
  }

  if (certs.len()) {
    txBuilder.set_certs(certs);
  }

  // #5 add withdrawals
  const withdrawals = Withdrawals.new();
  for (const item of builder.rewardWithdrawals.filter(
    (x) => Boolean(x.address) && Boolean(x.value)
  )) {
    const rewardAddress = RewardAddress.from_address(Address.from_bech32(item.address));
    const value = BigNum.from_str(item.value);

    if (!rewardAddress) {
      throw new Error("cannot create an address");
    }

    withdrawals.insert(rewardAddress, value);
  }

  if (withdrawals.len()) {
    txBuilder.set_withdrawals(withdrawals);
  }

  // #14 add required signers
  for (const requiredSigner of builder.requiredSigners) {
    const stakeCred = BaseAddress.from_address(Address.from_bech32(requiredSigner.address))
      ?.stake_cred()
      .to_keyhash()
      ?.to_hex();

    if (!stakeCred) {
      throw new Error("cannot create a stake credential");
    }

    txBuilder.add_required_signer(Ed25519KeyHash.from_hex(stakeCred));
  }

  // aux data
  const auxMetadata = AuxiliaryData.new();
  const txMetadata = GeneralTransactionMetadata.new();
  for (const item of builder.auxMetadata.metadata) {
    const regMessageMetadatumLabel = BigNum.from_str(item.key);
    // TODO: support other types
    const regMessageMetadatum = TransactionMetadatum.new_text(item.value);
    txMetadata.insert(regMessageMetadatumLabel, regMessageMetadatum);
  }

  if (txMetadata.len()) {
    auxMetadata.set_metadata(txMetadata);
  }

  // build a full transaction, passing in empty witness set
  const unsignedTx = Transaction.new(txBuilder.build(), TransactionWitnessSet.new(), auxMetadata);

  return unsignedTx;
}

// type Payload = {
//   /** Raw registration address in hex string. */
//   regAddress: string;
//   /** String number in lovelace unit. */
//   regAmount: string;
//   /** Transaction metadatum text, e.g., Cardano Wallet Tester. */
//   regText: string;
//   /** Transaction metadatum label, e.g., 98117105100108. */
//   regLabel: string;
//   /** Raw hex string address from `API.getUsedAddresses()`. */
//   usedAddresses: string[];
//   /** Raw hex string address from `API.getChangeAddress()`. */
//   changeAddress: string;
//   /** Raw hex string UTXOs directed from calling `API.getUtxos()`. */
//   rawUtxos: string[];
//   /** Transaction config */
//   config: TxBuilderArguments["config"];
// };

// const tx = await buildUnsignedTx({
//   regAddress: builderArgs.regAddress,
//   regAmount: builderArgs.regAmount,
//   regLabel: builderArgs.regLabel,
//   regText: builderArgs.regText,
//   usedAddresses: api.info["usedAddresses"]?.raw,
//   changeAddress: api.info["changeAddress"]?.raw,
//   rawUtxos: api.info["utxos"]?.raw,
//   config: builderArgs.config,
// });

// export default async function buildUnsignedTx(payload: Payload): Promise<Transaction> {
//   // Initialize builder with protocol parameters
//   const txBuilder = TransactionBuilder.new(
//     TransactionBuilderConfigBuilder.new()
//       .fee_algo(
//         LinearFee.new(
//           BigNum.from_str(payload.config.linearFee.minFeeA),
//           BigNum.from_str(payload.config.linearFee.minFeeB)
//         )
//       )
//       .pool_deposit(BigNum.from_str(payload.config.poolDeposit))
//       .key_deposit(BigNum.from_str(payload.config.keyDeposit))
//       .coins_per_utxo_word(BigNum.from_str(payload.config.coinsPerUtxoWord))
//       .max_value_size(payload.config.maxValSize)
//       .max_tx_size(payload.config.maxTxSize)
//       .prefer_pure_change(true)
//       .build()
//   );

//   // Set address to send ada to
//   const registrationAddress = Address.from_bech32(payload.regAddress);

//   // Set amount to send
//   const registrationAmount = Value.new(BigNum.from_str(payload.regAmount));

//   // Set transactional metadatum message
//   const regMessageMetadatumLabel = BigNum.from_str(payload.regLabel);
//   const regMessageMetadatum = TransactionMetadatum.new_text(payload.regText);

//   // Create Tx metadata object and parse into auxiliary data
//   const txMetadata = GeneralTransactionMetadata.new();
//   txMetadata.insert(regMessageMetadatumLabel, regMessageMetadatum);
//   const auxMetadata = AuxiliaryData.new();
//   auxMetadata.set_metadata(txMetadata);

//   // Add metadatum to transaction builder, so it can be included in the transaction balancing
//   txBuilder.set_auxiliary_data(auxMetadata);

//   // Add extra signature witness to transaction builder
//   if (!payload.usedAddresses[0]) {
//     throw new Error("cannot find any used address");
//   }

//   const stakeCred = BaseAddress.from_address(Address.from_hex(payload.usedAddresses[0]))
//     ?.stake_cred()
//     .to_keyhash()
//     ?.to_hex();

//   if (!stakeCred) {
//     throw new Error("cannot create a stake credential");
//   }

//   txBuilder.add_required_signer(Ed25519KeyHash.from_hex(stakeCred));

//   // Add outputs to the transaction builder
//   txBuilder.add_output(TransactionOutput.new(registrationAddress, registrationAmount));

//   // Find the available UTxOs in the wallet and use them as Inputs for the transaction
//   const txUnspentOutputs = payload.rawUtxos.reduce((acc, utxo) => {
//     acc.add(TransactionUnspentOutput.from_hex(utxo));
//     return acc;
//   }, TransactionUnspentOutputs.new());
//   // Use UTxO selection strategy RandomImproveMultiAsset aka 3
//   txBuilder.add_inputs_from(txUnspentOutputs, 3);

//   // Set change address, incase too much ADA provided for fee
//   const shelleyChangeAddress = Address.from_hex(payload.changeAddress);
//   txBuilder.add_change_if_needed(shelleyChangeAddress);

//   // Make a full transaction, passing in empty witness set
//   const txBody = txBuilder.build();
//   const transactionWitnessSet = TransactionWitnessSet.new();
//   const unsignedTx = Transaction.new(
//     txBody,
//     TransactionWitnessSet.from_bytes(transactionWitnessSet.to_bytes()),
//     auxMetadata
//   );

//   return unsignedTx;
// }
