import 'dart:typed_data';

import 'package:catalyst_key_derivation/src/rust/api/key_derivation.dart'
    as rust;
import 'package:cbor/cbor.dart';
import 'package:convert/convert.dart';
import 'package:equatable/equatable.dart';

/// Represents an extended BIP-32 signature using the Ed25519 curve.
///
/// This class provides methods to create, serialize, and manipulate
/// cryptographic signatures based on the BIP-32 HD wallet standard.
class Bip32Ed25519XSignature extends Equatable {
  final rust.Bip32Ed25519Signature _bytes;

  /// The default constructor for [Bip32Ed25519XSignature].
  const Bip32Ed25519XSignature(this._bytes);

  /// Constructs [Bip32Ed25519XSignature] from a byte list.
  Bip32Ed25519XSignature.fromBytes(List<int> bytes)
      : _bytes = rust.Bip32Ed25519Signature(
          sigBytes: rust.U8Array64(Uint8List.fromList(bytes)),
        );

  /// Serializes the type as cbor.
  CborValue toCbor() => CborBytes(bytes);

  /// Returns a hex representation of the [Bip32Ed25519XSignature].
  String toHex() => hex.encode(bytes);

  /// Returns the bytes of the signature.
  List<int> get bytes => _bytes.inner;

  @override
  List<Object?> get props => [_bytes];
}
