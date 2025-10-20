import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/models/current_page.dart';
import 'package:catalyst_voices_repositories/src/models/document_index_list.dart';
import 'package:catalyst_voices_repositories/src/models/document_index_query_filter.dart';
import 'package:catalyst_voices_repositories/src/models/document_reference.dart';
import 'package:catalyst_voices_repositories/src/models/indexed_document.dart';
import 'package:catalyst_voices_repositories/src/models/indexed_document_version.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../utils/test_factories.dart';

void main() {
  final CatGatewayService gateway = _MockedCatGateway();
  final CatReviewsService reviews = _MockedCatReviews();
  final SignedDocumentManager signedDocumentManager = _MockedSignedDocumentManager();

  late final ApiServices apiServices;
  late final CatGatewayDocumentDataSource source;

  const maxPageSize = CatGatewayDocumentDataSource.indexPageSize;

  setUpAll(() {
    registerFallbackValue(const DocumentIndexQueryFilter());

    apiServices = ApiServices.internal(
      gateway: gateway,
      reviews: reviews,
    );

    source = CatGatewayDocumentDataSource(apiServices, signedDocumentManager);
  });

  tearDown(() {
    reset(gateway);
    reset(reviews);
    reset(signedDocumentManager);
  });

  group(CatGatewayDocumentDataSource, () {
    group('index', () {
      test('loops thru all pages until there is no remaining refs '
          'and extracts refs from them', () async {
        final pageZero = DocumentIndexList(
          docs: List.generate(
            maxPageSize,
            (_) => _buildDocumentIndexList(),
          ),
          page: const CurrentPage(page: 0, limit: maxPageSize, remaining: 5),
        );
        final pageOne = DocumentIndexList(
          docs: List.generate(
            5,
            (_) => _buildDocumentIndexList(),
          ),
          page: const CurrentPage(page: 1, limit: maxPageSize, remaining: 0),
        );

        when(
          () => gateway.searchDocuments(
            filter: any(named: 'filter'),
            limit: maxPageSize,
            page: 0,
          ),
        ).thenAnswer((_) async => pageZero);

        when(
          () => gateway.searchDocuments(
            filter: any(named: 'filter'),
            limit: maxPageSize,
            page: 1,
          ),
        ).thenAnswer((_) async => pageOne);

        final refs = await source.index(campaign: Campaign.f14());

        expect(refs, isNotEmpty);

        verify(
          () => gateway.searchDocuments(
            filter: any(named: 'filter'),
            limit: any(named: 'limit'),
            page: any(named: 'page'),
          ),
        ).called(2);
      });

      test('expands all page refs correctly', () async {
        final proposalId = DocumentRefFactory.randomUuidV7();
        final proposalRefs = [
          SignedDocumentRef(id: proposalId, version: DocumentRefFactory.randomUuidV7()),
          SignedDocumentRef(id: proposalId, version: DocumentRefFactory.randomUuidV7()),
        ];
        final templateRef = SignedDocumentRef.first(DocumentRefFactory.randomUuidV7());

        final page = DocumentIndexList(
          docs: [
            IndexedDocument(
              id: proposalId,
              ver: proposalRefs.map((e) {
                return IndexedDocumentVersion(
                  ver: e.version!,
                  type: DocumentType.proposalDocument.uuid,
                  template: DocumentReference(
                    id: templateRef.id,
                    ver: templateRef.version!,
                  ),
                );
              }).toList(),
            ),
          ],
          page: const CurrentPage(page: 0, limit: maxPageSize, remaining: 0),
        );

        final expectedRefs = <TypedDocumentRef>[
          ...proposalRefs.map((e) => e.toTyped(DocumentType.proposalDocument)),
          templateRef.toTyped(DocumentType.proposalTemplate),
        ];

        when(
          () => gateway.searchDocuments(
            filter: any(named: 'filter'),
            limit: maxPageSize,
            page: 0,
          ),
        ).thenAnswer((_) async => page);

        final refs = await source.index(campaign: Campaign.f14());

        expect(
          refs,
          allOf(hasLength(expectedRefs.length), containsAll(expectedRefs)),
        );
      });
    });
  });
}

IndexedDocument _buildDocumentIndexList({
  int verCount = 2,
  DocumentReference? template,
  DocumentReference? ref,
}) {
  return IndexedDocument(
    id: DocumentRefFactory.randomUuidV7(),
    ver: List.generate(
      verCount,
      (index) {
        return IndexedDocumentVersion(
          ver: DocumentRefFactory.randomUuidV7(),
          type: DocumentRefFactory.randomUuidV7(),
          template: template,
          ref: ref,
        );
      },
    ),
  );
}

class _MockedCatGateway extends Mock implements CatGatewayService {}

class _MockedCatReviews extends Mock implements CatReviewsService {}

class _MockedSignedDocumentManager extends Mock implements SignedDocumentManager {}
