import 'dart:math';

class PagingRange {
  const PagingRange();

  static ({int from, int to}) calculateRange({
    required int pageKey,
    required int itemsPerPage,
    required int maxResults,
  }) {
    if (maxResults == 0) {
      return (from: 0, to: 0);
    }
    final from = pageKey * itemsPerPage;
    final to = min(
      min(from + itemsPerPage - 1, maxResults - 1),
      maxResults - 1,
    );

    return (from: from, to: to);
  }
}
