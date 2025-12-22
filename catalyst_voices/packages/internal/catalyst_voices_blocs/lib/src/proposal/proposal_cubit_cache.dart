import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Cache for [ProposalCubit].
final class ProposalCubitCache extends Equatable {
  final CatalystId? activeAccountId;
  final DocumentRef? ref;
  final ProposalDocument? proposal;
  final CampaignCategory? category;
  final CommentTemplate? commentTemplate;
  final List<CommentWithReplies>? comments;
  final List<ProposalDataCollaborator>? collaborators;
  final bool? isFavorite;
  final bool? isVotingStage;
  final bool? showComments;
  final bool? readOnlyMode;
  final ProposalBriefDataVotes? votes;
  final List<DocumentRef>? versions;
  final ProposalPublish? publish;

  const ProposalCubitCache({
    this.activeAccountId,
    this.ref,
    this.proposal,
    this.category,
    this.commentTemplate,
    this.comments,
    this.collaborators,
    this.isFavorite,
    this.isVotingStage,
    this.showComments,
    this.readOnlyMode,
    this.votes,
    this.versions,
    this.publish,
  });

  @override
  List<Object?> get props => [
    activeAccountId,
    ref,
    proposal,
    category,
    commentTemplate,
    comments,
    collaborators,
    isFavorite,
    isVotingStage,
    showComments,
    readOnlyMode,
    votes,
    versions,
    publish,
  ];

  ProposalCubitCache copyWith({
    Optional<CatalystId>? activeAccountId,
    Optional<DocumentRef>? ref,
    Optional<ProposalDocument>? proposal,
    Optional<CampaignCategory>? category,
    Optional<CommentTemplate>? commentTemplate,
    Optional<List<CommentWithReplies>>? comments,
    Optional<List<ProposalDataCollaborator>>? collaborators,
    Optional<bool>? isFavorite,
    Optional<bool>? isVotingStage,
    Optional<bool>? showComments,
    Optional<bool>? readOnlyMode,
    Optional<ProposalBriefDataVotes>? votes,
    Optional<List<DocumentRef>>? versions,
    Optional<ProposalPublish>? publish,
  }) {
    return ProposalCubitCache(
      activeAccountId: activeAccountId.dataOr(this.activeAccountId),
      ref: ref.dataOr(this.ref),
      proposal: proposal.dataOr(this.proposal),
      category: category.dataOr(this.category),
      commentTemplate: commentTemplate.dataOr(this.commentTemplate),
      comments: comments.dataOr(this.comments),
      collaborators: collaborators.dataOr(this.collaborators),
      isFavorite: isFavorite.dataOr(this.isFavorite),
      isVotingStage: isVotingStage.dataOr(this.isVotingStage),
      showComments: showComments.dataOr(this.showComments),
      readOnlyMode: readOnlyMode.dataOr(this.readOnlyMode),
      votes: votes.dataOr(this.votes),
      versions: versions.dataOr(this.versions),
      publish: publish.dataOr(this.publish),
    );
  }

  ProposalCubitCache copyWithoutProposal() {
    return copyWith(
      proposal: const Optional.empty(),
      commentTemplate: const Optional.empty(),
      comments: const Optional.empty(),
      isFavorite: const Optional.empty(),
      isVotingStage: const Optional.empty(),
      showComments: const Optional.empty(),
      readOnlyMode: const Optional.empty(),
      category: const Optional.empty(),
      votes: const Optional.empty(),
      ref: const Optional.empty(),
      versions: const Optional.empty(),
      publish: const Optional.empty(),
    );
  }
}
