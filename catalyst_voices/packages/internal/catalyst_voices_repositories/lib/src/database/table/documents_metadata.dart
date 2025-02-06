import 'package:catalyst_voices_repositories/src/database/table/documents.dart';
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
  @override
  Int64Column get verHi => int64().references(
        Documents,
        #verHi,
        onDelete: KeyAction.cascade,
        onUpdate: KeyAction.cascade,
      )();

  @override
  Int64Column get verLo => int64().references(
        Documents,
        #verLo,
        onDelete: KeyAction.cascade,
        onUpdate: KeyAction.cascade,
      )();

  /// e.g. 'category', 'title', 'description'
  TextColumn get fieldKey => textEnum<DocumentMetadataFieldKey>()();

  /// The actual value (for category, title, description, etc.)
  TextColumn get fieldValue => text()();

  @override
  Set<Column> get primaryKey => {
        verHi,
        verLo,
        fieldKey,
      };
}
