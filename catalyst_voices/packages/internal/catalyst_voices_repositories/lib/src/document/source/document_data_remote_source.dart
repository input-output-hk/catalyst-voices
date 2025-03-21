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

      // TODO(damian-molinski): mapping errors if response not successful
      if (!response.isSuccessful) {
        // throw exception.
      }

      final bytes = response.bodyBytes;

      final signedDocument = await _signedDocumentManager.parseDocument(bytes);
      final documentData = DocumentDataFactory.create(signedDocument);

      if (kDebugMode) {
        debugPrint('DocumentData: $documentData');
      }

      return documentData;
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
