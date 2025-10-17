import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/generated/api/cat_gateway.models.swagger.dart';
import 'package:catalyst_voices_repositories/src/common/content_types.dart';
import 'package:catalyst_voices_repositories/src/common/response_mapper.dart';
import 'package:catalyst_voices_repositories/src/document/document_data_factory.dart';
import 'package:catalyst_voices_repositories/src/dto/api/document_index_list_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/api/document_index_query_filters_dto.dart';
import 'package:collection/collection.dart';

final class CatGatewayDocumentDataSource implements DocumentDataRemoteSource {
  final ApiServices _api;
  final SignedDocumentManager _signedDocumentManager;

  CatGatewayDocumentDataSource(
    this._api,
    this._signedDocumentManager,
  );

  @override
  Future<DocumentData> get({required DocumentRef ref}) async {
    final bytes = await _api.gateway
        .apiGatewayV1DocumentDocumentIdGet(
          documentId: ref.id,
          version: ref.version,
        )
        .successBodyBytesOrThrow();

    final signedDocument = await _signedDocumentManager.parseDocument(bytes);
    return DocumentDataFactory.create(signedDocument);
  }

  @override
  Future<String?> getLatestVersion(String id) async {
    final ver = constantDocumentsRefs
        .firstWhereOrNull((element) => element.hasId(id))
        ?.withId(id)
        ?.version;

    if (ver != null) {
      return ver;
    }

    try {
      final index = await _api.gateway
          .apiGatewayV1DocumentIndexPost(
            body: DocumentIndexQueryFilter(id: EqOrRangedIdDto.eq(id)),
            limit: 1,
          )
          .successBodyOrThrow();

      final docs = index.docs;
      if (docs.isEmpty) {
        return null;
      }

      return docs
          .sublist(0, 1)
          .cast<Map<String, dynamic>>()
          .map(DocumentIndexListDto.fromJson)
          .firstOrNull
          ?.ver
          .firstOrNull
          ?.ver;
    } on NotFoundException {
      return null;
    }
  }

  @override
  Future<DocumentIndexList> index() async {
    return _getDocumentIndexList(
      page: 0,
      limit: 100,
    );
  }

  @override
  Future<void> publish(SignedDocument document) async {
    final bytes = document.toBytes();
    await _api.gateway
        .apiGatewayV1DocumentPut(
          body: bytes,
          contentType: ContentTypes.applicationCbor,
        )
        .successOrThrow();
  }

  Future<DocumentIndexList> _getDocumentIndexList({
    required int page,
    required int limit,
  }) async {
    return _api.gateway
        .apiGatewayV1DocumentIndexPost(
          body: const DocumentIndexQueryFilter(),
          limit: limit,
          page: page,
        )
        .successBodyOrThrow()
        .then(
          (response) {
            // TODO(damian-molinski): Remove this workaround when migrated to V2 endpoint.
            // https://github.com/input-output-hk/catalyst-voices/issues/3199#issuecomment-3204803465
            final remaining = response.docs.length < limit ? 0 : response.page.remaining;
            final page = response.page.copyWith(remaining: remaining);

            return response.copyWith(page: page);
          },
        )
        // TODO(damian-molinski): Remove this workaround when migrated to V2 endpoint.
        // https://github.com/input-output-hk/catalyst-voices/issues/3199#issuecomment-3204803465
        .onError<NotFoundException>(
          (_, _) {
            return DocumentIndexList(
              docs: [],
              page: CurrentPage(page: page, limit: limit, remaining: 0),
            );
          },
        );
  }
}

abstract interface class DocumentDataRemoteSource implements DocumentDataSource {
  Future<String?> getLatestVersion(String id);

  Future<DocumentIndexList> index();

  Future<void> publish(SignedDocument document);
}

extension on DocumentRefForFilteredDocuments {
  SignedDocumentRef toRef() => SignedDocumentRef(id: id, version: ver);
}

extension DocumentIndexListExt on DocumentIndexList {
  List<SignedDocumentRef> get refs {
    return docs
        .cast<Map<String, dynamic>>()
        .map(DocumentIndexListDto.fromJson)
        .map((ref) {
          return <SignedDocumentRef>[
            ...ref.ver
                .map<List<SignedDocumentRef>>((ver) {
                  return [
                    SignedDocumentRef(id: ref.id, version: ver.ver),
                    if (ver.ref case final value?) value.toRef(),
                    if (ver.reply case final value?) value.toRef(),
                    if (ver.template case final value?) value.toRef(),
                    if (ver.brand case final value?) value.toRef(),
                    if (ver.campaign case final value?) value.toRef(),
                    if (ver.category case final value?) value.toRef(),
                  ];
                })
                .expand((element) => element),
          ];
        })
        .expand((element) => element)
        .toList();
  }
}
