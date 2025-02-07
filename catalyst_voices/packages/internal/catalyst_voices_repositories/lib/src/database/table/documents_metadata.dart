import 'package:catalyst_voices_repositories/src/database/table/documents.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/mixin/ver_table_mixin.dart';
import 'package:drift/drift.dart';

/// Syntax sugar num to working with [DocumentsMetadata] queries
/// so keys names are strongly defined here.
///
/// Add new fields as needed.
enum DocumentMetadataFieldKey {
  title,
}

/// This table breaks out metadata into a key-value structure for each
/// document version, enabling more granular or indexed queries
@DataClassName('DocumentMetadata')
@TableIndex(
  name: 'idx_doc_metadata_key_value',
  columns: {#fieldKey, #fieldValue},
)
class DocumentsMetadata extends Table with VerTableMixin {
  /// e.g. 'category', 'title', 'description'
  TextColumn get fieldKey => textEnum<DocumentMetadataFieldKey>()();

  /// The actual value (for category, title, description, etc.)
  TextColumn get fieldValue => text()();

  @override
  List<String> get customConstraints => [
        /// Referring with two columns throws a
        /// "SqliteException(1): foreign key mismatch"
        /// But when doing it explicitly it no longer complains
        // ignore: lines_longer_than_80_chars
        'FOREIGN KEY("ver_hi", "ver_lo") REFERENCES "${$DocumentsTable.$name}"("ver_hi", "ver_lo") ON DELETE CASCADE ON UPDATE CASCADE',
      ];

  @override
  Set<Column> get primaryKey => {
        verHi,
        verLo,
        fieldKey,
      };
}
