import 'dart:convert';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart'
    show AuthTokenCache;
import 'package:catalyst_voices_services/src/crypto/key_derivation_service.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/foundation.dart';
import 'package:synchronized/synchronized.dart';

abstract interface class AuthService implements AuthTokenProvider {
  factory AuthService(
    AuthTokenCache cache,
    UserObserver userObserver,
    KeyDerivationService keyDerivationService,
  ) = AuthServiceImpl;
}

final class AuthServiceImpl implements AuthService {
  @visibleForTesting
  static const String tokenPrefix = 'catid';

  final AuthTokenCache _cache;
  final UserObserver _userObserver;
  final KeyDerivationService _keyDerivationService;

  final _rbacTokenLock = Lock();

  AuthServiceImpl(
    this._cache,
    this._userObserver,
    this._keyDerivationService,
  );

  @override
  Future<String> createRbacToken({
    bool forceRefresh = false,
  }) {
    return _rbacTokenLock.synchronized(() {
      return _createRbacToken(forceRefresh: forceRefresh);
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

  Future<String> _createRbacToken({
    required bool forceRefresh,
  }) async {
    final account = await _getAccount();

    if (!forceRefresh) {
      final cachedToken = await _cache.getRbac(id: account.catalystId);
      if (cachedToken != null) {
        return cachedToken;
      }
    }

    final token = await _createRbacTokenFor(account: account);

    await _cache.setRbac(token, id: account.catalystId);

    return token;
  }

  Future<String> _createRbacTokenFor({
    required Account account,
  }) async {
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

  Future<Account> _getAccount() async {
    final account = _userObserver.user.activeAccount;
    if (account == null) {
      throw StateError('Cannot create rbac token, account missing');
    }
    return account;
  }
}
