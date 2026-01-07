import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/api/models/current_page.dart';
import 'package:catalyst_voices_repositories/src/api/models/document_index_list.dart';
import 'package:catalyst_voices_repositories/src/api/models/document_index_query_filter.dart';
import 'package:catalyst_voices_repositories/src/api/models/document_reference.dart';
import 'package:catalyst_voices_repositories/src/api/models/indexed_document.dart';
import 'package:catalyst_voices_repositories/src/api/models/indexed_document_version.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
<<<<<<< HEAD
  final CatGatewayService gateway = _MockedCatGateway();
  final CatReviewsService reviews = _MockedCatReviews();
  final CatStatusService status = _MockedCatStatus();
=======
  final CatGateway gateway = MockCatGateway();
  final CatReviews reviews = MockCatReviews();
  final CatStatus status = MockedCatStatus();
  final AppMetaService appMeta = MockedAppMetaService();

>>>>>>> feat/face-performance-optimization-3352
  final SignedDocumentManager signedDocumentManager = _MockedSignedDocumentManager();

  late final ApiServices apiServices;
  late final CatGatewayDocumentDataSource source;

  setUpAll(() {
    registerFallbackValue(const DocumentIndexQueryFilter());

    apiServices = ApiServices.internal(
      gateway: gateway,
      reviews: reviews,
      status: status,
      appMeta: appMeta,
    );

    source = CatGatewayDocumentDataSource(apiServices, signedDocumentManager);
  });

  tearDown(() {
    reset(gateway);
    reset(reviews);
    reset(status);
    reset(signedDocumentManager);
  });

  group(CatGatewayDocumentDataSource, () {
    group('index', () {
<<<<<<< HEAD
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
          () => gateway.documentIndex(
            filter: any(named: 'filter'),
            limit: maxPageSize,
            page: 0,
          ),
        ).thenAnswer((_) async => pageZero);

        when(
          () => gateway.documentIndex(
            filter: any(named: 'filter'),
            limit: maxPageSize,
            page: 1,
          ),
        ).thenAnswer((_) async => pageOne);

        final refs = await source.index(campaign: Campaign.f14());

        expect(refs, isNotEmpty);

        verify(
          () => gateway.documentIndex(
            filter: any(named: 'filter'),
=======
      test('calls API with mapped filters for categories ids', () async {
        // Given
        const filters = DocumentIndexFilters(categoriesIds: ['cat1', 'cat2']);
        const page = 0;
        const limit = 10;

        final responseBody = DocumentIndexList(
          docs: List.generate(2, (_) => _buildDocumentIndexList().toJson()),
          page: const CurrentPage(page: page, limit: limit, remaining: 0),
        );
        final response = Response(http.Response('', 200), responseBody);

        const expectedFiltersQueryBody = DocumentIndexQueryFilter(
          parameters: {
            'id': {
              'in': ['cat1', 'cat2'],
            },
          },
        );

        when(
          () {
            return gateway.apiV1DocumentIndexPost(
              body: any(named: 'body'),
              limit: limit,
              page: page,
            );
          },
        ).thenAnswer((_) => Future.value(response));

        // When
        // ignore: avoid_redundant_argument_values
        await source.index(page: page, limit: limit, filters: filters);

        // Then
        final captured = verify(
          () => gateway.apiV1DocumentIndexPost(
            body: captureAny(named: 'body'),
>>>>>>> feat/face-performance-optimization-3352
            limit: any(named: 'limit'),
            page: any(named: 'page'),
          ),
        ).captured;

        expect(captured.last, equals(expectedFiltersQueryBody));
      });

<<<<<<< HEAD
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
                  id: '01944e87-e68c-7f22-9df1-816863cfa5ff',
                  template: [
                    DocumentReference(
                      id: templateRef.id,
                      ver: templateRef.version!,
                    ),
                  ],
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
          () => gateway.documentIndex(
            filter: any(named: 'filter'),
            limit: maxPageSize,
            page: 0,
          ),
        ).thenAnswer((_) async => page);
=======
      test('handles dynamic json correctly', () async {
        // Given
        const filters = DocumentIndexFilters(categoriesIds: []);
        const page = 0;
        const limit = 10;

        final docs = List.generate(2, (_) => _buildDocumentIndexList());
        final responseBody = DocumentIndexList(
          docs: docs.map((e) => e.toJson()).toList(),
          page: const CurrentPage(page: page, limit: limit, remaining: 0),
        );
        final responseBodyJson = responseBody.toJson();
        final response = Response(http.Response('', 200), responseBodyJson);

        when(
          () {
            return gateway.apiV1DocumentIndexPost(
              body: any(named: 'body'),
              limit: limit,
              page: page,
            );
          },
        ).thenAnswer((_) => Future.value(response));
>>>>>>> feat/face-performance-optimization-3352

        // When
        // ignore: avoid_redundant_argument_values
        final index = await source.index(page: page, limit: limit, filters: filters);

<<<<<<< HEAD
        expect(
          refs,
          allOf(hasLength(expectedRefs.length), containsAll(expectedRefs)),
        );
=======
        // Then
        expect(index.page.page, page);
        expect(index.page.limit, limit);
        expect(index.page.remaining, 0);
        expect(index.docs, hasLength(docs.length));
        expect(index.docs.map((e) => e.id), docs.map((e) => e.id));
>>>>>>> feat/face-performance-optimization-3352
      });
    });
  });
}

IndexedDocument _buildDocumentIndexList({
  int verCount = 2,
  List<DocumentReference>? template,
  List<DocumentReference>? ref,
}) {
  return IndexedDocument(
    id: DocumentRefFactory.randomUuidV7(),
    ver: List.generate(
      verCount,
      (index) {
        return IndexedDocumentVersion(
          ver: DocumentRefFactory.randomUuidV7(),
          type: DocumentRefFactory.randomUuidV7(),
          id: DocumentRefFactory.randomUuidV7(),
          template: template,
          ref: ref,
        );
      },
    ),
  );
}

<<<<<<< HEAD
class _MockedCatGateway extends Mock implements CatGatewayService {}

class _MockedCatReviews extends Mock implements CatReviewsService {}

class _MockedCatStatus extends Mock implements CatStatusService {}

=======
>>>>>>> feat/face-performance-optimization-3352
class _MockedSignedDocumentManager extends Mock implements SignedDocumentManager {}
