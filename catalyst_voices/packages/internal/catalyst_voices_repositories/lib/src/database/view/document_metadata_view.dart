import 'package:catalyst_voices_repositories/src/database/table/documents_v2.dart';
import 'package:catalyst_voices_repositories/src/database/table/local_documents_drafts.dart';
import 'package:catalyst_voices_repositories/src/database/table/mixin/document_table_metadata_mixin.dart';
import 'package:drift/drift.dart';

/// A view over [DocumentsV2] that excludes the `content` blob column.
///
/// This is optimized for queries that only need metadata, avoiding the
/// overhead of fetching potentially large content blobs from the database.
///
/// The view includes all columns from [DocumentTableMetadataMixin].
@DriftView(name: 'documents_v2_metadata_view')
abstract class DocumentsV2MetadataView extends View {
  DocumentsV2 get documentsV2;

  @override
  Query<HasResultSet, dynamic> as() => select([
    documentsV2.authors,
    documentsV2.collaborators,
    documentsV2.contentType,
    documentsV2.id,
    documentsV2.parameters,
    documentsV2.refId,
    documentsV2.refVer,
    documentsV2.replyId,
    documentsV2.replyVer,
    documentsV2.section,
    documentsV2.templateId,
    documentsV2.templateVer,
    documentsV2.type,
    documentsV2.ver,
    documentsV2.createdAt,
  ]).from(documentsV2);
}

/// A view over [LocalDocumentsDrafts] that excludes the `content` blob column.
///
/// This is optimized for queries that only need metadata, avoiding the
/// overhead of fetching potentially large content blobs from the database.
///
/// The view includes all columns from [DocumentTableMetadataMixin].
@DriftView(name: 'local_documents_drafts_metadata_view')
abstract class LocalDocumentsDraftsMetadataView extends View {
  LocalDocumentsDrafts get localDocumentsDrafts;

  @override
  Query<HasResultSet, dynamic> as() => select([
    localDocumentsDrafts.authors,
    localDocumentsDrafts.collaborators,
    localDocumentsDrafts.contentType,
    localDocumentsDrafts.id,
    localDocumentsDrafts.parameters,
    localDocumentsDrafts.refId,
    localDocumentsDrafts.refVer,
    localDocumentsDrafts.replyId,
    localDocumentsDrafts.replyVer,
    localDocumentsDrafts.section,
    localDocumentsDrafts.templateId,
    localDocumentsDrafts.templateVer,
    localDocumentsDrafts.type,
    localDocumentsDrafts.ver,
    localDocumentsDrafts.createdAt,
  ]).from(localDocumentsDrafts);
}
