import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart' show AuthTokenCache;
import 'package:catalyst_voices_services/src/auth/auth_token_generator.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:synchronized/synchronized.dart';

/// AuthService is a service that provides authentication tokens.
/// 
/// [UserObserver] is used to get the current user.
/// [AuthTokenCache] is used to cache the authentication tokens.
/// [AuthTokenGenerator] is used to generate the authentication tokens.
abstract interface class AuthService implements AuthTokenProvider {
  factory AuthService(
    AuthTokenCache cache,
    UserObserver userObserver,
    AuthTokenGenerator authTokenGenerator,
  ) = AuthServiceImpl;
}

final class AuthServiceImpl implements AuthService {
  final AuthTokenCache _cache;
  final UserObserver _userObserver;
  final AuthTokenGenerator _authTokenGenerator;

  final _rbacTokenLock = Lock();

  AuthServiceImpl(
    this._cache,
    this._userObserver,
    this._authTokenGenerator,
  );

  Future<bool> get _isUnlocked async {
    final keychain = _userObserver.user.activeAccount?.keychain;
    return await keychain?.isUnlocked ?? false;
  }

  @override
  Future<RbacToken?> createRbacToken({
    bool forceRefresh = false,
  }) {
    return _rbacTokenLock.synchronized(() async {
      return _createRbacToken(forceRefresh: forceRefresh);
    });
  }

  Future<RbacToken?> _createRbacToken({
    required bool forceRefresh,
  }) async {
    if (!await _isUnlocked) {
      // the keychain is locked or not existing,
      // cannot generate a token
      return null;
    }

    final account = await _getAccount();

    if (!forceRefresh) {
      final cachedToken = await _cache.getRbac(id: account.catalystId);
      if (cachedToken != null) {
        return RbacToken(cachedToken);
      }
    }

    final token = await _createRbacTokenForAccount(account);
    await _cache.setRbac(token.value, id: account.catalystId);
    return token;
  }

  Future<RbacToken> _createRbacTokenForAccount(Account account) async {
    return account.keychain.getMasterKey().use((masterKey) async {
      return _authTokenGenerator.generate(
        masterKey: masterKey,
        catalystId: account.catalystId,
      );
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
