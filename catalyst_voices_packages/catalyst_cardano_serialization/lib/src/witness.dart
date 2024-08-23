import 'package:catalyst_cardano_serialization/src/signature.dart';
import 'package:catalyst_cardano_serialization/src/types.dart';
import 'package:cbor/cbor.dart';
import 'package:equatable/equatable.dart';

/// A set of witnesses that sign the transaction.
final class TransactionWitnessSet extends Equatable implements CborEncodable {
  /// The witnesses that sign the transaction.
  final Set<VkeyWitness> vkeyWitnesses;

  /// The default constructor for [TransactionWitnessSet].
  const TransactionWitnessSet({required this.vkeyWitnesses});

  /// Deserializes the type from cbor.
  factory TransactionWitnessSet.fromCbor(CborValue value) {
    final map = value as CborMap;
    return TransactionWitnessSet(
      vkeyWitnesses: map.values.map(VkeyWitness.fromCbor).toSet(),
    );
  }

  /// Serializes the type as cbor.
  @override
  CborValue toCbor() {
    return CborMap({
      for (final vkey in vkeyWitnesses.indexed)
        CborSmallInt(vkey.$1): vkey.$2.toCbor(),
    });
  }

  @override
  List<Object?> get props => [vkeyWitnesses];
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
    final innerList = list[0] as CborList;
    final vkey = innerList[0];
    final signature = innerList[1];

    return VkeyWitness(
      vkey: Ed25519PublicKey.fromCbor(vkey),
      signature: Ed25519Signature.fromCbor(signature),
    );
  }

  /// Serializes the type as cbor.
  @override
  CborValue toCbor() {
    return CborList([
      CborList([
        vkey.toCbor(),
        signature.toCbor(),
      ]),
    ]);
  }

  @override
  List<Object?> get props => [vkey, signature];
}
