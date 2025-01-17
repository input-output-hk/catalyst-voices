import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_schema_property_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(DocumentSchemaPropertyDto, () {
    late Map<String, dynamic> schemaJson;

    setUpAll(() async {
      schemaJson = await VoicesDocumentsTemplates.proposalF14Schema;
    });

    test('includeIfNull does not add keys for values that are null', () {
      // Given
      const dto = DocumentSchemaPropertyDto(
        ref: '#/definitions/section',
        id: 'solution',
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
        final dto = DocumentSchemaPropertyDto.fromJson(json);

        // Then
        expect(dto.ref, '#/definitions/singleGroupedTagSelector');
        expect(
          dto.oneOf,
          allOf(isNotNull, hasLength(13)),
        );

        for (final group in dto.oneOf!) {
          expect(group.conditions, hasLength(2));
          expect(group.conditions![0].id, 'group');
          expect(group.conditions![1].id, 'tag');
        }
      });
    });
  });
}
