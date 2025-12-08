import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart' hide Document;

abstract final class DocumentDataFactory {
  static DocumentData build({
    DocumentType type = DocumentType.proposalDocument,
    DocumentRef? id,
    SignedDocumentRef? ref,
    SignedDocumentRef? template,
    List<CatalystId>? collaborators,
    DocumentParameters parameters = const DocumentParameters(),
    List<CatalystId>? authors,
    DocumentContentType contentType = DocumentContentType.json,
    Map<String, dynamic> contentData = const {},
  }) {
    return DocumentData(
      metadata: DocumentDataMetadata(
        contentType: contentType,
        type: type,
        id: id ?? DocumentRefFactory.signedDocumentRef(),
        ref: ref,
        template: template,
        collaborators: collaborators,
        parameters: parameters,
        authors: authors,
      ),
      content: DocumentDataContent(contentData),
    );
  }
}
