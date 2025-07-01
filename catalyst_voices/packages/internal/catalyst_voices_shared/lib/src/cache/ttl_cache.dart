import 'dart:async';

import 'package:catalyst_voices_shared/src/cache/cache.dart';

/// An interface of a [Cache] that keeps the data only for the ttl duration.
abstract interface class TtlCache<K, V> implements Cache<K, V> {
  FutureOr<void> extendExpiration({
    required K key,
    Duration? ttl,
  });

  Future<bool> isAboutToExpire({
    required K key,
    required Duration tolerance,
  });

  Future<bool> isExpired({required K key});

  @override
  FutureOr<void> set(
    V value, {
    required K key,
    Duration? ttl,
  });
}
