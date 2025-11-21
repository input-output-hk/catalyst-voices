import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/model/document_with_authors_entity.dart';
import 'package:catalyst_voices_repositories/src/database/table/document_authors.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.drift.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

final class DocumentWithAuthorsFactory {
  DocumentWithAuthorsFactory._();

  static DocumentWithAuthorsEntity create({
    String? id,
    String? ver,
    Map<String, dynamic> contentData = const {},
    DocumentType type = DocumentType.proposalDocument,
    DateTime? createdAt,
    String? authors,
    String? categoryId,
    String? categoryVer,
    String? refId,
    String? refVer,
    String? replyId,
    String? replyVer,
    String? section,
    String? templateId,
    String? templateVer,
  }) {
    id ??= DocumentRefFactory.randomUuidV7();
    ver ??= id;
    authors ??= '';

    final docEntity = DocumentEntityV2(
      id: id,
      ver: ver,
      content: DocumentDataContent(contentData),
      createdAt: createdAt ?? ver.tryDateTime ?? DateTime.now(),
      type: type,
      authors: authors,
      categoryId: categoryId,
      categoryVer: categoryVer,
      refId: refId,
      refVer: refVer,
      replyId: replyId,
      replyVer: replyVer,
      section: section,
      templateId: templateId,
      templateVer: templateVer,
    );

    final authorsEntities = authors
        .split(',')
        .where((element) => element.trim().isNotEmpty)
        .map(CatalystId.tryParse)
        .nonNulls
        .map(
          (e) => DocumentAuthorEntity(
            documentId: docEntity.id,
            documentVer: docEntity.ver,
            authorId: e.toUri().toString(),
            authorIdSignificant: e.toSignificant().toUri().toString(),
            authorUsername: e.username,
          ),
        )
        .toList();

    return DocumentWithAuthorsEntity(docEntity, authorsEntities);
  }
}
