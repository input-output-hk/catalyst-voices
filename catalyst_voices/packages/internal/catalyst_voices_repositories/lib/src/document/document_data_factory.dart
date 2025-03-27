import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';

/// Centralizes mapping [SignedDocument] to a [DocumentData].
final class DocumentDataFactory {
  DocumentDataFactory._();

  /// Creates correct [DocumentData] from [document].
  ///
  /// Throws [SignedDocumentMetadataMalformed] in case of any required fields
  /// missing.
  ///
  /// Throws [UnknownSignedDocumentContentType] in case of not supported
  /// [document] contentType.
  static DocumentData create(SignedDocument document) {
    final malformedReasons = <String>[];
    final id = document.metadata.id;
    if (id == null) {
      malformedReasons.add('id is missing');
    }
    final ver = document.metadata.ver;
    if (ver == null) {
      malformedReasons.add('version is missing');
    }

    if (malformedReasons.isNotEmpty) {
      throw SignedDocumentMetadataMalformed(reasons: malformedReasons);
    }

    final metadata = DocumentDataMetadata(
      type: document.metadata.documentType,
      selfRef: SignedDocumentRef(id: id!, version: ver),
      ref: document.metadata.ref?.toModel(),
      refHash: document.metadata.refHash?.toModel(),
      template: document.metadata.template?.toModel(),
      reply: document.metadata.reply?.toModel(),
      section: document.metadata.section,
      brandId: document.metadata.brandId?.toModel(),
      campaignId: document.metadata.campaignId?.toModel(),
      electionId: document.metadata.electionId,
      categoryId: document.metadata.categoryId?.toModel(),
      authors: document.signers,
    );

    final content = switch (document.payload) {
      SignedDocumentJsonPayload(:final data) => DocumentDataContent(data),
      SignedDocumentUnknownPayload() => throw UnknownSignedDocumentContentType(
          type: document.metadata.contentType,
        ),
    };

    return DocumentData(
      metadata: metadata,
      content: content,
    );
  }
}

extension on SignedDocumentMetadataRef {
  SignedDocumentRef toModel() => SignedDocumentRef(id: id, version: ver);
}

extension on SignedDocumentMetadataRefHash {
  SecuredDocumentRef toModel() {
    return SecuredDocumentRef(
      ref: ref.toModel(),
      hash: hash,
    );
  }
}
