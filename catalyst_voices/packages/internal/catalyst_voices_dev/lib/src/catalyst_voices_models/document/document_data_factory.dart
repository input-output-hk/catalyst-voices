import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart' hide Document;

abstract final class DocumentDataFactory {
  static DocumentData build({
    DocumentContentType contentType = DocumentContentType.json,
    DocumentType type = DocumentType.proposalDocument,
    DocumentRef? id,
    SignedDocumentRef? template,
    DocumentParameters parameters = const DocumentParameters(),
    DocumentDataContent content = const DocumentDataContent({}),
  }) {
    return DocumentData(
      metadata: DocumentDataMetadata(
        contentType: contentType,
        type: type,
        id: id ?? DocumentRefFactory.signedDocumentRef(),
        template: template,
        parameters: parameters,
      ),
      content: content,
    );
  }
}
