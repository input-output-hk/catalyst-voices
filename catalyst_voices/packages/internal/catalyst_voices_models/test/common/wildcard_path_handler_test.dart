import 'package:catalyst_voices_models/src/common/node_id.dart';
import 'package:catalyst_voices_models/src/common/wildcard_path_handler.dart';
import 'package:test/test.dart';

void main() {
  group(WildcardPathHandler, () {
    test('returns null for paths without wildcards', () {
      const handler = WildcardPathHandler('node1.node2');
      expect(handler.getWildcardPaths, isNull);
    });

    test('returns correct segments for path with one wildcard', () {
      const handler = WildcardPathHandler('node1.*.node3');
      final result = handler.getWildcardPaths;
      expect(
        result,
        (prefix: const NodeId('node1'), suffix: const NodeId('node3')),
      );
    });

    test('handles wildcard at the beginning', () {
      const handler = WildcardPathHandler('*.node2.node3');
      final result = handler.getWildcardPaths;
      expect(
        result,
        (prefix: const NodeId(''), suffix: const NodeId('node2.node3')),
      );
    });

    test('handles wildcard at the end', () {
      const handler = WildcardPathHandler('node1.node2.*');
      final result = handler.getWildcardPaths;
      expect(result, (prefix: const NodeId('node1.node2'), suffix: null));
    });
  });
}
