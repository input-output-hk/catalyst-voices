import 'dart:async';

import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

const _isUnlockedKey = 'IsUnlocked';

abstract interface class SecureStorageVaultCache {
  Future<bool> getIsUnlocked();

  Future<void> setIsUnlocked({required bool value});

  Future<bool> isUnlockedExpired();

  Future<void> extendIsUnlocked();
}

final class SecureStorageVaultTtlCache extends LocalTllCache
    implements SecureStorageVaultCache {
  SecureStorageVaultTtlCache({
    super.key,
    super.sharedPreferences,
    super.defaultTtl = const Duration(hours: 1),
  }) : super(
          allowList: {_isUnlockedKey},
        );

  @override
  Future<bool> getIsUnlocked() {
    return get(key: _isUnlockedKey).then((value) => value == 'true');
  }

  @override
  Future<void> setIsUnlocked({required bool value}) {
    return set('$value', key: _isUnlockedKey);
  }

  @override
  Future<bool> isUnlockedExpired() => isExpired(key: _isUnlockedKey);

  @override
  Future<void> extendIsUnlocked() => extendExpiration(key: _isUnlockedKey);
}
