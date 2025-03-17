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

  Profile? get author {
    /* cSpell:disable */
    final uri = Uri.parse(
      'id.catalyst://cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE',
    );
    var catId = CatalystId.fromUri(uri);
    catId = catId.copyWith(username: const Optional('Daniel Ribar'));
    return Profile(catalystId: catId);
    /* cSpell:enable */
  }

  @override
  List<Object?> get props => [metadata, document];
}

final class CommentMetadata extends DocumentMetadata {
  final SignedDocumentRef? parent;

  CommentMetadata({
    // Note. no drafts for comments
    required SignedDocumentRef super.selfRef,
    this.parent,
  });

  @override
  List<Object?> get props => super.props + [parent];

  @override
  SignedDocumentRef get selfRef => super.selfRef as SignedDocumentRef;
}
