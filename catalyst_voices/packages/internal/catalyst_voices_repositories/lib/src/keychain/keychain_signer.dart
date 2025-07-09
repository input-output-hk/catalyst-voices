import 'dart:typed_data';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';

// ignore: one_member_abstracts
abstract interface class KeychainSigner {
  Future<CatalystKeyPair> deriveKeyPair({
    required CatalystPrivateKey masterKey,
    required AccountRole role,
  });

  Future<CatalystSignature> sign(
    Uint8List message, {
    required CatalystPrivateKey masterKey,
    required AccountRole role,
  });
}
