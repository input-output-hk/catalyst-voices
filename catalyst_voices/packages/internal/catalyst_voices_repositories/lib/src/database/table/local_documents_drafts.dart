import 'package:catalyst_voices_repositories/src/database/table/mixin/document_table_content_mixin.dart';
import 'package:catalyst_voices_repositories/src/database/table/mixin/document_table_metadata_mixin.dart';
import 'package:drift/drift.dart';

/// This table holds in-progress (draft) versions of documents that are not yet
/// been made public or submitted.
///
/// [content] will be encrypted in future.
@DataClassName('LocalDocumentDraftEntity')
class LocalDocumentsDrafts extends Table
    with DocumentTableContentMixin, DocumentTableMetadataMixin {
  /// Timestamp extracted from [ver].
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>>? get primaryKey => {
    id,
    ver,
  };
}
