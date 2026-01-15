import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';

/// Centralizes mapping [SignedDocument] to a [DocumentData].
final class DocumentDataFactory {
  DocumentDataFactory._();

  /// Creates correct [DocumentData] from [document].
  ///
  /// Throws [UnknownDocumentContentTypeException] in case of not supported
  /// [document] contentType.
  static DocumentDataWithArtifact create(SignedDocument document) {
    final metadata = document.metadata;
    final content = switch (document.payload) {
      SignedDocumentJsonPayload(:final data) => DocumentDataContent(data),
      SignedDocumentJsonSchemaPayload(:final data) => DocumentDataContent(data),
      SignedDocumentBinaryPayload() ||
      SignedDocumentUnknownPayload() => throw UnknownDocumentContentTypeException(
        type: document.metadata.contentType,
      ),
    };
    final artifact = document.toArtifact();

    return DocumentDataWithArtifact(
      metadata: metadata,
      content: content,
      artifact: artifact,
    );
  }
}
