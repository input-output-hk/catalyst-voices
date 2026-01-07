import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/table/mixin/document_table_content_mixin.dart';
import 'package:catalyst_voices_repositories/src/database/table/mixin/document_table_metadata_mixin.dart';
import 'package:drift/drift.dart';

/// This table stores a record of each document with its content and flattened metadata fields.
///
/// Its representation of [DocumentData] class.
///
/// Identity & Versioning:
/// - [id]: Document identifier (UUIDv7). Multiple records can share same id (versioning).
/// - [ver]: Document version identifier (UUIDv7). Composite key with id.
/// - [createdAt]: Timestamp extracted from `ver` for sorting and filtering.
///
/// Versioning Model:
/// - Each ([id], [ver]) pair is unique (composite primary key).
/// - Multiple versions of same document coexist in table.
/// - Latest version is determined by comparing [createdAt] timestamps or `ver` UUIDv7 values.
/// - Example: Proposal with id='abc' can have ver='v1', ver='v2', ver='v3', etc.
///
/// Reference Relationships:
/// - proposal: uses [templateId] to reference the template's [id]
/// - proposal: uses [templateVer] to reference specific template [ver]
/// - proposalActionDocument: uses [refId] to reference the proposal's [id]
/// - proposalActionDocument: uses [refVer] to pin final action to specific proposal [ver]
/// - commentDocument: uses [refId] to reference commented proposal
@DataClassName('DocumentEntityV2')
@TableIndex(name: 'idx_documents_v2_type_id', columns: {#type, #id})
@TableIndex(name: 'idx_documents_v2_type_id_ver', columns: {#type, #id, #ver})
@TableIndex(name: 'idx_documents_v2_type_ref_id', columns: {#type, #refId})
@TableIndex(name: 'idx_documents_v2_type_ref_id_ver', columns: {#type, #refId, #ver})
@TableIndex(name: 'idx_documents_v2_ref_id_ver', columns: {#refId, #ver})
@TableIndex(name: 'idx_documents_v2_type_id_created_at', columns: {#type, #id, #createdAt})
@TableIndex(name: 'idx_documents_v2_type_ref_id_ref_ver', columns: {#type, #refId, #refVer})
@TableIndex(name: 'idx_documents_v2_type_created_at', columns: {#type, #createdAt})
@TableIndex(name: 'idx_documents_v2_type_template', columns: {#type, #templateId, #templateVer})
class DocumentsV2 extends Table with DocumentTableContentMixin, DocumentTableMetadataMixin {
  /// Timestamp extracted from [ver] field.
  /// Represents when this version was created.
  /// Used for sorting (ORDER BY createdAt DESC) and filtering by date range.
  DateTimeColumn get createdAt => dateTime()();

  /// Composite primary key: ([id], [ver])
  /// This allows multiple versions of the same document to coexist.
  /// SQLite enforces uniqueness on this combination.
  @override
  Set<Column<Object>>? get primaryKey => {id, ver};
}
