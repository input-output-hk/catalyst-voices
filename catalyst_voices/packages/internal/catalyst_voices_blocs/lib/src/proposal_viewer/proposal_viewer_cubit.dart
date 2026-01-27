import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/proposal_viewer/proposal_segment_builder.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';

final _logger = Logger('ProposalViewerCubit');

final class ProposalViewerCubit
    extends DocumentViewerCubit<ProposalViewerState, ProposalViewerCache>
    with
        DocumentViewerCommentsMixin<ProposalViewerState, ProposalViewerCache>,
        DocumentViewerCollaboratorsMixin<ProposalViewerState, ProposalViewerCache> {
  @override
  final CommentService commentService;

  // Builder for creating proposal segments
  final _segmentBuilder = const ProposalSegmentBuilder();

  // Subscription for watching proposal data updates
  StreamSubscription<ProposalDataV2?>? _proposalSub;

  ProposalViewerCubit(
    super.proposalService,
    super.userService,
    super.documentMapper,
    super.featureFlagsService,
    this.commentService,
  ) : super(
        initialState: const ProposalViewerState(),
        cache: const ProposalViewerCache(),
      );

  @override
  Future<void> close() async {
    await _proposalSub?.cancel();
    _proposalSub = null;

    return super.close();
  }

  @override
  Future<void> fetchCommentTemplate() async {
    final categoryId = cache.proposalData?.proposalOrDocument.category?.id;
    final commentTemplate = categoryId != null
        ? await commentService.getCommentTemplate(category: categoryId)
        : null;

    cache = cache.copyWith(commentTemplate: Optional(commentTemplate));

    if (!isClosed) rebuildState();
  }

  @override
  List<DocumentRef> getDocumentVersions() {
    return cache.proposalData?.versions ?? [];
  }

  @override
  void init() {
    super.init();

    cache = cache.copyWith(
      activeAccountId: Optional(userService.user.activeAccount?.catalystId),
    );
  }

  @override
  bool isVotingStage() {
    final proposalCampaign = cache.proposalData?.proposalOrDocument.campaign;
    return _isVotingStage(proposalCampaign);
  }

  Future<void> loadProposal(DocumentRef id) async {
    return super.loadDocument(id);
  }

  /// Rebuilds the state from the cache.
  @override
  void rebuildState() {
    final proposalData = cache.proposalData;

    final proposalCampaign = proposalData?.proposalOrDocument.campaign;
    final submissionPhase = proposalCampaign?.phaseStateTo(CampaignPhaseType.proposalSubmission);
    final isReadOnlyMode = submissionPhase?.status.isPost ?? true;
    final collaboratorsState = cache.collaboratorsState;
    final proposalViewData = _buildProposalViewDataUsingCache();

    emit(
      state.copyWith(
        data: proposalViewData,
        collaborator: collaboratorsState,
        readOnlyMode: isReadOnlyMode,
      ),
    );
  }

  @override
  Future<DocumentRef> resolveToLatestVersion(DocumentRef id) async {
    return proposalService.getLatestProposalVersion(id: id);
  }

  @override
  Future<void> retryLastRef() async {
    final id = cache.id;

    if (id != null) {
      return loadProposal(id);
    }
  }

  @override
  Future<void> syncAndWatchDocument() async {
    // Cancel existing subscription
    await _proposalSub?.cancel();
    _proposalSub = null;

    // Sync the proposal data first
    await _syncProposal();

    // Then watch for updates
    if (!isClosed) {
      _watchProposal();
    }
  }

  @override
  void updateCommentBuilder({
    required SignedDocumentRef ref,
    required bool show,
  }) {
    final updatedComments = state.comments.updateCommentBuilder(ref: ref, show: show);
    emit(state.copyWith(comments: updatedComments));
  }

  @override
  void updateCommentReplies({
    required SignedDocumentRef ref,
    required bool show,
  }) {
    final updatedComments = state.comments.updateCommentReplies(ref: ref, show: show);
    emit(state.copyWith(comments: updatedComments));
  }

  @override
  void updateCommentsSort({required DocumentCommentsSort sort}) {
    final data = state.data;

    final comments = state.comments;
    final segments = data.segments.sortWith(sort: sort).toList();

    final updatedData = data.copyWith(segments: segments);
    final updatedComments = comments.copyWith(commentsSort: sort);

    emit(
      state.copyWith(
        data: updatedData,
        comments: updatedComments,
      ),
    );
  }

  @override
  Future<void> updateIsFavorite({required bool value}) async {
    final id = cache.id;
    assert(id != null, 'Proposal id not found. Load doc first');

    // Update cache optimistically
    cache = cache.copyWithIsFavorite(value: value);
    rebuildState();

    // Update via service
    try {
      if (value) {
        await proposalService.addFavoriteProposal(id: id!);
      } else {
        await proposalService.removeFavoriteProposal(id: id!);
      }
    } catch (error, stackTrace) {
      _logger.severe('Failed to update favorite status', error, stackTrace);
      // Rollback on error
      cache = cache.copyWithIsFavorite(value: !value);
      if (!isClosed) {
        rebuildState();
        emitError(LocalizedException.create(error));
      }
    }
  }

  /// Builds the list of document versions from proposal versions.
  ///
  /// Maps each version to a [DocumentVersion] with its position, current state,
  /// and latest state.
  List<DocumentVersion> _buildDocumentVersions({
    required List<DocumentRef> proposalVersions,
    required DocumentRef? currentId,
  }) {
    if (currentId == null) {
      return [];
    }

    return proposalVersions.toDocumentVersions(currentId).toList();
  }

  ProposalViewData _buildProposalViewData({
    required bool hasAccountUsername,
    required CatalystId? activeAccountId,
    required ProposalDocument? proposal,
    required CampaignCategory? category,
    required ProposalBriefDataVotes? votingData,
    required List<CommentWithReplies> comments,
    required DocumentSchema? commentSchema,
    required DocumentCommentsSort commentsSort,
    required List<ProposalDataCollaborator> collaborators,
    required bool isFavorite,
    required bool isVotingStage,
    required bool showComments,
    required bool readOnlyMode,
    required List<DocumentRef> proposalVersions,
    required ProposalPublish? publish,
  }) {
    // Return empty view if no proposal loaded
    if (proposal == null) {
      return const ProposalViewData();
    }

    final proposalId = proposal.metadata.id;

    // Build document versions list
    final versions = _buildDocumentVersions(
      proposalVersions: proposalVersions,
      currentId: proposalId,
    );
    final currentVersion = versions.singleWhereOrNull((e) => e.isCurrent);

    // Determine effective publish status
    final effectivePublish = ProposalPublish.getStatus(
      isFinal: publish?.isPublished ?? false,
      ref: proposalId,
    );

    final segmentData = ProposalSegmentData(
      activeAccountId: activeAccountId,
      hasAccountUsername: hasAccountUsername,
      isVotingStage: isVotingStage,
      showComments: showComments,
    );

    final metadata = ProposalMetadataSegmentData(
      proposal: proposal,
      category: category,
      currentVersion: currentVersion,
      effectivePublish: effectivePublish,
    );

    final commentsSegmentData = CommentsSegmentData.build(
      comments: comments,
      commentSchema: commentSchema,
      commentsSort: commentsSort,
      showComments: showComments,
      hasActiveAccount: segmentData.hasActiveAccount,
      hasAccountUsername: hasAccountUsername,
      isLocalDocument: effectivePublish.isLocal,
      isVotingStage: isVotingStage,
    );

    final collaboratorsState = Collaborators.filterByActiveAccount(
      activeAccountId: activeAccountId,
      authorId: proposal.authorId,
      collaborators: collaborators.map(Collaborator.fromBriefData).toList(),
    );

    final contentSegments = mapDocumentToSegments(proposal.document);

    // Build all segments using the segment builder
    final segments = _segmentBuilder.buildSegments(
      segmentData: segmentData,
      metadata: metadata,
      comments: commentsSegmentData,
      voting: votingData,
      collaborators: collaboratorsState,
      contentSegments: contentSegments,
    );

    final header = ProposalViewHeader(
      documentRef: proposalId,
      title: proposal.title ?? '',
      authorName: proposal.authorName,
      createdAt: proposalId.ver?.tryDateTime,
      commentsCount: commentsSegmentData.commentsCount,
      versions: versions,
      isFavorite: isFavorite,
    );

    return ProposalViewData(
      isCurrentVersionLatest: currentVersion?.isLatest,
      header: header,
      segments: segments,
      categoryText: category?.formattedCategoryName,
    );
  }

  ProposalViewData _buildProposalViewDataUsingCache() {
    final proposalData = cache.proposalData;
    final commentTemplate = cache.commentTemplate;
    final comments = cache.comments ?? const [];
    final commentsSort = state.comments.commentsSort;
    final activeAccountId = cache.activeAccountId;

    final proposalCampaign = proposalData?.proposalOrDocument.campaign;
    final submissionPhase = proposalCampaign?.phaseStateTo(CampaignPhaseType.proposalSubmission);
    final isReadOnlyMode = submissionPhase?.status.isPost ?? true;

    final isVotingStage = _isVotingStage(proposalCampaign);

    return _buildProposalViewData(
      activeAccountId: activeAccountId,
      hasAccountUsername: !(activeAccountId?.isAnonymous ?? true),
      proposal: proposalData?.proposalOrDocument.asProposalDocument,
      category: proposalData?.proposalOrDocument.category,
      votingData: proposalData?.votes,
      comments: comments,
      commentSchema: commentTemplate?.schema,
      commentsSort: commentsSort,
      collaborators: proposalData?.collaborators ?? const [],
      isFavorite: proposalData?.isFavorite ?? false,
      readOnlyMode: isReadOnlyMode,
      isVotingStage: isVotingStage,
      showComments: !(proposalData?.publish.isLocal ?? false),
      proposalVersions: proposalData?.versions ?? [],
      publish: proposalData?.publish,
    );
  }

  /// Handles changes to proposal data.
  void _handleProposalData(ProposalDataV2? data) {
    final proposalDataChanged = cache.proposalData != data;
    final proposalIdChanged = cache.proposalData?.id != data?.id;
    final activeAccountId = cache.activeAccountId;

    cache = cache.copyWith(
      proposalData: Optional(data),
      documentParameters: data != null ? Optional(data.proposalOrDocument.parameters) : null,
    );

    if (proposalIdChanged) {
      final collaborators = cache.proposalData?.collaborators ?? const <ProposalDataCollaborator>[];
      final isFinal = cache.proposalData?.publish.isPublished ?? false;
      buildCollaboratorState(
        collaborators: collaborators,
        activeAccountId: activeAccountId,
        isFinal: isFinal,
      );
      // Proposal changed - fetch comment template and watch comments
      unawaited(fetchCommentTemplate());
      watchComments();

      // Reset comments UI state
      emit(state.copyWith(comments: const CommentsState()));

      // Update collaborator state
      if (!state.isLoading) {
        handleDocumentVersionSignal();
      }
    }

    if (proposalDataChanged) {
      rebuildState();
    }
  }

  /// Checks if voting stage is active.
  bool _isVotingStage(Campaign? campaign) {
    if (!featureFlagsService.isEnabled(Features.voting)) return false;
    return campaign?.isVotingStateActive ?? false;
  }

  /// Synchronizes proposal data from the service.
  Future<void> _syncProposal() async {
    final id = cache.id;
    if (id == null) {
      return;
    }

    emit(state.copyWith(isLoading: true, error: const Optional.empty()));
    try {
      final activeAccountId = cache.activeAccountId;
      final proposal = await proposalService.getProposalV2(
        id: id,
        activeAccount: activeAccountId,
      );

      if (isClosed) return;

      _validateProposalData(proposal);
      _handleProposalData(proposal);
    } catch (error, stack) {
      _logger.severe('Synchronizing proposal($id) failed', error, stack);
      if (!isClosed) {
        emit(
          state.copyWith(error: Optional(LocalizedException.create(error))),
        );
      }
    } finally {
      if (!isClosed) {
        emit(state.copyWith(isLoading: false));
      }
    }
  }

  /// Validates proposal data before processing.
  void _validateProposalData(ProposalDataV2? data) {
    if (data == null) {
      throw const LocalizedNotFoundException();
    }

    if (data.isHidden) {
      throw const LocalizedNotFoundException();
    }

    if (!data.proposalOrDocument.isProposal) {
      throw const LocalizedProposalTemplateNotFoundException();
    }
  }

  /// Watches for proposal updates via stream.
  void _watchProposal() {
    final id = cache.id;
    final activeAccountId = cache.activeAccountId;

    final stream = id != null
        ? proposalService.watchProposal(id: id, activeAccount: activeAccountId)
        : Stream<ProposalDataV2?>.value(null);

    unawaited(_proposalSub?.cancel());
    _proposalSub = stream.distinct().listen(_handleProposalData);
  }
}
