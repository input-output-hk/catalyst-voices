import 'package:cbor/cbor.dart';

/// A set of witnesses that sign the transaction.
class TransactionWitnessSet {
  /// The witnesses that sign the transaction.
  final Set<VkeyWitness> vkeyWitnesses;

  /// The default constructor for [TransactionWitnessSet].
  const TransactionWitnessSet({required this.vkeyWitnesses});

  /// Serializes the type as cbor.
  CborValue toCbor() {
    return CborMap({
      for (final vkey in vkeyWitnesses.indexed)
        CborSmallInt(vkey.$1): vkey.$2.toCbor(),
    });
  }
}

/// The transaction witness with a [signature] of the transaction.
class VkeyWitness {
  /// The public key of the witness.
  final Vkey vkey;

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
      vkey: Vkey.seeded(byte),
      signature: Ed25519Signature.seeded(byte),
    );
  }

  /// Serializes the type as cbor.
  CborValue toCbor() {
    return CborList([
      vkey.toCbor(),
      signature.toCbor(),
    ]);
  }
}

/// The public key of the witness.
extension type Vkey._(List<int> bytes) {
  /// The length of the [Vkey].
  static const int length = 32;

  /// The default constructor for [Vkey].
  Vkey.fromBytes(this.bytes) {
    if (bytes.length != length) {
      throw ArgumentError('Vkey length does not match: ${bytes.length}');
    }
  }

  /// Returns the [Vkey] filled with [byte] that can be
  /// used to reserve size to calculate the final transaction bytes size.
  factory Vkey.seeded(int byte) => Vkey.fromBytes(List.filled(length, byte));

  /// Serializes the type as cbor.
  CborValue toCbor() => CborBytes(bytes);
}

/// The witness signature of the transaction.
extension type Ed25519Signature._(List<int> bytes) {
  /// The length of the [Ed25519Signature].
  static const int length = 64;

  /// The default constructor for [Ed25519Signature].
  Ed25519Signature.fromBytes(this.bytes) {
    if (bytes.length != length) {
      throw ArgumentError(
        'Ed25519Signature length does not match: ${bytes.length}',
      );
    }
  }

  /// Returns the [Ed25519Signature] filled with [byte] that can be
  /// used to reserve size to calculate the final transaction bytes size.
  factory Ed25519Signature.seeded(int byte) =>
      Ed25519Signature.fromBytes(List.filled(length, byte));

  /// Serializes the type as cbor.
  CborValue toCbor() => CborBytes(bytes);
}
