import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/proposals_dao.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_metadata.dart';
import 'package:catalyst_voices_repositories/src/dto/proposal/proposal_submission_action_dto.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/test_factories.dart';

void main() {
  late DriftCatalystDatabase database;

  setUp(() {
    final inMemory = DatabaseConnection(NativeDatabase.memory());
    database = DriftCatalystDatabase(inMemory);
  });

  tearDown(() async {
    await database.close();
  });

  group(DriftProposalsDao, () {
    group('watchCount', () {
      test(
          'returns correct total number of '
          'proposals for empty filters', () async {
        // Given
        final proposals = [
          _buildProposal(),
          _buildProposal(),
        ];
        const filters = ProposalsCountFilters();

        // When
        await database.documentsDao.saveAll(proposals);

        // Then
        final count = await database.proposalsDao
            .watchCount(
              filters: filters,
            )
            .first;

        expect(count.total, proposals.length);
      });

      test(
          'when two versions of same proposal '
          'exists there are counted as one', () async {
        // Given
        final ref = SignedDocumentRef.generateFirstRef();
        final proposals = [
          _buildProposal(selfRef: ref),
          _buildProposal(selfRef: ref.nextVersion().toSignedDocumentRef()),
        ];
        const filters = ProposalsCountFilters();

        // When
        await database.documentsDao.saveAll(proposals);

        // Then
        final count = await database.proposalsDao
            .watchCount(
              filters: filters,
            )
            .first;

        expect(count.total, 1);
      });

      test('returns one final proposal if final submission is found', () async {
        // Given
        final ref = SignedDocumentRef.generateFirstRef();
        final proposals = [
          _buildProposal(selfRef: ref),
          _buildProposal(),
        ];
        final actions = [
          _buildProposalAction(
            action: ProposalSubmissionActionDto.aFinal,
            proposalRef: ref,
          ),
        ];
        const filters = ProposalsCountFilters();

        // When
        await database.documentsDao.saveAll([...proposals, ...actions]);

        // Then
        final count = await database.proposalsDao
            .watchCount(
              filters: filters,
            )
            .first;

        expect(count.finals, 1);
      });

      test(
          'returns one final proposal if final submission is '
          'latest action but old draft action exists', () async {
        // Given
        final ref = SignedDocumentRef.generateFirstRef();
        final proposals = [
          _buildProposal(selfRef: ref),
        ];
        final actions = [
          _buildProposalAction(
            action: ProposalSubmissionActionDto.draft,
            proposalRef: ref,
          ),
          _buildProposalAction(
            action: ProposalSubmissionActionDto.aFinal,
            proposalRef: ref,
          ),
        ];
        const filters = ProposalsCountFilters();

        // When
        await database.documentsDao.saveAll([...proposals, ...actions]);

        // Then
        final count = await database.proposalsDao
            .watchCount(
              filters: filters,
            )
            .first;

        expect(count.finals, 1);
      });
    });
  });
}

DocumentEntityWithMetadata _buildProposal({
  SignedDocumentRef? selfRef,
  String? title,
}) {
  final metadata = DocumentDataMetadata(
    type: DocumentType.proposalDocument,
    selfRef: selfRef ?? SignedDocumentRef.generateFirstRef(),
  );
  final content = DocumentDataContent({
    if (title != null) 'title': title,
  });

  final document = DocumentFactory.build(
    content: content,
    metadata: metadata,
  );

  final metadataEntities = [
    if (title != null)
      DocumentMetadataFactory.build(
        fieldKey: DocumentMetadataFieldKey.title,
        fieldValue: title,
      ),
  ];

  return (document: document, metadata: metadataEntities);
}

DocumentEntityWithMetadata _buildProposalAction({
  DocumentRef? selfRef,
  required ProposalSubmissionActionDto action,
  required DocumentRef proposalRef,
}) {
  final metadata = DocumentDataMetadata(
    type: DocumentType.proposalActionDocument,
    selfRef: selfRef ?? SignedDocumentRef.generateFirstRef(),
    ref: proposalRef,
  );
  final dto = ProposalSubmissionActionDocumentDto(action: action);
  final content = DocumentDataContent(dto.toJson());

  final document = DocumentFactory.build(
    content: content,
    metadata: metadata,
  );

  const metadataEntities = <DocumentMetadataEntity>[];

  return (document: document, metadata: metadataEntities);
}
