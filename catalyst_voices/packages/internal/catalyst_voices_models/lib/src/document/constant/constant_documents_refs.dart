import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Groups related [proposal] and [comment] templates to given [category].
final class CategoryTemplatesRefs extends Equatable {
  final SignedDocumentRef category;
  final SignedDocumentRef proposal;
  final SignedDocumentRef comment;

  const CategoryTemplatesRefs({
    required this.category,
    required this.proposal,
    required this.comment,
  });

  Iterable<SignedDocumentRef> get all => [category, proposal, comment];

  @override
  List<Object?> get props => [category, proposal, comment];

  bool hasId(String id) => withId(id) != null;

  SignedDocumentRef? withId(String id) {
    if (category.id == id) {
      return category;
    }
    if (proposal.id == id) {
      return proposal;
    }
    if (comment.id == id) {
      return comment;
    }

    return null;
  }
}
