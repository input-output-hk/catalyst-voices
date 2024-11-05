import 'dart:typed_data';

import 'package:catalyst_key_derivation/src/ed25519_extended/ed25519_extended_public_key.dart';
import 'package:catalyst_key_derivation/src/ed25519_extended/ed25519_extended_signature.dart';
import 'package:catalyst_key_derivation/src/rust/api/key_derivation.dart'
    as rust;
import 'package:cbor/cbor.dart';
import 'package:convert/convert.dart';
import 'package:equatable/equatable.dart';

/// The Ed25519 private key that is 256 bits long.
class Ed25519ExtendedPrivateKey extends Equatable {
  final rust.Bip32Ed25519XPrivateKey _bytes;

  /// The default constructor for [Ed25519ExtendedPrivateKey].
  const Ed25519ExtendedPrivateKey(this._bytes);

  /// Constructs [Ed25519ExtendedPrivateKey] from a byte list.
  Ed25519ExtendedPrivateKey.fromBytes(List<int> bytes)
      : _bytes = rust.Bip32Ed25519XPrivateKey(
          xprvBytes: rust.U8Array96(Uint8List.fromList(bytes)),
        );

  /// Constructs [Ed25519ExtendedPrivateKey] from a hex [string].
  factory Ed25519ExtendedPrivateKey.fromHex(String string) {
    return Ed25519ExtendedPrivateKey.fromBytes(hex.decode(string));
  }

  /// Returns the [Ed25519ExtendedPrivateKey] filled with [byte].
  factory Ed25519ExtendedPrivateKey.seeded(int byte) =>
      Ed25519ExtendedPrivateKey.fromBytes(
        List.filled(rust.U8Array96.arraySize, byte),
      );

  /// Deserializes the type from cbor.
  factory Ed25519ExtendedPrivateKey.fromCbor(CborValue value) {
    return Ed25519ExtendedPrivateKey.fromBytes((value as CborBytes).bytes);
  }

  /// Serializes the type as cbor.
  CborValue toCbor() => CborBytes(bytes);

  /// Returns a hex representation of the [Ed25519ExtendedPrivateKey].
  String toHex() => hex.encode(bytes);

  /// Returns the bytes of the private key.
  List<int> get bytes => _bytes.inner;

  /// Signs the [message] with the private key and returns the signature.
  Future<Ed25519ExtendedSignature> sign(List<int> message) async {
    final signature = await _bytes.signData(data: message);
    return Ed25519ExtendedSignature(signature);
  }

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

  /// Returns a [Ed25519ExtendedPublicKey] derived from this private key.
  Future<Ed25519ExtendedPublicKey> derivePublicKey() async {
    final key = await _bytes.xpublicKey();
    return Ed25519ExtendedPublicKey(key);
  }

  /// Returns a child [Ed25519ExtendedPrivateKey] derived from
  /// this private key using [path].
  Future<Ed25519ExtendedPrivateKey> derivePrivateKey({
    required String path,
  }) async {
    final key = await _bytes.deriveXprv(path: path);
    return Ed25519ExtendedPrivateKey(key);
  }

  /// Clears this private key.
  ///
  /// After this the key cannot be used anymore.
  void drop() {
    _bytes.drop();
  }

  @override
  List<Object?> get props => [_bytes];
}
