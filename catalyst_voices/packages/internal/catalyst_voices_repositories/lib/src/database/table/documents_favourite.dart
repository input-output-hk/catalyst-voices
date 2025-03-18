import 'package:catalyst_voices_repositories/src/database/table/converter/document_converters.dart';
import 'package:catalyst_voices_repositories/src/database/table/mixin/id_table_mixin.dart';
import 'package:drift/drift.dart';

@TableIndex(name: 'idx_doc_favourite_type', columns: {#type})
@TableIndex(name: 'idx_doc_unique_ver', columns: {#verHi, #verLo}, unique: true)
@DataClassName('DocumentFavouriteEntity')
class DocumentsFavourite extends Table with IdHiLoTableMixin {
  BoolColumn get isFavourite => boolean()();

  BoolColumn get isLocalDraft => boolean()();

  @override
  Set<Column> get primaryKey => {
        idHi,
        idLo,
      };

  TextColumn get type => text().map(DocumentConverters.type)();
}
