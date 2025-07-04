import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

/// Interface providing methods to get or set authentication tokens in cache.
abstract interface class AuthTokenCache {
  Future<String?> getRbac({required CatalystId id});

  Future<void> setRbac(String value, {required CatalystId id});
}

/// Local implementation of [AuthTokenCache] using [LocalTllCache].
final class LocalAuthTokenCache extends LocalTllCache implements AuthTokenCache {
  static const _maxTokenAge = Duration(hours: 1);

  LocalAuthTokenCache({
    required super.sharedPreferences,
  }) : super(
          key: 'LocalAuthCache',
        );

  @override
  Future<String?> getRbac({required CatalystId id}) async {
    if (await isAboutToExpire(key: id.asKey)) {
      return null;
    }
    return get(key: id.asKey);
  }

  @override
  Future<void> setRbac(String value, {required CatalystId id}) async {
    await set(value, key: id.asKey, ttl: _maxTokenAge);
  }
}

extension on CatalystId {
  String get asKey {
    return toSignificant().toUri().toStringWithoutScheme();
  }
}
