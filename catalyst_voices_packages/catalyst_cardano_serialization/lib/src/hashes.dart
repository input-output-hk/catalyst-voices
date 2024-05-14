// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes

import 'dart:typed_data';

import 'package:catalyst_cardano_serialization/src/exceptions.dart';
import 'package:catalyst_cardano_serialization/src/transaction.dart';
import 'package:cbor/cbor.dart';
import 'package:convert/convert.dart';
import 'package:pinenacl/digests.dart';

/// Implements a common base of hash types that holds
/// binary [bytes] of exact [length].
abstract base class BaseHash {
  /// The raw [bytes] of a hash.
  final List<int> bytes;

  /// Constructs the [BaseHash] from raw [bytes].
  BaseHash.fromBytes({required this.bytes}) {
    if (bytes.length != length) {
      throw const HashFormatException();
    }
  }

  /// Constructs the [BaseHash] from a hex string representation
  /// of [bytes].
  BaseHash.fromHex(String string) : this.fromBytes(bytes: hex.decode(string));

  /// The expected length of the transaction hash bytes.
  int get length;

  /// Serializes the type as cbor.
  CborValue toCbor() => CborBytes(bytes);

  /// Returns the hex string representation of [bytes].
  String toHex() => hex.encode(bytes);

  @override
  String toString() => toHex();

  @override
  int get hashCode => Object.hash(bytes, length);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BaseHash) return false;

    // prevent subclasses of different types to be equal to each other,
    // even if they hold the same bytes they represent different kinds
    if (other.runtimeType != runtimeType) return false;

    if (length != other.length) return false;

    for (var i = 0; i < bytes.length; i++) {
      if (bytes[i] != other.bytes[i]) return false;
    }

    return true;
  }
}

/// Describes the hash of the transaction which serves as proof
/// of transaction validation.
final class TransactionHash extends BaseHash {
  static const int _length = 32;

  /// Constructs the [TransactionHash] from raw [bytes].
  TransactionHash.fromBytes({required super.bytes}) : super.fromBytes();

  /// Constructs the [TransactionHash] from a hex string representation
  /// of [bytes].
  TransactionHash.fromHex(super.string) : super.fromHex();

  @override
  int get length => _length;
}

/// Describes the hash of auxiliary data which is included
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

  @override
  int get length => _length;
}
