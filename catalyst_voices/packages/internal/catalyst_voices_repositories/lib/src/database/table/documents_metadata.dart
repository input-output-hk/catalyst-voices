import 'package:catalyst_voices_repositories/src/database/table/documents.dart';
import 'package:drift/drift.dart';

@DataClassName('DocumentMetadata')
class DocumentsMetadata extends Table {
  // Composite key matching the Documents table over version not document fields
  Int64Column get verHi => int64().references(
        Documents,
        #verHi,
        onDelete: KeyAction.cascade,
        onUpdate: KeyAction.cascade,
      )();

  Int64Column get verLo => int64().references(
        Documents,
        #verLo,
        onDelete: KeyAction.cascade,
        onUpdate: KeyAction.cascade,
      )();

  // e.g. 'category', 'title', 'description'
  TextColumn get fieldKey => text()();

  // The actual value (for category, title, description, etc.)
  TextColumn get fieldValue => text()();

  @override
  Set<Column> get primaryKey => {verHi, verLo, fieldKey};
}
