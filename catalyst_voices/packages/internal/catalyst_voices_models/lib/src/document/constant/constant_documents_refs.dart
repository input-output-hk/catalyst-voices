import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Groups related [proposal] and [comment] templates to given [category].
final class CategoryTemplatesRefs extends Equatable {
  final SignedDocumentRef category;
  final SignedDocumentRef? proposal;
  final SignedDocumentRef? comment;

  const CategoryTemplatesRefs({
    required this.category,
    this.proposal,
    this.comment,
  });

  Iterable<SignedDocumentRef> get all => [
    category,
    ?proposal,
    ?comment,
  ];

  Iterable<TypedDocumentRef> get allTyped {
    return [
      TypedDocumentRef(
        ref: category,
        type: DocumentType.categoryParametersDocument,
      ),
      if (proposal case final value?)
        TypedDocumentRef(ref: value, type: DocumentType.proposalTemplate),
      if (comment case final value?)
        TypedDocumentRef(ref: value, type: DocumentType.commentTemplate),
    ];
  }

  @override
  List<Object?> get props => [
    category,
    proposal,
    comment,
  ];
}
