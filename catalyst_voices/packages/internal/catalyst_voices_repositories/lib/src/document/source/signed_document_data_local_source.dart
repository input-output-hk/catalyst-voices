import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';

/// Interface for accessing immutable, cryptographically signed documents.
///
/// Signed documents are final and cannot be modified, only superseded by
/// newer versions.
/// See [DatabaseDocumentsDataSource].
abstract interface class SignedDocumentDataSource implements DocumentDataLocalSource {
  /// Retrieves a single signed document matching the filters.
  ///
  /// * [originalAuthorId]: Filters documents authored by a specific [CatalystId].
  @override
  Future<DocumentData?> findFirst({
    DocumentType? type,
    DocumentRef? id,
    DocumentRef? referencing,
    DocumentRef? parameter,
    CatalystId? originalAuthorId,
  });

  /// Retrieves only the artifact of a specific document by its unique reference.
  ///
  /// Returns `null` if the document with the specific [DocumentRef.id] and
  /// [DocumentRef.ver] is not found.
  Future<DocumentArtifact?> getArtifact(SignedDocumentRef id);

  /// Persists a single [DocumentDataWithArtifact] object to local storage.
  ///
  /// If the document already exists, it should be updated (upsert).
  Future<void> save({required DocumentDataWithArtifact data});

  /// Persists multiple [DocumentDataWithArtifact] objects to local storage in a batch.
  Future<void> saveAll(Iterable<DocumentDataWithArtifact> data);

  /// Watches for changes to a list of signed documents.
  ///
  /// * [originalAuthorId]: Filters documents authored by a specific [CatalystId].
  @override
  Stream<List<DocumentData>> watchAll({
    DocumentType? type,
    DocumentRef? id,
    DocumentRef? referencing,
    CatalystId? originalAuthorId,
    bool latestOnly,
    int limit,
    int offset,
  });
}
