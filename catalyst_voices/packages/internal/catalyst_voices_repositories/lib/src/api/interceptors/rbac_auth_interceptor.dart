import 'dart:async';

import 'package:catalyst_voices_repositories/src/auth/auth_token_provider.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:chopper/chopper.dart';

/// Token specification:
/// https://github.com/input-output-hk/catalyst-voices/blob/main/docs/src/catalyst-standards/permissionless-auth/auth-header.md
///
/// - 401: The token is either invalidly formatted, or we don't know who that is
/// (likely they have not registered on chain).
/// - 403: The token is valid, we know who they are but either the timestamp is
/// wrong (out of date) or the signature is wrong.
final class RbacAuthInterceptor implements Interceptor {
  final UserObserver _userObserver;
  final AuthTokenProvider _authTokenProvider;

  const RbacAuthInterceptor(this._userObserver, this._authTokenProvider);

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    final keychain = _userObserver.user.activeAccount?.keychain;
    final isUnlocked = await keychain?.isUnlocked;

    var request = chain.request;

    if (isUnlocked ?? false) {
      // TODO(damian-molinski): react to 401 and 403 statuses.
      final token = await _authTokenProvider.createRbacToken();
      request = applyHeader(request, 'Authorization', 'Bearer $token');
    }

    return chain.proceed(request);
  }
}
