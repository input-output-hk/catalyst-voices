import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';

/// Base interface to interact with locally stored document data (Database/Storage).
///
/// This interface handles common CRUD operations and reactive streams for
/// both [SignedDocumentDataSource] and [DraftDataSource].
abstract interface class DocumentDataLocalSource implements DocumentDataSource {
  /// Counts the number of documents matching the provided filters.
  ///
  /// * [type]: Filter by the [DocumentType] (e.g., Proposal, Comment).
  /// * [ref]: Filter by the specific identity of the document (ID/Version).
  /// * [refTo]: Filter for documents that reference *this* target [refTo].
  ///   (e.g., Find all comments pointing to Proposal X).
  Future<int> count({
    DocumentType? type,
    DocumentRef? ref,
    DocumentRef? refTo,
  });

  /// Deletes documents matching the provided filters.
  ///
  /// * [typeNotIn]: If provided, deletes all documents *except* those
  ///   matching the types in this list.
  ///
  /// Returns the number of records deleted.
  Future<int> delete({
    List<DocumentType>? typeNotIn,
  });

  /// Checks if a specific document exists in local storage.
  Future<bool> exists({required DocumentRef ref});

  /// Checks a list of [refs] and returns a subset list containing only
  /// the references that actually exist in the local storage.
  Future<List<DocumentRef>> filterExisting(List<DocumentRef> refs);

  /// Retrieves a list of documents matching the provided filters.
  ///
  /// * [latestOnly]: If `true`, only the most recent version of each
  ///   document ID is returned.
  /// * [limit] and [offset]: Used for pagination.
  Future<List<DocumentData>> getAll({
    DocumentType? type,
    DocumentRef? ref,
    DocumentRef? refTo,
    bool latestOnly,
    int limit,
    int offset,
  });

  /// Retrieves a single document matching the provided filters.
  ///
  /// Returns `null` if no document matches or if multiple match (depending on impl).
  /// Generally used when the filter is expected to yield a unique result.
  Future<DocumentData?> getWhere({
    DocumentType? type,
    DocumentRef? ref,
    DocumentRef? refTo,
  });

  /// Persists a single [DocumentData] object to local storage.
  ///
  /// If the document already exists, it should be updated (upsert).
  Future<void> save({required DocumentData data});

  /// Persists multiple [DocumentData] objects to local storage in a batch.
  Future<void> saveAll(Iterable<DocumentData> data);

  /// Watches for changes to a single document matching the filters.
  ///
  /// Emits a new value whenever the matching document is updated or inserted.
  Stream<DocumentData?> watch({
    DocumentType? type,
    DocumentRef? ref,
    DocumentRef? refTo,
  });

  /// Watches for changes to a list of documents matching the filters.
  ///
  /// Emits a new list whenever any document matching the criteria changes.
  Stream<List<DocumentData>> watchAll({
    DocumentType? type,
    DocumentRef? ref,
    DocumentRef? refTo,
    bool latestOnly,
    int limit,
    int offset,
  });

  /// Watches the count of documents matching the filters.
  Stream<int> watchCount({
    DocumentType? type,
    DocumentRef? ref,
    DocumentRef? refTo,
  });
}
