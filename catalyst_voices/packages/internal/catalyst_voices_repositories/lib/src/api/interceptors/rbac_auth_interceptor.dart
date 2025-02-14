import 'dart:async';

import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:chopper/chopper.dart';

/* cSpell:disable */
const _key =
    'catv1.UJm5ZNT1n7l3_h3c3VXp1R9QAZStRmrxdtYwTrdsxKWIF1hAi3mqbz6dPNiICQCko'
    'XWJs8KCpcaPuE7LE5Iu9su0ZweK_0Qr9KhBNNHrDMCh79-fruK7WyNPYNc6FrjwTPaIAQ';
/* cSpell:enable */

final class RbacAuthInterceptor implements Interceptor {
  final ActiveAccountProvider _activeAccountProvider;

  const RbacAuthInterceptor(this._activeAccountProvider);

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    final keychain = _activeAccountProvider.account?.keychain;
    final isUnlocked = await keychain?.isUnlocked;

    var request = chain.request;

    if (isUnlocked ?? false) {
      // TODO(damian-molinski): key should come from keychain
      request = applyHeader(request, 'Authorization', 'Bearer $_key');
    }

    return chain.proceed(request);
  }
}
