import 'dart:convert';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/src/crypto/key_derivation_service.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/foundation.dart';

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
    final secondsSinceEpoch =
        dateTime.millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond;

    return catalystId.copyWith(
      username: const Optional.empty(),
      nonce: Optional(secondsSinceEpoch),
      role: const Optional.empty(),
      rotation: const Optional.empty(),
      encrypt: false,
    );
  }
}
