import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/generated/api/cat_gateway.models.swagger.dart';
import 'package:catalyst_voices_repositories/src/document/document_data_factory.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid_plus/uuid_plus.dart';

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

  // TODO(damian-molinski): ask index api
  @override
  Future<String?> getLatestVersion(String id) async => const Uuid().v7();

  @override
  Future<List<SignedDocumentRef>> index() async {
    final refs = <SignedDocumentRef>[];

    var page = 0;
    const maxPerPage = 100;
    var remaining = 0;

    do {
      final response = await _getDocumentIndexList(
        page: page,
        limit: maxPerPage,
      );

      if (kDebugMode) {
        print(
          'page[$page] '
          'refs.count[${response.docs.length}] '
          'remaining[${response.page.remaining}]',
        );
      }

      refs.addAll(response.refs);

      remaining = response.page.remaining;
      page = response.page.page + 1;
    } while (remaining > 0);

    return refs;
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
    return [];
  }
}
