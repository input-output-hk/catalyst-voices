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

    test(
      'Roundtrip from json string to dto and reverse '
      'should result in the same document',
      () {
        final schema = DocumentSchemaDto.fromJson(schemaJson).toModel();

        // original
        final originalJsonString = json.encode(documentJson);

        // serialized and deserialized
        final documentDto = DocumentDto.fromJsonSchema(documentJson, schema);
        final documentDtoJson = documentDto.toJson();
        final serializedJsonString = json.encode(documentDtoJson);

        // verify they are the same
        expect(serializedJsonString, equals(originalJsonString));
      },
      // TODO(dtscalac): fix parsing the document and enable this test
      // the reason it fails is that we are ignoring some properties
      // and not outputting them back but they are present in the original doc
    );

    test(
        'Roundtrip from json to model and reverse '
        'should result in the same document', () {
      final schema = DocumentSchemaDto.fromJson(schemaJson).toModel();

      // original
      final originalDocDto = DocumentDto.fromJsonSchema(documentJson, schema);
      final originalDoc = originalDocDto.toModel();

      // serialized and deserialized
      final serializedDocJson = DocumentDto.fromModel(originalDoc).toJson();
      final deserializedDocDto =
          DocumentDto.fromJsonSchema(serializedDocJson, schema);
      final deserializedDoc = deserializedDocDto.toModel();

      // verify they are the same
      expect(deserializedDoc, equals(originalDoc));
    });

    test('Converts segments list into object for JSON', () {
      final schemaDto = DocumentSchemaDto.fromJson(schemaJson);
      final schema = schemaDto.toModel();

      final document = DocumentBuilder.fromSchema(
        schemaUrl: schemaPath,
        schema: schema,
      ).build();

      final documentDto = DocumentDto.fromModel(document);
      final documentJson = documentDto.toJson();

      for (final segment in documentDto.segments) {
        expect(documentJson[segment.schema.id], isA<Map<String, dynamic>>());
      }
    });

    test('Converts object from JSON into List of segments', () {
      final schemaDto = DocumentSchemaDto.fromJson(schemaJson);
      final schema = schemaDto.toModel();

      final document = DocumentBuilder.fromSchema(
        schemaUrl: schemaPath,
        schema: schema,
      ).build();

      final documentDto = DocumentDto.fromModel(document);

      final documentJson = documentDto.toJson();
      final documentDtoFromJson =
          DocumentDto.fromJsonSchema(documentJson, schema);

      expect(
        documentDtoFromJson.segments.length,
        documentDto.segments.length,
      );
    });

    test('After serialization $DocumentPropertyValueDto has correct type', () {
      final schemaDto = DocumentSchemaDto.fromJson(schemaJson);
      final schema = schemaDto.toModel();

      final documentDto = DocumentDto.fromJsonSchema(documentJson, schema);

      final agreementSegment = documentDto.segments
          .indexWhere((e) => e.schema.nodeId.paths.last == 'agreements');
      expect(agreementSegment, isNot(equals(-1)));
      final agreementSections = documentDto.segments[agreementSegment].sections;
      final agreementProperty = agreementSections.first.properties.first
          as DocumentPropertyValueDto<Object>;
      expect(agreementProperty.value, true);
    });
  });
}
