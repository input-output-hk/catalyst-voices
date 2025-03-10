import 'dart:typed_data';

import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/src/crypto/bip32_ed25519_catalyst_private_key.dart';
import 'package:catalyst_voices_services/src/crypto/bip32_ed25519_catalyst_public_key.dart';
import 'package:catalyst_voices_services/src/crypto/bip32_ed25519_catalyst_signature.dart';

final class Bip32Ed25519CatalystKeyFactory
    implements
        CatalystPrivateKeyFactory,
        CatalystPublicKeyFactory,
        CatalystSignatureFactory {
  const Bip32Ed25519CatalystKeyFactory();

  @override
  CatalystPrivateKey createPrivateKey(Uint8List bytes) {
    final privateKey = Bip32Ed25519XPrivateKeyFactory.instance.fromBytes(bytes);
    return Bip32Ed25519CatalystPrivateKey(privateKey);
  }

  @override
  CatalystPublicKey createPublicKey(Uint8List bytes) {
    final publicKey = Bip32Ed25519XPublicKeyFactory.instance.fromBytes(bytes);
    return Bip32Ed25519XCatalystPublicKey(publicKey);
  }

  @override
  CatalystSignature createSignature(Uint8List bytes) {
    final signature = Bip32Ed25519XSignatureFactory.instance.fromBytes(bytes);
    return Bip32Ed25519XCatalystSignature(signature);
  }
}
