import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:uuid/uuid.dart';

abstract interface class DocumentDataRemoteSource
    implements DocumentDataSource {
  Future<String?> getLatestVersion(String id);
}

final class CatGatewayDocumentDataSource implements DocumentDataRemoteSource {
  // ignore: unused_field
  final SignedDocumentManager _signedDocumentManager;

  CatGatewayDocumentDataSource(
    this._signedDocumentManager,
  );

  // TODO(damian-molinski): ask index api
  @override
  Future<String?> getLatestVersion(String id) async => const Uuid().v7();

  // TODO(damian-molinski): make API call and use _signedDocumentManager.
  @override
  Future<DocumentData> get({required DocumentRef ref}) async {
    final isSchema = ref.id == 'schema';

    final signedDocument = await (isSchema
        ? VoicesDocumentsTemplates.proposalF14Schema
        : VoicesDocumentsTemplates.proposalF14Document);

    final type = isSchema
        ? DocumentType.proposalTemplate
        : DocumentType.proposalDocument;
    final ver = ref.version ?? const Uuid().v7();
    final template = !isSchema ? const DocumentRef(id: 'schema') : null;

    final metadata = DocumentDataMetadata(
      type: type,
      id: ref.id,
      version: ver,
      template: template,
    );

    final content = DocumentDataContent(signedDocument);

    return DocumentData(
      metadata: metadata,
      content: content,
    );
  }
}
