import 'dart:convert';

import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
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

        // original
        final originalJsonString = json.encode(documentJson);

        // serialized and deserialized
        final documentData = DocumentDataDto.fromJson(documentJson);
        final documentDto = DocumentDto.fromJsonSchema(documentData, schema);
        final documentDtoJson = documentDto.toJson();
        final serializedJsonString = json.encode(documentDtoJson);

        // verify they are the same
        expect(serializedJsonString, equals(originalJsonString));
      },
    );

    test(
        'Roundtrip from json to model and reverse '
        'should result in the same document', () {
      final schema = DocumentSchemaDto.fromJson(schemaJson).toModel();

      // original
      final originalDocData = DocumentDataDto.fromJson(documentJson);
      final originalDocDto =
          DocumentDto.fromJsonSchema(originalDocData, schema);
      final originalDoc = originalDocDto.toModel();

      // serialized and deserialized
      final serializeDocData = DocumentDto.fromModel(originalDoc).toJson();
      final deserializedDocDto =
          DocumentDto.fromJsonSchema(serializeDocData, schema);
      final deserializedDoc = deserializedDocDto.toModel();

      // verify they are the same
      expect(deserializedDoc, equals(originalDoc));
    });
  });
}
