import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:cbor/cbor.dart';
import 'package:equatable/equatable.dart';

/// Witnesses that allow for various types of transactions on the Cardano
/// blockchain.
enum WitnessType {
  /// A witness that contains a verification key.
  vkeyWitness(0),

  /// A native script witness.
  nativeScript(1),

  /// A bootstrap witness.
  bootstrapWitness(2),

  /// A Plutus v1 script witness.
  plutusV1Script(3),

  /// A Plutus data witness.
  plutusData(4),

  /// A redeemer witness.
  redeemers(5),

  /// A Plutus v2 script witness.
  plutusV2Script(6),

  /// A Plutus v3 script witness.
  plutusV3Script(7);

  /// The integer value associated with the witness type.
  final int value;

  /// Constructs a new `WitnessType` with the given integer value.
  const WitnessType(this.value);
}

/// A set of witnesses that sign the transaction.
final class TransactionWitnessSet extends Equatable implements CborEncodable {
  /// The witnesses that sign the transaction.
  final Set<VkeyWitness> vkeyWitnesses;

  /// The native scripts.
  final Set<NativeScript> nativeScripts;

  /// The Plutus V1 scripts.
  final Set<PlutusV1Script> plutusV1Scripts;

  /// Redeemers for Plutus scripts.
  // FIXME(ilap): implement proper redeemers type.
  final Set<Redeemer> redeemers;

  /// The Plutus V2 scripts.
  final Set<PlutusV2Script> plutusV2Scripts;

  /// The Plutus V3 scripts.
  final Set<PlutusV3Script> plutusV3Scripts;

  /// The default constructor for [TransactionWitnessSet].
  const TransactionWitnessSet({
    this.vkeyWitnesses = const {},
    this.nativeScripts = const {},
    this.plutusV1Scripts = const {},
    this.redeemers = const {},
    this.plutusV2Scripts = const {},
    this.plutusV3Scripts = const {},
  });

  /// Deserializes the type from cbor.
  factory TransactionWitnessSet.fromCbor(CborValue value) {
    final map = value as CborMap;
    return TransactionWitnessSet(
      vkeyWitnesses: _getWitnesses<VkeyWitness>(
        map,
        WitnessType.vkeyWitness,
        VkeyWitness.fromCbor,
      ),
      nativeScripts: _getWitnesses<NativeScript>(
        map,
        WitnessType.nativeScript,
        NativeScript.fromCbor,
      ),
      plutusV1Scripts: _getWitnesses<PlutusV1Script>(
        map,
        WitnessType.plutusV1Script,
        PlutusV1Script.fromCbor,
      ),
      redeemers: _getWitnesses<Redeemer>(
        map,
        WitnessType.redeemers,
        Redeemer.fromCbor,
      ),
      plutusV2Scripts: _getWitnesses<PlutusV2Script>(
        map,
        WitnessType.plutusV2Script,
        PlutusV2Script.fromCbor,
      ),
      plutusV3Scripts: _getWitnesses<PlutusV3Script>(
        map,
        WitnessType.plutusV3Script,
        PlutusV3Script.fromCbor,
      ),
    );
  }

  static Set<T> _getWitnesses<T>(
    CborMap map,
    WitnessType type,
    T Function(CborValue) fromCbor,
  ) {
    final value = map[CborSmallInt(type.value)] as CborList?;
    return value?.map(fromCbor).toSet() ?? {};
  }

  /// Serializes the type as cbor.
  @override
  CborValue toCbor() {
    return CborMap({
      ..._generateCborPair(WitnessType.vkeyWitness, vkeyWitnesses),
      ..._generateCborPair(WitnessType.nativeScript, nativeScripts),
      ..._generateCborPair(WitnessType.plutusV1Script, plutusV1Scripts),
      ..._generateCborPair(WitnessType.redeemers, redeemers),
      ..._generateCborPair(WitnessType.plutusV2Script, plutusV2Scripts),
      ..._generateCborPair(WitnessType.plutusV3Script, plutusV3Scripts),
    });
  }

  Map<CborValue, CborValue> _generateCborPair(
    WitnessType witnessType,
    Set<CborEncodable> witnesses,
  ) {
    if (witnesses.isNotEmpty) {
      return {
        CborSmallInt(witnessType.value): CborList(
          witnesses
              .map(
                (value) => value.toCbor(),
              )
              .toList(),
        ),
      };
    }
    return {};
  }

  @override
  List<Object?> get props => [
        vkeyWitnesses,
        nativeScripts,
        plutusV1Scripts,
        redeemers,
        plutusV2Scripts,
        plutusV3Scripts,
      ];
}

/// The transaction witness with a [signature] of the transaction.
final class VkeyWitness extends Equatable implements CborEncodable {
  /// The public key of the witness.
  final Ed25519PublicKey vkey;

  /// The witness signature of the transaction.
  final Ed25519Signature signature;

  /// The default constructor for [VkeyWitness].
  const VkeyWitness({
    required this.vkey,
    required this.signature,
  });

  /// Builds a fake [VkeyWitness] that helps to measure target transaction
  /// size when the transaction hasn't been signed yet.
  factory VkeyWitness.seeded(int byte) {
    return VkeyWitness(
      vkey: Ed25519PublicKey.seeded(byte),
      signature: Ed25519Signature.seeded(byte),
    );
  }

  /// Deserializes the type from cbor.
  factory VkeyWitness.fromCbor(CborValue value) {
    final list = value as CborList;
    final vkey = list[0];
    final signature = list[1];

    return VkeyWitness(
      vkey: Ed25519PublicKey.fromCbor(vkey),
      signature: Ed25519Signature.fromCbor(signature),
    );
  }

  /// Serializes the type as cbor.
  @override
  CborValue toCbor() {
    return CborList([
      vkey.toCbor(),
      signature.toCbor(),
    ]);
  }

  @override
  List<Object?> get props => [vkey, signature];
}
