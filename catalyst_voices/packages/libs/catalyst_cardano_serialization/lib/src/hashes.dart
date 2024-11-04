// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes

import 'dart:typed_data';

import 'package:catalyst_cardano_serialization/src/certificate.dart';
import 'package:catalyst_cardano_serialization/src/exceptions.dart';
import 'package:catalyst_cardano_serialization/src/redeemer.dart';
import 'package:catalyst_cardano_serialization/src/signature.dart';
import 'package:catalyst_cardano_serialization/src/transaction.dart';
import 'package:catalyst_cardano_serialization/src/types.dart';
import 'package:cbor/cbor.dart';
import 'package:convert/convert.dart';
import 'package:equatable/equatable.dart';
import 'package:pinenacl/digests.dart';

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
  BaseHash.fromCbor(CborValue value)
      : this.fromBytes(bytes: (value as CborBytes).bytes);

  /// Serializes the type as cbor.
  @override
  CborValue toCbor() => CborBytes(bytes);

  /// Constructs the [BaseHash] from a hex string representation
  /// of [bytes].
  BaseHash.fromHex(String string) : this.fromBytes(bytes: hex.decode(string));

  /// The expected length of the transaction hash bytes.
  int get length;

  /// Returns the hex string representation of [bytes].
  String toHex() => hex.encode(bytes);

  @override
  String toString() => toHex();

  @override
  List<Object?> get props => [bytes];
}

/// Describes the Blake2b-256 hash of the transaction which serves as proof
/// of transaction validation.
final class TransactionHash extends BaseHash {
  static const int _length = 32;

  /// Constructs the [TransactionHash] from raw [bytes].
  TransactionHash.fromBytes({required super.bytes}) : super.fromBytes();

  /// Constructs the [TransactionHash] from a hex string representation
  /// of [bytes].
  TransactionHash.fromHex(super.string) : super.fromHex();

  /// Constructs the [TransactionHash] from a [TransactionBody].
  TransactionHash.fromTransactionBody(TransactionBody body)
      : super.fromBytes(
          bytes: Hash.blake2b(
            Uint8List.fromList(cbor.encode(body.toCbor())),
            digestSize: _length,
          ),
        );

  /// Deserializes the type from cbor.
  TransactionHash.fromCbor(super.value) : super.fromCbor();

  @override
  int get length => _length;
}

/// Describes the Blake2b-128 hash of the transaction inputs (UTXOs)
/// which can be used as a link to a certain transaction
/// (as UTXOs can only be spent once).
final class TransactionInputsHash extends BaseHash {
  static const int _length = 16;

  /// Constructs the [TransactionInputsHash] from raw [bytes].
  TransactionInputsHash.fromBytes({required super.bytes}) : super.fromBytes();

  /// Constructs the [TransactionInputsHash] from a hex string representation
  /// of [bytes].
  TransactionInputsHash.fromHex(super.string) : super.fromHex();

  /// Constructs the [TransactionInputsHash] from a [TransactionBody].
  TransactionInputsHash.fromTransactionInputs(
    Set<TransactionUnspentOutput> utxos,
  ) : super.fromBytes(
          bytes: Hash.blake2b(
            Uint8List.fromList(
              cbor.encode(
                CborList([
                  for (final utxo in utxos) utxo.input.toCbor(),
                ]),
              ),
            ),
            digestSize: _length,
          ),
        );

  /// Deserializes the type from cbor.
  TransactionInputsHash.fromCbor(super.value) : super.fromCbor();

  @override
  int get length => _length;
}

/// Describes the Blake2b-256 hash of auxiliary data which is included
/// in the transaction body.
final class AuxiliaryDataHash extends BaseHash {
  static const int _length = 32;

  /// Constructs the [AuxiliaryDataHash] from raw [bytes].
  AuxiliaryDataHash.fromBytes({required super.bytes}) : super.fromBytes();

  /// Constructs the [AuxiliaryDataHash] from a hex string representation
  /// of [bytes].
  AuxiliaryDataHash.fromHex(super.string) : super.fromHex();

  /// Constructs the [AuxiliaryDataHash] from a [AuxiliaryData].
  AuxiliaryDataHash.fromAuxiliaryData(AuxiliaryData data)
      : super.fromBytes(
          bytes: Hash.blake2b(
            Uint8List.fromList(cbor.encode(data.toCbor())),
            digestSize: _length,
          ),
        );

  /// Deserializes the type from cbor.
  AuxiliaryDataHash.fromCbor(super.value) : super.fromCbor();

  @override
  int get length => _length;
}

/// Describes the Blake2b-128 hash of a certificate.
final class CertificateHash extends BaseHash {
  static const int _length = 16;

  /// Constructs the [CertificateHash] from raw [bytes].
  CertificateHash.fromBytes({required super.bytes}) : super.fromBytes();

  /// Constructs the [CertificateHash] from a hex string representation
  /// of [bytes].
  CertificateHash.fromHex(super.string) : super.fromHex();

  /// Constructs the [CertificateHash] from a [X509DerCertificate].
  CertificateHash.fromX509DerCertificate(X509DerCertificate certificate)
      : super.fromBytes(
          bytes: Hash.blake2b(
            Uint8List.fromList(certificate.bytes),
            digestSize: _length,
          ),
        );

  /// Constructs the [CertificateHash] from a [C509Certificate].
  CertificateHash.fromC509Certificate(C509Certificate certificate)
      : super.fromBytes(
          bytes: Hash.blake2b(
            Uint8List.fromList(certificate.bytes),
            digestSize: _length,
          ),
        );

  /// Deserializes the type from cbor.
  CertificateHash.fromCbor(super.value) : super.fromCbor();

  @override
  int get length => _length;
}

/// Describes the Blake2b-224 hash of a [Ed25519PublicKey].
final class Ed25519PublicKeyHash extends BaseHash {
  static const int _length = 28;

  /// Constructs the [Ed25519PublicKeyHash] from raw [bytes].
  Ed25519PublicKeyHash.fromBytes({required super.bytes}) : super.fromBytes();

  /// Constructs the [Ed25519PublicKeyHash] from a hex string representation
  /// of [bytes].
  Ed25519PublicKeyHash.fromHex(super.string) : super.fromHex();

  /// Constructs the [Ed25519PublicKeyHash] from a [Ed25519PublicKey].
  Ed25519PublicKeyHash.fromPublicKey(Ed25519PublicKey key)
      : super.fromBytes(
          bytes: Hash.blake2b(
            Uint8List.fromList(key.bytes),
            digestSize: _length,
          ),
        );

  /// Deserializes the type from cbor.
  Ed25519PublicKeyHash.fromCbor(super.value) : super.fromCbor();

  @override
  int get length => _length;
}

/// Describes the Blake2b-256 hash of script data which is included
/// in the transaction body.
final class ScriptDataHash extends BaseHash {
  static const int _length = 32;

  /// Constructs the [ScriptDataHash] from raw [bytes].
  ScriptDataHash.fromBytes({required super.bytes}) : super.fromBytes();

  /// Constructs the [ScriptDataHash] from a hex string representation
  /// of [bytes].
  ScriptDataHash.fromHex(super.string) : super.fromHex();

  /// Constructs the [ScriptDataHash] from a [ScriptData].
  ScriptDataHash.fromScriptData(ScriptData data)
      : super.fromBytes(
          bytes: Hash.blake2b(
            Uint8List.fromList(cbor.encode(data.toCbor())),
            digestSize: _length,
          ),
        );

  /// Deserializes the type from cbor.
  ScriptDataHash.fromCbor(super.value) : super.fromCbor();

  @override
  int get length => _length;
}
