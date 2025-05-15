import 'package:catalyst_voices_models/src/document/document_node_id.dart';
import 'package:test/test.dart';

void main() {
  group(DocumentNodeId, () {
    test('root node has no paths and empty value', () {
      expect(DocumentNodeId.root.paths, isEmpty);
      expect(DocumentNodeId.root.value, '');
    });

    test('child node adds path correctly', () {
      final childNode = DocumentNodeId.root.child('section1');
      expect(childNode.paths, ['section1']);
      expect(childNode.value, 'section1');
    });

    test('nested child nodes add paths correctly', () {
      final childNode =
          DocumentNodeId.root.child('section1').child('paragraph1');
      expect(childNode.paths, ['section1', 'paragraph1']);
      expect(childNode.value, 'section1.paragraph1');
    });

    test('lastPath returns the last path segment', () {
      final node = DocumentNodeId.root.child('section1').child('paragraph1');
      expect(node.lastPath, 'paragraph1');
    });

    test('parent returns correct parent node', () {
      final node = DocumentNodeId.root.child('section1').child('paragraph1');
      final parentNode = node.parent();
      expect(parentNode.paths, ['section1']);
      expect(parentNode.value, 'section1');
    });

    test('parent of root returns root itself', () {
      final parentOfRoot = DocumentNodeId.root.parent();
      expect(parentOfRoot, DocumentNodeId.root);
    });

    test('child node with empty string adds a path', () {
      final childNode = DocumentNodeId.root.child('');
      expect(childNode.paths, ['']);
      expect(childNode.value, '');
    });

    test('parent of a single child node returns root', () {
      final childNode = DocumentNodeId.root.child('section1');
      final parentNode = childNode.parent();
      expect(parentNode, DocumentNodeId.root);
    });

    test('multiple parent calls reduce paths step by step', () {
      final node = DocumentNodeId.root
          .child('section1')
          .child('paragraph1')
          .child('sentence1');
      final parentNode1 = node.parent();
      final parentNode2 = parentNode1.parent();
      expect(parentNode1.value, 'section1.paragraph1');
      expect(parentNode2.value, 'section1');
    });

    test('isChildOf correctly identifies child nodes', () {
      final parentNode = DocumentNodeId.root.child('section1');
      final childNode = parentNode.child('paragraph1');
      expect(childNode.isChildOf(parentNode), isTrue);
      expect(parentNode.isChildOf(childNode), isFalse);
    });

    test('toString outputs the value', () {
      final node = DocumentNodeId.root.child('section1').child('paragraph1');
      expect(node.toString(), 'section1.paragraph1');
    });
  });
}
