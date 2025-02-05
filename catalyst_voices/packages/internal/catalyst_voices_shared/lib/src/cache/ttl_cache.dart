import 'dart:async';

import 'package:catalyst_voices_shared/src/cache/cache.dart';

abstract interface class TtlCache<K, V> implements Cache<K, V> {
  @override
  FutureOr<void> set(
    V value, {
    required K key,
    Duration? ttl,
  });

  Future<bool> isExpired({required K key});

  FutureOr<void> extendExpiration({
    required K key,
    Duration? ttl,
  });
}
