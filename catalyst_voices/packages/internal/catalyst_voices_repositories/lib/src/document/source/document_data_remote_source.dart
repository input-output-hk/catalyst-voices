import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:uuid/uuid.dart';

const mockedDocumentUuid = '0194f567-65f5-7ec6-b4f2-f744c0f74844';
const mockedTemplateUuid = '0194d492-1daa-75b5-b4a4-5cf331cd8d1a';

final class CatGatewayDocumentDataSource implements DocumentDataRemoteSource {
  final ApiServices _api;
  final SignedDocumentManager _signedDocumentManager;

  CatGatewayDocumentDataSource(
    this._api,
    this._signedDocumentManager,
  );

  // TODO(damian-molinski): make API call and use _signedDocumentManager.
  @override
  Future<DocumentData> get({required DocumentRef ref}) async {
    /*try {
      final response = await _api.gateway.apiV1DocumentDocumentIdGet(
        documentId: ref.id,
        version: ref.version,
      );

      // TODO(damian-molinski): mapping errors if response not successful
      if (!response.isSuccessful) {
        // throw exception.
      }

      final bytes = response.bodyBytes;

      final signedDocument = await _signedDocumentManager.parseDocument(
        bytes,
        parser: SignedDocumentJsonPayload.fromBytes,
      );

      // TODO(damian-molinski): parsing metadata
      // TODO(damian-molinski): mapping signedDocument to DocumentData.
      if (kDebugMode) {
        debugPrint('Document');
        debugPrint(json.encode(signedDocument.payload.data));
      }
    } catch (error, stack) {
      if (kDebugMode) {
        debugPrint(error.toString());
        debugPrintStack(stackTrace: stack);
      }
      rethrow;
    }*/

    final isSchema = ref.id == mockedTemplateUuid;

    final signedDocument = await (isSchema
        ? VoicesDocumentsTemplates.proposalF14Schema
        : VoicesDocumentsTemplates.proposalF14Document);

    final type = isSchema
        ? DocumentType.proposalTemplate
        : DocumentType.proposalDocument;
    final ver = ref.version ?? ref.id;
    final template =
        !isSchema ? const SignedDocumentRef(id: mockedTemplateUuid) : null;

    final metadata = DocumentDataMetadata(
      type: type,
      selfRef: SignedDocumentRef(id: ref.id, version: ver),
      template: template,
    );

    final content = DocumentDataContent(signedDocument);

    return DocumentData(
      metadata: metadata,
      content: content,
    );
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
  Future<void> upload(SignedDocument document) async {
    final bytes = document.toBytes();
    await _api.gateway.apiV1DocumentPut(body: bytes);
  }
}

abstract interface class DocumentDataRemoteSource
    implements DocumentDataSource {
  Future<String?> getLatestVersion(String id);

  @override
  Future<List<SignedDocumentRef>> index();

  Future<void> upload(SignedDocument document);
}
