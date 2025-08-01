import 'dart:typed_data';

import 'package:catalyst_cardano_serialization/src/certificate.dart';
import 'package:catalyst_cardano_serialization/src/exceptions.dart';
import 'package:catalyst_cardano_serialization/src/redeemer.dart';
import 'package:catalyst_cardano_serialization/src/signature.dart';
import 'package:catalyst_cardano_serialization/src/transaction.dart';
import 'package:catalyst_cardano_serialization/src/types.dart';
import 'package:catalyst_cardano_serialization/src/utils/hex.dart';
import 'package:cbor/cbor.dart';
import 'package:convert/convert.dart';
import 'package:equatable/equatable.dart';
import 'package:pinenacl/digests.dart';

/// Describes the Blake2b-256 hash of auxiliary data which is included
/// in the transaction body.
final class AuxiliaryDataHash extends BaseHash {
  /// Length of the [AuxiliaryDataHash].
  static const int hashLength = 32;

  /// Creates a blake2b hash from [bytes].
  AuxiliaryDataHash.blake2b(List<int> bytes)
      : super.fromBytes(
          bytes: Hash.blake2b(
            Uint8List.fromList(bytes),
            digestSize: hashLength,
          ),
        );

  /// Constructs the [AuxiliaryDataHash] from a [AuxiliaryData].
  AuxiliaryDataHash.fromAuxiliaryData(AuxiliaryData data)
      : this.blake2b(cbor.encode(data.toCbor()));

  /// Constructs the [AuxiliaryDataHash] from raw [bytes].
  AuxiliaryDataHash.fromBytes({required super.bytes}) : super.fromBytes();

  /// Deserializes the type from cbor.
  AuxiliaryDataHash.fromCbor(super.value) : super.fromCbor();

  /// Constructs the [AuxiliaryDataHash] from a hex string representation
  /// of [bytes].
  AuxiliaryDataHash.fromHex(super.string) : super.fromHex();

  @override
  int get length => hashLength;
}

/// Implements a common base of hash types that holds
/// binary [bytes] of exact [length].
abstract base class BaseHash extends Equatable implements CborEncodable {
  /// The raw [bytes] of a hash.
  final List<int> bytes;

  /// Constructs the [BaseHash] from raw [bytes].
  BaseHash.fromBytes({required this.bytes}) {
    if (bytes.length != length) {
      throw HashFormatException('Expected $length bytes, got: ${bytes.length}');
    }
  }

  /// Deserializes the type from cbor.
  BaseHash.fromCbor(CborValue value) : this.fromBytes(bytes: (value as CborBytes).bytes);

  /// Constructs the [BaseHash] from a hex string representation
  /// of [bytes].
  BaseHash.fromHex(String string) : this.fromBytes(bytes: hexDecode(string));

  /// The expected length of the transaction hash bytes.
  int get length;

  @override
  List<Object?> get props => [bytes];

  /// Serializes the type as cbor.
  @override
  CborValue toCbor({List<int> tags = const []}) => CborBytes(bytes, tags: tags);

  /// Returns the hex string representation of [bytes].
  String toHex() => hex.encode(bytes);

  @override
  String toString() => toHex();
}

/// Describes the Blake2b-128 hash of a certificate.
final class CertificateHash extends BaseHash {
  /// Length of the [CertificateHash].
  static const int hashLength = 16;

  /// Constructs the [CertificateHash] from raw [bytes].
  CertificateHash.fromBytes({required super.bytes}) : super.fromBytes();

  /// Constructs the [CertificateHash] from a [C509Certificate].
  CertificateHash.fromC509Certificate(C509Certificate certificate)
      : super.fromBytes(
          bytes: Hash.blake2b(
            Uint8List.fromList(certificate.bytes),
            digestSize: hashLength,
          ),
        );

  /// Deserializes the type from cbor.
  CertificateHash.fromCbor(super.value) : super.fromCbor();

  /// Constructs the [CertificateHash] from a hex string representation
  /// of [bytes].
  CertificateHash.fromHex(super.string) : super.fromHex();

  /// Constructs the [CertificateHash] from a [X509DerCertificate].
  CertificateHash.fromX509DerCertificate(X509DerCertificate certificate)
      : super.fromBytes(
          bytes: Hash.blake2b(
            Uint8List.fromList(certificate.bytes),
            digestSize: hashLength,
          ),
        );

  @override
  int get length => hashLength;
}

/// Describes the Blake2b-224 hash of a [Ed25519PublicKey].
final class Ed25519PublicKeyHash extends BaseHash {
  /// Length of the [Ed25519PublicKeyHash].
  static const int hashLength = 28;

  /// Constructs the [Ed25519PublicKeyHash] from raw [bytes].
  Ed25519PublicKeyHash.fromBytes({required super.bytes}) : super.fromBytes();

  /// Deserializes the type from cbor.
  Ed25519PublicKeyHash.fromCbor(super.value) : super.fromCbor();

  /// Constructs the [Ed25519PublicKeyHash] from a hex string representation
  /// of [bytes].
  Ed25519PublicKeyHash.fromHex(super.string) : super.fromHex();

  /// Constructs the [Ed25519PublicKeyHash] from a [Ed25519PublicKey].
  Ed25519PublicKeyHash.fromPublicKey(Ed25519PublicKey key)
      : super.fromBytes(
          bytes: Hash.blake2b(
            Uint8List.fromList(key.bytes),
            digestSize: hashLength,
          ),
        );

  @override
  int get length => hashLength;
}

/// Describes the Blake2b-256 hash of script data which is included
/// in the transaction body.
final class ScriptDataHash extends BaseHash {
  /// Length of the [ScriptDataHash].
  static const int hashLength = 32;

  /// Constructs the [ScriptDataHash] from raw [bytes].
  ScriptDataHash.fromBytes({required super.bytes}) : super.fromBytes();

  /// Deserializes the type from cbor.
  ScriptDataHash.fromCbor(super.value) : super.fromCbor();

  /// Constructs the [ScriptDataHash] from a hex string representation
  /// of [bytes].
  ScriptDataHash.fromHex(super.string) : super.fromHex();

  /// Constructs the [ScriptDataHash] from a [ScriptData].
  ScriptDataHash.fromScriptData(ScriptData data)
      : super.fromBytes(
          bytes: Hash.blake2b(
            Uint8List.fromList(cbor.encode(data.toCbor())),
            digestSize: hashLength,
          ),
        );

  @override
  int get length => hashLength;
}

/// Describes the Blake2b-256 hash of the transaction which serves as proof
/// of transaction validation.
final class TransactionHash extends BaseHash {
  /// Length of the [TransactionHash].
  static const int hashLength = 32;

  /// Constructs the [TransactionHash] from raw [bytes].
  TransactionHash.fromBytes({required super.bytes}) : super.fromBytes();

  /// Deserializes the type from cbor.
  TransactionHash.fromCbor(super.value) : super.fromCbor();

  /// Constructs the [TransactionHash] from a hex string representation
  /// of [bytes].
  TransactionHash.fromHex(super.string) : super.fromHex();

  /// Constructs the [TransactionHash] from a [TransactionBody].
  TransactionHash.fromTransactionBody(TransactionBody body)
      : super.fromBytes(
          bytes: Hash.blake2b(
            Uint8List.fromList(cbor.encode(body.toCbor())),
            digestSize: hashLength,
          ),
        );

  @override
  int get length => hashLength;
}

/// Describes the Blake2b-128 hash of the transaction inputs (UTXOs)
/// which can be used as a link to a certain transaction
/// (as UTXOs can only be spent once).
final class TransactionInputsHash extends BaseHash {
  /// Length of the [TransactionInputsHash].
  static const int hashLength = 16;

  /// Creates a blake2b hash from [bytes].
  TransactionInputsHash.blake2b(List<int> bytes)
      : super.fromBytes(
          bytes: Hash.blake2b(
            Uint8List.fromList(bytes),
            digestSize: hashLength,
          ),
        );

  /// Constructs the [TransactionInputsHash] from raw [bytes].
  TransactionInputsHash.fromBytes({required super.bytes}) : super.fromBytes();

  /// Deserializes the type from cbor.
  TransactionInputsHash.fromCbor(super.value) : super.fromCbor();

  /// Constructs the [TransactionInputsHash] from a hex string representation
  /// of [bytes].
  TransactionInputsHash.fromHex(super.string) : super.fromHex();

  /// Constructs the [TransactionInputsHash] from a [TransactionBody].
  TransactionInputsHash.fromTransactionInputs(
    Set<TransactionUnspentOutput> utxos,
  ) : this.blake2b(
          cbor.encode(
            CborList([
              for (final utxo in utxos) utxo.input.toCbor(),
            ]),
          ),
        );

  @override
  int get length => hashLength;
}
