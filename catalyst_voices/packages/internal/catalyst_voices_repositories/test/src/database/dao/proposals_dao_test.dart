import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/proposals_dao.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_metadata.dart';
import 'package:catalyst_voices_repositories/src/dto/proposal/proposal_submission_action_dto.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid_plus/uuid_plus.dart';

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
            action: ProposalSubmissionActionDto.aFinal,
            proposalRef: ref,
          ),
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

      test(
          'returns zero final proposal if latest '
          'submission is draft', () async {
        // Given
        final ref = SignedDocumentRef.generateFirstRef();
        final proposals = [
          _buildProposal(selfRef: ref),
        ];
        final actions = [
          _buildProposalAction(
            selfRef: _buildRefAt(DateTime(2025, 04, 7)),
            action: ProposalSubmissionActionDto.aFinal,
            proposalRef: ref,
          ),
          _buildProposalAction(
            selfRef: _buildRefAt(DateTime(2025, 04, 8)),
            action: ProposalSubmissionActionDto.draft,
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

        expect(count.finals, 0);
      });

      test(
          'returns two final proposal when each have '
          'complex action history', () async {
        // Given
        final proposalOneRef = SignedDocumentRef.generateFirstRef();
        final proposalTwoRef = SignedDocumentRef.generateFirstRef();
        final proposals = [
          _buildProposal(selfRef: proposalOneRef),
          _buildProposal(selfRef: proposalTwoRef),
        ];
        final actions = [
          _buildProposalAction(
            selfRef: _buildRefAt(DateTime(2025, 04, 1)),
            action: ProposalSubmissionActionDto.draft,
            proposalRef: proposalOneRef,
          ),
          _buildProposalAction(
            selfRef: _buildRefAt(DateTime(2025, 04, 2)),
            action: ProposalSubmissionActionDto.aFinal,
            proposalRef: proposalOneRef,
          ),
          _buildProposalAction(
            selfRef: _buildRefAt(DateTime(2025, 04, 7)),
            action: ProposalSubmissionActionDto.hide,
            proposalRef: proposalTwoRef,
          ),
          _buildProposalAction(
            selfRef: _buildRefAt(DateTime(2025, 04, 8)),
            action: ProposalSubmissionActionDto.aFinal,
            proposalRef: proposalTwoRef,
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

        expect(count.finals, 2);
      });

      test('returns calculated drafts and finals count', () async {
        // Given
        final proposalOneRef = SignedDocumentRef.generateFirstRef();
        final proposalTwoRef = SignedDocumentRef.generateFirstRef();
        final proposals = [
          _buildProposal(selfRef: proposalOneRef),
          _buildProposal(selfRef: proposalTwoRef),
        ];
        final actions = [
          _buildProposalAction(
            action: ProposalSubmissionActionDto.aFinal,
            proposalRef: proposalOneRef,
          ),
          _buildProposalAction(
            action: ProposalSubmissionActionDto.draft,
            proposalRef: proposalTwoRef,
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

        expect(count.total, 2);
        expect(count.drafts, 1);
        expect(count.finals, 1);
      });

      test('returns correct favorites count', () async {
        // Given
        final proposalOneRef = SignedDocumentRef.generateFirstRef();
        final proposalTwoRef = SignedDocumentRef.generateFirstRef();
        final proposals = [
          _buildProposal(selfRef: proposalOneRef),
          _buildProposal(selfRef: proposalTwoRef),
        ];
        final favorites = [
          _buildProposalFavorite(proposalRef: proposalOneRef),
        ];

        const filters = ProposalsCountFilters();

        // When
        await database.documentsDao.saveAll(proposals);
        for (final fav in favorites) {
          await database.favoritesDao.save(fav);
        }

        // Then
        final count = await database.proposalsDao
            .watchCount(
              filters: filters,
            )
            .first;

        expect(count.total, 2);
        expect(count.favorites, 1);
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

DocumentFavoriteEntity _buildProposalFavorite({
  required DocumentRef proposalRef,
}) {
  final hilo = UuidHiLo.from(proposalRef.id);
  return DocumentFavoriteEntity(
    idHi: hilo.high,
    idLo: hilo.low,
    isFavorite: true,
    type: DocumentType.proposalDocument,
  );
}

SignedDocumentRef _buildRefAt(DateTime dateTime) {
  final config = V7Options(dateTime.millisecondsSinceEpoch, null);
  final val = const Uuid().v7(config: config);
  return SignedDocumentRef.first(val);
}
