import 'package:catalyst_voices_repositories/src/database/table/document_authors.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.drift.dart';

final class DocumentWithAuthorsEntity {
  final DocumentEntityV2 doc;
  final List<DocumentAuthorEntity> authors;

  const DocumentWithAuthorsEntity(this.doc, this.authors);
}
