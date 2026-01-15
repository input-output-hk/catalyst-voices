import 'package:catalyst_compression/catalyst_compression.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/document/exception/document_exception.dart';
import 'package:catalyst_voices_repositories/src/signed_document/signed_document_manager_impl.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

/// Manages the [SignedDocument]s.
abstract interface class SignedDocumentManager {
  /// The default constructor for the [SignedDocumentManager],
  /// provides the default implementation of the interface.
  const factory SignedDocumentManager({
    required CatalystCompressor brotli,
    required CatalystCompressor zstd,
    CatalystProfiler profiler,
  }) = SignedDocumentManagerImpl;

  /// Parses the document from the [DocumentArtifact].
  ///
  /// The implementation of this method must be able to understand the [DocumentArtifact]
  /// that are obtained from the [SignedDocument.toArtifact] method.
  ///
  /// Throws [DocumentMetadataMalformedException] in case of any required fields
  /// missing.
  Future<SignedDocument> parseDocument(DocumentArtifact artifact);

  /// Signs the [document] with a single [privateKey].
  ///
  /// The [catalystId] will be added as metadata in the signed document
  /// so that it's easier to identify who signed it.
  Future<SignedDocument> signDocument(
    SignedDocumentPayload document, {
    required DocumentDataMetadata metadata,
    required CatalystId catalystId,
    required CatalystPrivateKey privateKey,
  });
}
