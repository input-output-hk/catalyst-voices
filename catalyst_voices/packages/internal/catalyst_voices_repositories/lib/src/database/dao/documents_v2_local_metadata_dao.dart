import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/documents_v2_local_metadata_dao.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_local_metadata.dart';
import 'package:drift/drift.dart';

abstract interface class DocumentsV2LocalMetadataDao {
  /// Deletes all local metadata records from the database.
  ///
  /// This operation is typically used to clear all user-specific data,
  /// such as 'favorite' status.
  /// Returns the number of rows that were deleted.
  Future<int> deleteWhere();

  /// Checks if a document with the given [id] is marked as a favorite.
  ///
  /// Returns `true` if the document is a favorite, otherwise `false`.
  /// If the document is not found, it also returns `false`.
  Future<bool> isFavorite(String id);
}

@DriftAccessor(
  tables: [
    DocumentsLocalMetadata,
  ],
)
class DriftDocumentsV2LocalMetadataDao extends DatabaseAccessor<DriftCatalystDatabase>
    with $DriftDocumentsV2LocalMetadataDaoMixin
    implements DocumentsV2LocalMetadataDao {
  DriftDocumentsV2LocalMetadataDao(super.attachedDatabase);

  @override
  Future<int> deleteWhere() {
    final query = delete(documentsLocalMetadata);

    return query.go();
  }

  @override
  Future<bool> isFavorite(String id) {
    final query = selectOnly(documentsLocalMetadata)
      ..addColumns([documentsLocalMetadata.isFavorite])
      ..where(documentsLocalMetadata.id.equals(id))
      ..limit(1);

    return query
        .map((row) => row.read(documentsLocalMetadata.isFavorite))
        .getSingleOrNull()
        .then((value) => value ?? false);
  }
}
