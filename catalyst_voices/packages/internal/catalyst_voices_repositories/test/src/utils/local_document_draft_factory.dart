import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/table/local_documents_drafts.drift.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

final class LocalDocumentDraftFactory {
  LocalDocumentDraftFactory._();

  static LocalDocumentDraftEntity create({
    String? id,
    String? ver,
    Map<String, dynamic> contentData = const {},
    DocumentContentType contentType = DocumentContentType.json,
    DocumentType type = DocumentType.proposalDocument,
    DateTime? createdAt,
    List<CatalystId>? authors,
    String? refId,
    String? refVer,
    String? replyId,
    String? replyVer,
    String? section,
    String? templateId,
    String? templateVer,
    List<DocumentRef> parameters = const [],
    List<CatalystId> collaborators = const [],
  }) {
    id ??= DocumentRefFactory.randomUuidV7();
    ver ??= id;
    authors ??= const [];
    final authorsNames = authors.map((e) => e.username).toList();
    final authorsSignificant = authors.map((e) => e.toSignificant()).toList();

    return LocalDocumentDraftEntity(
      id: id,
      ver: ver,
      contentType: contentType.value,
      content: DocumentDataContent(contentData),
      createdAt: createdAt ?? ver.tryDateTime ?? DateTime.now(),
      type: type,
      authors: authors,
      authorsNames: authorsNames,
      authorsSignificant: authorsSignificant,
      refId: refId,
      refVer: refVer,
      replyId: replyId,
      replyVer: replyVer,
      section: section,
      templateId: templateId,
      templateVer: templateVer,
      collaborators: collaborators,
      parameters: DocumentParameters(parameters.map((e) => e.toSignedDocumentRef()).toSet()),
    );
  }
}
