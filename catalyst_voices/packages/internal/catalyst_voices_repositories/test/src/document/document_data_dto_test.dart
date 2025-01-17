import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_data_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(DocumentDataDto, () {
    test('getProperty returns correct value for valid path', () {
      final json = {
        'title': 'Test Document',
        'content': {
          'text': 'This is a test.',
        },
        'tags': ['test', 'flutter'],
      };

      final dto = DocumentDataDto.fromJson(json);
      final nodeId = DocumentNodeId.root.child('content').child('text');

      expect(dto.getProperty(nodeId), 'This is a test.');
    });

    test('getProperty returns correct value for lists', () {
      final json = {
        'tags': ['test', 'flutter'],
      };

      final dto = DocumentDataDto.fromJson(json);
      final nodeId = DocumentNodeId.root.child('tags').child('1');

      expect(dto.getProperty(nodeId), 'flutter');
    });

    test('getProperty returns null for invalid path', () {
      final json = {
        'title': 'Test Document',
      };

      final dto = DocumentDataDto.fromJson(json);
      final nodeId = DocumentNodeId.root.child('content').child('text');

      expect(dto.getProperty(nodeId), isNull);
    });

    test('getProperty returns null for invalid list index', () {
      final json = {
        'tags': ['test', 'flutter'],
      };

      final dto = DocumentDataDto.fromJson(json);
      final nodeId = DocumentNodeId.root.child('tags').child('invalid_index');

      expect(dto.getProperty(nodeId), isNull);
    });

    test('getProperty returns null for accessing non-collection', () {
      final json = {
        'title': 'Test Document',
      };

      final dto = DocumentDataDto.fromJson(json);
      final nodeId = DocumentNodeId.root.child('title').child('extra');

      expect(dto.getProperty(nodeId), isNull);
    });
  });
}
