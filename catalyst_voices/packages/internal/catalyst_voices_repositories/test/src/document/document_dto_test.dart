import 'dart:convert';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_schema_dto.dart';
import 'package:test/test.dart';

import '../../helpers/read_json.dart';

void main() {
  group(DocumentDto, () {
    const schemaPath =
        'test/assets/0ce8ab38-9258-4fbc-a62e-7faa6e58318f.schema.json';
    const documentPath = 'test/assets/generic_proposal.json';

    late Map<String, dynamic> schemaJson;
    late Map<String, dynamic> documentJson;

    setUpAll(() {
      schemaJson = json.decode(readJson(schemaPath)) as Map<String, dynamic>;
      documentJson =
          json.decode(readJson(documentPath)) as Map<String, dynamic>;
    });

    test('Converts segments list into object for JSON', () {
      final schemaDto = DocumentSchemaDto.fromJson(schemaJson);
      final schema = schemaDto.toModel();

      final document = Document.fromSchema(schema);
      final documentDto = DocumentDto.fromModel(document);
      final documentJson = documentDto.toJson();

      for (final segment in documentDto.segments) {
        expect(documentJson[segment.schema.id], isA<Map<String, dynamic>>());
      }
    });

    test('Converts object from JSON into List of segments', () {
      final schemaDto = DocumentSchemaDto.fromJson(schemaJson);
      final schema = schemaDto.toModel();

      final document = Document.fromSchema(schema);
      final documentDto = DocumentDto.fromModel(document);

      final documentJson = documentDto.toJson();
      final documentDtoFromJson =
          DocumentDto.fromJsonSchema(documentJson, schema);

      expect(
        documentDtoFromJson.segments.length,
        documentDto.segments.length,
      );
    });

    test('After serialization $DocumentPropertyDto has correct type', () {
      final schemaDto = DocumentSchemaDto.fromJson(schemaJson);
      final schema = schemaDto.toModel();

      final documentDto = DocumentDto.fromJsonSchema(documentJson, schema);

      final agreementSegment = documentDto.segments
          .indexWhere((e) => e.schema.nodeId.paths.last == 'agreements');
      expect(agreementSegment, isNot(equals(-1)));
      final agreementSections = documentDto.segments[agreementSegment].sections;
      expect(
        agreementSections.first.properties.first.value,
        isA<bool?>(),
      );
      expect(agreementSections.first.properties.first.value, true);
    });
  });
}
