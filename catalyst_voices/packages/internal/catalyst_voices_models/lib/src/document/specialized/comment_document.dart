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

  DocumentData toDocumentData({
    required DocumentMapper mapper,
  }) {
    return DocumentData(
      metadata: metadata.toDocumentMetadata(),
      content: mapper.toContent(document),
    );
  }
}

final class CommentMetadata extends DocumentMetadata {
  /// [ref] is document ref that this comment refers to. Comment can not
  /// exist on its own but just in a context of other documents.
  final SignedDocumentRef ref;

  /// against which [CommentDocument] is valid.
  final SignedDocumentRef template;

  /// [reply] equals other comment of this is a reply to it.
  final SignedDocumentRef? reply;

  // Nullable only for backwards compatibility.
  /// Pointer to category of proposal that [ref] points to.
  final DocumentParameters parameters;

  /// Creator of document.
  final CatalystId authorId;

  CommentMetadata({
    // Note. no drafts for comments
    required SignedDocumentRef super.id,
    required this.ref,
    required this.template,
    this.reply,
    required this.parameters,
    required this.authorId,
  }) : assert(
         ref.isExact,
         'Comments can refer only exact documents',
       );

  @override
  SignedDocumentRef get id => super.id as SignedDocumentRef;

  @override
  List<Object?> get props =>
      super.props +
      [
        ref,
        template,
        reply,
        parameters,
        authorId,
      ];

  DocumentDataMetadata toDocumentMetadata() {
    return DocumentDataMetadata.comment(
      id: id,
      proposalRef: ref,
      template: template,
      reply: reply,
      authors: [authorId],
      parameters: parameters,
    );
  }
}
