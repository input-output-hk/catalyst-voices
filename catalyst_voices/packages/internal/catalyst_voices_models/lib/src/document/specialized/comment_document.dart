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
}

final class CommentMetadata extends DocumentMetadata {
  final SignedDocumentRef? parent;

  CommentMetadata({
    required SignedDocumentRef super.selfRef,
    this.parent,
  });

  @override
  List<Object?> get props => super.props + [parent];
}
