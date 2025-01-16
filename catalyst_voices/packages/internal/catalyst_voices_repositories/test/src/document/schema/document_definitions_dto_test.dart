import 'package:catalyst_voices_repositories/src/dto/document/schema/document_definitions_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_property_schema_dto.dart';
import 'package:test/test.dart';

void main() {
  group(DocumentDefinitionsDto, () {
    test('fromJson should create a valid instance from JSON', () {
      final json = {
        'def1': {'title': 'Title 1'},
        'def2': {'title': 'Title 2'},
      };

      final dto = DocumentDefinitionsDto.fromJson(json);

      expect(dto.getDefinition('def1')?.title, 'Title 1');
      expect(dto.getDefinition('def2')?.title, 'Title 2');
    });

    test('toJson should convert instance to JSON correctly', () {
      final definitions = {
        'def1': const DocumentPropertySchemaDto.optional(title: 'Title 1'),
        'def2': const DocumentPropertySchemaDto.optional(title: 'Title 2'),
      };

      final dto = DocumentDefinitionsDto(definitions);
      final json = dto.toJson();

      expect((json['def1'] as Map)['title'], 'Title 1');
      expect((json['def2'] as Map)['title'], 'Title 2');
    });

    test('getDefinition should return the correct definition', () {
      final definitions = {
        'def1': const DocumentPropertySchemaDto.optional(title: 'Title 1'),
      };

      final dto = DocumentDefinitionsDto(definitions);

      expect(dto.getDefinition('def1')?.title, 'Title 1');
      expect(dto.getDefinition('def2'), isNull);
    });

    test('getDefinition should return null for non-existent definition', () {
      final definitions = {
        'def1': const DocumentPropertySchemaDto.optional(title: 'Title 1'),
      };

      final dto = DocumentDefinitionsDto(definitions);

      expect(dto.getDefinition('non_existent'), isNull);
    });
  });
}
