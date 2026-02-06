import 'package:catalyst_voices_repositories/src/database/table/mixin/document_table_content_mixin.dart';
import 'package:catalyst_voices_repositories/src/database/table/mixin/document_table_metadata_mixin.dart';
import 'package:drift/drift.dart';

mixin DocumentTableMixin on Table, DocumentTableContentMixin, DocumentTableMetadataMixin {
  /// Timestamp extracted from [ver] field.
  /// Represents when this version was created.
  /// Used for sorting (ORDER BY createdAt DESC) and filtering by date range.
  DateTimeColumn get createdAt => dateTime()();

  /// Composite primary key: ([id], [ver])
  /// This allows multiple versions of the same document to coexist.
  /// SQLite enforces uniqueness on this combination.
  @override
  Set<Column<Object>>? get primaryKey => {id, ver};
}
