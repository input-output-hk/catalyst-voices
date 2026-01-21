import 'package:catalyst_voices_blocs/src/document_viewer/cache/document_viewer_cache.dart';
import 'package:catalyst_voices_blocs/src/document_viewer/cache/document_viewer_collaborators_cache.dart';
import 'package:catalyst_voices_blocs/src/document_viewer/cache/document_viewer_comments_cache.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';

/// Cache for ProposalViewerCubit with support for comments, voting, and collaborators.
final class ProposalViewerCache
    implements DocumentViewerCache, DocumentViewerCommentsCache, DocumentViewerCollaboratorsCache {
  @override
  final DocumentRef? id;

  @override
  final CatalystId? activeAccountId;

  @override
  final DocumentParameters? documentParameters;

  /// The full proposal data including metadata, versions, collaborators, votes, etc.
  final ProposalDataV2? proposalData;

  @override
  final List<CommentWithReplies>? comments;

  @override
  final CommentTemplate? commentTemplate;

  @override
  final CollaboratorProposalState collaboratorsState;

  ProposalViewerCache({
    this.id,
    this.activeAccountId,
    this.documentParameters,
    this.proposalData,
    this.comments,
    this.commentTemplate,
    this.collaboratorsState = const NoneCollaboratorProposalState(),
  });

  /// Creates an empty cache with default values.
  factory ProposalViewerCache.empty() => ProposalViewerCache();

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

  @override
  ProposalViewerCache copyWithCollaborators(CollaboratorProposalState collaboratorsState) {
    return copyWith(collaboratorsState: collaboratorsState);
  }

  @override
  ProposalViewerCache copyWithComments(List<CommentWithReplies>? comments) {
    return copyWith(comments: Optional(comments));
  }

  @override
  ProposalViewerCache copyWithCommentTemplate(CommentTemplate? template) {
    return copyWith(commentTemplate: Optional(template));
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
