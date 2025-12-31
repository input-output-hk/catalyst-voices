import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/generated/api/cat_gateway.models.swagger.dart';
import 'package:catalyst_voices_repositories/src/dto/api/document_index_list_dto.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

void main() {
  final CatGateway gateway = MockCatGateway();
  final CatReviews reviews = MockCatReviews();
  final CatStatus status = MockedCatStatus();
  final AppMetaService appMeta = MockedAppMetaService();

  final SignedDocumentManager signedDocumentManager = _MockedSignedDocumentManager();

  late final ApiServices apiServices;
  late final CatGatewayDocumentDataSource source;

  setUpAll(() {
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
        const filters = DocumentIndexFilters(parameters: ['cat1', 'cat2']);
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
            limit: any(named: 'limit'),
            page: any(named: 'page'),
          ),
        ).captured;

        expect(captured.last, equals(expectedFiltersQueryBody));
      });

      test('handles dynamic json correctly', () async {
        // Given
        const filters = DocumentIndexFilters(parameters: []);
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

DocumentIndexListDto _buildDocumentIndexList({
  int verCount = 2,
  DocumentRefForFilteredDocuments? template,
  DocumentRefForFilteredDocuments? ref,
}) {
  return DocumentIndexListDto(
    id: DocumentRefFactory.randomUuidV7(),
    ver: List.generate(
      verCount,
      (index) {
        return IndividualDocumentVersion(
          ver: DocumentRefFactory.randomUuidV7(),
          type: DocumentRefFactory.randomUuidV7(),
          template: template,
          ref: ref,
        );
      },
    ),
  );
}

class _MockedSignedDocumentManager extends Mock implements SignedDocumentManager {}
