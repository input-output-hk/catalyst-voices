import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(DocumentNodeTraverser, () {
    test('getValue retrieves nested value correctly', () {
      final nodeId = DocumentNodeId.fromString('user.name');
      final data = {
        'user': {'name': 'John Doe'},
      };

      expect(DocumentNodeTraverser.getValue(nodeId, data), 'John Doe');
    });

    test('getValue returns null for missing path', () {
      final nodeId = DocumentNodeId.fromString('user.age');
      final data = {
        'user': {'name': 'John Doe'},
      };

      expect(DocumentNodeTraverser.getValue(nodeId, data), isNull);
    });

    test('getValue retrieves value from list correctly', () {
      final nodeId = DocumentNodeId.fromString('users.1.name');
      final data = {
        'users': [
          {'name': 'Alice'},
          {'name': 'Bob'},
        ],
      };

      expect(DocumentNodeTraverser.getValue(nodeId, data), 'Bob');
    });

    test('getValue returns null for invalid list index', () {
      final nodeId = DocumentNodeId.fromString('users.invalid.name');
      final data = {
        'users': [
          {'name': 'Alice'},
          {'name': 'Bob'},
        ],
      };

      expect(DocumentNodeTraverser.getValue(nodeId, data), isNull);
    });

    test('getValue returns null for accessing non-map or non-list', () {
      final nodeId = DocumentNodeId.fromString('user.namefirst');
      final data = {
        'user': {'name': 'John Doe'},
      };

      expect(DocumentNodeTraverser.getValue(nodeId, data), isNull);
    });
  });
}
