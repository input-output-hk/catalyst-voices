extension MapFilterExtension<K, V> on Map<K, V> {
  Map<K, V> useKeys(List<K> keys) {
    return Map.fromEntries(
      entries.where((entry) => keys.contains(entry.key)),
    );
  }
}
