import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/table/converter/document_converters.dart';
import 'package:catalyst_voices_repositories/src/database/table/mixin/document_table_content_mixin.dart';
import 'package:catalyst_voices_repositories/src/database/table/mixin/document_table_metadata_mixin.dart';
import 'package:drift/drift.dart';

/// This table holds in-progress (draft) versions of documents that are not yet
/// been made public or submitted.
///
/// [content] will be encrypted in future.
@DataClassName('LocalDocumentDraftEntity')
@TableIndex(name: 'idx_local_drafts_type_authors', columns: {#type, #authorsSignificant})
@TableIndex(name: 'idx_local_drafts_type_id', columns: {#type, #id})
@TableIndex(name: 'idx_local_drafts_created_at', columns: {#createdAt})
class LocalDocumentsDrafts extends Table
    with DocumentTableContentMixin, DocumentTableMetadataMixin {
  /// Keeps usernames of [authors].
  TextColumn get authorsNames => text().map(DocumentConverters.strings)();

  /// Keeps significant([CatalystId.toSignificant]) version of [authors].
  TextColumn get authorsSignificant => text().map(DocumentConverters.catId)();

  /// Timestamp extracted from [ver].
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>>? get primaryKey => {
    id,
    ver,
  };
}
