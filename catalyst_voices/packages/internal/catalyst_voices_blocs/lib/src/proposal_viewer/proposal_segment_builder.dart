import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';

/// Builder for creating proposal view segments.
///
/// This class encapsulates the logic for building different types of segments
/// used in the proposal viewer, reducing complexity in the cubit.
final class ProposalSegmentBuilder {
  const ProposalSegmentBuilder();

  /// Builds the comments segment if applicable.
  ///
  /// Returns null if comments shouldn't be shown (e.g., published proposals
  /// or when neither commenting nor viewing is available).
  DocumentCommentsSegment? buildCommentsSegment({
    required ProposalSegmentData segmentData,
    required CommentsSegmentData comments,
  }) {
    // Don't show comments segment if not applicable
    if (!segmentData.showComments) return null;
    if (!comments.shouldShowCommentsSegment) return null;

    return DocumentCommentsSegment(
      id: const NodeId('comments'),
      sort: comments.commentsSort,
      sections: [
        DocumentViewCommentsSection(
          id: const NodeId('comments.view'),
          sort: comments.commentsSort,
          comments: comments.commentsSort.applyTo(comments.comments),
          canReply: comments.canReply,
        ),
        if (comments.canComment)
          DocumentAddCommentSection(
            id: const NodeId('comments.add'),
            schema: comments.commentSchema!,
            showUsernameRequired: !segmentData.hasAccountUsername,
          ),
      ],
    );
  }

  /// Builds the proposal overview segment with metadata.
  ///
  /// This segment is always shown when a proposal is loaded.
  ProposalOverviewSegment buildOverviewSegment({
    required ProposalSegmentData segmentData,
    required ProposalMetadataSegmentData metadata,
    required CommentsSegmentData comments,
    required Collaborators collaborators,
  }) {
    // Determine if voting indicator should be shown in overview
    final showVotingIndicator =
        segmentData.isVotingStage &&
        metadata.isLatestVersion &&
        metadata.effectivePublish.isPublished;

    return ProposalOverviewSegment.build(
      categoryName: metadata.category?.formattedCategoryName ?? '',
      proposalTitle: metadata.proposal.title ?? '',
      isVotingStage: showVotingIndicator,
      data: ProposalViewMetadata(
        author: Profile(catalystId: metadata.proposal.authorId!),
        collaborators: collaborators,
        description: metadata.proposal.description,
        status: metadata.effectivePublish,
        createdAt: metadata.currentVersion?.id.tryDateTime ?? DateTimeExt.now(),
        warningCreatedAt: metadata.currentVersion?.isLatest == false,
        tag: metadata.proposal.tag,
        commentsCount: comments.commentsCount,
        fundsRequested: metadata.proposal.fundsRequested,
        projectDuration: metadata.proposal.duration,
        milestoneCount: metadata.proposal.milestoneCount,
      ),
    );
  }

  /// Builds all segments for the proposal view using segment data objects.
  ///
  /// This method coordinates the segment builders, each of which handles
  /// its own visibility logic and returns null if not applicable.
  ///
  /// The [contentSegments] parameter contains the proposal content segments
  /// (typically built from the proposal document using DocumentToSegmentMixin).
  List<Segment> buildSegments({
    required ProposalSegmentData segmentData,
    required ProposalMetadataSegmentData metadata,
    required CommentsSegmentData comments,
    required ProposalBriefDataVotes? voting,
    required Collaborators collaborators,
    required List<DocumentSegment> contentSegments,
  }) {
    final votingSegment = buildVotingSegment(
      segmentData: segmentData,
      metadata: metadata,
      voting: voting,
    );

    final overviewSegment = buildOverviewSegment(
      segmentData: segmentData,
      metadata: metadata,
      comments: comments,
      collaborators: collaborators,
    );

    final commentsSegment = buildCommentsSegment(
      segmentData: segmentData,
      comments: comments,
    );

    return [
      ?votingSegment,
      overviewSegment,
      ...contentSegments,
      ?commentsSegment,
    ];
  }

  /// Builds the voting overview segment if voting is active and conditions are met.
  ///
  /// Returns null if:
  /// - Not in voting stage
  /// - No active account
  /// - Not viewing latest version
  /// - Proposal not published
  ProposalVotingOverviewSegment? buildVotingSegment({
    required ProposalSegmentData segmentData,
    required ProposalMetadataSegmentData metadata,
    required ProposalBriefDataVotes? voting,
  }) {
    // Early exits for conditions not met
    if (!segmentData.isVotingStage) return null;
    if (!segmentData.hasActiveAccount) return null;
    if (!metadata.isLatestVersion) return null;
    if (!metadata.effectivePublish.isPublished) return null;
    if (metadata.proposalId is! SignedDocumentRef) return null;

    return ProposalVotingOverviewSegment.build(
      data: ProposalViewVoting(
        VoteButtonData.fromProposalVotes(
          ProposalVotes(
            proposalRef: metadata.proposalId as SignedDocumentRef,
            lastCasted: voting?.casted,
            currentDraft: voting?.draft,
          ),
        ),
        metadata.proposalId as SignedDocumentRef,
      ),
    );
  }
}
