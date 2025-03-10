import 'dart:async';

import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:chopper/chopper.dart';

/* cSpell:disable */
const _key =
    'catid.:1740660380@preprod.cardano/ycih6xARcuFGiRrtf1ETLWPvXGd_UBheZ4A5kcc'
    'WNAU.2CB_ByoGhZ8xBjLveK6jcGbKZ7_5TDjCwbTyNtHWFXnyKuvkTp9zo9tmBOVkPRbHjSw'
    'zx85kX3lIoGtKF3_dDQ';
/* cSpell:enable */

/// Token specification:
/// https://github.com/input-output-hk/catalyst-voices/blob/main/docs/src/catalyst-standards/permissionless-auth/auth-header.md
///
/// - 401: The token is either invalidly formatted, or we don't know who that is
/// (likely they have not registered on chain).
/// - 403: The token is valid, we know who they are but either the timestamp is
/// wrong (out of date) or the signature is wrong.
final class RbacAuthInterceptor implements Interceptor {
  final UserObserver _userObserver;

  const RbacAuthInterceptor(this._userObserver);

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    final keychain = _userObserver.user.activeAccount?.keychain;
    final isUnlocked = await keychain?.isUnlocked;

    var request = chain.request;

    if (isUnlocked ?? false) {
      // TODO(damian-molinski): key should come from keychain
      // TODO(damian-molinski): react to 401 and 403 statuses.
      request = applyHeader(request, 'Authorization', 'Bearer $_key');
    }

    return chain.proceed(request);
  }
}
