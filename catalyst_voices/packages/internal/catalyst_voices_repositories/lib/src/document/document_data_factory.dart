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
  static DocumentDataWithArtifact create(SignedDocument document) {
    final metadata = document.metadata;
    final content = switch (document.payload) {
      SignedDocumentJsonPayload(:final data) => DocumentDataContent(data),
      SignedDocumentUnknownPayload() => throw const UnknownSignedDocumentContentType(
        type: SignedDocumentContentType.unknown,
      ),
      SignedDocumentBinaryPayload(:final data) => DocumentDataContent(
        // Assuming that binary data is UTF-8 encoded string representing a json,
        // at the moment no other data type is allowed.
        SignedDocumentJsonPayload.fromBytes(data).data,
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
