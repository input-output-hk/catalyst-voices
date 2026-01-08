import 'package:drift/drift.dart';

@DataClassName('DocumentLocalMetadataEntity')
@TableIndex(name: 'idx_local_metadata_favorite', columns: {#isFavorite})
class DocumentsLocalMetadata extends Table {
  TextColumn get id => text()();

  BoolColumn get isFavorite => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}
