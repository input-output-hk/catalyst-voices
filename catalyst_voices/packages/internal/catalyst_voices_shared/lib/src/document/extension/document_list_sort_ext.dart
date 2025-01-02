import 'package:catalyst_voices_models/catalyst_voices_models.dart';

extension DocumentListSortExt<T extends DocumentNode> on List<T> {
  void sortByOrder(List<DocumentNodeId> order) {
    final orderMap = {
      for (var i = 0; i < order.length; i++) order[i]: i,
    };

    sort((a, b) {
      final aIndex = orderMap[a.nodeId] ?? double.maxFinite.toInt();
      final bIndex = orderMap[b.nodeId] ?? double.maxFinite.toInt();
      return aIndex.compareTo(bIndex);
    });
  }
}
