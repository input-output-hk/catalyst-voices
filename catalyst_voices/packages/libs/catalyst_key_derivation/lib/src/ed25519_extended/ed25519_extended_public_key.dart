import 'dart:typed_data';

import 'package:catalyst_key_derivation/src/ed25519_extended/ed25519_extended_signature.dart';
import 'package:catalyst_key_derivation/src/rust/api/key_derivation.dart'
    as rust;
import 'package:cbor/cbor.dart';
import 'package:convert/convert.dart';
import 'package:equatable/equatable.dart';

/// The ED25519 public key that is 256 bits long.
class Ed25519ExtendedPublicKey extends Equatable {
  final rust.Bip32Ed25519XPublicKey _bytes;

  /// The default constructor for [Ed25519ExtendedPublicKey].
  const Ed25519ExtendedPublicKey(this._bytes);

  /// Constructs [Ed25519ExtendedPublicKey] from a byte list.
  Ed25519ExtendedPublicKey.fromBytes(List<int> bytes)
      : _bytes = rust.Bip32Ed25519XPublicKey(
          xpubBytes: rust.U8Array64(Uint8List.fromList(bytes)),
        );

  /// Constructs [Ed25519ExtendedPublicKey] from a hex [string].
  factory Ed25519ExtendedPublicKey.fromHex(String string) {
    return Ed25519ExtendedPublicKey.fromBytes(hex.decode(string));
  }

  /// Returns the [Ed25519ExtendedPublicKey] filled with [byte] that can be
  /// used to reserve size to calculate the final transaction bytes size.
  factory Ed25519ExtendedPublicKey.seeded(int byte) =>
      Ed25519ExtendedPublicKey.fromBytes(
        List.filled(rust.U8Array64.arraySize, byte),
      );

  /// Deserializes the type from cbor.
  factory Ed25519ExtendedPublicKey.fromCbor(CborValue value) {
    return Ed25519ExtendedPublicKey.fromBytes((value as CborBytes).bytes);
  }

  /// Serializes the type as cbor.
  CborValue toCbor({List<int> tags = const []}) {
    return CborBytes(bytes, tags: tags);
  }

  /// Returns a hex representation of the [Ed25519ExtendedPublicKey].
  String toHex() => hex.encode(bytes);

  /// Returns the bytes of the public key.
  List<int> get bytes => _bytes.inner;

  /// Returns true if this signature belongs to a given
  /// for given [message], false otherwise.
  Future<bool> verify(
    List<int> message, {
    required Ed25519ExtendedSignature signature,
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
