import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';

/// Interface for accessing mutable draft documents.
///
/// Drafts are local-only, unsigned work-in-progress documents.
/// See [DatabaseDraftsDataSource].
abstract interface class DraftDataSource implements DocumentDataLocalSource {
  /// Deletes drafts matching the criteria.
  ///
  /// * [ref]: If provided, deletes the specific draft.
  /// * [excludeTypes]: Deletes all drafts NOT matching these types (often used for cleanup).
  @override
  Future<int> delete({
    DocumentRef? ref,
    List<DocumentType>? excludeTypes,
  });

  /// Updates the content of an existing draft identified by [ref].
  ///
  /// This is distinct from [save] as it implies modifying the payload
  /// of an existing entity without necessarily creating a new version/ID.
  Future<void> updateContent({
    required DraftRef ref,
    required DocumentDataContent content,
  });
}
