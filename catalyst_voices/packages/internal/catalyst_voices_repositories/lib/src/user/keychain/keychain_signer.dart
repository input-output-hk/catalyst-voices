import 'dart:typed_data';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';

/// An interface which exposes cryptographic operations done on a [Keychain].
abstract interface class KeychainSigner {
  Future<CatalystKeyPair> deriveAccountRoleKeyPair({
    required Keychain keychain,
    required AccountRole role,
  });

  Future<CatalystSignature> sign(
    Uint8List message, {
    required Keychain keychain,
    required AccountRole role,
  });
}
