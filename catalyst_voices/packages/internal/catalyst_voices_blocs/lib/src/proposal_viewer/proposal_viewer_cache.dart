import 'package:catalyst_voices_blocs/src/document_viewer/cache/document_viewer_cache.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';

/// Cache for ProposalViewerCubit with support for comments, voting, and collaborators.
final class ProposalViewerCache extends DocumentViewerCache<ProposalViewerCache> {
  /// The full proposal data including metadata, versions, collaborators, votes, etc.
  final ProposalDataV2? proposalData;

  const ProposalViewerCache({
    super.id,
    super.activeAccountId,
    super.documentParameters,
    super.comments,
    super.commentTemplate,
    super.collaboratorsState = const NoneCollaboratorProposalState(),
    this.proposalData,
  });

  @override
  ProposalViewerCache copyWith({
    Optional<DocumentRef>? id,
    Optional<CatalystId>? activeAccountId,
    Optional<DocumentParameters>? documentParameters,
    Optional<ProposalDataV2>? proposalData,
    Optional<List<CommentWithReplies>>? comments,
    Optional<CommentTemplate>? commentTemplate,
    Optional<Vote>? vote,
    CollaboratorProposalState? collaboratorsState,
  }) {
    return ProposalViewerCache(
      id: id.dataOr(this.id),
      activeAccountId: activeAccountId.dataOr(this.activeAccountId),
      documentParameters: documentParameters.dataOr(this.documentParameters),
      proposalData: proposalData.dataOr(this.proposalData),
      comments: comments.dataOr(this.comments),
      commentTemplate: commentTemplate.dataOr(this.commentTemplate),
      collaboratorsState: collaboratorsState ?? this.collaboratorsState,
    );
  }

  /// Updates the favorite status of the proposal.
  ProposalViewerCache copyWithIsFavorite({required bool value}) {
    return copyWith(
      proposalData: Optional(proposalData?.copyWith(isFavorite: value)),
    );
  }

  /// Clears proposal-specific data while keeping account information.
  ProposalViewerCache copyWithoutProposal() {
    return copyWith(
      id: const Optional.empty(),
      documentParameters: const Optional.empty(),
      proposalData: const Optional.empty(),
      comments: const Optional.empty(),
      commentTemplate: const Optional.empty(),
      vote: const Optional.empty(),
      collaboratorsState: const NoneCollaboratorProposalState(),
    );
  }
}
