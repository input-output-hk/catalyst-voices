// cspell: words Metadatum metadatum keyhash bignum scripthash

import {
  Address,
  AuxiliaryData,
  BaseAddress,
  BigNum,
  Certificate,
  Certificates,
  Ed25519KeyHash,
  GeneralTransactionMetadata,
  Int,
  LinearFee,
  NetworkId,
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

import { CertificateType, MetadataValueType, type TxBuilderArguments } from "types/cardano";

import hex2bin from "./hex2bin";

export default async function buildUnsignedTx(
  payload: TxBuilderArguments,
  changeAddress: string
): Promise<Transaction> {
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
    let rewardAddress = RewardAddress.from_address(Address.from_bech32(item.address));
    const value = BigNum.from_str(item.value);

    // fallback
    if (!rewardAddress) {
      const stakeCred = BaseAddress.from_address(Address.from_bech32(item.address))?.stake_cred();

      if (stakeCred) {
        let net: number;
        if (item.network) {
          net = Number(item.network);
        } else {
          net = item.address.includes("test") ? 0 : 1;
        }

        rewardAddress = RewardAddress.new(net, stakeCred);
      }
    }

    if (!rewardAddress) {
      throw new Error("cannot create an address");
    }

    withdrawals.insert(rewardAddress, value);
  }

  if (withdrawals.len()) {
    txBuilder.set_withdrawals(withdrawals);
  }

  // #7 add auxiliary data hash
  if (builder.auxiliaryDataHash) {
    // note: the hash will be set after building auxiliary data
  }

  // #8 add validity interval start
  if (builder.validityIntervalStart) {
    const val = BigNum.from_str(builder.validityIntervalStart);
    txBuilder.set_validity_start_interval_bignum(val);
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
    let txMetadatum: TransactionMetadatum;
    if (item.valueType === MetadataValueType.Text) {
      txMetadatum = TransactionMetadatum.new_text(item.value);
    } else if (item.valueType === MetadataValueType.Hex) {
      txMetadatum = TransactionMetadatum.new_bytes(hex2bin(item.value));
    } else if (item.valueType === MetadataValueType.Int) {
      txMetadatum = TransactionMetadatum.new_int(Int.from_str(item.value));
    } else if (item.valueType === MetadataValueType.Cbor) {
      txMetadatum = TransactionMetadatum.from_bytes(hex2bin(item.value));
    } else if (item.valueType === MetadataValueType.List) {
      // TODO:
      throw new Error("value type is currently not supported");
    } else if (item.valueType === MetadataValueType.Map) {
      // TODO:
      throw new Error("value type is currently not supported");
    } else {
      throw new Error("unknown value type");
    }

    const regMessageMetadatumLabel = BigNum.from_str(item.key);
    // TODO: support other types

    // MetadataMap.new().insert()
    // MetadataList.new().add()

    // TransactionMetadatum.new_map(MetadataMap.new())
    // TransactionMetadatum.new_list(MetadataList.new())
    txMetadata.insert(regMessageMetadatumLabel, txMetadatum);
  }

  if (txMetadata.len()) {
    auxMetadata.set_metadata(txMetadata);
    txBuilder.set_auxiliary_data(auxMetadata);
  }

  // generate fee incase too much ADA provided for fee
  if (!builder.txFee) {
    const shelleyChangeAddress = Address.from_hex(changeAddress);
    txBuilder.add_change_if_needed(shelleyChangeAddress);
  }

  // build a full transaction, passing in empty witness set
  const txBody = txBuilder.build();

  // #15 add network id
  if (builder.networkId && [0, 1].includes(Number(builder.networkId))) {
    const networkId = Number(builder.networkId) === 0 ? NetworkId.testnet() : NetworkId.mainnet()
    txBody.set_network_id(networkId);
  }

  const unsignedTx = Transaction.new(txBody, TransactionWitnessSet.new(), auxMetadata);

  return unsignedTx;
}
