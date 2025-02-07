import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/table/mixin/document_table_mixin.dart';
import 'package:catalyst_voices_repositories/src/database/table/mixin/id_table_mixin.dart';
import 'package:catalyst_voices_repositories/src/database/table/mixin/ver_table_mixin.dart';
import 'package:drift/drift.dart';

/// This table stores a record of each document (including its content and
/// related metadata).
///
/// Its representation of [SignedDocumentData] class.
@TableIndex(name: 'idx_doc_type', columns: {#type})
@TableIndex(name: 'idx_unique_ver', columns: {#verHi, #verLo}, unique: true)
class Documents extends Table
    with IdHiLoTableMixin, VerHiLoTableMixin, DocumentTableMixin {
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>>? get primaryKey => {
        idHi,
        idLo,
        verHi,
        verLo,
      };
}
