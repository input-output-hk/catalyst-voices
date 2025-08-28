import 'dart:async';

import 'package:catalyst_voices_repositories/src/cache/local_tll_cache.dart';

const _isUnlockedKey = 'IsUnlocked';

abstract interface class SecureStorageVaultCache {
  Future<void> clear();

  Future<bool> containsIsUnlocked();

  Future<void> extendIsUnlocked();

  Future<bool> getIsUnlocked();

  Future<bool> isUnlockedExpired();

  Future<void> setIsUnlocked({required bool value});
}

final class SecureStorageVaultTtlCache extends LocalTllCache implements SecureStorageVaultCache {
  SecureStorageVaultTtlCache({
    super.key,
    required super.sharedPreferences,
    super.defaultTtl = const Duration(hours: 1),
  }) : super(
         allowList: {_isUnlockedKey},
       );

  @override
  Future<bool> containsIsUnlocked() async => contains(key: _isUnlockedKey);

  @override
  Future<void> extendIsUnlocked() => extendExpiration(key: _isUnlockedKey);

  @override
  Future<bool> getIsUnlocked() {
    return get(key: _isUnlockedKey).then((value) => value == 'true');
  }

  @override
  Future<bool> isUnlockedExpired() => isExpired(key: _isUnlockedKey);

  @override
  Future<void> setIsUnlocked({required bool value}) {
    return set('$value', key: _isUnlockedKey);
  }
}
