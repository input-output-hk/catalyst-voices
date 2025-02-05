import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_schema_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(DocumentSchemaDto, () {
    late Map<String, dynamic> schemaJson;

    setUpAll(() async {
      schemaJson = await VoicesDocumentsTemplates.proposalF14Schema;
    });

    test('document schema can be decoded and encoded', () {
      final originalSchema = DocumentSchemaDto.fromJson(schemaJson);
      final originalModel = originalSchema.toModel();
      expect(originalModel.properties, isNotEmpty);

      final encodedSchema = originalSchema.toJson();
      expect(encodedSchema, isNotEmpty);

      final recodedSchema = DocumentSchemaDto.fromJson(encodedSchema);
      final recodedModel = recodedSchema.toModel();
      expect(recodedModel, equals(originalModel));
    });
  });
}
