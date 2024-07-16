import 'package:cbor/cbor.dart';
import 'package:equatable/equatable.dart';

/// A set of witnesses that sign the transaction.
final class TransactionWitnessSet extends Equatable {
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
final class VkeyWitness extends Equatable {
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

/// The ED25519 public key that is 256 bits long.
extension type Ed25519PublicKey._(List<int> bytes) {
  /// The length of the [Ed25519PublicKey] in bytes.
  static const int length = 32;

  /// The default constructor for [Ed25519PublicKey].
  Ed25519PublicKey.fromBytes(this.bytes) {
    if (bytes.length != length) {
      throw ArgumentError(
        'Ed25519PublicKey length does not match: ${bytes.length}',
      );
    }
  }

  /// Returns the [Ed25519PublicKey] filled with [byte] that can be
  /// used to reserve size to calculate the final transaction bytes size.
  factory Ed25519PublicKey.seeded(int byte) =>
      Ed25519PublicKey.fromBytes(List.filled(length, byte));

  /// Deserializes the type from cbor.
  factory Ed25519PublicKey.fromCbor(CborValue value) {
    return Ed25519PublicKey.fromBytes((value as CborBytes).bytes);
  }

  /// Serializes the type as cbor.
  CborValue toCbor() => CborBytes(bytes);
}

/// The witness signature of the transaction.
extension type Ed25519Signature._(List<int> bytes) {
  /// The length of the [Ed25519Signature] in bytes.
  static const int length = 64;

  /// The default constructor for [Ed25519Signature].
  Ed25519Signature.fromBytes(this.bytes) {
    if (bytes.length != length) {
      throw ArgumentError(
        'Ed25519Signature length does not match: ${bytes.length}',
      );
    }
  }

  /// Returns the [Ed25519Signature] filled with [byte]
  /// that can be used to reserve size.
  factory Ed25519Signature.seeded(int byte) =>
      Ed25519Signature.fromBytes(List.filled(length, byte));

  /// Deserializes the type from cbor.
  factory Ed25519Signature.fromCbor(CborValue value) {
    return Ed25519Signature.fromBytes((value as CborBytes).bytes);
  }

  /// Serializes the type as cbor.
  CborValue toCbor() => CborBytes(bytes);
}
