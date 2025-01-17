import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_schema_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(DocumentSchemaDto, () {
    late Map<String, dynamic> schemaJson;

    setUpAll(() async {
      schemaJson = await VoicesDocumentsTemplates.proposalF14Schema;
    });

    test('X-order of segments is kept in model class', () async {
      final schemaDto = DocumentSchemaDto.fromJson(schemaJson);

      final schema = schemaDto.toModel();

      if (schemaDto.order?.length != schema.segments.length) {
        return;
      }
      for (var i = 0; i < schema.segments.length; i++) {
        expect(schema.segments[i].id, schemaDto.order?[i]);
      }
    });

    test('X-order of section is kept in model class', () {
      final schemaDto = DocumentSchemaDto.fromJson(schemaJson);
      final schema = schemaDto.toModel();

      for (var i = 0; i < schema.segments.length; i++) {
        if (schemaDto.segments[i].order?.length !=
            schema.segments[i].sections.length) {
          continue;
        }
        for (var j = 0; j < schema.segments[i].sections.length; j++) {
          expect(
            schema.segments[i].sections[j].id,
            schemaDto.segments[i].order?[j],
          );
        }
      }
    });

    test('Check if every segment has a SegmentDefinition as ref', () {
      final schemaDto = DocumentSchemaDto.fromJson(schemaJson);
      final schema = schemaDto.toModel();

      for (final segment in schema.segments) {
        expect(segment.definition, isA<SegmentDefinition>());
      }
    });
  });
}
