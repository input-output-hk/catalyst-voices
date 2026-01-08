import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_data_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_schema_dto.dart';

/// Allows access to comment data.
abstract interface class CommentRepository {
  const factory CommentRepository(
    SignedDocumentManager signedDocumentManager,
    DocumentRepository documentRepository,
  ) = DocumentsCommentRepository;

  Future<CommentTemplate?> getCommentTemplate({
    required DocumentRef category,
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
  Future<CommentTemplate?> getCommentTemplate({
    required DocumentRef category,
  }) async {
    final document = await _documentRepository.findFirst(
      type: DocumentType.commentTemplate,
      parameter: category,
    );

    if (document == null) {
      return null;
    }

    return _buildCommentTemplate(documentData: document);
  }

  @override
  Future<void> publishComment({
    required DocumentData document,
    required CatalystId catalystId,
    required CatalystPrivateKey privateKey,
  }) async {
    assert(
      document.metadata.ref != null,
      'CommentDocument have to have a ref to other document',
    );

    final signedDocument = await _signedDocumentManager.signDocument(
      SignedDocumentJsonPayload(document.content.data),
      metadata: document.metadata,
      catalystId: catalystId,
      privateKey: privateKey,
    );

    await _documentRepository.publishDocument(document: signedDocument);
  }

  @override
  Future<void> saveComment({
    required DocumentData document,
  }) async {
    await _documentRepository.upsertLocalDraftDocument(document: document);
  }

  @override
  Stream<List<CommentDocument>> watchCommentsWith({
    required DocumentRef ref,
  }) {
    return _documentRepository
        .watchDocuments(
          type: DocumentType.commentDocument,
          refGetter: (data) => data.metadata.template!,
          referencing: ref,
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
      documentData.metadata.id is SignedDocumentRef,
      'Comment only supports signed documents',
    );
    assert(
      documentData.metadata.ref is SignedDocumentRef,
      'Comment have to have a ref to other document',
    );

    final template = _buildCommentTemplate(documentData: templateData);

    final authors = documentData.metadata.authors;
    final metadata = CommentMetadata(
      id: documentData.metadata.id as SignedDocumentRef,
      proposalRef: documentData.metadata.ref! as SignedDocumentRef,
      commentTemplate: templateData.metadata.id as SignedDocumentRef,
      reply: documentData.metadata.reply,
      parameters: documentData.metadata.parameters,
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
      documentData.metadata.id is SignedDocumentRef,
      'Comment template only supports signed documents',
    );

    final metadata = CommentTemplateMetadata(
      id: documentData.metadata.id as SignedDocumentRef,
      parameters: documentData.metadata.parameters,
    );

    final contentData = documentData.content.data;
    final schema = DocumentSchemaDto.fromJson(contentData).toModel();

    return CommentTemplate(
      metadata: metadata,
      schema: schema,
    );
  }
}
