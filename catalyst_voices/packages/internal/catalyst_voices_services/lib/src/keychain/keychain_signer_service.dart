import 'dart:typed_data';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/src/crypto/key_derivation_service.dart';

final class KeychainSignerService implements KeychainSigner {
  final KeyDerivationService _keyDerivationService;

  const KeychainSignerService(this._keyDerivationService);

  @override
  Future<CatalystKeyPair> deriveAccountRoleKeyPair({
    required Keychain keychain,
    required AccountRole role,
  }) {
    return keychain.getMasterKey().use((masterKey) {
      return _keyDerivationService.deriveAccountRoleKeyPair(
        masterKey: masterKey,
        role: role,
      );
    });
  }

  @override
  Future<CatalystSignature> sign(
    Uint8List message, {
    required Keychain keychain,
    required AccountRole role,
  }) async {
    return keychain.getMasterKey().use((masterKey) {
      final keyPair = _keyDerivationService.deriveAccountRoleKeyPair(
        masterKey: masterKey,
        role: role,
      );

      return keyPair.use((keyPair) => keyPair.privateKey.sign(message));
    });
  }
}
