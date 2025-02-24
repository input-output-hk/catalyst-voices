import 'dart:async';

import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:chopper/chopper.dart';

/* cSpell:disable */
const _key =
    'catv1.UJm5ZNT1n7l3_h3c3VXp1R9QAZStRmrxdtYwTrdsxKWIF1hAi3mqbz6dPNiICQCko'
    'XWJs8KCpcaPuE7LE5Iu9su0ZweK_0Qr9KhBNNHrDMCh79-fruK7WyNPYNc6FrjwTPaIAQ';
/* cSpell:enable */

// TODO(damian-molinski): If token will be cached we may need to implement
//  handling 401 response.
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
      request = applyHeader(request, 'Authorization', 'Bearer $_key');
    }

    return chain.proceed(request);
  }
}
