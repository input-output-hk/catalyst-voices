import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_data_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_schema_dto.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixture/voices_document_templates.dart';
import '../utils/test_factories.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(
    ProposalDocument,
    () {
      late Map<String, dynamic> schemaJson;
      late Map<String, dynamic> documentJson;

      setUpAll(() async {
        schemaJson = await VoicesDocumentsTemplates.proposalF14Schema;
        documentJson = await VoicesDocumentsTemplates.proposalF14Document;
      });

      ProposalDocument createProposalDocument() {
        final documentDto = DocumentDto.fromJsonSchema(
          DocumentDataContentDto.fromJson(documentJson),
          DocumentSchemaDto.fromJson(schemaJson).toModel(),
        );
        final document = documentDto.toModel();
        final categoryRef = DocumentRefFactory.signedDocumentRef();

        return ProposalDocument(
          metadata: ProposalMetadata(
            selfRef: DocumentRefFactory.draftRef(),
            templateRef: DocumentRefFactory.signedDocumentRef(),
            parameters: DocumentParameters({categoryRef}),
            authors: const [],
          ),
          document: document,
        );
      }

      test('allNodeIds can be resolved in the document template', () {
        final proposalDocument = createProposalDocument();
        final document = proposalDocument.document;

        for (final nodeId in ProposalDocument.allNodeIds) {
          final property = document.getProperty(nodeId);
          expect(
            property,
            isNotNull,
            reason:
                'Expected property {$nodeId} did not '
                'appear in the document template. '
                'Make sure to include it.',
          );
        }
      });

      test('authorName can be extracted from document', () {
        final document = createProposalDocument();
        expect(
          document.authorName,
          isNotEmpty,
          reason:
              'Make sure the ${ProposalDocument.authorNameNodeId} '
              'property exists.',
        );
      });

      test('description can be extracted from document', () {
        final document = createProposalDocument();
        expect(
          document.description,
          isNotEmpty,
          reason:
              'Make sure the ${ProposalDocument.descriptionNodeId} '
              'property exists.',
        );
      });

      test('duration can be extracted from document', () {
        final document = createProposalDocument();
        expect(
          document.duration,
          isNotNull,
          reason:
              'Make sure the ${ProposalDocument.durationNodeId} '
              'property exists.',
        );
      });

      test('fundsRequested can be extracted from document', () {
        final document = createProposalDocument();
        expect(
          document.fundsRequested,
          isNotNull,
          reason:
              'Make sure the ${ProposalDocument.requestedFundsNodeId} '
              'property exists.',
        );
      });

      test('milestoneCount can be extracted from document', () {
        final document = createProposalDocument();
        expect(
          document.milestoneCount,
          isNotNull,
          reason:
              'Make sure the ${ProposalDocument.milestoneListNodeId} '
              'property exists.',
        );
      });

      test('tag can be extracted from document', () {
        final document = createProposalDocument();
        expect(
          document.tag,
          isNotEmpty,
          reason:
              'Make sure the ${ProposalDocument.tagNodeId} '
              'property exists.',
        );
      });

      test('title can be extracted from document', () {
        final document = createProposalDocument();
        expect(
          document.title,
          isNotEmpty,
          reason:
              'Make sure the ${ProposalDocument.titleNodeId} '
              'property exists.',
        );
      });
    },
    // Skip on web as there is no way to access local files required for
    // those tests to run against template.
    skip: CatalystPlatform.isWeb,
  );
}
