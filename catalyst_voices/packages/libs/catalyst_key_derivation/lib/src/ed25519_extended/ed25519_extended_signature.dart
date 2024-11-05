import 'dart:typed_data';

import 'package:catalyst_key_derivation/src/rust/api/key_derivation.dart'
    as rust;
import 'package:cbor/cbor.dart';
import 'package:convert/convert.dart';
import 'package:equatable/equatable.dart';

/// The witness signature of the transaction.
class Ed25519ExtendedSignature extends Equatable {
  final rust.Bip32Ed25519Signature _bytes;

  /// The default constructor for [Ed25519ExtendedSignature].
  const Ed25519ExtendedSignature(this._bytes);

  /// Constructs [Ed25519ExtendedSignature] from a byte list.
  Ed25519ExtendedSignature.fromBytes(List<int> bytes)
      : _bytes = rust.Bip32Ed25519Signature(
          sigBytes: rust.U8Array64(Uint8List.fromList(bytes)),
        );

  /// Constructs [Ed25519ExtendedSignature] from a hex [string].
  factory Ed25519ExtendedSignature.fromHex(String string) {
    return Ed25519ExtendedSignature.fromBytes(hex.decode(string));
  }

  /// Returns the [Ed25519ExtendedSignature] filled with [byte]
  /// that can be used to reserve size.
  factory Ed25519ExtendedSignature.seeded(int byte) =>
      Ed25519ExtendedSignature.fromBytes(
        List.filled(rust.U8Array64.arraySize, byte),
      );

  /// Deserializes the type from cbor.
  factory Ed25519ExtendedSignature.fromCbor(CborValue value) {
    return Ed25519ExtendedSignature.fromBytes((value as CborBytes).bytes);
  }

  /// Serializes the type as cbor.
  CborValue toCbor() => CborBytes(bytes);

  /// Returns a hex representation of the [Ed25519ExtendedSignature].
  String toHex() => hex.encode(bytes);

  /// Returns the bytes of the signature.
  List<int> get bytes => _bytes.inner;

  @override
  List<Object?> get props => [_bytes];
}
