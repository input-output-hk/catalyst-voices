import 'package:catalyst_voices_models/catalyst_voices_models.dart';
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

    group('wildcard matchesPattern support', () {
      test('matchesPattern supports wildcard segment', () {
        final pattern = DocumentNodeId.fromString('milestones.milestones.milestone_list.*.title');

        final node1 = DocumentNodeId.fromString('milestones.milestones.milestone_list.0.title');
        final node2 = DocumentNodeId.fromString('milestones.milestones.milestone_list.1.title');
        final node3 = DocumentNodeId.fromString('milestones.milestones.milestone_list.foo.title');
        final node4 = DocumentNodeId.fromString('milestones.milestones.milestone_list.title');

        expect(node1.matchesPattern(pattern), isTrue);
        expect(node2.matchesPattern(pattern), isTrue);
        expect(node3.matchesPattern(pattern), isTrue);
        expect(node4.matchesPattern(pattern), isFalse);
      });

      test('matchesPattern supports wildcard at start of path', () {
        final pattern = DocumentNodeId.fromString('*.title');

        final node1 = DocumentNodeId.fromString('milestones.milestones.milestone_list.0.title');
        final node2 = DocumentNodeId.fromString('milestones.milestones.milestone_list.title');
        final node3 = DocumentNodeId.fromString('milestones.milestones.milestone_list');

        expect(node1.matchesPattern(pattern), isTrue);
        expect(node2.matchesPattern(pattern), isTrue);
        expect(node3.matchesPattern(pattern), isFalse);
      });

      test('matchesPattern supports wildcard at end of path', () {
        final pattern = DocumentNodeId.fromString('milestones.*');

        final node1 = DocumentNodeId.fromString('milestones.milestones.milestone_list.0.title');
        final node2 = DocumentNodeId.fromString('milestones.milestones.milestone_list.title');
        final node3 = DocumentNodeId.fromString('milestone_list.title');

        expect(node1.matchesPattern(pattern), isTrue);
        expect(node2.matchesPattern(pattern), isTrue);
        expect(node3.matchesPattern(pattern), isFalse);
      });
    });
  });
}
