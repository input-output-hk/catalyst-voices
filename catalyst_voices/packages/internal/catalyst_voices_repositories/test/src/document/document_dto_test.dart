import 'dart:convert';

import 'package:catalyst_voices_repositories/src/dto/document/document_data_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_schema_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixture/voices_document_templates.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(
    DocumentDto,
    () {
      var schemaJson = <String, dynamic>{};
      var documentJson = <String, dynamic>{};

      setUpAll(() async {
        if (!kIsWeb) {
          schemaJson = await VoicesDocumentsTemplates.proposalF14Schema;
          documentJson = await VoicesDocumentsTemplates.proposalF14Document;
        }
      });

      test(
        'Roundtrip from json string to dto and reverse '
        'should result in the same document',
        () {
          final schema = DocumentSchemaDto.fromJson(schemaJson).toModel();

          // original
          final originalJsonString = json.encode(documentJson);

          // serialized and deserialized
          final documentContent = DocumentDataContentDto.fromJson(documentJson);
          final documentDto = DocumentDto.fromJsonSchema(documentContent, schema);
          final documentDtoJson = documentDto.toJson();
          final serializedJsonString = json.encode(documentDtoJson.data);

          // verify they are the same
          expect(serializedJsonString, equals(originalJsonString));
        },
      );

      test(
          'Roundtrip from json to model and reverse '
          'should result in the same document', () {
        final schema = DocumentSchemaDto.fromJson(schemaJson).toModel();

        // original
        final originalDocContent = DocumentDataContentDto.fromJson(documentJson);
        final originalDocDto = DocumentDto.fromJsonSchema(
          originalDocContent,
          schema,
        );
        final originalDoc = originalDocDto.toModel();

        // serialized and deserialized
        final serializeDocData = DocumentDto.fromModel(originalDoc).toJson();
        final deserializedDocDto = DocumentDto.fromJsonSchema(serializeDocData, schema);
        final deserializedDoc = deserializedDocDto.toModel();

        // verify they are the same
        expect(deserializedDoc, equals(originalDoc));
      });
    },
    // Skip on web as there is no way to access local files required for
    // those tests to run against template.
    skip: kIsWeb,
  );
}
