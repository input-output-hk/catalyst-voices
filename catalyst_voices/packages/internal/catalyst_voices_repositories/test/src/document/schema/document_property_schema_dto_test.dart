import 'package:catalyst_voices_repositories/src/dto/document/schema/document_property_schema_dto.dart';
import 'package:test/test.dart';

void main() {
  group(DocumentPropertySchemaDto, () {
    group('mergeWith', () {
      test('should merge two schemas with non-overlapping properties', () {
        const schema1 = DocumentPropertySchemaDto.optional(
          title: 'Title 1',
          description: 'Description 1',
        );

        const schema2 = DocumentPropertySchemaDto.optional(
          format: 'Format 2',
          contentMediaType: 'Media 2',
        );

        final merged = schema1.mergeWith(schema2);

        expect(merged.title, 'Title 1');
        expect(merged.description, 'Description 1');
        expect(merged.format, 'Format 2');
        expect(merged.contentMediaType, 'Media 2');
      });

      test('should prefer non-null properties from the original schema', () {
        const schema1 = DocumentPropertySchemaDto.optional(
          title: 'Title 1',
          format: 'Format 1',
        );

        const schema2 = DocumentPropertySchemaDto.optional(
          title: 'Title 2',
          format: 'Format 2',
        );

        final merged = schema1.mergeWith(schema2);

        expect(merged.title, 'Title 1');
        expect(merged.format, 'Format 1');
      });

      test('should merge nested properties correctly', () {
        const schema1 = DocumentPropertySchemaDto.optional(
          properties: {
            'prop1': DocumentPropertySchemaDto.optional(title: 'Prop1 Title'),
          },
        );

        const schema2 = DocumentPropertySchemaDto.optional(
          properties: {
            'prop2': DocumentPropertySchemaDto.optional(title: 'Prop2 Title'),
          },
        );

        final merged = schema1.mergeWith(schema2);

        expect(merged.properties!.length, 2);
        expect(merged.properties!['prop1']!.title, 'Prop1 Title');
        expect(merged.properties!['prop2']!.title, 'Prop2 Title');
      });

      test('should merge nested schemas recursively', () {
        const schema1 = DocumentPropertySchemaDto.optional(
          items: DocumentPropertySchemaDto.optional(title: 'Item Title 1'),
        );

        const schema2 = DocumentPropertySchemaDto.optional(
          items: DocumentPropertySchemaDto.optional(title: 'Item Title 2'),
        );

        final merged = schema1.mergeWith(schema2);

        expect(merged.items!.title, 'Item Title 1');
      });
    });

    group('definition', () {
      test('returns the correct ref', () {
        const dto = DocumentPropertySchemaDto.optional(
          ref: '#/definitions/singleLineTextEntry',
        );
        expect(dto.definition(), equals('singleLineTextEntry'));
      });
    });
  });
}
