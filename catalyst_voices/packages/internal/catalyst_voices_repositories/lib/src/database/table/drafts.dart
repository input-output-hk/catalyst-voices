import 'package:catalyst_voices_repositories/src/database/table/documents_metadata.dart';
import 'package:catalyst_voices_repositories/src/database/table/mixin/document_table_mixin.dart';
import 'package:catalyst_voices_repositories/src/database/table/mixin/id_table_mixin.dart';
import 'package:catalyst_voices_repositories/src/database/table/mixin/ver_table_mixin.dart';
import 'package:drift/drift.dart';

/// This table holds in-progress (draft) versions of documents that are not yet
/// been made public or submitted.
///
/// [content] will be encrypted in future but we still need to be able to
/// search for drafts against fields like [title] for example.
///
/// In future we may need to delete [title] or add more columns for search
/// purposes. If there will be too many requirements we may introduce
/// DraftsMetadata table, similar to [DocumentsMetadata].
@TableIndex(name: 'idx_draft_type', columns: {#type})
class Drafts extends Table
    with IdTableMixin, VerTableMixin, DocumentTableMixin {
  /// not encrypted title for search
  TextColumn get title => text()();

  @override
  Set<Column<Object>>? get primaryKey => {
        idHi,
        idLo,
        verHi,
        verLo,
      };
}
