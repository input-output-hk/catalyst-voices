import 'dart:typed_data';

import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/src/crypto/bip32_ed25519_catalyst_public_key.dart';
import 'package:catalyst_voices_services/src/crypto/bip32_ed25519_catalyst_signature.dart';

final class Bip32Ed25519CatalystPrivateKey implements CatalystPrivateKey {
  final Bip32Ed25519XPrivateKey _privateKey;

  const Bip32Ed25519CatalystPrivateKey(this._privateKey);

  @override
  CatalystSignatureAlgorithm get algorithm =>
      CatalystSignatureAlgorithm.ed25519;

  @override
  Uint8List get bytes => Uint8List.fromList(_privateKey.bytes);

  @override
  Future<CatalystPrivateKey> derivePrivateKey({required String path}) async {
    final derivedKey = await _privateKey.derivePrivateKey(path: path);
    return Bip32Ed25519CatalystPrivateKey(derivedKey);
  }

  @override
  Future<CatalystPublicKey> derivePublicKey() async {
    final derivedKey = await _privateKey.derivePublicKey();
    return Bip32Ed25519XCatalystPublicKey(derivedKey);
  }

  @override
  void drop() {
    _privateKey.drop();
  }

  @override
  Future<CatalystSignature> sign(Uint8List data) async {
    final signature = await _privateKey.sign(data);
    return Bip32Ed25519XCatalystSignature(signature);
  }
}
