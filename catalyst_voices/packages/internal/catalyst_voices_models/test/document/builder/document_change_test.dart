import 'package:catalyst_voices_models/src/document/builder/document_change.dart';
import 'package:catalyst_voices_models/src/document/document_node_id.dart';
import 'package:test/test.dart';

void main() {
  group(DocumentChange, () {
    final nodeId = DocumentNodeId.root.child('node1');
    final node = _DocumentNode(nodeId);

    test('targetsDocumentNode should return true for direct match', () {
      final change = DocumentValueChange(
        nodeId: DocumentNodeId.root.child('node1'),
        value: 'TestValue',
      );

      expect(change.targetsDocumentNode(node), isTrue);
    });

    test('targetsDocumentNode should return true for child match', () {
      final change = DocumentValueChange(
        nodeId: DocumentNodeId.root.child('node1').child('child1'),
        value: 'TestValue',
      );

      expect(change.targetsDocumentNode(node), isTrue);
    });

    test('targetsDocumentNode should return false for unrelated node', () {
      final change = DocumentValueChange(
        nodeId: DocumentNodeId.root.child('node2'),
        value: 'TestValue',
      );

      expect(change.targetsDocumentNode(node), isFalse);
    });
  });
}

class _DocumentNode implements DocumentNode {
  @override
  final DocumentNodeId nodeId;

  const _DocumentNode(this.nodeId);
}
