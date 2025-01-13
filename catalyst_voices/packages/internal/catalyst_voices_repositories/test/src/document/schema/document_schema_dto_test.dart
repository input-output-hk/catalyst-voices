import 'dart:convert';
import 'dart:io';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_schema_dto.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

void main() {
  group(DocumentSchemaDto, () {
    late Map<String, dynamic> schemaJson;

    final id = const Uuid().v7();
    final version = const Uuid().v7();

    setUpAll(() {
      final encodedSchema = File(Paths.f14ProposalSchema).readAsStringSync();

      schemaJson = json.decode(encodedSchema) as Map<String, dynamic>;
    });

    test('X-order of segments is kept in model class', () async {
      final schemaDto = DocumentSchemaDto.fromJson(schemaJson);

      final schema = schemaDto.toModel(
        documentId: id,
        documentVersion: version,
      );

      if (schemaDto.order?.length != schema.segments.length) {
        return;
      }
      for (var i = 0; i < schema.segments.length; i++) {
        expect(schema.segments[i].id, schemaDto.order?[i]);
      }
    });

    test('X-order of section is kept in model class', () {
      final schemaDto = DocumentSchemaDto.fromJson(schemaJson);
      final schema = schemaDto.toModel(
        documentId: id,
        documentVersion: version,
      );

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
      final schema = schemaDto.toModel(
        documentId: id,
        documentVersion: version,
      );

      for (final segment in schema.segments) {
        expect(segment.definition, isA<SegmentDefinition>());
      }
    });
  });
}
