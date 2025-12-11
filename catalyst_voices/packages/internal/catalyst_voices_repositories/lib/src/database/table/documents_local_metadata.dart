import 'package:drift/drift.dart';

@DataClassName('DocumentLocalMetadataEntity')
class DocumentsLocalMetadata extends Table {
  TextColumn get id => text()();

  BoolColumn get isFavorite => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}
