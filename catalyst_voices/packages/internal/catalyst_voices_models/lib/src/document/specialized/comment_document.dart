import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_models/src/document/document_metadata.dart';
import 'package:equatable/equatable.dart';

final class CommentDocument extends Equatable {
  static final content = DocumentNodeId.fromString('comment.content');

  final CommentMetadata metadata;
  final Document document;

  const CommentDocument({
    required this.metadata,
    required this.document,
  });

  @override
  List<Object?> get props => [metadata, document];

  DocumentData toDocumentData({required DocumentMapper mapper}) {
    return DocumentData(
      metadata: metadata.toDocumentMetadata(),
      content: mapper.toContent(document),
    );
  }
}

final class CommentMetadata extends DocumentMetadata {
  /// [proposalRef] is document ref that this comment refers to. Comment can not
  /// exist on its own but just in a context of other documents.
  final SignedDocumentRef proposalRef;

  /// Against which [CommentDocument] is valid.
  final SignedDocumentRef commentTemplate;

  /// [reply] equals other comment of this is a reply to it.
  final SignedDocumentRef? reply;

  /// Creator of document.
  final CatalystId authorId;

  CommentMetadata({
    // Note. no drafts for comments
    required SignedDocumentRef super.selfRef,
    required super.parameters,
    required this.proposalRef,
    required this.commentTemplate,
    this.reply,
    required this.authorId,
  }) : assert(
         proposalRef.isExact,
         'Comments can refer only exact documents',
       );

  @override
  List<Object?> get props =>
      super.props +
      [
        proposalRef,
        commentTemplate,
        reply,
        authorId,
      ];

  @override
  SignedDocumentRef get selfRef => super.selfRef as SignedDocumentRef;

  DocumentDataMetadata toDocumentMetadata() {
    return DocumentDataMetadata.comment(
      selfRef: selfRef,
      proposalRef: proposalRef,
      template: commentTemplate,
      reply: reply,
      authors: [authorId],
      parameters: parameters,
    );
  }
}
