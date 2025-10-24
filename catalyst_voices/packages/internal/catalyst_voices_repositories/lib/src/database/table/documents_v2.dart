import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/table/mixin/document_table_content_mixin.dart';
import 'package:catalyst_voices_repositories/src/database/table/mixin/document_table_metadata_mixin.dart';
import 'package:drift/drift.dart';

/// This table stores a record of each document (including its content and
/// related metadata).
///
/// Its representation of [DocumentData] class.
@DataClassName('DocumentEntity')
class DocumentsV2 extends Table with DocumentTableContentMixin, DocumentTableMetadataMixin {
  /// Timestamp extracted from [ver].
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>>? get primaryKey => {id, ver};
}
