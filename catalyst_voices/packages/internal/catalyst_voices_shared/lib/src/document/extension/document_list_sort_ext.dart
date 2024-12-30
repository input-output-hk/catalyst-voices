/// Extracts an id from the [data].
typedef DocumentListIdGetter<T> = String Function(T data);

extension DocumentListSortExt<T> on List<T> {
  void sortByOrder(
    List<String> order, {
    required DocumentListIdGetter<T> id,
  }) {
    final orderMap = {
      for (var i = 0; i < order.length; i++) order[i]: i,
    };

    sort((a, b) {
      final aIndex = orderMap[id(a)] ?? double.maxFinite.toInt();
      final bIndex = orderMap[id(b)] ?? double.maxFinite.toInt();
      return aIndex.compareTo(bIndex);
    });
  }
}
