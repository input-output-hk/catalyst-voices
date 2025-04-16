import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_data_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_schema_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(ProposalDocument, () {
    late Map<String, dynamic> schemaJson;
    late Map<String, dynamic> documentJson;

    setUpAll(() async {
      schemaJson = await VoicesDocumentsTemplates.proposalF14Schema;
      documentJson = await VoicesDocumentsTemplates.proposalF14Document;
    });

    test('allNodeIds can be resolved in the document template', () {
      final documentDto = DocumentDto.fromJsonSchema(
        DocumentDataContentDto.fromJson(documentJson),
        DocumentSchemaDto.fromJson(schemaJson).toModel(),
      );
      final document = documentDto.toModel();

      for (final nodeId in ProposalDocument.allNodeIds) {
        final property = document.getProperty(nodeId);
        expect(
          property,
          isNotNull,
          reason: 'Expected property {$nodeId} did not '
              'appear in the document template. '
              'Make sure to include it.',
        );
      }
    });
  });
}
