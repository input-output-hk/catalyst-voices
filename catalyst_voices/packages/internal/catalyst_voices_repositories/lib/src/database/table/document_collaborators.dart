// ignore: directives_ordering,unused_import
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.dart';
import 'package:catalyst_voices_repositories/src/database/table/mixin/account_table_mixin.dart';
import 'package:drift/drift.dart';

/// Normalized junction table for document collaborators with efficient querying capabilities.
@DataClassName('DocumentCollaboratorEntity')
@TableIndex(
  name: 'idx_document_collaborators_composite',
  columns: {#documentId, #documentVer, #accountSignificantId},
)
@TableIndex(name: 'idx_document_collaborators_identity', columns: {#accountSignificantId})
@TableIndex(name: 'idx_document_collaborators_username', columns: {#username})
class DocumentCollaborators extends Table with AccountTableMixin {
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (document_id, document_ver) REFERENCES documents_v2(id, ver) ON DELETE CASCADE',
  ];

  TextColumn get documentId => text()();

  TextColumn get documentVer => text()();

  @override
  Set<Column> get primaryKey => {documentId, documentVer, accountId};
}
