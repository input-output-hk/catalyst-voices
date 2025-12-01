// ignore: directives_ordering,unused_import
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.dart';
import 'package:drift/drift.dart';

@DataClassName('DocumentParameterEntity')
@TableIndex(
  name: 'idx_document_parameters_composite',
  columns: {#documentId, #documentVer, #id, #ver},
)
class DocumentParameters extends Table {
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (document_id, document_ver) REFERENCES documents_v2(id, ver) ON DELETE CASCADE',
  ];

  TextColumn get documentId => text()();

  TextColumn get documentVer => text()();

  TextColumn get id => text()();

  @override
  Set<Column> get primaryKey => {id, ver, documentId, documentVer};

  TextColumn get ver => text()();
}
