import 'dart:typed_data';

import 'package:catalyst_key_derivation/src/bip32_ed25519/bip32_ed25519_signature.dart';
import 'package:catalyst_key_derivation/src/rust/api/key_derivation.dart'
    as rust;
import 'package:cbor/cbor.dart';
import 'package:convert/convert.dart';
import 'package:equatable/equatable.dart';

/// An extended public key using the BIP-32 standard with the Ed25519 curve.
class Bip32Ed25519XPublicKey extends Equatable {
  final rust.Bip32Ed25519XPublicKey _bytes;

  /// The default constructor for [Bip32Ed25519XPublicKey].
  const Bip32Ed25519XPublicKey(this._bytes);

  /// Constructs [Bip32Ed25519XPublicKey] from a byte list.
  Bip32Ed25519XPublicKey.fromBytes(List<int> bytes)
      : _bytes = rust.Bip32Ed25519XPublicKey(
          xpubBytes: rust.U8Array64(Uint8List.fromList(bytes)),
        );

  /// Serializes the type as cbor.
  CborValue toCbor({List<int> tags = const []}) {
    return CborBytes(bytes, tags: tags);
  }

  /// Returns a hex representation of the [Bip32Ed25519XPublicKey].
  String toHex() => hex.encode(bytes);

  /// Returns the bytes of the public key.
  List<int> get bytes => _bytes.inner;

  /// Verifies whether a given [signature] was created using this public key
  /// for the provided [message].
  ///
  /// Returns `true` if the signature is valid for the [message] and matches
  /// this public key; `false` otherwise.
  Future<bool> verify(
    List<int> message, {
    required Bip32Ed25519XSignature signature,
  }) async {
    return _bytes.verifySignature(
      data: message,
      signature: rust.Bip32Ed25519Signature(
        sigBytes: rust.U8Array64(
          Uint8List.fromList(signature.bytes),
        ),
      ),
    );
  }

  @override
  List<Object?> get props => [_bytes];
}
