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
    CatalystId? originalAuthorId,
  });

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
