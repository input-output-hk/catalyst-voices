// cspell: words Metadatum metadatum keyhash bignum scripthash

import {
  Address,
  AuxiliaryData,
  Certificate,
  Credential,
  Ed25519KeyHash,
  ExUnitPrices,
  Int,
  LinearFee,
  Metadata,
  NetworkId,
  Rational,
  RewardAddress,
  SingleCertificateBuilder,
  SingleOutputBuilderResult,
  SingleWithdrawalBuilder,
  Transaction,
  TransactionBuilder,
  TransactionBuilderConfigBuilder,
  TransactionMetadatum,
  TransactionOutput,
  TransactionUnspentOutput,
  TransactionWitnessSet,
  Value
} from "@dcspark/cardano-multiplatform-lib-browser";

import { CertificateType, MetadataValueType, type TxBuilderArguments } from "types/cardano";

import hex2bin from "./hex2bin";

export default async function builidUnsignedTxWithMultiplatformLib(
  payload: TxBuilderArguments,
  changeAddress: string
): Promise<Uint8Array> {
  const { config, ...builder } = payload;

  // Initialize builder with protocol parameters
  const txBuilder = TransactionBuilder.new(
    TransactionBuilderConfigBuilder.new()
      .fee_algo(
        LinearFee.new(
          BigInt(config.linearFee.minFeeA),
          BigInt(config.linearFee.minFeeB)
        )
      )
      .pool_deposit(BigInt(config.poolDeposit))
      .key_deposit(BigInt(config.keyDeposit))
      .coins_per_utxo_byte(BigInt(config.coinsPerUtxoWord))
      .max_value_size(config.maxValSize)
      .max_tx_size(config.maxTxSize)
      .prefer_pure_change(true)
      .ex_unit_prices(
        ExUnitPrices.new(
          Rational.new(BigInt(577), BigInt(10_000)),
          Rational.new(BigInt(721), BigInt(1_000_000)),
        )
      )
      .collateral_percentage(150)
      .max_collateral_inputs(3)
      .build()
  );

  // #0 add inputs
  for (const item of builder.txInputs.filter((x) => Boolean(x.hex))) {
    const utxo = TransactionUnspentOutput.from_cbor_hex(item.hex);
    txBuilder.add_reference_input(utxo)
  }

  // #1 add outputs
  for (const item of builder.txOutputs.filter((x) => Boolean(x.address) && Boolean(x.amount))) {
    
    const address = Address.from_bech32(item.address);
    const amount = Value.from_coin(BigInt(item.amount));
    const output = TransactionOutput.new(address, amount);

    txBuilder.add_output(SingleOutputBuilderResult.new(output));
  }

  // #2 add fee
  if (builder.txFee) {
    const val = BigInt(builder.txFee);
    txBuilder.set_fee(val);
  }

  // #3 add ttl
  if (builder.timeToLive) {
    const val = BigInt(builder.timeToLive);
    txBuilder.set_ttl(val);
  }

  // #4 add certs
  for (const item of builder.certificates) {
    // TODO: add other types
    if (item.type === CertificateType.StakeDelegation) {
      let cred: Credential;
      if (item.hashType === "addr_keyhash") {
        cred = Credential.new_pub_key(Ed25519KeyHash.from_hex(item.hash));
      } else if (item.hashType === "scripthash") {
        cred = Credential.new_script(Ed25519KeyHash.from_hex(item.hash));
      } else {
        throw new Error("certificate hash type is not defined");
      }

      const poolKeyhash = Ed25519KeyHash.from_hex(item.poolKeyhash);
      const cert = Certificate.new_stake_delegation(cred, poolKeyhash)
      const result = SingleCertificateBuilder.new(cert)

      txBuilder.add_cert(result)
    } else {
      throw new Error("cannot build a certificate");
    }
  }

  // #5 add withdrawals
  for (const item of builder.rewardWithdrawals.filter(
    (x) => Boolean(x.address) && Boolean(x.value)
  )) {
    let rewardAddress = RewardAddress.from_address(Address.from_bech32(item.address));
    const value = BigInt(item.value);

    if (!rewardAddress) {
      throw new Error("cannot create an address");
    }

    const result = SingleWithdrawalBuilder.new(rewardAddress, value).payment_key()

    txBuilder.add_withdrawal(result)
  }

  // #7 add auxiliary data hash
  if (builder.auxiliaryDataHash) {
    // note: the hash will be set after building auxillary data
  }

  // #8 add validity interval start
  if (builder.validityIntervalStart) {
    const val = BigInt(builder.validityIntervalStart);
    txBuilder.set_validity_start_interval(val);
  }

  // #14 add required signers
  for (const requiredSigner of builder.requiredSigners) {
    const result = Ed25519KeyHash.from_bech32(requiredSigner.address);
    txBuilder.add_required_signer(result);
  }

  // #15 add network id
  if (builder.networkId && [0, 1].includes(Number(builder.networkId))) {
    const networkId = Number(builder.networkId) === 0 ? NetworkId.testnet() : NetworkId.mainnet()
    txBuilder.set_network_id(networkId)
  }

  // aux data
  const auxMetadata = AuxiliaryData.new();
  for (const item of builder.auxMetadata.metadata) {
    let txMetadatum: TransactionMetadatum;
    if (item.valueType === MetadataValueType.Text) {
      txMetadatum = TransactionMetadatum.new_text(item.value);
    } else if (item.valueType === MetadataValueType.Hex) {
      txMetadatum = TransactionMetadatum.new_bytes(hex2bin(item.value));
    } else if (item.valueType === MetadataValueType.Int) {
      txMetadatum = TransactionMetadatum.new_int(Int.from_str(item.value));
    } else if (item.valueType === MetadataValueType.Cbor) {
      txMetadatum = TransactionMetadatum.from_cbor_bytes(hex2bin(item.value));
    } else if (item.valueType === MetadataValueType.List) {
      // TODO:
      throw new Error("value type is currently not supported");
    } else if (item.valueType === MetadataValueType.Map) {
      // TODO:
      throw new Error("value type is currently not supported");
    } else {
      throw new Error("unknown value type");
    }

    const regMessageMetadatumLabel = BigInt(item.key);
    // TODO: support other types

    // MetadataMap.new().insert()
    // MetadataList.new().add()

    const metadata = Metadata.new()
    metadata.set(regMessageMetadatumLabel, txMetadatum)

    auxMetadata.add_metadata(metadata);
  }

  if (auxMetadata.metadata()?.len()) {
    txBuilder.set_auxiliary_data(auxMetadata)
  }

  console.log("testing");

  // generate fee incase too much ADA provided for fee
  // if (!builder.txFee) {
  //   const shelleyChangeAddress = Address.from_hex(changeAddress);
  //   txBuilder.add_change_if_needed(shelleyChangeAddress, true);
  // }

  // build a full transaction, passing in empty witness set
  const shelleyChangeAddress = Address.from_hex(changeAddress);
  const txBody = txBuilder.build(0, shelleyChangeAddress).body();

  console.log("testing");

  const unsignedTx = Transaction.new(txBody, TransactionWitnessSet.new(), true, auxMetadata);

  return unsignedTx.to_cbor_bytes();
}
