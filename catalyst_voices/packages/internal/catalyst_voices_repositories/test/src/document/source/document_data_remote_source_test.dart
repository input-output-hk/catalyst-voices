import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/generated/api/cat_gateway.models.swagger.dart';
import 'package:catalyst_voices_repositories/src/dto/api/document_index_list_dto.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:uuid_plus/uuid_plus.dart';

void main() {
  final CatGateway gateway = _MockedCatGateway();
  final CatReviews reviews = _MockedCatReviews();
  final SignedDocumentManager signedDocumentManager =
      _MockedSignedDocumentManager();

  late final ApiServices apiServices;
  late final CatGatewayDocumentDataSource source;

  const maxPageSize = CatGatewayDocumentDataSource.indexPageSize;

  setUpAll(() {
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
      test(
          'loops thru all pages until there is no remaining refs '
          'and exacts refs from them', () async {
        // Given
        final pageZero = DocumentIndexList(
          docs: List.generate(
            maxPageSize,
            (_) => _buildDocumentIndexList().toJson(),
          ),
          page: const CurrentPage(page: 0, limit: maxPageSize, remaining: 5),
        );
        final pageOne = DocumentIndexList(
          docs: List.generate(
            5,
            (_) => _buildDocumentIndexList().toJson(),
          ),
          page: const CurrentPage(page: 1, limit: maxPageSize, remaining: 0),
        );

        final pageZeroResponse = Response(http.Response('', 200), pageZero);
        final pageOneResponse = Response(http.Response('', 200), pageOne);

        // When
        when(
          () => gateway.apiV1DocumentIndexPost(
            body: const DocumentIndexQueryFilter(),
            limit: maxPageSize,
            page: 0,
          ),
        ).thenAnswer((_) => Future.value(pageZeroResponse));
        when(
          () => gateway.apiV1DocumentIndexPost(
            body: const DocumentIndexQueryFilter(),
            limit: maxPageSize,
            page: 1,
          ),
        ).thenAnswer((_) => Future.value(pageOneResponse));

        final refs = await source.index();

        // Then
        expect(refs, isNotEmpty);

        verify(
          () => gateway.apiV1DocumentIndexPost(
            body: any(named: 'body'),
            limit: any(named: 'limit'),
            page: any(named: 'page'),
          ),
        ).called(2);
      });

      test('expands all page refs correctly', () async {
        // Given
        final proposalId = const Uuid().v7();
        final proposalRefs = [
          SignedDocumentRef(id: proposalId, version: const Uuid().v7()),
          SignedDocumentRef(id: proposalId, version: const Uuid().v7()),
        ];
        final templateRef = SignedDocumentRef(id: const Uuid().v7());

        final page = DocumentIndexList(
          docs: [
            DocumentIndexListDto(
              id: proposalId,
              ver: proposalRefs.map((e) {
                return IndividualDocumentVersion(
                  ver: e.version!,
                  type: '',
                  template: DocumentRefForFilteredDocuments(id: templateRef.id),
                );
              }).toList(),
            ).toJson(),
          ],
          page: const CurrentPage(page: 0, limit: maxPageSize, remaining: 0),
        );
        final response = Response(http.Response('', 200), page);

        final expectedRefs = [
          ...proposalRefs,
          templateRef,
        ];

        // When
        when(
          () => gateway.apiV1DocumentIndexPost(
            body: const DocumentIndexQueryFilter(),
            limit: maxPageSize,
            page: 0,
          ),
        ).thenAnswer((_) => Future.value(response));

        final refs = await source.index();

        // Then
        expect(
          refs,
          allOf(hasLength(expectedRefs.length), containsAll(expectedRefs)),
        );
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
    id: const Uuid().v7(),
    ver: List.generate(
      verCount,
      (index) {
        return IndividualDocumentVersion(
          ver: const Uuid().v7(),
          type: const Uuid().v7(),
          template: template,
          ref: ref,
        );
      },
    ),
  );
}

class _MockedCatGateway extends Mock implements CatGateway {}

class _MockedCatReviews extends Mock implements CatReviews {}

class _MockedSignedDocumentManager extends Mock
    implements SignedDocumentManager {}
