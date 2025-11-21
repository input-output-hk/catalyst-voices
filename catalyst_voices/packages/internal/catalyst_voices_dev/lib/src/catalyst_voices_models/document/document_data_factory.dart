import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart' hide Document;

abstract final class DocumentDataFactory {
  static DocumentData build({
    DocumentType type = DocumentType.proposalDocument,
    DocumentRef? selfRef,
    SignedDocumentRef? template,
    SignedDocumentRef? categoryId,
    DocumentDataContent content = const DocumentDataContent({}),
  }) {
    return DocumentData(
      metadata: DocumentDataMetadata(
        type: type,
        selfRef: selfRef ?? DocumentRefFactory.signedDocumentRef(),
        template: template,
        categoryId: categoryId,
      ),
      content: content,
    );
  }
}
