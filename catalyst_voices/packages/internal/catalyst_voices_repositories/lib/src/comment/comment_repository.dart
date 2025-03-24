import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_schema_dto.dart';

abstract interface class CommentRepository {
  const factory CommentRepository(
    SignedDocumentManager signedDocumentManager,
    DocumentRepository documentRepository,
  ) = DocumentsCommentRepository;

  Future<CommentTemplate> getCommentTemplate({
    required SignedDocumentRef ref,
  });

  Future<void> publishComment({
    required DocumentData document,
    required CatalystId catalystId,
    required CatalystPrivateKey privateKey,
  });

  Stream<List<CommentDocument>> watchCommentsWith({
    required DocumentRef ref,
  });
}

final class DocumentsCommentRepository implements CommentRepository {
  final SignedDocumentManager _signedDocumentManager;
  final DocumentRepository _documentRepository;

  const DocumentsCommentRepository(
    this._signedDocumentManager,
    this._documentRepository,
  );

  @override
  Future<CommentTemplate> getCommentTemplate({
    required SignedDocumentRef ref,
  }) async {
    final documentData = await _documentRepository.getDocumentData(ref: ref);

    return _buildCommentTemplate(documentData: documentData);
  }

  @override
  Future<void> publishComment({
    required DocumentData document,
    required CatalystId catalystId,
    required CatalystPrivateKey privateKey,
  }) async {
    final ref = document.metadata.ref;
    final reply = document.metadata.ref;

    assert(ref != null, 'CommentDocument have to have a ref to other document');

    final signedDocument = await _signedDocumentManager.signDocument(
      SignedDocumentJsonPayload(document.content.data),
      metadata: SignedDocumentMetadata(
        contentType: SignedDocumentContentType.json,
        documentType: DocumentType.commentDocument,
        id: document.metadata.id,
        ver: document.metadata.version,
        ref: SignedDocumentMetadataRef.fromDocumentRef(ref!),
        reply: reply != null
            ? SignedDocumentMetadataRef.fromDocumentRef(reply)
            : null,
      ),
      catalystId: catalystId,
      privateKey: privateKey,
    );

    await _documentRepository.publishDocument(document: signedDocument);
  }

  @override
  Stream<List<CommentDocument>> watchCommentsWith({
    required DocumentRef ref,
  }) {
    // TODO: implement watchCommentsWith
    throw UnimplementedError();
  }

  CommentTemplate _buildCommentTemplate({
    required DocumentData documentData,
  }) {
    assert(
      documentData.metadata.type == DocumentType.commentTemplate,
      'Not a commentTemplate document data type',
    );
    assert(
      documentData.metadata.selfRef is SignedDocumentRef,
      'Comment template only supports signed documents',
    );

    final metadata = CommentTemplateMetadata(
      selfRef: documentData.metadata.selfRef as SignedDocumentRef,
    );

    final contentData = documentData.content.data;
    final schema = DocumentSchemaDto.fromJson(contentData).toModel();

    return CommentTemplate(
      metadata: metadata,
      schema: schema,
    );
  }
}
