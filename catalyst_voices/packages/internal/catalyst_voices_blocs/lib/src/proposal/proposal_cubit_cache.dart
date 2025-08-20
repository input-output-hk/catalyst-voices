import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Cache for [ProposalCubit].
final class ProposalCubitCache extends Equatable {
  final CatalystId? activeAccountId;
  final DocumentRef? ref;
  final ProposalDetailData? proposal;
  final CampaignCategory? category;
  final CommentTemplate? commentTemplate;
  final List<CommentWithReplies>? comments;
  final bool? isFavorite;
  final bool? isVotingStage;
  final bool? readOnlyMode;
  final Vote? lastCastedVote;

  const ProposalCubitCache({
    this.activeAccountId,
    this.ref,
    this.proposal,
    this.category,
    this.commentTemplate,
    this.comments,
    this.isFavorite,
    this.isVotingStage,
    this.readOnlyMode,
    this.lastCastedVote,
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
    isVotingStage,
    readOnlyMode,
    lastCastedVote,
  ];

  ProposalCubitCache copyWith({
    Optional<CatalystId>? activeAccountId,
    Optional<DocumentRef>? ref,
    Optional<ProposalDetailData>? proposal,
    Optional<CampaignCategory>? category,
    Optional<CommentTemplate>? commentTemplate,
    Optional<List<CommentWithReplies>>? comments,
    Optional<bool>? isFavorite,
    Optional<bool>? isVotingStage,
    Optional<bool>? readOnlyMode,
    Optional<Vote>? lastCastedVote,
  }) {
    return ProposalCubitCache(
      activeAccountId: activeAccountId.dataOr(this.activeAccountId),
      ref: ref.dataOr(this.ref),
      proposal: proposal.dataOr(this.proposal),
      category: category.dataOr(this.category),
      commentTemplate: commentTemplate.dataOr(this.commentTemplate),
      comments: comments.dataOr(this.comments),
      isFavorite: isFavorite.dataOr(this.isFavorite),
      isVotingStage: isVotingStage.dataOr(this.isVotingStage),
      readOnlyMode: readOnlyMode.dataOr(this.readOnlyMode),
      lastCastedVote: lastCastedVote.dataOr(this.lastCastedVote),
    );
  }

  ProposalCubitCache copyWithoutProposal() {
    return copyWith(
      proposal: const Optional.empty(),
      commentTemplate: const Optional.empty(),
      comments: const Optional.empty(),
      isFavorite: const Optional.empty(),
      isVotingStage: const Optional.empty(),
      readOnlyMode: const Optional.empty(),
      category: const Optional.empty(),
      lastCastedVote: const Optional.empty(),
      ref: const Optional.empty(),
    );
  }
}
