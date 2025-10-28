import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';

/// Centralizes mapping [SignedDocument] to a [DocumentData].
final class DocumentDataFactory {
  DocumentDataFactory._();

  /// Creates correct [DocumentData] from [document].
  ///
  /// Throws [UnknownDocumentContentTypeException] in case of not supported
  /// [document] contentType.
  static DocumentData create(SignedDocument document) {
    final content = switch (document.payload) {
      SignedDocumentJsonPayload(:final data) => DocumentDataContent(data),
      SignedDocumentUnknownPayload() => throw UnknownDocumentContentTypeException(
        type: document.metadata.contentType,
      ),
    };

    return DocumentData(
      metadata: document.metadata,
      content: content,
    );
  }
}
