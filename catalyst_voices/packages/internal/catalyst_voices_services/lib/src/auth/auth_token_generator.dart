import 'dart:convert';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/src/crypto/key_derivation_service.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/foundation.dart';

/// Generates AuthToken for a given [CatalystPrivateKey] and [CatalystId].
/// 
/// The token is generated using the following steps:
/// 1. Derive the account role key pair from the master key using [KeyDerivationService].
/// 2. Create a CatalystId token from the CatalystId.
/// 3. Sign the CatalystId token using the account role key pair.
/// 4. Encode the signature using base64UrlNoPad.
/// 5. Return the AuthToken.
final class AuthTokenGenerator {
  @visibleForTesting
  static const String tokenPrefix = 'catid';

  final KeyDerivationService _keyDerivationService;

  const AuthTokenGenerator(this._keyDerivationService);

  Future<RbacToken> generate({
    required CatalystPrivateKey masterKey,
    required CatalystId catalystId,
  }) {
    final keyPair = _keyDerivationService.deriveAccountRoleKeyPair(
      masterKey: masterKey,
      role: AccountRole.root,
    );

    return keyPair.use((keyPair) async {
      final catalystIdToken = _createCatalystIdForToken(catalystId);
      final catalystIdString = catalystIdToken.toUri().toStringWithoutScheme();
      final toBeSigned = utf8.encode('$tokenPrefix.$catalystIdString.');
      final signature = await keyPair.privateKey.sign(toBeSigned);
      final encodedSignature = base64UrlNoPadEncode(signature.bytes);

      return RbacToken('$tokenPrefix.$catalystIdString.$encodedSignature');
    });
  }

  CatalystId _createCatalystIdForToken(CatalystId catalystId) {
    final dateTime = DateTimeExt.now();
    final secondsSinceEpoch = dateTime.millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond;

    return catalystId.copyWith(
      username: const Optional.empty(),
      nonce: Optional(secondsSinceEpoch),
      role: const Optional.empty(),
      rotation: const Optional.empty(),
      encrypt: false,
    );
  }
}
