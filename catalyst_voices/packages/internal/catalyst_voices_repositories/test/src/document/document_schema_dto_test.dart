import 'dart:convert';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_schema_dto.dart';
import 'package:test/test.dart';

import '../../helpers/read_json.dart';

void main() {
  group(DocumentSchemaDto, () {
    const schemaPath =
        'test/assets/0ce8ab38-9258-4fbc-a62e-7faa6e58318f.schema.json';

    late Map<String, dynamic> schemaJson;

    setUpAll(() {
      schemaJson = json.decode(readJson(schemaPath)) as Map<String, dynamic>;
    });

    test('X-order of segments is kept in model class', () async {
      final schemaDto = DocumentSchemaDto.fromJson(schemaJson);

      final schema = schemaDto.toModel();

      if (schemaDto.order?.length != schema.sortedSegments.length) {
        return;
      }
      for (var i = 0; i < schema.sortedSegments.length; i++) {
        expect(schema.sortedSegments[i].id, schemaDto.order?[i]);
      }
    });

    test('X-order of section is kept in model class', () {
      final schemaDto = DocumentSchemaDto.fromJson(schemaJson);
      final schema = schemaDto.toModel();

      for (var i = 0; i < schema.sortedSegments.length; i++) {
        if (schemaDto.segments[i].order?.length !=
            schema.sortedSegments[i].sortedSections.length) {
          continue;
        }
        for (var j = 0;
            j < schema.sortedSegments[i].sortedSections.length;
            j++) {
          expect(
            schema.sortedSegments[i].sortedSections[j].id,
            schemaDto.segments[i].order?[j],
          );
        }
      }
    });

    test('Check if every segment has a SegmentDefinition as ref', () {
      final schemaDto = DocumentSchemaDto.fromJson(schemaJson);
      final schema = schemaDto.toModel();

      for (final segment in schema.sortedSegments) {
        expect(segment.definition, isA<SegmentDefinition>());
      }
    });
  });
}
