import 'dart:async';

import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

base class LocalTllCache extends LocalStorage
    implements TtlCache<String, String> {
  final Duration _defaultTtl;

  LocalTllCache({
    super.key = 'LocalTllCache',
    Set<String>? allowList,
    super.sharedPreferences,
    Duration defaultTtl = const Duration(minutes: 1),
  })  : _defaultTtl = defaultTtl,
        super(
          allowList: allowList != null ? _extendAllowList(allowList) : null,
        );

  @override
  Future<String?> get({
    required String key,
  }) async {
    final isExpired = await _isExpired(key: key);
    if (isExpired) {
      await delete(key: key);
      await delete(key: _buildExpireKey(key));
      return null;
    }

    return readString(key: key);
  }

  @override
  Future<void> set(
    String value, {
    required String key,
    Duration? ttl,
  }) async {
    await writeString(value, key: key);
    await extendExpiration(key: key, ttl: ttl);
  }

  @override
  Future<void> extendExpiration({
    required String key,
    Duration? ttl,
  }) async {
    if (!(await contains(key: key))) {
      throw ArgumentError(
        'Can not extend expiration for key[$key] because value is not set',
      );
    }

    final effectiveTtl = ttl ?? _defaultTtl;
    final now = DateTimeExt.now();
    final expireDate = await _readExpireDate(key: key);

    final updatedExpireDate = (expireDate ?? now).add(effectiveTtl);
    final expireDateTimestamp = updatedExpireDate.toIso8601String();
    final expireDateKey = _buildExpireKey(key);

    await writeString(expireDateTimestamp, key: expireDateKey);
  }

  Future<bool> _isExpired({required String key}) async {
    final expireDate = await _readExpireDate(key: key);
    final now = DateTimeExt.now();

    final other = expireDate ?? now;

    return now.isAfter(other) || now.isAtSameMomentAs(other);
  }

  Future<DateTime?> _readExpireDate({required String key}) async {
    final expireKey = _buildExpireKey(key);
    final expireTimestamp = await readString(key: expireKey);
    return DateTime.tryParse(expireTimestamp ?? '');
  }
}

String _buildExpireKey(String key) => '$key.expireDate';

Set<String> _extendAllowList(Set<String> allowList) {
  return allowList
      .expand((element) => [element, _buildExpireKey(element)])
      .toSet();
}
