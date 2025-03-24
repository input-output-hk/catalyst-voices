import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalCubitCache extends Equatable {
  final CatalystId? activeAccountId;
  final DocumentRef? ref;
  final ProposalData? proposal;
  final CommentTemplate? commentTemplate;
  final List<CommentWithReplies>? comments;
  final bool? isFavorite;

  const ProposalCubitCache({
    this.activeAccountId,
    this.ref,
    this.proposal,
    this.commentTemplate,
    this.comments,
    this.isFavorite,
  });

  @override
  List<Object?> get props => [
        activeAccountId,
        ref,
        proposal,
        commentTemplate,
        comments,
        isFavorite,
      ];

  ProposalCubitCache copyWith({
    Optional<CatalystId>? activeAccountId,
    Optional<DocumentRef>? ref,
    Optional<ProposalData>? proposal,
    Optional<CommentTemplate>? commentTemplate,
    Optional<List<CommentWithReplies>>? comments,
    Optional<bool>? isFavorite,
  }) {
    return ProposalCubitCache(
      activeAccountId: activeAccountId.dataOr(this.activeAccountId),
      ref: ref.dataOr(this.ref),
      proposal: proposal.dataOr(this.proposal),
      commentTemplate: commentTemplate.dataOr(this.commentTemplate),
      comments: comments.dataOr(this.comments),
      isFavorite: isFavorite.dataOr(this.isFavorite),
    );
  }
}
