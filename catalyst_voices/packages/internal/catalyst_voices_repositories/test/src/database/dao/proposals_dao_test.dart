import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/proposals_dao.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_metadata.dart';
import 'package:catalyst_voices_repositories/src/dto/proposal/proposal_submission_action_dto.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid_plus/uuid_plus.dart';

import '../../utils/test_factories.dart';

void main() {
  late DriftCatalystDatabase database;

  // ignore: unnecessary_lambdas
  setUpAll(() {
    DummyCatalystIdFactory.registerDummyKeyFactory();
  });

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
          'returns one final proposal when final submission is '
          'latest action but old draft action exists', () async {
        // Given
        final ref = SignedDocumentRef.generateFirstRef();
        final proposals = [
          _buildProposal(selfRef: ref),
        ];
        final actions = [
          _buildProposalAction(
            selfRef: _buildRefAt(DateTime(2025, 04, 1)),
            action: ProposalSubmissionActionDto.aFinal,
            proposalRef: ref,
          ),
          _buildProposalAction(
            selfRef: _buildRefAt(DateTime(2025, 04, 2)),
            action: ProposalSubmissionActionDto.draft,
            proposalRef: ref,
          ),
          _buildProposalAction(
            selfRef: _buildRefAt(DateTime(2025, 04, 8)),
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

      test('returns correct my count base on author', () async {
        // Given
        final userId = DummyCatalystIdFactory.create(username: 'damian');
        final proposalOneRef = SignedDocumentRef.generateFirstRef();
        final proposalTwoRef = SignedDocumentRef.generateFirstRef();
        final proposals = [
          _buildProposal(selfRef: proposalOneRef),
          _buildProposal(selfRef: proposalTwoRef, author: userId),
        ];

        final filters = ProposalsCountFilters(author: userId);

        // When
        await database.documentsDao.saveAll(proposals);

        // Then
        final count = await database.proposalsDao
            .watchCount(
              filters: filters,
            )
            .first;

        expect(count.total, 2);
        expect(count.my, 1);
      });

      test('returns correct count when only author filter is on', () async {
        // Given
        final userId = DummyCatalystIdFactory.create(username: 'damian');
        final proposalOneRef = SignedDocumentRef.generateFirstRef();
        final proposalTwoRef = SignedDocumentRef.generateFirstRef();
        final proposals = [
          _buildProposal(selfRef: proposalOneRef),
          _buildProposal(selfRef: proposalTwoRef, author: userId),
        ];
        final favorites = [
          _buildProposalFavorite(proposalRef: proposalOneRef),
        ];
        final actions = [
          _buildProposalAction(
            action: ProposalSubmissionActionDto.aFinal,
            proposalRef: proposalTwoRef,
          ),
        ];

        final filters = ProposalsCountFilters(
          author: userId,
          onlyAuthor: true,
        );
        const expectedCount = ProposalsCount(
          total: 1,
          drafts: 0,
          finals: 1,
          favorites: 0,
          my: 1,
        );

        // When
        await database.documentsDao.saveAll([...proposals, ...actions]);

        for (final fav in favorites) {
          await database.favoritesDao.save(fav);
        }

        // Then
        final count = await database.proposalsDao
            .watchCount(
              filters: filters,
            )
            .first;

        expect(count, expectedCount);
      });

      test('returns correct count when category filter is on', () async {
        // Given
        final userId = DummyCatalystIdFactory.create(username: 'damian');
        final categoryId = categoriesTemplatesRefs.first.category;

        final proposalOneRef = SignedDocumentRef.generateFirstRef();
        final proposalTwoRef = SignedDocumentRef.generateFirstRef();
        final proposals = [
          _buildProposal(
            selfRef: proposalOneRef,
            categoryId: categoriesTemplatesRefs[1].category,
          ),
          _buildProposal(
            selfRef: proposalTwoRef,
            author: userId,
            categoryId: categoryId,
          ),
        ];
        final favorites = [
          _buildProposalFavorite(proposalRef: proposalOneRef),
        ];
        final actions = [
          _buildProposalAction(
            action: ProposalSubmissionActionDto.aFinal,
            proposalRef: proposalTwoRef,
          ),
        ];

        final filters = ProposalsCountFilters(category: categoryId);
        const expectedCount = ProposalsCount(
          total: 1,
          drafts: 0,
          finals: 1,
          favorites: 0,
          my: 0,
        );

        // When
        await database.documentsDao.saveAll([...proposals, ...actions]);

        for (final fav in favorites) {
          await database.favoritesDao.save(fav);
        }

        // Then
        final count = await database.proposalsDao
            .watchCount(
              filters: filters,
            )
            .first;

        expect(count, expectedCount);
      });

      test('returns correct count when search query is not empty', () async {
        // Given
        final proposals = [
          _buildProposal(),
          _buildProposal(title: 'Explore'),
          _buildProposal(title: 'Not this one'),
        ];

        /* cSpell:disable */
        const filters = ProposalsCountFilters(searchQuery: 'Expl');
        /* cSpell:enable */
        const expectedCount = ProposalsCount(
          total: 1,
          drafts: 1,
          finals: 0,
          favorites: 0,
          my: 0,
        );

        // When
        await database.documentsDao.saveAll(proposals);

        // Then
        final count = await database.proposalsDao
            .watchCount(
              filters: filters,
            )
            .first;

        expect(count, expectedCount);
      });

      test('search is looking up author name in catalystId', () async {
        // Given
        const authorName = 'Damian';
        final search = authorName.substring(0, 2);
        final userId = DummyCatalystIdFactory.create(username: authorName);

        final proposals = [
          _buildProposal(contentAuthorName: 'Unknown'),
          _buildProposal(author: userId),
          _buildProposal(contentAuthorName: 'Other'),
        ];

        final filters = ProposalsCountFilters(searchQuery: search);
        const expectedCount = ProposalsCount(
          total: 1,
          drafts: 1,
          finals: 0,
          favorites: 0,
          my: 0,
        );

        // When
        await database.documentsDao.saveAll(proposals);

        // Then
        final count = await database.proposalsDao
            .watchCount(
              filters: filters,
            )
            .first;

        expect(count, expectedCount);
      });

      test('search is looking up author name in content', () async {
        // Given
        const authorName = 'Damian';
        final search = authorName.substring(0, 2);

        final proposals = [
          _buildProposal(contentAuthorName: 'Unknown'),
          _buildProposal(contentAuthorName: authorName),
          _buildProposal(contentAuthorName: 'Other'),
        ];

        final filters = ProposalsCountFilters(searchQuery: search);
        const expectedCount = ProposalsCount(
          total: 1,
          drafts: 1,
          finals: 0,
          favorites: 0,
          my: 0,
        );

        // When
        await database.documentsDao.saveAll(proposals);

        // Then
        final count = await database.proposalsDao
            .watchCount(
              filters: filters,
            )
            .first;

        expect(count, expectedCount);
      });
    });

    group('queryProposalsPage', () {
      test('only newest version of proposal is returned', () async {
        // Given
        final templateRef = SignedDocumentRef.generateFirstRef();

        final ref = _buildRefAt(DateTime(2025, 4, 7));
        final nextRef = _buildRefAt(DateTime(2025, 4, 8)).copyWith(id: ref.id);
        final latestRef =
            _buildRefAt(DateTime(2025, 4, 9)).copyWith(id: ref.id);

        final differentRef = _buildRefAt(DateTime(2025, 4, 12));

        final templates = [
          _buildProposalTemplate(selfRef: templateRef),
        ];

        final proposals = [
          _buildProposal(selfRef: ref, template: templateRef),
          _buildProposal(selfRef: nextRef, template: templateRef),
          _buildProposal(selfRef: latestRef, template: templateRef),
          _buildProposal(selfRef: differentRef, template: templateRef),
        ];
        const request = PageRequest(page: 0, size: 10);
        const filters = ProposalsFilters();

        final expectedRefs = [
          latestRef,
          differentRef,
        ];

        // When
        await database.documentsDao.saveAll([...templates, ...proposals]);

        // Then
        final page = await database.proposalsDao.queryProposalsPage(
          request: request,
          filters: filters,
        );

        expect(page.items.length, 2);
        expect(page.items.length, page.total);

        final proposalsRefs = page.items
            .map((e) => e.proposal)
            .map((entity) => entity.ref)
            .toList();

        expect(
          proposalsRefs,
          expectedRefs,
        );
      });

      test('proposals are split into pages correctly', () async {
        // Given
        final templateRef = SignedDocumentRef.generateFirstRef();

        final templates = [
          _buildProposalTemplate(selfRef: templateRef),
        ];

        final now = DateTime(2024, 4, 9);
        final proposals = List.generate(45, (index) {
          return _buildProposal(
            selfRef: _buildRefAt(now.subtract(Duration(days: index))),
            template: templateRef,
          );
        });
        const filters = ProposalsFilters();

        // When
        await database.documentsDao.saveAll([...templates, ...proposals]);

        // Then
        const firstRequest = PageRequest(page: 0, size: 25);
        final pageZero = await database.proposalsDao.queryProposalsPage(
          request: firstRequest,
          filters: filters,
        );

        expect(pageZero.page, 0);
        expect(pageZero.total, proposals.length);
        expect(pageZero.items.length, firstRequest.size);

        const secondRequest = PageRequest(page: 1, size: 25);

        final pageOne = await database.proposalsDao.queryProposalsPage(
          request: secondRequest,
          filters: filters,
        );

        expect(pageOne.page, 1);
        expect(pageOne.total, proposals.length);
        expect(pageOne.items.length, proposals.length - pageZero.items.length);
      });

      test('proposals category filter works as expected', () async {
        // Given
        final templateRef = SignedDocumentRef.generateFirstRef();
        final categoryId = categoriesTemplatesRefs.first.category;

        final templates = [
          _buildProposalTemplate(selfRef: templateRef),
        ];

        final proposals = [
          _buildProposal(
            selfRef: _buildRefAt(DateTime(2025, 4, 1)),
            template: templateRef,
            categoryId: categoryId,
          ),
          _buildProposal(
            selfRef: _buildRefAt(DateTime(2025, 4, 2)),
            template: templateRef,
            categoryId: categoryId,
          ),
          _buildProposal(
            selfRef: _buildRefAt(DateTime(2025, 4, 3)),
            template: templateRef,
            categoryId: categoryId,
          ),
          _buildProposal(
            template: templateRef,
            categoryId: categoriesTemplatesRefs[1].category,
          ),
        ];

        final expectedRefs = proposals
            .sublist(0, 3)
            .map((proposal) => proposal.document.ref)
            .toList();

        final filters = ProposalsFilters(category: categoryId);

        // When
        await database.documentsDao.saveAll([...templates, ...proposals]);

        // Then
        const request = PageRequest(page: 0, size: 25);
        final page = await database.proposalsDao.queryProposalsPage(
          request: request,
          filters: filters,
        );

        expect(page.page, 0);
        expect(page.total, 3);
        expect(page.items.map((e) => e.proposal.ref), expectedRefs);
      });

      test('final proposals filter works as expected', () async {
        // Given
        final templateRef = SignedDocumentRef.generateFirstRef();

        final templates = [
          _buildProposalTemplate(selfRef: templateRef),
        ];

        final proposalRef1 = _buildRefAt(DateTime(2025, 4, 1));
        final proposalRef2 = _buildRefAt(DateTime(2025, 4, 2));
        final proposalRef3 = _buildRefAt(DateTime(2025, 4, 3));

        final proposals = [
          _buildProposal(
            selfRef: proposalRef1,
            template: templateRef,
          ),
          _buildProposal(
            selfRef: proposalRef2,
            template: templateRef,
          ),
          _buildProposal(
            selfRef: proposalRef3,
            template: templateRef,
          ),
          _buildProposal(template: templateRef),
        ];

        final actions = [
          _buildProposalAction(
            action: ProposalSubmissionActionDto.aFinal,
            proposalRef: proposalRef1,
          ),
          _buildProposalAction(
            action: ProposalSubmissionActionDto.aFinal,
            proposalRef: proposalRef2,
          ),
        ];

        final expectedRefs = [
          proposalRef1,
          proposalRef2,
        ];

        const filters = ProposalsFilters(type: ProposalsFilterType.finals);

        // When
        await database.documentsDao.saveAll([
          ...templates,
          ...proposals,
          ...actions,
        ]);

        // Then
        const request = PageRequest(page: 0, size: 25);
        final page = await database.proposalsDao.queryProposalsPage(
          request: request,
          filters: filters,
        );

        expect(page.page, 0);
        expect(page.total, 2);
        expect(page.items.map((e) => e.proposal.ref), expectedRefs);
      });

      test('final proposals is one with latest action as final', () async {
        // Given
        final templateRef = SignedDocumentRef.generateFirstRef();

        final templates = [
          _buildProposalTemplate(selfRef: templateRef),
        ];

        final proposalRef1 = _buildRefAt(DateTime(2025, 4, 1));
        final proposalRef2 = _buildRefAt(DateTime(2025, 4, 2));
        final proposalRef3 = _buildRefAt(DateTime(2025, 4, 3));

        final proposals = [
          _buildProposal(
            selfRef: proposalRef1,
            template: templateRef,
          ),
          _buildProposal(
            selfRef: proposalRef2,
            template: templateRef,
          ),
          _buildProposal(
            selfRef: proposalRef3,
            template: templateRef,
          ),
          _buildProposal(template: templateRef),
        ];

        final actions = [
          _buildProposalAction(
            selfRef: _buildRefAt(DateTime(2025, 4, 5)),
            action: ProposalSubmissionActionDto.aFinal,
            proposalRef: proposalRef1,
          ),
          _buildProposalAction(
            selfRef: _buildRefAt(DateTime(2025, 4, 1)),
            action: ProposalSubmissionActionDto.draft,
            proposalRef: proposalRef1,
          ),
        ];

        final expectedRefs = [
          proposalRef1,
        ];

        const filters = ProposalsFilters(type: ProposalsFilterType.finals);

        // When
        await database.documentsDao.saveAll([
          ...templates,
          ...proposals,
          ...actions,
        ]);

        // Then
        const request = PageRequest(page: 0, size: 25);
        final page = await database.proposalsDao.queryProposalsPage(
          request: request,
          filters: filters,
        );

        expect(page.page, 0);
        expect(page.total, 1);
        expect(page.items.map((e) => e.proposal.ref), expectedRefs);
      });

      test('JoinedProposal is build correctly ', () async {
        // Given
        final templateRef = SignedDocumentRef.generateFirstRef();

        final templates = [
          _buildProposalTemplate(selfRef: templateRef),
        ];

        final proposalRef1 = _buildRefAt(DateTime(2025, 4, 1));
        final proposalRef2 =
            _buildRefAt(DateTime(2025, 4, 2)).copyWith(id: proposalRef1.id);
        final proposalRef3 =
            _buildRefAt(DateTime(2025, 4, 3)).copyWith(id: proposalRef1.id);

        final proposals = [
          _buildProposal(
            selfRef: proposalRef1,
            template: templateRef,
          ),
          _buildProposal(
            selfRef: proposalRef2,
            template: templateRef,
          ),
          _buildProposal(
            selfRef: proposalRef3,
            template: templateRef,
          ),
        ];

        final actions = [
          _buildProposalAction(
            selfRef: _buildRefAt(DateTime(2025, 4, 5)),
            action: ProposalSubmissionActionDto.aFinal,
            proposalRef: proposalRef2,
          ),
          _buildProposalAction(
            selfRef: _buildRefAt(DateTime(2025, 4, 1)),
            action: ProposalSubmissionActionDto.draft,
            proposalRef: proposalRef1,
          ),
        ];

        final comments = [
          _buildProposalComment(proposalRef: proposalRef1),
          _buildProposalComment(proposalRef: proposalRef2),
          _buildProposalComment(proposalRef: proposalRef2),
          _buildProposalComment(proposalRef: proposalRef3),
        ];

        const filters = ProposalsFilters();

        // When
        await database.documentsDao.saveAll([
          ...templates,
          ...proposals,
          ...actions,
          ...comments,
        ]);

        // Then
        const request = PageRequest(page: 0, size: 25);
        final page = await database.proposalsDao.queryProposalsPage(
          request: request,
          filters: filters,
        );

        expect(page.page, 0);
        expect(page.total, 1);

        final joinedProposal = page.items.single;

        expect(joinedProposal.proposal, proposals[1].document);
        expect(joinedProposal.template, templates[0].document);
        expect(joinedProposal.action, actions[0].document);
        expect(joinedProposal.commentsCount, 2);
        expect(
          joinedProposal.versions,
          proposals.map((e) => e.document.ref.version).toList().reversed,
        );
      });

      test(
        'search query is looking up catalystId and proposal content ',
        () async {
          // Given
          const authorName = 'Damian';
          final searchQuery = authorName.substring(0, 3);

          final templateRef = SignedDocumentRef.generateFirstRef();

          final templates = [
            _buildProposalTemplate(selfRef: templateRef),
          ];

          final proposals = [
            _buildProposal(
              template: templateRef,
              author: DummyCatalystIdFactory.create(username: authorName),
              title: '11',
            ),
            _buildProposal(
              template: templateRef,
              contentAuthorName: authorName,
              title: '22',
            ),
            _buildProposal(
              template: templateRef,
              contentAuthorName: 'Different one',
              title: 'Test',
            ),
          ];

          final expectedRefs = [
            proposals[0].document.metadata.selfRef,
            proposals[1].document.metadata.selfRef,
          ];

          final actions = <DocumentEntityWithMetadata>[];
          final comments = <DocumentEntityWithMetadata>[];

          final filters = ProposalsFilters(searchQuery: searchQuery);

          // When
          await database.documentsDao.saveAll([
            ...templates,
            ...proposals,
            ...actions,
            ...comments,
          ]);

          // Then
          const request = PageRequest(page: 0, size: 25);
          final page = await database.proposalsDao.queryProposalsPage(
            request: request,
            filters: filters,
          );

          expect(page.page, 0);
          expect(page.total, 2);

          final refs =
              page.items.map((e) => e.proposal.metadata.selfRef).toList();

          expect(refs, hasLength(expectedRefs.length));
          expect(refs, containsAll(expectedRefs));
        },
      );
    });
  });
}

DocumentEntityWithMetadata _buildProposal({
  SignedDocumentRef? selfRef,
  SignedDocumentRef? template,
  String? title,
  CatalystId? author,
  String? contentAuthorName,
  SignedDocumentRef? categoryId,
}) {
  final metadata = DocumentDataMetadata(
    type: DocumentType.proposalDocument,
    selfRef: selfRef ?? SignedDocumentRef.generateFirstRef(),
    template: template ?? SignedDocumentRef.generateFirstRef(),
    authors: [
      if (author != null) author,
    ],
    categoryId: categoryId ?? categoriesTemplatesRefs.first.category,
  );
  final content = DocumentDataContent({
    if (title != null || contentAuthorName != null)
      'setup': {
        if (contentAuthorName != null)
          'proposer': {
            'applicant': contentAuthorName,
          },
        if (title != null)
          'title': {
            'title': title,
          },
      },
  });

  final document = DocumentFactory.build(
    content: content,
    metadata: metadata,
  );

  final metadataEntities = [
    if (title != null)
      DocumentMetadataFactory.build(
        ver: metadata.selfRef.version,
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

DocumentEntityWithMetadata _buildProposalComment({
  SignedDocumentRef? selfRef,
  required DocumentRef proposalRef,
}) {
  final metadata = DocumentDataMetadata(
    type: DocumentType.commentDocument,
    selfRef: selfRef ?? SignedDocumentRef.generateFirstRef(),
    ref: proposalRef,
  );
  const content = DocumentDataContent({});

  final document = DocumentFactory.build(
    content: content,
    metadata: metadata,
  );

  final metadataEntities = <DocumentMetadataEntity>[];

  return (document: document, metadata: metadataEntities);
}

DocumentFavoriteEntity _buildProposalFavorite({
  required DocumentRef proposalRef,
}) {
  final hiLo = UuidHiLo.from(proposalRef.id);
  return DocumentFavoriteEntity(
    idHi: hiLo.high,
    idLo: hiLo.low,
    isFavorite: true,
    type: DocumentType.proposalDocument,
  );
}

DocumentEntityWithMetadata _buildProposalTemplate({
  SignedDocumentRef? selfRef,
}) {
  final metadata = DocumentDataMetadata(
    type: DocumentType.proposalTemplate,
    selfRef: selfRef ?? SignedDocumentRef.generateFirstRef(),
  );
  const content = DocumentDataContent({});

  final document = DocumentFactory.build(
    content: content,
    metadata: metadata,
  );

  final metadataEntities = <DocumentMetadataEntity>[];

  return (document: document, metadata: metadataEntities);
}

SignedDocumentRef _buildRefAt(DateTime dateTime) {
  final config = V7Options(dateTime.millisecondsSinceEpoch, null);
  final val = const Uuid().v7(config: config);
  return SignedDocumentRef.first(val);
}

extension on DocumentEntity {
  SignedDocumentRef get ref {
    return SignedDocumentRef(
      id: UuidHiLo(high: idHi, low: idLo).uuid,
      version: UuidHiLo(high: verHi, low: verLo).uuid,
    );
  }
}
