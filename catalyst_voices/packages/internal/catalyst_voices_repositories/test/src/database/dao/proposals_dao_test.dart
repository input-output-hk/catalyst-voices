import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart' show Coin;
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/proposals_dao.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_metadata.dart';
import 'package:catalyst_voices_repositories/src/dto/proposal/proposal_submission_action_dto.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid_plus/uuid_plus.dart';

import '../../utils/test_factories.dart';
import '../connection/test_connection.dart';
import '../drift_test_platforms.dart';

void main() {
  late DriftCatalystDatabase database;

  // ignore: unnecessary_lambdas
  setUpAll(() {
    DummyCatalystIdFactory.registerDummyKeyFactory();
  });

  setUp(() async {
    final connection = await buildTestConnection();
    database = DriftCatalystDatabase(connection);
  });

  tearDown(() async {
    await database.close();
  });

  group(DriftProposalsDao, () {
    group(
      'watchCount',
      () {
        test(
          'returns correct total number of '
          'proposals for empty filters',
          () async {
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
          },
          onPlatform: driftOnPlatforms,
        );

        test(
          'when two versions of same proposal '
          'exists there are counted as one',
          () async {
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
          },
          onPlatform: driftOnPlatforms,
        );

        test(
          'returns one final proposal if final submission is found',
          () async {
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
          },
          onPlatform: driftOnPlatforms,
        );

        test(
          'returns one final proposal when final submission is '
          'latest action but old draft action exists',
          () async {
            // Given
            final ref = SignedDocumentRef.generateFirstRef();
            final proposals = [
              _buildProposal(selfRef: ref),
            ];
            final actions = [
              _buildProposalAction(
                selfRef: _buildRefAt(DateTime(2025, 04)),
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
          },
          onPlatform: driftOnPlatforms,
        );

        test(
          'returns zero final proposal if latest '
          'submission is draft',
          () async {
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
          },
          onPlatform: driftOnPlatforms,
        );

        test(
          'returns two final proposal when each have '
          'complex action history',
          () async {
            // Given
            final proposalOneRef = SignedDocumentRef.generateFirstRef();
            final proposalTwoRef = SignedDocumentRef.generateFirstRef();
            final proposals = [
              _buildProposal(selfRef: proposalOneRef),
              _buildProposal(selfRef: proposalTwoRef),
            ];
            final actions = [
              _buildProposalAction(
                selfRef: _buildRefAt(DateTime(2025, 04)),
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
          },
          onPlatform: driftOnPlatforms,
        );

        test(
          'returns calculated drafts and finals count',
          () async {
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
          },
          onPlatform: driftOnPlatforms,
        );

        test(
          'returns correct favorites count',
          () async {
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
          },
          onPlatform: driftOnPlatforms,
        );

        test(
          'returns correct my count base on author',
          () async {
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
          },
          onPlatform: driftOnPlatforms,
        );

        test(
          'returns correct count when only author filter is on',
          () async {
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
              finals: 1,
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
          },
          onPlatform: driftOnPlatforms,
        );

        test(
          'returns correct count when category filter is on',
          () async {
            // Given
            final userId = DummyCatalystIdFactory.create(username: 'damian');
            final categoryId = constantDocumentsRefs.first.category;

            final proposalOneRef = SignedDocumentRef.generateFirstRef();
            final proposalTwoRef = SignedDocumentRef.generateFirstRef();
            final proposals = [
              _buildProposal(
                selfRef: proposalOneRef,
                categoryId: constantDocumentsRefs[1].category,
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
              finals: 1,
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
          },
          onPlatform: driftOnPlatforms,
        );

        test(
          'returns correct count when search query is not empty',
          () async {
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
          },
          onPlatform: driftOnPlatforms,
        );

        test(
          'search is looking up author name in catalystId',
          () async {
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
          },
          onPlatform: driftOnPlatforms,
        );

        test(
          'search is looking up author name in content',
          () async {
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
          },
          onPlatform: driftOnPlatforms,
        );

        test(
          'returns correctly counted proposals',
          () async {
            // Given
            final one = SignedDocumentRef.generateFirstRef();
            final two = one.nextVersion().toSignedDocumentRef();
            final three = two.nextVersion().toSignedDocumentRef();

            final proposals = [
              _buildProposal(selfRef: one),
              _buildProposal(selfRef: two),
              _buildProposal(selfRef: three),
            ];
            final actions = [
              _buildProposalAction(
                selfRef: SignedDocumentRef.generateFirstRef(),
                action: ProposalSubmissionActionDto.aFinal,
                proposalRef: two,
              ),
            ];
            const filters = ProposalsCountFilters();
            const expectedCount = ProposalsCount(
              total: 1,
              finals: 1,
            );

            // When
            await database.documentsDao.saveAll([...proposals, ...actions]);

            // Then
            final count = await database.proposalsDao
                .watchCount(
                  filters: filters,
                )
                .first;

            expect(count, expectedCount);
          },
          onPlatform: driftOnPlatforms,
        );

        test(
          'hidden proposals are excluded from count',
          () async {
            // Given
            final one = SignedDocumentRef.generateFirstRef();
            final two = SignedDocumentRef.generateFirstRef();

            final proposals = [
              _buildProposal(selfRef: one),
              _buildProposal(selfRef: two),
            ];
            final actions = [
              _buildProposalAction(
                selfRef: SignedDocumentRef.generateFirstRef(),
                action: ProposalSubmissionActionDto.hide,
                proposalRef: two,
              ),
            ];
            const filters = ProposalsCountFilters();
            const expectedCount = ProposalsCount(
              total: 1,
              drafts: 1,
            );

            // When
            await database.documentsDao.saveAll([...proposals, ...actions]);

            // Then
            final count = await database.proposalsDao
                .watchCount(
                  filters: filters,
                )
                .first;

            expect(count, expectedCount);
          },
          onPlatform: driftOnPlatforms,
        );
      },
    );

    group('queryProposalsPage', () {
      test(
        'only newest version of proposal is returned',
        () async {
          // Given
          final templateRef = SignedDocumentRef.generateFirstRef();

          final ref = _buildRefAt(DateTime(2025, 4, 7));
          final nextRef = _buildRefAt(DateTime(2025, 4, 8)).copyWith(id: ref.id);
          final latestRef = _buildRefAt(DateTime(2025, 4, 9)).copyWith(id: ref.id);

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
          const order = UpdateDate(isAscending: true);

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
            order: order,
          );

          expect(page.items.length, 2);
          expect(page.items.length, page.total);

          final proposalsRefs =
              page.items.map((e) => e.proposal).map((entity) => entity.ref).toList();

          expect(
            proposalsRefs,
            expectedRefs,
          );
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'proposals are split into pages correctly',
        () async {
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
          const order = UpdateDate(isAscending: true);

          // When
          await database.documentsDao.saveAll([...templates, ...proposals]);

          // Then
          const firstRequest = PageRequest(page: 0, size: 25);
          final pageZero = await database.proposalsDao.queryProposalsPage(
            request: firstRequest,
            filters: filters,
            order: order,
          );

          expect(pageZero.page, 0);
          expect(pageZero.total, proposals.length);
          expect(pageZero.items.length, firstRequest.size);

          const secondRequest = PageRequest(page: 1, size: 25);

          final pageOne = await database.proposalsDao.queryProposalsPage(
            request: secondRequest,
            filters: filters,
            order: order,
          );

          expect(pageOne.page, 1);
          expect(pageOne.total, proposals.length);
          expect(
            pageOne.items.length,
            proposals.length - pageZero.items.length,
          );
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'proposals category filter works as expected',
        () async {
          // Given
          final templateRef = SignedDocumentRef.generateFirstRef();
          final categoryId = constantDocumentsRefs.first.category;

          final templates = [
            _buildProposalTemplate(selfRef: templateRef),
          ];

          final proposals = [
            _buildProposal(
              selfRef: _buildRefAt(DateTime(2025, 4)),
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
              categoryId: constantDocumentsRefs[1].category,
            ),
          ];

          final expectedRefs =
              proposals.sublist(0, 3).map((proposal) => proposal.document.ref).toList();

          final filters = ProposalsFilters(category: categoryId);
          const order = UpdateDate(isAscending: true);

          // When
          await database.documentsDao.saveAll([...templates, ...proposals]);

          // Then
          const request = PageRequest(page: 0, size: 25);
          final page = await database.proposalsDao.queryProposalsPage(
            request: request,
            filters: filters,
            order: order,
          );

          expect(page.page, 0);
          expect(page.total, 3);
          expect(page.items.map((e) => e.proposal.ref), expectedRefs);
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'final proposals filter works as expected',
        () async {
          // Given
          final templateRef = SignedDocumentRef.generateFirstRef();

          final templates = [
            _buildProposalTemplate(selfRef: templateRef),
          ];

          final proposalRef1 = _buildRefAt(DateTime(2025, 4));
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
          const order = UpdateDate(isAscending: true);

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
            order: order,
          );

          expect(page.page, 0);
          expect(page.total, 2);
          expect(page.items.map((e) => e.proposal.ref), expectedRefs);
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'final proposals is one with latest action as final',
        () async {
          // Given
          final templateRef = SignedDocumentRef.generateFirstRef();

          final templates = [
            _buildProposalTemplate(selfRef: templateRef),
          ];

          final proposalRef1 = _buildRefAt(DateTime(2025, 4));
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
              selfRef: _buildRefAt(DateTime(2025, 4)),
              action: ProposalSubmissionActionDto.draft,
              proposalRef: proposalRef1,
            ),
          ];

          final expectedRefs = [
            proposalRef1,
          ];

          const filters = ProposalsFilters(type: ProposalsFilterType.finals);
          const order = UpdateDate(isAscending: true);

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
            order: order,
          );

          expect(page.page, 0);
          expect(page.total, 1);
          expect(page.items.map((e) => e.proposal.ref), expectedRefs);
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'JoinedProposal is build correctly ',
        () async {
          // Given
          final templateRef = SignedDocumentRef.generateFirstRef();

          final templates = [
            _buildProposalTemplate(selfRef: templateRef),
          ];

          final proposalRef1 = _buildRefAt(DateTime(2025, 4));
          final proposalRef2 = _buildRefAt(DateTime(2025, 4, 2)).copyWith(id: proposalRef1.id);
          final proposalRef3 = _buildRefAt(DateTime(2025, 4, 3)).copyWith(id: proposalRef1.id);

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
              selfRef: _buildRefAt(DateTime(2025, 4)),
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
          const order = UpdateDate(isAscending: true);

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
            order: order,
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
        },
        onPlatform: driftOnPlatforms,
      );

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
          const order = UpdateDate(isAscending: true);

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
            order: order,
          );

          expect(page.page, 0);
          expect(page.total, 2);

          final refs = page.items.map((e) => e.proposal.metadata.selfRef).toList();

          expect(refs, hasLength(expectedRefs.length));
          expect(refs, containsAll(expectedRefs));
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'hidden proposals are filtered out when pointing to older version',
        () async {
          // Given
          final templateRef = SignedDocumentRef.generateFirstRef();
          final proposalRef = SignedDocumentRef.generateFirstRef();
          final nextProposalRef = proposalRef.nextVersion().toSignedDocumentRef();

          final templates = [
            _buildProposalTemplate(selfRef: templateRef),
          ];

          final proposals = [
            _buildProposal(
              selfRef: proposalRef,
              template: templateRef,
            ),
            _buildProposal(
              selfRef: nextProposalRef,
              template: templateRef,
            ),
          ];

          const expectedRefs = <SignedDocumentRef>[];

          final actions = <DocumentEntityWithMetadata>[
            _buildProposalAction(
              selfRef: _buildRefAt(DateTime(2025, 5, 2)),
              action: ProposalSubmissionActionDto.aFinal,
              proposalRef: proposalRef,
            ),
            _buildProposalAction(
              selfRef: _buildRefAt(DateTime(2025, 5, 20)),
              action: ProposalSubmissionActionDto.hide,
              proposalRef: proposalRef,
            ),
          ];
          final comments = <DocumentEntityWithMetadata>[];

          const filters = ProposalsFilters();
          const order = UpdateDate(isAscending: true);

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
            order: order,
          );

          expect(page.page, 0);
          expect(page.total, expectedRefs.length);

          final refs = page.items.map((e) => e.proposal.metadata.selfRef).toList();

          expect(refs, hasLength(expectedRefs.length));
          expect(refs, containsAll(expectedRefs));
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'order alphabetical works against title',
        () async {
          final templateRef = SignedDocumentRef.generateFirstRef();
          const titles = [
            'Abc',
            'Bcd',
            'cde',
          ];

          final templates = [
            _buildProposalTemplate(selfRef: templateRef),
          ];

          final proposals = titles.map((title) {
            return _buildProposal(
              selfRef: SignedDocumentRef.generateFirstRef(),
              template: templateRef,
              title: title,
            );
          }).shuffled();

          final actions = <DocumentEntityWithMetadata>[];
          final comments = <DocumentEntityWithMetadata>[];

          const filters = ProposalsFilters();
          const order = Alphabetical();

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
            order: order,
          );

          expect(page.page, 0);

          final proposalsTitles = page.items.map((e) => e.proposal.content.title).toList();

          expect(proposalsTitles, containsAllInOrder(titles));
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'order budget asc works against content path',
        () async {
          final templateRef = SignedDocumentRef.generateFirstRef();
          const budgets = [
            Coin.fromWholeAda(100000),
            Coin.fromWholeAda(199999),
            Coin.fromWholeAda(200000),
          ];

          final templates = [
            _buildProposalTemplate(selfRef: templateRef),
          ];

          final proposals = budgets.map((requestedFund) {
            return _buildProposal(
              selfRef: SignedDocumentRef.generateFirstRef(),
              template: templateRef,
              requestedFunds: requestedFund,
            );
          }).shuffled();

          final actions = <DocumentEntityWithMetadata>[];
          final comments = <DocumentEntityWithMetadata>[];

          const filters = ProposalsFilters();
          const order = Budget(isAscending: true);

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
            order: order,
          );

          expect(page.page, 0);

          final proposalsBudgets =
              page.items.map((e) => e.proposal.content.requestedFunds).toList();

          expect(proposalsBudgets, containsAllInOrder(budgets));
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'order budget desc works against content path',
        () async {
          final templateRef = SignedDocumentRef.generateFirstRef();
          const budgets = [
            Coin.fromWholeAda(200000),
            Coin.fromWholeAda(199999),
            Coin.fromWholeAda(100000),
          ];

          final templates = [
            _buildProposalTemplate(selfRef: templateRef),
          ];

          final proposals = budgets.map((requestedFund) {
            return _buildProposal(
              selfRef: SignedDocumentRef.generateFirstRef(),
              template: templateRef,
              requestedFunds: requestedFund,
            );
          }).shuffled();

          final actions = <DocumentEntityWithMetadata>[];
          final comments = <DocumentEntityWithMetadata>[];

          const filters = ProposalsFilters();
          const order = Budget(isAscending: false);

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
            order: order,
          );

          expect(page.page, 0);

          final proposalsBudgets =
              page.items.map((e) => e.proposal.content.requestedFunds).toList();

          expect(proposalsBudgets, containsAllInOrder(budgets));
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'order updateDate asc works against content path',
        () async {
          final templateRef = SignedDocumentRef.generateFirstRef();
          final dates = [
            DateTime.utc(2025, 5, 10),
            DateTime.utc(2025, 5, 20),
            DateTime.utc(2025, 5, 29),
          ];

          final templates = [
            _buildProposalTemplate(selfRef: templateRef),
          ];

          final proposals = dates.map((date) {
            return _buildProposal(
              selfRef: _buildRefAt(date),
              template: templateRef,
            );
          }).shuffled();

          final actions = <DocumentEntityWithMetadata>[];
          final comments = <DocumentEntityWithMetadata>[];

          const filters = ProposalsFilters();
          const order = UpdateDate(isAscending: true);

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
            order: order,
          );

          expect(page.page, 0);

          final proposalsDates = page.items
              .map((e) => UuidHiLo(high: e.proposal.verHi, low: e.proposal.verLo).dateTime)
              .toList();

          expect(proposalsDates, containsAllInOrder(dates));
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'order updateDate desc works against content path',
        () async {
          final templateRef = SignedDocumentRef.generateFirstRef();
          final dates = [
            DateTime.utc(2025, 5, 29),
            DateTime.utc(2025, 5, 20),
            DateTime.utc(2025, 5, 10),
          ];

          final templates = [
            _buildProposalTemplate(selfRef: templateRef),
          ];

          final proposals = dates.map((date) {
            return _buildProposal(
              selfRef: _buildRefAt(date),
              template: templateRef,
            );
          }).shuffled();

          final actions = <DocumentEntityWithMetadata>[];
          final comments = <DocumentEntityWithMetadata>[];

          const filters = ProposalsFilters();
          const order = UpdateDate(isAscending: false);

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
            order: order,
          );

          expect(page.page, 0);

          final proposalsDates = page.items
              .map((e) => UuidHiLo(high: e.proposal.verHi, low: e.proposal.verLo).dateTime)
              .toList();

          expect(proposalsDates, containsAllInOrder(dates));
        },
        onPlatform: driftOnPlatforms,
      );
    });
    group('queryProposals', () {
      test(
        'returns only newest version of each proposal',
        () async {
          // Given
          final templateRef = SignedDocumentRef.generateFirstRef();

          final ref = _buildRefAt(DateTime(2025, 4, 7));
          final nextRef = _buildRefAt(DateTime(2025, 4, 8)).copyWith(id: ref.id);
          final latestRef = _buildRefAt(DateTime(2025, 4, 9)).copyWith(id: ref.id);

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

          final expectedRefs = [
            latestRef,
            differentRef,
          ];

          // When
          await database.documentsDao.saveAll([...templates, ...proposals]);

          // Then
          final result = await database.proposalsDao.queryProposals(
            type: ProposalsFilterType.total,
          );

          expect(result.length, 2);
          expect(
            result.map((e) => e.proposal.ref),
            expectedRefs,
          );
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'filters by category when categoryRef is provided',
        () async {
          // Given
          final templateRef = SignedDocumentRef.generateFirstRef();

          final templates = [
            _buildProposalTemplate(selfRef: templateRef),
          ];

          final proposals = [
            _buildProposal(
              selfRef: _buildRefAt(DateTime(2025, 4)),
              template: templateRef,
            ),
            _buildProposal(
              selfRef: _buildRefAt(DateTime(2025, 4, 2)),
              template: templateRef,
              categoryId: constantDocumentsRefs[1].category,
            ),
            _buildProposal(
              selfRef: _buildRefAt(DateTime(2025, 4, 3)),
              template: templateRef,
              categoryId: constantDocumentsRefs[1].category,
            ),
          ];

          final expectedRefs = proposals
              .where(
                (p) => p.document.metadata.categoryId == constantDocumentsRefs[1].category,
              )
              .map((proposal) => proposal.document.ref)
              .toList();

          // When
          await database.documentsDao.saveAll([...templates, ...proposals]);

          // Then
          final result = await database.proposalsDao.queryProposals(
            categoryRef: constantDocumentsRefs[1].category,
            type: ProposalsFilterType.total,
          );

          expect(result.length, 2);
          expect(
            result.map((e) => e.proposal.ref).toList(),
            expectedRefs,
          );
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'filters final proposals correctly',
        () async {
          // Given
          final templateRef = SignedDocumentRef.generateFirstRef();

          final templates = [
            _buildProposalTemplate(selfRef: templateRef),
          ];

          final proposalRef1 = _buildRefAt(DateTime(2025, 4));
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

          // When
          await database.documentsDao.saveAll([
            ...templates,
            ...proposals,
            ...actions,
          ]);

          // Then
          final result = await database.proposalsDao.queryProposals(
            type: ProposalsFilterType.finals,
          );

          expect(result.length, 2);
          expect(
            result.map((e) => e.proposal.ref),
            expectedRefs,
          );
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'returns correct JoinedProposal structure',
        () async {
          // Given
          final templateRef = SignedDocumentRef.generateFirstRef();

          final templates = [
            _buildProposalTemplate(selfRef: templateRef),
          ];

          final baseTime = DateTime(2025, 4);
          final proposalRef1 = _buildRefAt(baseTime);
          final proposalRef2 =
              _buildRefAt(baseTime.add(const Duration(days: 1))).copyWith(id: proposalRef1.id);
          final proposalRef3 =
              _buildRefAt(baseTime.add(const Duration(days: 2))).copyWith(id: proposalRef1.id);

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

          final actionTime = baseTime.add(const Duration(days: 3));
          final actions = [
            _buildProposalAction(
              selfRef: _buildRefAt(actionTime),
              action: ProposalSubmissionActionDto.aFinal,
              proposalRef: proposalRef2,
            ),
          ];

          final comments = [
            _buildProposalComment(proposalRef: proposalRef1),
            _buildProposalComment(proposalRef: proposalRef2),
            _buildProposalComment(proposalRef: proposalRef2),
            _buildProposalComment(proposalRef: proposalRef3),
          ];

          // When
          await database.documentsDao.saveAll([
            ...templates,
            ...proposals,
            ...actions,
            ...comments,
          ]);

          // Then
          final result = await database.proposalsDao.queryProposals(
            type: ProposalsFilterType.total,
          );

          expect(result.length, 1);

          final joinedProposal = result.single;

          // Since there's a final action pointing to proposalRef2,
          // that should be the effective proposal version
          expect(joinedProposal.proposal, proposals[1].document);
          expect(joinedProposal.template, templates[0].document);
          expect(joinedProposal.action, actions[0].document);
          expect(
            joinedProposal.commentsCount,
            2,
          );
          expect(
            joinedProposal.versions,
            proposals.map((e) => e.document.ref.version).toList().reversed,
          );

          expect(joinedProposal.proposal.ref, proposalRef2);
          expect(joinedProposal.action?.metadata.ref, proposalRef2);
        },
        onPlatform: driftOnPlatforms,
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
  Coin? requestedFunds,
}) {
  final metadata = DocumentDataMetadata(
    type: DocumentType.proposalDocument,
    selfRef: selfRef ?? SignedDocumentRef.generateFirstRef(),
    template: template ?? SignedDocumentRef.generateFirstRef(),
    authors: [
      if (author != null) author,
    ],
    categoryId: categoryId ?? constantDocumentsRefs.first.category,
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
    if (requestedFunds != null)
      'summary': {
        'budget': {
          'requestedFunds': requestedFunds.ada.toInt(),
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
