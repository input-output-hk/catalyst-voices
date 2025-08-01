import 'dart:async';

import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart' show TtlCache;
import 'package:catalyst_voices_repositories/src/cache/ttl_cache.dart' show TtlCache;
import 'package:catalyst_voices_repositories/src/catalyst_voices_repositories.dart' show TtlCache;

/// A simple key-pair cache that stores data in the local storage.
///
/// Implementations might introduce a TTL-mechanisms such as cache expiration after a delay.
/// See [TtlCache].
abstract interface class Cache<K, V> {
  FutureOr<void> clear();

  FutureOr<bool> contains({required K key});

  FutureOr<void> delete({required K key});

  FutureOr<V?> get({required K key});

  FutureOr<void> set(
    V value, {
    required K key,
  });
}
