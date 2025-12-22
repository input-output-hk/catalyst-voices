import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Cache for [ProposalCubit].
final class ProposalCubitCache extends Equatable {
  final CatalystId? activeAccountId;
  final DocumentRef? id;
  final ProposalDataV2? proposalData;
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
    this.id,
    this.proposalData,
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
    id,
    proposalData,
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
    Optional<DocumentRef>? id,
    Optional<ProposalDataV2>? proposalData,
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
      id: id.dataOr(this.id),
      proposalData: proposalData.dataOr(this.proposalData),
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
      proposalData: const Optional.empty(),
      proposal: const Optional.empty(),
      commentTemplate: const Optional.empty(),
      comments: const Optional.empty(),
      isFavorite: const Optional.empty(),
      isVotingStage: const Optional.empty(),
      showComments: const Optional.empty(),
      readOnlyMode: const Optional.empty(),
      category: const Optional.empty(),
      votes: const Optional.empty(),
      id: const Optional.empty(),
      versions: const Optional.empty(),
      publish: const Optional.empty(),
    );
  }
}
