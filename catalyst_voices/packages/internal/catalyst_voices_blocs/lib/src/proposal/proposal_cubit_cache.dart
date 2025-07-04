import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Cache for [ProposalCubit].
final class ProposalCubitCache extends Equatable {
  final CatalystId? activeAccountId;
  final DocumentRef? ref;
  final ProposalData? proposal;
  final CampaignCategory? category;
  final CommentTemplate? commentTemplate;
  final List<CommentWithReplies>? comments;
  final bool? isFavorite;

  const ProposalCubitCache({
    this.activeAccountId,
    this.ref,
    this.proposal,
    this.category,
    this.commentTemplate,
    this.comments,
    this.isFavorite,
  });

  @override
  List<Object?> get props => [
        activeAccountId,
        ref,
        proposal,
        category,
        commentTemplate,
        comments,
        isFavorite,
      ];

  ProposalCubitCache copyWith({
    Optional<CatalystId>? activeAccountId,
    Optional<DocumentRef>? ref,
    Optional<ProposalData>? proposal,
    Optional<CampaignCategory>? category,
    Optional<CommentTemplate>? commentTemplate,
    Optional<List<CommentWithReplies>>? comments,
    Optional<bool>? isFavorite,
  }) {
    return ProposalCubitCache(
      activeAccountId: activeAccountId.dataOr(this.activeAccountId),
      ref: ref.dataOr(this.ref),
      proposal: proposal.dataOr(this.proposal),
      category: category.dataOr(this.category),
      commentTemplate: commentTemplate.dataOr(this.commentTemplate),
      comments: comments.dataOr(this.comments),
      isFavorite: isFavorite.dataOr(this.isFavorite),
    );
  }
}
