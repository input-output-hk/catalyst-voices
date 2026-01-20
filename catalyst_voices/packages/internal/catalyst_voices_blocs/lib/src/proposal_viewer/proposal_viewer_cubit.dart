import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';

final _logger = Logger('ProposalViewerCubit');

final class ProposalViewerCubit extends DocumentViewerCubit<ProposalViewerState>
    with DocumentViewerCommentsMixin, DocumentViewerCollaboratorsMixin {
  @override
  final CommentService commentService;

  // Subscription for watching proposal data updates
  StreamSubscription<ProposalDataV2?>? _proposalSub;

  ProposalViewerCubit(
    super.initialState,
    super.proposalService,
    super.userService,
    super.documentMapper,
    super.featureFlagsService,
    this.commentService,
  );

  // Helper to get typed cache
  ProposalViewerCache get _proposalCache => cache as ProposalViewerCache;

  @override
  Future<void> acceptCollaboratorInvitation() async {
    try {
      await super.acceptCollaboratorInvitation();
      if (!isClosed) {
        emit(state.copyWith(collaborator: const AcceptedCollaboratorInvitationState()));
      }
    } catch (error) {
      if (!isClosed) {
        emitError(LocalizedException.create(error));
      }
    }
  }

  @override
  Future<void> acceptFinalProposal() async {
    try {
      await super.acceptFinalProposal();

      if (!isClosed) {
        emit(state.copyWith(collaborator: const AcceptedFinalProposalConsentState()));
      }
    } catch (error) {
      if (!isClosed) {
        emitError(LocalizedException.create(error));
      }
    }
  }

  @override
  Future<void> close() async {
    await _proposalSub?.cancel();
    _proposalSub = null;

    // Explicitly call mixin cleanup methods to ensure all subscriptions are closed
    await cancelCommentsWatch();

    return super.close();
  }

  @override
  void dismissCollaboratorBanner() {
    cache = _proposalCache.copyWithCollaborators(const NoneCollaboratorProposalState());
    _rebuildState();
  }

  @override
  Future<void> fetchCommentTemplate() async {
    final categoryId = _proposalCache.proposalData?.proposalOrDocument.category?.id;
    final commentTemplate = categoryId != null
        ? await commentService.getCommentTemplate(category: categoryId)
        : null;

    cache = _proposalCache.copyWith(commentTemplate: Optional(commentTemplate));

    if (!isClosed) _rebuildState();
  }

  @override
  List<DocumentRef> getDocumentVersions() {
    return _proposalCache.proposalData?.versions ?? [];
  }

  @override
  void init() {
    super.init();

    // Initialize cache with specific type
    cache = ProposalViewerCache.empty().copyWith(
      activeAccountId: Optional(userService.user.activeAccount?.catalystId),
    );
  }

  @override
  bool isVotingStage() {
    final proposalCampaign = _proposalCache.proposalData?.proposalOrDocument.campaign;
    return _isVotingStage(proposalCampaign);
  }

  Future<void> loadProposal(DocumentRef id) async {
    return super.loadDocument(id);
  }

  @override
  Future<void> rejectCollaboratorInvitation() async {
    try {
      await super.rejectCollaboratorInvitation();

      if (!isClosed) {
        emit(state.copyWith(collaborator: const RejectedCollaboratorInvitationState()));
      }
    } catch (error) {
      if (!isClosed) {
        emitError(LocalizedException.create(error));
      }
    }
  }

  @override
  Future<void> rejectFinalProposal() async {
    try {
      await super.rejectFinalProposal();

      if (!isClosed) {
        emit(state.copyWith(collaborator: const RejectedCollaboratorFinalProposalConsentState()));
      }
    } catch (error) {
      if (!isClosed) {
        emitError(LocalizedException.create(error));
      }
    }
  }

  @override
  Future<DocumentRef> resolveToLatestVersion(DocumentRef id) async {
    return proposalService.getLatestProposalVersion(id: id);
  }

  @override
  Future<void> retryLastRef() async {
    final id = _proposalCache.id;

    if (id != null) {
      return loadProposal(id);
    }
  }

  @override
  Future<void> submitComment({
    required Document document,
    SignedDocumentRef? reply,
  }) async {
    try {
      await submitCommentInternal(document: document, reply: reply);
      if (!isClosed) _rebuildState();
    } catch (error, stack) {
      _logger.info('Publishing comment failed', error, stack);
      if (!isClosed) {
        final localizedException = LocalizedException.create(error);
        emitError(localizedException);
      }
      if (!isClosed) _rebuildState();
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
    final id = _proposalCache.id;
    assert(id != null, 'Proposal id not found. Load doc first');

    // Update cache optimistically
    cache = _proposalCache.copyWithIsFavorite(value: value);
    _rebuildState();

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
      cache = _proposalCache.copyWithIsFavorite(value: !value);
      if (!isClosed) {
        _rebuildState();
        emitError(LocalizedException.create(error));
      }
    }
  }

  @override
  Future<void> updateUsername(String value) async {
    try {
      await updateUsernameInternal(value);
      emitSignal(const UsernameUpdatedSignal());
    } catch (error) {
      emitError(LocalizedException.create(error));
    }
  }

  ProposalViewData _buildProposalViewData({
    required bool hasAccountUsername,
    required CatalystId? activeAccountId,
    required ProposalDocument? proposal,
    required CampaignCategory? category,
    required List<CommentWithReplies> comments,
    required DocumentSchema? commentSchema,
    required DocumentCommentsSort commentsSort,
    required List<ProposalDataCollaborator> collaborators,
    required bool isFavorite,
    required bool isVotingStage,
    required bool showComments,
    required bool readOnlyMode,
    required Vote? lastCastedVote,
    required Vote? draftVote,
    required List<DocumentRef> proposalVersions,
    required ProposalPublish? publish,
  }) {
    final proposalDocumentRef = proposal?.metadata.id;

    final versions = proposalVersions.reversed.mapIndexed((index, version) {
      final ver = version.ver;

      return DocumentVersion(
        id: ver ?? '',
        number: index + 1,
        isCurrent: ver == proposalDocumentRef?.ver,
        isLatest: index == proposalVersions.length - 1,
      );
    }).toList();
    final currentVersion = versions.singleWhereOrNull((e) => e.isCurrent);
    final commentsCount = showComments
        ? comments.fold(0, (prev, next) => prev + 1 + next.repliesCount)
        : null;

    final collaboratorsState = Collaborators.filterByActiveAccount(
      activeAccountId: activeAccountId,
      authorId: proposal?.authorId,
      collaborators: collaborators.map(Collaborator.fromBriefData).toList(),
    );

    final segments = proposal != null
        ? _buildSegments(
            proposal: proposal,
            category: category,
            version: currentVersion,
            comments: comments,
            commentSchema: commentSchema,
            commentsSort: commentsSort,
            collaborators: collaboratorsState,
            hasActiveAccount: activeAccountId != null,
            hasAccountUsername: hasAccountUsername,
            commentsCount: commentsCount,
            isVotingStage: isVotingStage,
            showComments: showComments,
            readOnlyMode: readOnlyMode,
            lastCastedVote: lastCastedVote,
            draftVote: draftVote,
            publish: publish,
          )
        : const <Segment>[];

    final header = ProposalViewHeader(
      documentRef: proposalDocumentRef,
      title: proposal?.title ?? '',
      authorName: proposal?.authorName,
      createdAt: proposalDocumentRef?.ver?.tryDateTime,
      commentsCount: commentsCount,
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
    final proposalData = _proposalCache.proposalData;
    final commentTemplate = _proposalCache.commentTemplate;
    final comments = _proposalCache.comments ?? const [];
    final commentsSort = state.comments.commentsSort;
    final activeAccountId = _proposalCache.activeAccountId;

    final proposalCampaign = proposalData?.proposalOrDocument.campaign;
    final submissionPhase = proposalCampaign?.phaseStateTo(CampaignPhaseType.proposalSubmission);
    final isReadOnlyMode = submissionPhase?.status.isPost ?? true;

    final isVotingStage = _isVotingStage(proposalCampaign);

    return _buildProposalViewData(
      activeAccountId: activeAccountId,
      hasAccountUsername: !(activeAccountId?.isAnonymous ?? true),
      proposal: proposalData?.proposalOrDocument.asProposalDocument,
      category: proposalData?.proposalOrDocument.category,
      comments: comments,
      commentSchema: commentTemplate?.schema,
      commentsSort: commentsSort,
      collaborators: proposalData?.collaborators ?? const [],
      isFavorite: proposalData?.isFavorite ?? false,
      readOnlyMode: isReadOnlyMode,
      isVotingStage: isVotingStage,
      showComments: !(proposalData?.publish.isPublished ?? false),
      lastCastedVote: proposalData?.votes?.casted,
      draftVote: proposalData?.votes?.draft,
      proposalVersions: proposalData?.versions ?? [],
      publish: proposalData?.publish,
    );
  }

  ProposalVotingOverviewSegment? _buildProposalVotingOverviewSegment({
    required bool isVotingStage,
    required bool hasActiveAccount,
    required bool isLatestVersion,
    required bool isFinal,
    required DocumentRef proposalRef,
    required Vote? lastCastedVote,
    required Vote? draftVote,
  }) {
    final appCheck = (isVotingStage && hasActiveAccount);
    final proposalCheck = isLatestVersion && isFinal && proposalRef is SignedDocumentRef;
    if (!appCheck || !proposalCheck) {
      return null;
    }

    return ProposalVotingOverviewSegment.build(
      data: ProposalViewVoting(
        VoteButtonData.fromProposalVotes(
          ProposalVotes(
            proposalRef: proposalRef,
            lastCasted: lastCastedVote,
            currentDraft: draftVote,
          ),
        ),
        proposalRef,
      ),
    );
  }

  List<Segment> _buildSegments({
    required ProposalDocument proposal,
    required CampaignCategory? category,
    required DocumentVersion? version,
    required List<CommentWithReplies> comments,
    required DocumentSchema? commentSchema,
    required DocumentCommentsSort commentsSort,
    required Collaborators collaborators,
    required bool hasActiveAccount,
    required bool hasAccountUsername,
    required int? commentsCount,
    required bool isVotingStage,
    required bool showComments,
    required bool readOnlyMode,
    required Vote? lastCastedVote,
    required Vote? draftVote,
    required ProposalPublish? publish,
  }) {
    final document = proposal.document;
    final isDraftProposal = proposal.metadata.id is DraftRef;
    final isLatestVersion = version?.isLatest ?? false;
    final effectivePublish =
        publish ?? (isDraftProposal ? ProposalPublish.localDraft : ProposalPublish.publishedDraft);

    final votingSegment = _buildProposalVotingOverviewSegment(
      isVotingStage: isVotingStage,
      hasActiveAccount: hasActiveAccount,
      isLatestVersion: isLatestVersion,
      isFinal: effectivePublish.isPublished,
      proposalRef: proposal.metadata.id,
      lastCastedVote: lastCastedVote,
      draftVote: draftVote,
    );

    final overviewSegment = ProposalOverviewSegment.build(
      categoryName: category?.formattedCategoryName ?? '',
      proposalTitle: proposal.title ?? '',
      isVotingStage: (isVotingStage && isLatestVersion && effectivePublish.isPublished),
      data: ProposalViewMetadata(
        author: Profile(catalystId: proposal.authorId!),
        collaborators: collaborators,
        description: proposal.description,
        status: effectivePublish,
        createdAt: version?.id.tryDateTime ?? DateTimeExt.now(),
        warningCreatedAt: version?.isLatest == false,
        tag: proposal.tag,
        commentsCount: commentsCount,
        fundsRequested: proposal.fundsRequested,
        projectDuration: proposal.duration,
        milestoneCount: proposal.milestoneCount,
      ),
    );

    final proposalSegments = mapDocumentToSegments(document);

    final isNotLocalAndHasActiveAccount = !isDraftProposal && hasActiveAccount;
    final canReply = isNotLocalAndHasActiveAccount && hasAccountUsername;
    final canComment = isNotLocalAndHasActiveAccount && commentSchema != null && !readOnlyMode;

    final commentsSegment = DocumentCommentsSegment(
      id: const NodeId('comments'),
      sort: commentsSort,
      sections: [
        DocumentViewCommentsSection(
          id: const NodeId('comments.view'),
          sort: commentsSort,
          comments: commentsSort.applyTo(comments),
          canReply: canReply,
        ),
        if (canComment)
          DocumentAddCommentSection(
            id: const NodeId('comments.add'),
            schema: commentSchema,
            showUsernameRequired: !hasAccountUsername,
          ),
      ],
    );

    return [
      if (votingSegment != null) votingSegment,
      overviewSegment,
      ...proposalSegments,
      if ((canComment || comments.isNotEmpty) && showComments) commentsSegment,
    ];
  }

  /// Handles changes to proposal data.
  void _handleProposalData(ProposalDataV2? data) {
    final proposalDataChanged = _proposalCache.proposalData != data;
    final proposalIdChanged = _proposalCache.proposalData?.id != data?.id;
    final activeAccountId = _proposalCache.activeAccountId;

    cache = _proposalCache.copyWith(proposalData: Optional(data));

    if (proposalIdChanged) {
      final collaborators =
          _proposalCache.proposalData?.collaborators ?? const <ProposalDataCollaborator>[];
      final isFinal = _proposalCache.proposalData?.publish.isPublished ?? false;
      buildCollaboratorState(
        collaborators: collaborators,
        activeAccountId: activeAccountId,
        isFinal: isFinal,
      );
      // Proposal changed - fetch comment template and watch comments
      unawaited(fetchCommentTemplate());
      watchComments(onCommentsChanged: (_) => _rebuildState());

      // Reset comments UI state
      emit(state.copyWith(comments: const CommentsState()));

      // Update collaborator state
      if (!state.isLoading) {
        handleDocumentVersionSignal();
      }
    }

    if (proposalDataChanged) {
      _rebuildState();
    }
  }

  /// Checks if voting stage is active.
  bool _isVotingStage(Campaign? campaign) {
    if (!featureFlagsService.isEnabled(Features.voting)) return false;
    return campaign?.isVotingStateActive ?? false;
  }

  /// Rebuilds the state from the cache.
  void _rebuildState() {
    final proposalData = _proposalCache.proposalData;

    final proposalCampaign = proposalData?.proposalOrDocument.campaign;
    final submissionPhase = proposalCampaign?.phaseStateTo(CampaignPhaseType.proposalSubmission);
    final isReadOnlyMode = submissionPhase?.status.isPost ?? true;
    final collaboratorsState = _proposalCache.collaboratorsState;
    final proposalViewData = _buildProposalViewDataUsingCache();

    emit(
      state.copyWith(
        data: proposalViewData,
        collaborator: collaboratorsState,
        readOnlyMode: isReadOnlyMode,
      ),
    );
  }

  /// Synchronizes proposal data from the service.
  Future<void> _syncProposal() async {
    final id = _proposalCache.id;
    if (id == null) {
      return;
    }

    emit(state.copyWith(isLoading: true, error: const Optional.empty()));
    try {
      final activeAccountId = _proposalCache.activeAccountId;
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
    final id = _proposalCache.id;
    final activeAccountId = _proposalCache.activeAccountId;

    final stream = id != null
        ? proposalService.watchProposal(id: id, activeAccount: activeAccountId)
        : Stream<ProposalDataV2?>.value(null);

    unawaited(_proposalSub?.cancel());
    _proposalSub = stream.distinct().listen(_handleProposalData);
  }
}
