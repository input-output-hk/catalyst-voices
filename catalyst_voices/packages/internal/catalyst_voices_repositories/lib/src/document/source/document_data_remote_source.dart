import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/generated/api/cat_gateway.models.swagger.dart';
import 'package:catalyst_voices_repositories/src/document/document_data_factory.dart';
import 'package:catalyst_voices_repositories/src/dto/api/document_index_list_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/api/document_index_query_filters_dto.dart';

final class CatGatewayDocumentDataSource implements DocumentDataRemoteSource {
  final ApiServices _api;
  final SignedDocumentManager _signedDocumentManager;

  CatGatewayDocumentDataSource(
    this._api,
    this._signedDocumentManager,
  );

  @override
  Future<DocumentData> get({required DocumentRef ref}) async {
    final response = await _api.gateway.apiV1DocumentDocumentIdGet(
      documentId: ref.id,
      version: ref.version,
    );

    if (!response.isSuccessful) {
      final statusCode = response.statusCode;
      final error = response.error;

      throw ApiErrorResponseException(statusCode: statusCode, error: error);
    }

    final bytes = response.bodyBytes;
    final signedDocument = await _signedDocumentManager.parseDocument(bytes);
    return DocumentDataFactory.create(signedDocument);
  }

  @override
  Future<String?> getLatestVersion(String id) async {
    final response = await _api.gateway.apiV1DocumentIndexPost(
      body: DocumentIndexQueryFilter(id: EqOrRangedIdDto.eq(id)),
      limit: 1,
    );

    if (response.statusCode == ApiErrorResponseException.notFound) {
      return null;
    }

    if (!response.isSuccessful) {
      final statusCode = response.statusCode;
      final error = response.error;

      throw ApiErrorResponseException(statusCode: statusCode, error: error);
    }

    return response.body?.docs
        .cast<Map<String, dynamic>>()
        .map(DocumentIndexListDto.fromJson)
        .firstOrNull
        ?.ver
        .firstOrNull
        ?.ver;
  }

  @override
  Future<List<SignedDocumentRef>> index() async {
    final allRefs = <SignedDocumentRef>{};

    var page = 0;
    const maxPerPage = 100;
    var remaining = 0;

    do {
      final response = await _getDocumentIndexList(
        page: page,
        limit: maxPerPage,
      );

      allRefs.addAll(response.refs);

      remaining = response.page.remaining;
      page = response.page.page + 1;
    } while (remaining > 0);

    return allRefs.toList();
  }

  @override
  Future<void> publish(SignedDocument document) async {
    final bytes = document.toBytes();
    final response = await _api.gateway.apiV1DocumentPut(body: bytes);

    if (!response.isSuccessful) {
      final statusCode = response.statusCode;
      final error = response.error;

      throw ApiErrorResponseException(statusCode: statusCode, error: error);
    }
  }

  Future<DocumentIndexList> _getDocumentIndexList({
    required int page,
    required int limit,
  }) async {
    final response = await _api.gateway.apiV1DocumentIndexPost(
      body: const DocumentIndexQueryFilter(),
      limit: limit,
      page: page,
    );

    if (!response.isSuccessful) {
      final statusCode = response.statusCode;
      final error = response.error;

      throw ApiErrorResponseException(statusCode: statusCode, error: error);
    }

    return response.bodyOrThrow;
  }
}

abstract interface class DocumentDataRemoteSource
    implements DocumentDataSource {
  Future<String?> getLatestVersion(String id);

  @override
  Future<List<SignedDocumentRef>> index();

  Future<void> publish(SignedDocument document);
}

extension on DocumentIndexList {
  List<SignedDocumentRef> get refs {
    return docs
        .cast<Map<String, dynamic>>()
        .map(DocumentIndexListDto.fromJson)
        .map((ref) {
          return <SignedDocumentRef>[
            SignedDocumentRef(id: ref.id),
            ...ref.ver.map((ver) {
              return <SignedDocumentRef>[
                SignedDocumentRef(id: ref.id, version: ver.ver),
                if (ver.ref != null) ver.ref!.toRef(),
                if (ver.reply != null) ver.reply!.toRef(),
                if (ver.template != null) ver.template!.toRef(),
                if (ver.brand != null) ver.brand!.toRef(),
                if (ver.campaign != null) ver.campaign!.toRef(),
                if (ver.category != null) ver.category!.toRef(),
              ];
            }).expand((element) => element),
          ];
        })
        .expand((element) => element)
        .toList();
  }
}

extension on DocumentRefForFilteredDocuments {
  SignedDocumentRef toRef() => SignedDocumentRef(id: id, version: ver);
}
