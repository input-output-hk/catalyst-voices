import 'package:catalyst_voices_models/catalyst_voices_models.dart';

/// A base interface for retrieving document data from any source (Local, Remote, Memory).
abstract interface class DocumentDataSource {
  /// Retrieves a specific document by its unique reference.
  ///
  /// Returns `null` if the document with the specific [DocumentRef.id] and
  /// [DocumentRef.ver] is not found.
  Future<DocumentData?> get(DocumentRef ref);

  /// Resolves the reference to the latest available version of a document chain.
  ///
  /// If [ref] points to an older version, this returns the [DocumentRef]
  /// for the most recent version of that document ID.
  /// Returns `null` if the document ID does not exist in the source.
  Future<DocumentRef?> getLatestRefOf(DocumentRef ref);
}
