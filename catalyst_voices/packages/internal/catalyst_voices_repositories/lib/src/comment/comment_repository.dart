import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_data_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_dto.dart';
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

  Future<void> saveComment({
    required DocumentData document,
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
    final reply = document.metadata.reply;
    assert(ref != null, 'CommentDocument have to have a ref to other document');

    final payload = SignedDocumentJsonPayload(document.content.data);
    final metadata = SignedDocumentMetadata(
      contentType: SignedDocumentContentType.json,
      documentType: DocumentType.commentDocument,
      id: document.metadata.id,
      ver: document.metadata.version,
      ref: SignedDocumentMetadataRef.fromDocumentRef(ref!),
      template: SignedDocumentMetadataRef.fromDocumentRef(
        document.metadata.template!,
      ),
      reply: reply != null
          ? SignedDocumentMetadataRef.fromDocumentRef(reply)
          : null,
    );

    final signedDocument = await _signedDocumentManager.signDocument(
      payload,
      metadata: metadata,
      catalystId: catalystId,
      privateKey: privateKey,
    );

    await _documentRepository.publishDocument(document: signedDocument);
  }

  @override
  Future<void> saveComment({
    required DocumentData document,
  }) async {
    await _documentRepository.upsertDocument(document: document);
  }

  @override
  Stream<List<CommentDocument>> watchCommentsWith({
    required DocumentRef ref,
  }) {
    return _documentRepository
        .watchDocuments(
      type: DocumentType.commentDocument,
      refGetter: (data) => data.metadata.template!,
      refTo: ref,
    )
        .map(
      (documents) {
        return documents.map((documentWithRef) {
          final commentData = documentWithRef.data;
          final templateData = documentWithRef.refData;

          return _buildCommentDocument(
            documentData: commentData,
            templateData: templateData,
          );
        }).toList();
      },
    );
  }

  CommentDocument _buildCommentDocument({
    required DocumentData documentData,
    required DocumentData templateData,
  }) {
    assert(
      documentData.metadata.type == DocumentType.commentDocument,
      'Not a commentDocument document data type',
    );
    assert(
      documentData.metadata.selfRef is SignedDocumentRef,
      'Comment only supports signed documents',
    );
    assert(
      documentData.metadata.ref is SignedDocumentRef,
      'Comment have to have a ref to other document',
    );

    final template = _buildCommentTemplate(documentData: templateData);

    final authors = documentData.metadata.authors;
    final metadata = CommentMetadata(
      selfRef: documentData.metadata.selfRef as SignedDocumentRef,
      ref: documentData.metadata.ref! as SignedDocumentRef,
      template: templateData.metadata.selfRef as SignedDocumentRef,
      reply: documentData.metadata.reply,
      authorId: authors!.single,
    );
    final content = DocumentDataContentDto.fromModel(
      documentData.content,
    );
    final schema = template.schema;
    final document = DocumentDto.fromJsonSchema(content, schema).toModel();

    return CommentDocument(
      metadata: metadata,
      document: document,
    );
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
