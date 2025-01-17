import 'dart:convert';

import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_data_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_schema_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(DocumentDto, () {
    late Map<String, dynamic> schemaJson;
    late Map<String, dynamic> documentJson;

    setUpAll(() async {
      schemaJson = await VoicesDocumentsTemplates.proposalF14Schema;
      documentJson = await VoicesDocumentsTemplates.proposalF14Document;
    });

    test(
      'Roundtrip from json string to dto and reverse '
      'should result in the same document',
      () {
        final schema = DocumentSchemaDto.fromJson(schemaJson).toModel();
        final data = DocumentDataDto.fromJson(documentJson);

        // original
        final originalJsonString = json.encode(documentJson);

        // serialized and deserialized
        final documentDto = DocumentDto.fromJsonSchema(data, schema);
        final documentDtoJson = documentDto.toJson();
        final serializedJsonString = json.encode(documentDtoJson);

        // verify they are the same
        expect(serializedJsonString, equals(originalJsonString));
      },
      // TODO(dtscalac): fix parsing the document and enable this test
      // the reason it fails is that we are ignoring some properties
      // and not outputting them back but they are present in the original doc
      skip: true,
    );

    test(
        'Roundtrip from json to model and reverse '
        'should result in the same document', () {
      final schema = DocumentSchemaDto.fromJson(schemaJson).toModel();
      final data = DocumentDataDto.fromJson(documentJson);

      // original
      final originalDocDto = DocumentDto.fromJsonSchema(data, schema);
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
        schemaUrl: '',
        schema: schema,
      ).build();

      final documentDto = DocumentDto.fromModel(document);
      final documentData = documentDto.toJson();

      for (final segment in documentDto.segments) {
        final actual = documentData.json[segment.schema.id];
        expect(actual, isA<Map<String, dynamic>>());
      }
    });

    test('Converts object from JSON into List of segments', () {
      final schemaDto = DocumentSchemaDto.fromJson(schemaJson);
      final schema = schemaDto.toModel();

      final document = DocumentBuilder.fromSchema(
        schemaUrl: '',
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

    test('After serialization $DocumentPropertyDto has correct type', () {
      final schemaDto = DocumentSchemaDto.fromJson(schemaJson);
      final schema = schemaDto.toModel();
      final data = DocumentDataDto.fromJson(documentJson);

      final documentDto = DocumentDto.fromJsonSchema(data, schema);

      final agreementSegment = documentDto.segments
          .indexWhere((e) => e.schema.nodeId.paths.last == 'agreements');
      expect(agreementSegment, isNot(equals(-1)));
      final agreementSections = documentDto.segments[agreementSegment].sections;
      expect(
        agreementSections.first.properties.first.value,
        isA<bool>(),
      );
      expect(agreementSections.first.properties.first.value, true);
    });
  });
}
