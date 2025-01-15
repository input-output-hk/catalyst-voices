import 'dart:convert';

import 'package:catalyst_voices_repositories/src/dto/document/schema/document_property_schema_dto.dart';
import 'package:test/test.dart';

import '../../../helpers/read_json.dart';

void main() {
  group(DocumentPropertySchemaDto, () {
    const schemaPath =
        'test/assets/0ce8ab38-9258-4fbc-a62e-7faa6e58318f.schema.json';

    late Map<String, dynamic> schemaJson;

    setUpAll(() {
      schemaJson = json.decode(readJson(schemaPath)) as Map<String, dynamic>;
    });

    test('includeIfNull does not add keys for values that are null', () {
      // Given
      const dto = DocumentPropertySchemaDto(
        ref: '#/definitions/section',
      );

      const expectedJson = {
        r'$ref': '#/definitions/section',
      };

      // When
      final json = dto.toJson();

      // Then
      expect(json, expectedJson);
    });

    group('grouped_tag', () {
      test('oneOf is parsed correctly', () {
        // Given
        // ignore: avoid_dynamic_calls
        final json = schemaJson['properties']['horizons']['properties']['theme']
            ['properties']['grouped_tag'] as Map<String, dynamic>
          ..['id'] = 'grouped_tag';

        // When
        final dto = DocumentPropertySchemaDto.fromJson(json);

        // Then
        expect(dto.ref, '#/definitions/singleGroupedTagSelector');
        expect(
          dto.oneOf,
          allOf(isNotNull, hasLength(13)),
        );

        // for (final group in dto.oneOf!) {
        //   expect(group.conditions, hasLength(2));
        //   expect(group.conditions![0], 'group');
        //   expect(group.conditions![1].id, 'tag');
        // }
      });
    });
  });
}
