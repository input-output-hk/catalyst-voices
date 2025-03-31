import 'dart:convert';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/src/crypto/key_derivation_service.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/foundation.dart';

abstract interface class AuthService implements AuthTokenProvider {
  const factory AuthService(
    UserObserver userObserver,
    KeyDerivationService keyDerivationService,
  ) = AuthServiceImpl;
}

/// Note. token age 1h.
final class AuthServiceImpl implements AuthService {
  @visibleForTesting
  static const String tokenPrefix = 'catid';

  final UserObserver _userObserver;
  final KeyDerivationService _keyDerivationService;

  const AuthServiceImpl(
    this._userObserver,
    this._keyDerivationService,
  );

  @override
  Future<String> createRbacToken({
    bool forceRefresh = false,
  }) async {
    final account = await _getAccount();

    return account.keychain.getMasterKey().use((masterKey) {
      final keyPair = _keyDerivationService.deriveAccountRoleKeyPair(
        masterKey: masterKey,
        role: AccountRole.root,
      );

      return keyPair.use((keyPair) async {
        final catalystId = _createCatalystId(account);
        final catalystIdString = catalystId.toUri().toStringWithoutScheme();
        final toBeSigned = utf8.encode('$tokenPrefix.$catalystIdString.');
        final signature = await keyPair.privateKey.sign(toBeSigned);
        final encodedSignature = base64UrlNoPadEncode(signature.bytes);

        return '$tokenPrefix.$catalystIdString.$encodedSignature';
      });
    });
  }

  CatalystId _createCatalystId(Account account) {
    final dateTime = DateTimeExt.now();
    final secondsSinceEpoch =
        dateTime.millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond;

    return account.catalystId.copyWith(
      username: const Optional.empty(),
      nonce: Optional(secondsSinceEpoch),
      role: const Optional.empty(),
      rotation: const Optional.empty(),
      encrypt: false,
    );
  }

  Future<Account> _getAccount() async {
    final account = _userObserver.user.activeAccount;
    if (account == null) {
      throw StateError('Cannot create rbac token, account missing');
    }
    return account;
  }
}
