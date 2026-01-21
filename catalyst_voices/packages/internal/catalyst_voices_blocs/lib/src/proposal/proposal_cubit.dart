import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/document/document_to_segment_mixin.dart';
import 'package:catalyst_voices_blocs/src/proposal/proposal.dart';
import 'package:catalyst_voices_blocs/src/proposal/proposal_cubit_cache.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

final _logger = Logger('ProposalBloc');

/// Manages data for the proposal viewer screen
///
/// This Cubit has [ProposalCubitCache] to store the data which allows to reduce
/// the number of calls to the services.
final class ProposalCubit extends Cubit<ProposalState>
    with
        DocumentToSegmentMixin,
        BlocErrorEmitterMixin<ProposalState>,
        BlocSignalEmitterMixin<ProposalSignal, ProposalState> {
  final UserService _userService;
  final ProposalService _proposalService;
  final CommentService _commentService;
  final DocumentMapper _documentMapper;
  final FeatureFlagsService _featureFlagsService;

  ProposalCubitCache _cache = const ProposalCubitCache();

  StreamSubscription<CatalystId?>? _activeAccountIdSub;
  StreamSubscription<List<CommentWithReplies>>? _commentsSub;
  StreamSubscription<ProposalDataV2?>? _proposalSub;

  ProposalCubit(
    this._userService,
    this._proposalService,
    this._commentService,
    this._documentMapper,
    this._featureFlagsService,
  ) : super(const ProposalState()) {
    _cache = _cache.copyWith(
      activeAccountId: Optional(_userService.user.activeAccount?.catalystId),
    );
    _activeAccountIdSub = _userService.watchUnlockedActiveAccount
        .map((activeAccount) => activeAccount?.catalystId)
        .distinct()
        .listen(_handleActiveAccountIdChanged);
  }

  // Exported to DocumentViewerCollaboratorMixin
  Future<void> acceptCollaboratorInvitation() async {
    try {
      final id = _cache.id;
      if (id is! SignedDocumentRef) {
        throw ArgumentError('Cannot accept collaborator invitation for a draft proposal: $id');
      }

      await _proposalService.submitCollaboratorProposalAction(
        proposalId: id,
        action: CollaboratorProposalAction.acceptInvitation,
      );
      if (!isClosed) {
        emit(state.copyWith(collaborator: const AcceptedCollaboratorInvitationState()));
      }
    } catch (error, stackTrace) {
      _logger.severe('acceptCollaboratorInvitation', error, stackTrace);
      if (!isClosed) {
        emitError(LocalizedException.create(error));
      }
    }
  }

  // Exported to DocumentViewerCollaboratorMixin
  Future<void> acceptFinalProposal() async {
    try {
      final id = _cache.id;
      if (id is! SignedDocumentRef) {
        throw ArgumentError('Cannot accept final proposal of a draft: $id');
      }

      await _proposalService.submitCollaboratorProposalAction(
        proposalId: id,
        action: CollaboratorProposalAction.acceptFinal,
      );

      if (!isClosed) {
        emit(state.copyWith(collaborator: const AcceptedFinalProposalConsentState()));
      }
    } catch (error, stackTrace) {
      _logger.severe('acceptFinalProposal', error, stackTrace);
      if (!isClosed) {
        emitError(LocalizedException.create(error));
      }
    }
  }

  void clear() {
    _cache = _cache.copyWithoutProposal();
    emit(const ProposalState());
  }

  @override
  Future<void> close() async {
    await _activeAccountIdSub?.cancel();
    _activeAccountIdSub = null;

    await _commentsSub?.cancel();
    _commentsSub = null;

    await _proposalSub?.cancel();
    _proposalSub = null;

    return super.close();
  }

  // Exported to DocumentViewerCollaboratorMixin
  Future<void> dismissCollaboratorBanner() async {
    emit(state.copyWith(collaborator: const NoneCollaboratorProposalState()));
  }

  Future<void> loadProposal(DocumentRef id) async {
    if (!id.isValid) {
      emit(state.copyWith(error: const Optional(LocalizedDocumentReferenceException())));
      return;
    }
    // If the ref is loose (no version), resolve it to the latest version first
    final effectiveId = id.isLoose ? await _proposalService.getLatestProposalVersion(id: id) : id;
    if (isClosed) return;

    _cache = _cache.copyWith(id: Optional(effectiveId));

    await _syncAndWatchProposal();
  }

  // Exported to DocumentViewerCollaboratorMixin
  Future<void> rejectCollaboratorInvitation() async {
    try {
      final id = _cache.id;
      if (id is! SignedDocumentRef) {
        throw ArgumentError('Cannot reject collaborator invitation for a draft proposal: $id');
      }

      await _proposalService.submitCollaboratorProposalAction(
        proposalId: id,
        action: CollaboratorProposalAction.rejectInvitation,
      );

      if (!isClosed) {
        emit(state.copyWith(collaborator: const RejectedCollaboratorInvitationState()));
      }
    } catch (error, stackTrace) {
      _logger.severe('rejectCollaboratorInvitation', error, stackTrace);
      if (!isClosed) {
        emitError(LocalizedException.create(error));
      }
    }
  }

  // Exported to DocumentViewerCollaboratorMixin
  Future<void> rejectFinalProposal() async {
    try {
      final id = _cache.id;
      if (id is! SignedDocumentRef) {
        throw ArgumentError('Cannot reject reject final proposal of a draft: $id');
      }

      await _proposalService.submitCollaboratorProposalAction(
        proposalId: id,
        action: CollaboratorProposalAction.rejectFinal,
      );

      if (!isClosed) {
        emit(state.copyWith(collaborator: const RejectedCollaboratorFinalProposalConsentState()));
      }
    } catch (error, stackTrace) {
      _logger.severe('rejectFinalProposal', error, stackTrace);
      if (!isClosed) {
        emitError(LocalizedException.create(error));
      }
    }
  }

  Future<void> retryLastRef() async {
    final id = _cache.id;
    if (id != null) {
      await loadProposal(id);
    }
  }

  Future<void> submitComment({
    required Document document,
    SignedDocumentRef? reply,
  }) async {
    final proposalId = _cache.id;
    assert(proposalId != null, 'Proposal ref not found. Load document first!');
    assert(
      proposalId != null && proposalId.isSigned,
      'Can comment only on signed documents',
    );

    final proposalParameters = _cache.proposalData?.proposalOrDocument.parameters;

    final activeAccountId = _cache.activeAccountId;
    assert(activeAccountId != null, 'No active account found!');

    final commentTemplate = _cache.commentTemplate;
    assert(commentTemplate != null, 'No comment template found!');

    final commentRef = SignedDocumentRef.generateFirstRef();
    final comment = CommentDocument(
      metadata: CommentMetadata(
        id: commentRef,
        proposalRef: proposalId! as SignedDocumentRef,
        commentTemplate: commentTemplate!.metadata.id as SignedDocumentRef,
        reply: reply,
        parameters: proposalParameters!,
        authorId: activeAccountId!,
      ),
      document: document,
    );

    final comments = (_cache.comments ?? []).addComment(comment: comment);
    _cache = _cache.copyWith(comments: Optional(comments));
    _rebuildState();

    final documentData = comment.toDocumentData(mapper: _documentMapper);

    try {
      await _commentService.submitComment(document: documentData);
    } catch (error, stack) {
      _logger.info('Publishing comment failed', error, stack);

      if (!isClosed) {
        final localizedException = LocalizedException.create(
          error,
          fallback: LocalizedUnknownPublishCommentException.new,
        );

        emitError(localizedException);
      }

      final source = _cache.comments;
      final comments = (source ?? []).removeComment(ref: commentRef);
      _cache = _cache.copyWith(comments: Optional(comments));

      if (!isClosed) _rebuildState();
    }
  }

  void updateCommentBuilder({
    required SignedDocumentRef ref,
    required bool show,
  }) {
    final updatedComments = state.comments.updateCommentBuilder(ref: ref, show: show);

    emit(state.copyWith(comments: updatedComments));
  }

  void updateCommentReplies({
    required SignedDocumentRef ref,
    required bool show,
  }) {
    final updatedComments = state.comments.updateCommentReplies(ref: ref, show: show);

    emit(state.copyWith(comments: updatedComments));
  }

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

  Future<void> updateIsFavorite({required bool value}) async {
    final id = _cache.id;
    assert(id != null, 'Proposal id not found. Load doc first');

    _cache = _cache.copyWithIsFavorite(value: value);
    emit(state.copyWithFavorite(isFavorite: value));

    if (value) {
      await _proposalService.addFavoriteProposal(id: id!);
    } else {
      await _proposalService.removeFavoriteProposal(id: id!);
    }
  }

  Future<void> updateUsername(String value) async {
    final catId = _cache.activeAccountId;
    if (catId == null) {
      _logger.warning('Tried to update username but no action account found');
      return;
    }

    try {
      await _userService.updateAccount(
        id: catId,
        username: value.isNotEmpty ? Optional(value) : const Optional.empty(),
      );

      // TODO(LynxLynxx): Will be removed in cleanup pr
      // emitSignal(const UsernameUpdatedSignal());
    } catch (error, stackTrace) {
      _logger.severe('Update username failed', error, stackTrace);
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
    final proposalData = _cache.proposalData;
    final commentTemplate = _cache.commentTemplate;
    final comments = _cache.comments ?? const [];
    final commentsSort = state.comments.commentsSort;
    final activeAccountId = _cache.activeAccountId;

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
      isVotingStage: (isVotingStage && isLatestVersion),
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

  Future<void> _getCommentBuilderTemplate() async {
    final categoryId = _cache.proposalData?.proposalOrDocument.category?.id;
    final commentTemplate = categoryId != null
        ? await _commentService.getCommentTemplate(category: categoryId)
        : null;

    _cache = _cache.copyWith(commentTemplate: Optional(commentTemplate));

    if (!isClosed) _rebuildState();
  }

  void _handleActiveAccountIdChanged(CatalystId? data) {
    final activeAccountId = _cache.activeAccountId;
    if (activeAccountId == data) {
      return;
    }

    _cache = _cache.copyWith(activeAccountId: Optional(data));

    if (activeAccountId.isSameAs(data)) {
      _rebuildState();
    } else {
      unawaited(_syncAndWatchProposal());
    }
  }

  void _handleCommentsChange(List<CommentWithReplies> comments) {
    _cache = _cache.copyWith(comments: Optional(comments));

    _rebuildState();
  }

  void _handleProposalData(ProposalDataV2? data) {
    final proposalDataChanged = _cache.proposalData != data;
    final proposalIdChanged = _cache.proposalData?.id != data?.id;

    _cache = _cache.copyWith(proposalData: Optional(data));

    if (proposalIdChanged) {
      unawaited(_getCommentBuilderTemplate());
      _watchProposalComments();

      emit(state.copyWith(comments: const CommentsState()));

      _handleProposalVersionSignal();
    }

    if (proposalDataChanged) _rebuildState();
  }

  void _handleProposalVersionSignal() {
    if (state.isLoading || state.isViewingLatestVersion) {
      return;
    }

    final proposalCampaign = _cache.proposalData?.proposalOrDocument.campaign;
    final isVotingStage = _isVotingStage(proposalCampaign);

    if (isVotingStage && _cache.activeAccountId != null) {
      // emitSignal(const ViewingOlderVersionWhileVotingSignal());
    } else {
      // emitSignal(const ViewingOlderVersionSignal());
    }
  }

  bool _isVotingStage(Campaign? campaign) {
    if (!_featureFlagsService.isEnabled(Features.voting)) return false;

    return campaign?.isVotingStateActive ?? false;
  }

  void _rebuildState() {
    final proposalData = _cache.proposalData;

    final proposalCampaign = proposalData?.proposalOrDocument.campaign;
    final submissionPhase = proposalCampaign?.phaseStateTo(CampaignPhaseType.proposalSubmission);
    final isReadOnlyMode = submissionPhase?.status.isPost ?? true;

    final activeAccountId = _cache.activeAccountId;
    final collaborators = proposalData?.collaborators ?? const <ProposalDataCollaborator>[];
    final collaboratorsState = CollaboratorProposalState.fromCollaboratorData(
      collaborators: collaborators,
      activeAccountId: activeAccountId,
      isFinal: proposalData?.publish.isPublished ?? false,
    );

    final proposalViewData = _buildProposalViewDataUsingCache();

    emit(
      state.copyWith(
        data: proposalViewData,
        collaborator: collaboratorsState,
        readOnlyMode: isReadOnlyMode,
      ),
    );
  }

  Future<void> _syncAndWatchProposal() async {
    await _proposalSub?.cancel();
    _proposalSub = null;

    await _syncProposal();

    if (!isClosed) _watchProposal();
  }

  Future<void> _syncProposal() async {
    final id = _cache.id;
    if (id == null) {
      return;
    }

    emit(state.copyWith(isLoading: true, error: const Optional.empty()));
    try {
      final activeAccountId = _cache.activeAccountId;
      final proposal = await _proposalService.getProposalV2(id: id, activeAccount: activeAccountId);

      if (isClosed) return;

      _validateProposalData(proposal);
      _handleProposalData(proposal);
    } catch (error, stack) {
      _logger.severe('Synchronizing proposal($id) failed', error, stack);
      if (!isClosed) emit(state.copyWith(error: Optional(LocalizedException.create(error))));
    } finally {
      if (!isClosed) emit(state.copyWith(isLoading: false));
    }
  }

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

  void _watchProposal() {
    final id = _cache.id;
    final activeAccountId = _cache.activeAccountId;

    final stream = id != null
        ? _proposalService.watchProposal(id: id, activeAccount: activeAccountId)
        : Stream.value(null);

    unawaited(_proposalSub?.cancel());
    _proposalSub = stream.distinct().listen(_handleProposalData);
  }

  /// Watch comments on exact version of proposal.
  void _watchProposalComments() {
    final id = _cache.proposalData?.id;

    final stream = id != null
        ? _commentService.watchCommentsWith(ref: id).startWith(const <CommentWithReplies>[])
        : Stream.value(const <CommentWithReplies>[]);

    unawaited(_commentsSub?.cancel());
    _commentsSub = stream.distinct(listEquals).listen(_handleCommentsChange);
  }
}
