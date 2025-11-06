import 'package:drift/drift.dart';

@DataClassName('DocumentAuthorEntity')
@TableIndex(
  name: 'idx_document_authors_composite',
  columns: {#documentId, #documentVer, #authorCatIdSignificant},
)
@TableIndex(name: 'idx_document_authors_identity', columns: {#authorCatIdSignificant})
@TableIndex(name: 'idx_document_authors_username', columns: {#authorUsername})
class DocumentAuthors extends Table {
  TextColumn get authorCatId => text()();

  TextColumn get authorCatIdSignificant => text()();

  TextColumn get authorCatIdWithoutUsername => text()();

  TextColumn get authorUsername => text().nullable()();

  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (document_id, document_ver) REFERENCES documents_v2(id, ver) ON DELETE CASCADE',
  ];

  TextColumn get documentId => text()();

  TextColumn get documentVer => text()();

  @override
  Set<Column> get primaryKey => {documentId, documentVer, authorCatId};
}
