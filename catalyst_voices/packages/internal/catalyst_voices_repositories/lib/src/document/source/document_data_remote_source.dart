import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
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
    try {
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
    } catch (error, stack) {
      if (kDebugMode) {
        debugPrint(error.toString());
        debugPrintStack(stackTrace: stack);
      }
      rethrow;
    }
  }

  // TODO(damian-molinski): ask index api
  @override
  Future<String?> getLatestVersion(String id) async => const Uuid().v7();

  // TODO(damian-molinski): ask index api
  @override
  Future<List<SignedDocumentRef>> index() async {
    return [];
  }

  @override
  Future<void> publish(SignedDocument document) async {
    final bytes = document.toBytes();
    await _api.gateway.apiV1DocumentPut(body: bytes);
  }
}

abstract interface class DocumentDataRemoteSource
    implements DocumentDataSource {
  Future<String?> getLatestVersion(String id);

  @override
  Future<List<SignedDocumentRef>> index();

  Future<void> publish(SignedDocument document);
}
