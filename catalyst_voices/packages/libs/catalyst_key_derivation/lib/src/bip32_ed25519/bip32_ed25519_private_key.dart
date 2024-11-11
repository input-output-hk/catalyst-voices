import 'dart:typed_data';

import 'package:catalyst_key_derivation/src/bip32_ed25519/bip32_ed25519_public_key.dart';
import 'package:catalyst_key_derivation/src/bip32_ed25519/bip32_ed25519_signature.dart';
import 'package:catalyst_key_derivation/src/rust/api/key_derivation.dart'
    as rust;
import 'package:cbor/cbor.dart';
import 'package:convert/convert.dart';
import 'package:equatable/equatable.dart';

/// Represents an extended BIP-32 private key based on the Ed25519 curve.
/// 
/// It is recommended to call [drop] as soon as the key is not needed anymore.
class Bip32Ed25519XPrivateKey extends Equatable {
  final rust.Bip32Ed25519XPrivateKey _bytes;

  /// The default constructor for [Bip32Ed25519XPrivateKey].
  const Bip32Ed25519XPrivateKey(this._bytes);

  /// Constructs [Bip32Ed25519XPrivateKey] from a byte list.
  Bip32Ed25519XPrivateKey.fromBytes(List<int> bytes)
      : _bytes = rust.Bip32Ed25519XPrivateKey(
          xprvBytes: rust.U8Array96(Uint8List.fromList(bytes)),
        );

  /// Serializes the type as cbor.
  CborValue toCbor() => CborBytes(bytes);

  /// Returns a hex representation of the [Bip32Ed25519XPrivateKey].
  String toHex() => hex.encode(bytes);

  /// Returns the bytes of the private key.
  List<int> get bytes => _bytes.inner;

  /// Signs the specified [message] and returns a [Bip32Ed25519XSignature].
  ///
  /// This method uses the private key to generate a cryptographic signature
  /// of the [message].
  Future<Bip32Ed25519XSignature> sign(List<int> message) async {
    final signature = await _bytes.signData(data: message);
    return Bip32Ed25519XSignature(signature);
  }

  /// Verifies that the [signature] is valid for the given [message] using the
  /// public key derived from this private key.
  ///
  /// Returns `true` if the [signature] is valid, `false` otherwise.
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

  /// Derives and returns the associated [Bip32Ed25519XPublicKey]
  /// for this private key.
  ///
  /// The derived public key can be used for signature verification and other
  /// public-key cryptographic operations.
  Future<Bip32Ed25519XPublicKey> derivePublicKey() async {
    final key = await _bytes.xpublicKey();
    return Bip32Ed25519XPublicKey(key);
  }

  /// Derives and returns a child [Bip32Ed25519XPrivateKey] using the specified
  /// BIP-32 derivation [path].
  ///
  /// [path] is the BIP-32 derivation path,
  /// used to generate a child private key.
  Future<Bip32Ed25519XPrivateKey> derivePrivateKey({
    required String path,
  }) async {
    final key = await _bytes.deriveXprv(path: path);
    return Bip32Ed25519XPrivateKey(key);
  }

  /// Clears the sensitive data associated with this private key.
  ///
  /// This operation invalidates the key, making it unusable for future
  /// operations.
  void drop() {
    _bytes.drop();
  }

  @override
  List<Object?> get props => [_bytes];
}
