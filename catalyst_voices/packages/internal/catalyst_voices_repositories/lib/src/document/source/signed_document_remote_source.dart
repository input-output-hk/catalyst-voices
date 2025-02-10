import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:uuid/uuid.dart';

abstract interface class SignedDocumentRemoteSource
    implements SignedDocumentSource {
  factory SignedDocumentRemoteSource(
    SignedDocumentManager signedDocumentManager,
  ) = CatGatewaySignedDocumentSource;

  Future<String?> getLatestVersion(String id);
}

final class CatGatewaySignedDocumentSource
    implements SignedDocumentRemoteSource {
  // ignore: unused_field
  final SignedDocumentManager _signedDocumentManager;

  CatGatewaySignedDocumentSource(
    this._signedDocumentManager,
  );

  // TODO(damian-molinski): ask index api
  @override
  Future<String?> getLatestVersion(String id) async => const Uuid().v7();

  // TODO(damian-molinski): make API call and use _signedDocumentManager.
  @override
  Future<SignedDocumentData> get({required SignedDocumentRef ref}) async {
    final isSchema = ref.id == 'schema';

    final signedDocument = await (isSchema
        ? VoicesDocumentsTemplates.proposalF14Schema
        : VoicesDocumentsTemplates.proposalF14Document);

    final type = isSchema
        ? SignedDocumentType.proposalTemplate
        : SignedDocumentType.proposalDocument;
    final ver = ref.version ?? const Uuid().v7();
    final template = !isSchema ? const SignedDocumentRef(id: 'schema') : null;

    final metadata = SignedDocumentMetadata(
      type: type,
      id: ref.id,
      version: ver,
      template: template,
    );

    final content = SignedDocumentContent(signedDocument);

    return SignedDocumentData(
      metadata: metadata,
      content: content,
    );
  }
}
