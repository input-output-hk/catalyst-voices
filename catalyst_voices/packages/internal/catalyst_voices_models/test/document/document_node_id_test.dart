import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:test/test.dart';

void main() {
  group(DocumentNodeId, () {
    const paths = ['setup', 'title', 'title'];

    test('paths getter returns expected values', () {
      // Given

      // When
      final nodeId = paths.fold(
        DocumentNodeId.root,
        (previousValue, element) => previousValue.child(element),
      );

      // Then
      expect(nodeId.paths.skip(1), paths);
    });

    test('two nodes from same paths equals', () {
      // Given

      // When
      final nodeIdOne = paths.fold(
        DocumentNodeId.root,
        (previousValue, element) => previousValue.child(element),
      );
      final nodeIdTwo = paths.fold(
        DocumentNodeId.root,
        (previousValue, element) => previousValue.child(element),
      );

      // Then
      expect(nodeIdOne, nodeIdTwo);
    });

    test('parent works as expected', () {
      // Given
      final parentPaths = paths.sublist(0, paths.length - 1);

      // When
      final nodeId = paths.fold(
        DocumentNodeId.root,
        (previousValue, element) => previousValue.child(element),
      );
      final parentNodeId = parentPaths.fold(
        DocumentNodeId.root,
        (previousValue, element) => previousValue.child(element),
      );

      // Then
      expect(nodeId.parent(), parentNodeId);
    });

    test('isChildOf returns true for correct parent', () {
      // Given
      final parentPaths = paths.sublist(0, paths.length - 1);

      // When
      final nodeId = paths.fold(
        DocumentNodeId.root,
        (previousValue, element) => previousValue.child(element),
      );
      final parentNodeId = parentPaths.fold(
        DocumentNodeId.root,
        (previousValue, element) => previousValue.child(element),
      );

      // Then
      expect(nodeId.isChildOf(parentNodeId), isTrue);
    });

    test('isChildOf returns false for different parent', () {
      // Given
      final parentPaths = [...paths]..[0] = 'summary';

      // When
      final nodeId = paths.fold(
        DocumentNodeId.root,
        (previousValue, element) => previousValue.child(element),
      );
      final parentNodeId = parentPaths.fold(
        DocumentNodeId.root,
        (previousValue, element) => previousValue.child(element),
      );

      // Then
      expect(nodeId.isChildOf(parentNodeId), isFalse);
    });
  });
}
