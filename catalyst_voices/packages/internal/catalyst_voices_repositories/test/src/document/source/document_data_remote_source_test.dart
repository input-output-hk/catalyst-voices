import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/api/models/current_page.dart';
import 'package:catalyst_voices_repositories/src/api/models/document_index_list.dart';
import 'package:catalyst_voices_repositories/src/api/models/document_index_query_filter.dart';
import 'package:catalyst_voices_repositories/src/api/models/document_reference.dart';
import 'package:catalyst_voices_repositories/src/api/models/id_and_ver_ref.dart';
import 'package:catalyst_voices_repositories/src/api/models/id_selector.dart';
import 'package:catalyst_voices_repositories/src/api/models/indexed_document.dart';
import 'package:catalyst_voices_repositories/src/api/models/indexed_document_version.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  final CatGatewayService gateway = MockCatGateway();
  final CatReviewsService reviews = MockCatReviews();
  final CatStatusService status = MockedCatStatus();
  final AppMetaService appMeta = MockedAppMetaService();

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
      test('calls API with mapped filters for categories ids', () async {
        // Given
        const filters = DocumentIndexFilters(categoriesIds: ['cat1', 'cat2']);
        const page = 0;
        const limit = 10;

        final responseBody = DocumentIndexList(
          docs: List.generate(2, (_) => _buildDocumentIndexList()),
          page: const CurrentPage(page: page, limit: limit, remaining: 0),
        );
        final response = responseBody;

        const expectedFiltersQueryBody = DocumentIndexQueryFilter(
          parameters: IdAndVerRef.idOnly(IdSelector.inside(['cat1', 'cat2'])),
        );

        when(
          () {
            return gateway.documentIndex(
              filter: any(named: 'filter'),
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
          () => gateway.documentIndex(
            filter: captureAny(named: 'filter'),
            limit: any(named: 'limit'),
            page: any(named: 'page'),
          ),
        ).captured;

        expect(captured.last, equals(expectedFiltersQueryBody));
      });

      test('handles dynamic json correctly', () async {
        // Given
        const filters = DocumentIndexFilters(categoriesIds: []);
        const page = 0;
        const limit = 10;

        final docs = List.generate(2, (_) => _buildDocumentIndexList());
        final responseBody = DocumentIndexList(
          docs: docs.map((e) => e).toList(),
          page: const CurrentPage(page: page, limit: limit, remaining: 0),
        );

        when(
          () {
            return gateway.documentIndex(
              filter: any(named: 'filter'),
              limit: limit,
              page: page,
            );
          },
        ).thenAnswer((_) => Future.value(responseBody));

        // When
        // ignore: avoid_redundant_argument_values
        final index = await source.index(page: page, limit: limit, filters: filters);

        // Then
        expect(index.page.page, page);
        expect(index.page.limit, limit);
        expect(index.page.remaining, 0);
        expect(index.docs, hasLength(docs.length));
        expect(index.docs.map((e) => e.id), docs.map((e) => e.id));
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

class _MockedSignedDocumentManager extends Mock implements SignedDocumentManager {}
