import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/drafts_dao.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/drafts.dart';
import 'package:catalyst_voices_repositories/src/database/table/drafts.drift.dart';
import 'package:drift/drift.dart';

/// Exposes only public operation on drafts, and related, tables.
abstract interface class DraftsDao {
  /// Returns all drafts
  Future<List<DraftEntity>> queryAll();

  /// Counts unique drafts. All versions of same document are counted as 1.
  Future<int> countAll();

  /// Inserts all drafts. On conflicts updates.
  Future<void> saveAll(Iterable<DraftEntity> drafts);
}

@DriftAccessor(
  tables: [
    Drafts,
  ],
)
class DriftDraftsDao extends DatabaseAccessor<DriftCatalystDatabase>
    with $DriftDraftsDaoMixin
    implements DraftsDao {
  DriftDraftsDao(super.attachedDatabase);

  @override
  Future<List<DraftEntity>> queryAll() {
    return select(drafts).get();
  }

  @override
  Future<int> countAll() {
    return drafts.count().getSingle();
  }

  @override
  Future<void> saveAll(Iterable<DraftEntity> drafts) async {
    await batch((batch) {
      batch.insertAll(
        this.drafts,
        drafts,
        mode: InsertMode.insertOrReplace,
      );
    });
  }
}
