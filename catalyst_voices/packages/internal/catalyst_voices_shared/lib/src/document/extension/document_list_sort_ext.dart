import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

extension DocumentListSortExt<T extends Identifiable> on List<T> {
  void sortByOrder(List<String> order) {
    final orderMap = {
      for (var i = 0; i < order.length; i++) order[i]: i,
    };

    sort((a, b) {
      final aIndex = orderMap[a.id] ?? double.maxFinite.toInt();
      final bIndex = orderMap[b.id] ?? double.maxFinite.toInt();
      return aIndex.compareTo(bIndex);
    });
  }
}
