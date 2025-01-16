import 'dart:convert';

import 'package:catalyst_voices_repositories/src/dto/document/schema/document_schema_dto.dart';
import 'package:test/test.dart';

import '../../../helpers/read_json.dart';

void main() {
  group(DocumentSchemaDto, () {
    const schemaPath =
        'test/assets/0ce8ab38-9258-4fbc-a62e-7faa6e58318f.schema.json';

    late Map<String, dynamic> schemaJson;

    setUpAll(() {
      schemaJson = json.decode(readJson(schemaPath)) as Map<String, dynamic>;
    });

    test('document schema can be decoded and encoded', () {
      final originalSchema = DocumentSchemaDto.fromJson(schemaJson);
      final originalModel = originalSchema.toModel();
      expect(originalModel.properties, isNotEmpty);

      final encodedSchema = originalSchema.toJson();
      expect(encodedSchema, isNotEmpty);

      final redecodedSchema = DocumentSchemaDto.fromJson(encodedSchema);
      final redecodedModel = redecodedSchema.toModel();
      expect(redecodedModel, equals(originalModel));
    });
  });
}
