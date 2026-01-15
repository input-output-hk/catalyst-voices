import 'dart:typed_data';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uuid_plus/uuid_plus.dart';

void main() {
  late final CatalystDatabase db;
  late final SignedDocumentDataSource local;
  late final DocumentDataRemoteSource remote;

  late final DocumentsSynchronizer synchronizer;

  setUpAll(
    () {
      db = _MockCatalystDatabase();
      remote = _MockDocumentDataRemoteSource();
      local = _MockSignedDocumentDataSource();

      synchronizer = DocumentsSynchronizer(db, local, remote);

      registerFallbackValue(const DocumentIndexFilters(parameters: []));
      registerFallbackValue(SignedDocumentRef(id: const Uuid().v7()));
    },
  );

  tearDown(() {
    reset(db);
    reset(local);
    reset(remote);
  });

  group(DocumentsSynchronizer, () {
    test(
      'given no documents in index, '
      'when sync is called, '
      'then it returns zero counts and does not save anything',
      () async {
        // Given
        final campaign = Campaign.f15().copyWith(categories: []);

        // Mock index to return empty results for all 3 sync steps
        when(
          () => remote.index(
            page: any(named: 'page'),
            limit: any(named: 'limit'),
            filters: any(named: 'filters'),
          ),
        ).thenAnswer(
          (_) async => const DocumentIndex(
            page: DocumentIndexPage(page: 0, limit: 100, remaining: 0),
            docs: [],
          ),
        );
        when(() => local.filterExisting(any())).thenAnswer((_) async => []);

        // When
        final result = await synchronizer.start(CampaignSyncRequest(campaign));

        // Then
        expect(result.newDocumentsCount, 0);
        expect(result.failedDocumentsCount, 0);

        // Verify index was called at least 3 times (once for each sync step)
        verify(
          () => remote.index(
            page: 0,
            limit: any(named: 'limit'),
            filters: any(named: 'filters'),
          ),
        ).called(3);

        verifyNever(() => local.saveAll(any()));
      },
    );

    test(
      'given new documents in index, '
      'when sync is called, '
      'then it fetches and saves documents',
      () async {
        // Given
        final campaign = Campaign.f15().copyWith(categories: []);
        final docRef = SignedDocumentRef.first(const Uuid().v7());
        final indexDoc = DocumentIndexDoc(
          id: docRef.id,
          ver: [
            DocumentIndexDocVersion(ver: docRef.ver!, type: DocumentType.proposalTemplate),
          ],
        );
        final docData = DocumentDataWithArtifact(
          metadata: DocumentDataMetadata(
            contentType: DocumentContentType.json,
            type: DocumentType.proposalTemplate,
            id: docRef,
          ),
          content: const DocumentDataContent({}),
          artifact: DocumentArtifact(Uint8List(0)),
        );

        // Step 1: Index returns 1 doc
        when(
          () => remote.index(
            page: 0,
            limit: any(named: 'limit'),
            filters: any(named: 'filters'),
          ),
        ).thenAnswer((invocation) async {
          // Only return a doc for the first step to simplify test
          final filters = invocation.namedArguments[#filters] as DocumentIndexFilters;

          if ((filters.type ?? []).contains(DocumentType.proposalTemplate)) {
            return DocumentIndex(
              page: const DocumentIndexPage(page: 0, limit: 100, remaining: 0),
              docs: [indexDoc],
            );
          }
          return const DocumentIndex(
            page: DocumentIndexPage(page: 0, limit: 100, remaining: 0),
            docs: [],
          );
        });

        // Not cached
        when(() => local.filterExisting(any())).thenAnswer((_) async => []);

        // Fetch succeeds
        when(() => remote.get(any())).thenAnswer((_) async => docData);

        // Save succeeds
        when(() => local.saveAll(any())).thenAnswer((_) async {});

        // When
        final result = await synchronizer.start(CampaignSyncRequest(campaign));

        // Then
        expect(result.newDocumentsCount, 1);
        expect(result.failedDocumentsCount, 0);

        verify(() => remote.get(docRef)).called(1);
        verify(() => local.saveAll(any())).called(1);
      },
    );

    test(
      'given documents are already cached, '
      'when sync is called, '
      'then it skips fetching them',
      () async {
        // Given
        final campaign = Campaign.f15().copyWith(categories: []);
        final docRef = SignedDocumentRef.first(const Uuid().v7());
        final indexDoc = DocumentIndexDoc(
          id: docRef.id,
          ver: [
            DocumentIndexDocVersion(ver: docRef.ver!, type: DocumentType.proposalTemplate),
          ],
        );

        // Index returns doc
        when(
          () => remote.index(
            page: any(named: 'page'),
            limit: any(named: 'limit'),
            filters: any(named: 'filters'),
          ),
        ).thenAnswer((invocation) async {
          final filters = invocation.namedArguments[#filters] as DocumentIndexFilters;
          // Only return for one specific step
          if ((filters.type ?? []).contains(DocumentType.proposalTemplate)) {
            return DocumentIndex(
              page: const DocumentIndexPage(page: 0, limit: 100, remaining: 0),
              docs: [indexDoc],
            );
          }
          return const DocumentIndex(
            page: DocumentIndexPage(page: 0, limit: 100, remaining: 0),
            docs: [],
          );
        });

        // Cached!
        when(() => local.filterExisting(any())).thenAnswer((_) async => [docRef]);

        // When
        final result = await synchronizer.start(CampaignSyncRequest(campaign));

        // Then
        expect(result.newDocumentsCount, 0);

        // Verify fetch was NEVER called
        verifyNever(() => remote.get(any()));
      },
    );
  });
}

class _MockCatalystDatabase extends Mock implements CatalystDatabase {}

class _MockDocumentDataRemoteSource extends Mock implements DocumentDataRemoteSource {}

class _MockSignedDocumentDataSource extends Mock implements SignedDocumentDataSource {}
