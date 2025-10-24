import 'package:catalyst_voices_repositories/src/database/table/converter/document_converters.dart';
import 'package:drift/drift.dart';

@DataClassName('DocumentFavoriteEntity')
class DocumentsFavoritesV2 extends Table {
  TextColumn get id => text()();

  BoolColumn get isFavorite => boolean()();

  @override
  Set<Column> get primaryKey => {id};

  TextColumn get type => text().map(DocumentConverters.type)();
}
