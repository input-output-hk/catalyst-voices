import 'package:catalyst_voices_repositories/src/dto/document/schema/document_schema_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixture/voices_document_templates.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(
    DocumentSchemaDto,
    () {
      group('ProposalTemplate', () {
        test('document schema can be decoded and encoded', () async {
          final schemaJson = await VoicesDocumentsTemplates.proposalF14Schema;
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

      group('CommentTemplate', () {
        test('schema can be decoded and encoded', () async {
          // Given
          final json = await VoicesDocumentsTemplates.commentF14Schema;

          // When
          final dto = DocumentSchemaDto.fromJson(json);
          final model = dto.toModel();

          // Then
          expect(dto.properties, isNotEmpty);

          final recodedSchema = DocumentSchemaDto.fromJson(dto.toJson());
          final recodedModel = recodedSchema.toModel();
          expect(recodedModel, model);
        });
      });
    },
    // Skip on web as there is no way to access local files required for
    // those tests to run against template.
    skip: kIsWeb,
  );
}
