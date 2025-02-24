import 'dart:async';

import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:chopper/chopper.dart';

/* cSpell:disable */
const _key =
    'catv1.UJm5ZNT1n7l3_h3c3VXp1R9QAZStRmrxdtYwTrdsxKWIF1hAi3mqbz6dPNiICQCko'
    'XWJs8KCpcaPuE7LE5Iu9su0ZweK_0Qr9KhBNNHrDMCh79-fruK7WyNPYNc6FrjwTPaIAQ';
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
