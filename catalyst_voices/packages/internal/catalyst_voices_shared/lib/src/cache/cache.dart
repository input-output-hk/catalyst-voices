import 'dart:async';

abstract interface class Cache<K, V> {
  FutureOr<bool> contains({required K key});

  FutureOr<V?> get({required K key});

  FutureOr<void> set(
    V value, {
    required K key,
  });

  FutureOr<void> delete({required K key});

  FutureOr<void> clear();
}
