import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/document/document_to_segment_mixin.dart';
import 'package:catalyst_voices_blocs/src/proposal/proposal_cubit_cache.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

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
  StreamSubscription<Vote?>? _watchedCastedVotesSub;
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

  Future<void> acceptInvitation() async {
    try {
      await _proposalService.respondToCollaboratorInvite(
        ref: _cache.ref!,
        action: CollaboratorInvitationAction.accept,
      );
      if (!isClosed) {
        emit(state.copyWith(invitation: const CollaboratorInvitationState(showAsAccepted: true)));
      }
    } catch (error, stackTrace) {
      _logger.severe('acceptInvitation', error, stackTrace);
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

    await _watchedCastedVotesSub?.cancel();
    _watchedCastedVotesSub = null;

    return super.close();
  }

  Future<void> dismissInvitation() async {
    emit(state.copyWith(invitation: const CollaboratorInvitationState()));
  }

  Future<void> loadProposal(DocumentRef id) async {
    if (!id.isValid) {
      emit(state.copyWith(error: const Optional(LocalizedDocumentReferenceException())));
      return;
    }

    await _proposalSub?.cancel();
    _cache = _cache.copyWith(ref: Optional(id));
    emit(state.copyWith(isLoading: true, error: const Optional.empty()));
    // We don't call distinct() here as we need to emit loading off user loads proposal that still not exists
    _proposalSub = _proposalService
        .watchProposal(
          id: id,
          activeAccount: _cache.activeAccountId,
        )
        .listen(_handleProposalData);
  }

  Future<void> rejectInvitation() async {
    try {
      await _proposalService.respondToCollaboratorInvite(
        ref: _cache.ref!,
        action: CollaboratorInvitationAction.reject,
      );
      if (!isClosed) {
        emit(state.copyWith(invitation: const CollaboratorInvitationState(showAsRejected: true)));
      }
    } catch (error, stackTrace) {
      _logger.severe('rejectInvitation', error, stackTrace);
      if (!isClosed) {
        emitError(LocalizedException.create(error));
      }
    }
  }

  Future<void> retryLastRef() async {
    final id = _cache.ref;
    if (id != null) {
      await loadProposal(id);
    }
  }

  Future<void> submitComment({
    required Document document,
    SignedDocumentRef? reply,
  }) async {
    final proposalRef = _cache.ref;
    final proposalCategoryId = _cache.proposal?.metadata.parameters.set.first;
    assert(proposalRef != null, 'Proposal ref not found. Load document first!');
    assert(
      proposalRef is SignedDocumentRef,
      'Can comment only on signed documents',
    );

    final activeAccountId = _cache.activeAccountId;
    assert(activeAccountId != null, 'No active account found!');

    final commentTemplate = _cache.commentTemplate;
    assert(commentTemplate != null, 'No comment template found!');

    assert(proposalCategoryId != null, 'Proposal categoryId not found!');

    final commentRef = SignedDocumentRef.generateFirstRef();
    final comment = CommentDocument(
      metadata: CommentMetadata(
        id: commentRef,
        ref: proposalRef! as SignedDocumentRef,
        template: commentTemplate!.metadata.id as SignedDocumentRef,
        reply: reply,
        parameters: DocumentParameters({?proposalCategoryId}),
        authorId: activeAccountId!,
      ),
      document: document,
    );

    final comments = (_cache.comments ?? []).addComment(comment: comment);
    _cache = _cache.copyWith(comments: Optional(comments));
    emit(state.copyWith(data: _rebuildProposalViewData()));

    final documentData = comment.toDocumentData(mapper: _documentMapper);

    try {
      await _commentService.submitComment(document: documentData);
    } catch (error, stack) {
      _logger.info('Publishing comment failed', error, stack);

      final localizedException = LocalizedException.create(
        error,
        fallback: LocalizedUnknownPublishCommentException.new,
      );

      emitError(localizedException);

      final source = _cache.comments;
      final comments = (source ?? []).removeComment(ref: commentRef);
      _cache = _cache.copyWith(comments: Optional(comments));

      if (!isClosed) {
        emit(state.copyWith(data: _rebuildProposalViewData()));
      }
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

  void updateCommentsSort({required ProposalCommentsSort sort}) {
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
    final ref = _cache.ref;
    assert(ref != null, 'Proposal ref not found. Load doc first');

    _cache = _cache.copyWith(isFavorite: Optional(value));
    emit(state.copyWithFavorite(isFavorite: value));

    if (value) {
      await _proposalService.addFavoriteProposal(id: ref!);
    } else {
      await _proposalService.removeFavoriteProposal(ref: ref!);
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

      emitSignal(const UsernameUpdatedSignal());
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
    required ProposalCommentsSort commentsSort,
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
      proposalRef: proposalDocumentRef,
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
    required ProposalCommentsSort commentsSort,
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

    final commentsSegment = ProposalCommentsSegment(
      id: const NodeId('comments'),
      sort: commentsSort,
      sections: [
        ProposalViewCommentsSection(
          id: const NodeId('comments.view'),
          sort: commentsSort,
          comments: commentsSort.applyTo(comments),
          canReply: canReply,
        ),
        if (canComment)
          ProposalAddCommentSection(
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

  // TODO(dt-iohk): remove dummy logic when data source for invitations is ready
  // TODO(LynxLynxx): Rewrite this method as ProposalDataCollaborator should already have all data needed
  CollaboratorInvitationState _getCollaboratorInvitation(
    List<ProposalDataCollaborator> collaborators,
    CatalystId? activeAccountId,
  ) {
    if (activeAccountId != null && collaborators.none((e) => e.id == activeAccountId)) {
      return const CollaboratorInvitationState(
        invitation: CollaboratorInvitation(),
      );
    }
    return const CollaboratorInvitationState();
  }

  void _handleActiveAccountIdChanged(CatalystId? data) {
    if (_cache.activeAccountId != data) {
      _cache = _cache.copyWith(activeAccountId: Optional(data));
      emit(state.copyWith(data: _rebuildProposalViewData()));

      // Reload proposal if one is already loaded to update with new activeAccountId
      final currentRef = _cache.ref;
      if (currentRef != null) {
        unawaited(loadProposal(currentRef));
      }
    }
  }

  void _handleCommentsChange(List<CommentWithReplies> comments) {
    _cache = _cache.copyWith(comments: Optional(comments));

    emit(state.copyWith(data: _rebuildProposalViewData()));
  }

  Future<void> _handleProposalData(ProposalDataV2? proposal) async {
    try {
      if (proposal == null) {
        return emit(state.copyWith(error: const Optional(LocalizedNotFoundException())));
      }

      if (proposal.proposalOrDocument.asProposalDocument == null) {
        return emit(
          state.copyWith(error: const Optional(LocalizedProposalTemplateNotFoundException())),
        );
      }
      final proposalOrDocument = proposal.proposalOrDocument;
      final proposalDocument = proposal.proposalOrDocument.asProposalDocument!;

      final campaign = proposalOrDocument.campaign;
      final category = proposalOrDocument.category;

      final isReadOnlyMode =
          campaign?.phaseStateTo(CampaignPhaseType.proposalSubmission).status.isPost ?? true;

      final isVotingStage = _isVotingStage(campaign);
      final showComments = proposal.publish != ProposalPublish.submittedProposal;

      final invitation = _getCollaboratorInvitation(
        proposal.collaborators ?? [],
        _cache.activeAccountId,
      );

      final commentTemplate = await _commentService.getCommentTemplateFor(
        category: proposalDocument.metadata.parameters.set.first,
      );
      _cache = _cache.copyWith(
        proposal: Optional(proposalDocument),
        category: Optional(category),
        commentTemplate: Optional(commentTemplate),
        comments: const Optional([]),
        collaborators: Optional(proposal.collaborators),
        isFavorite: Optional(proposal.isFavorite),
        isVotingStage: Optional(isVotingStage),
        showComments: Optional(showComments),
        readOnlyMode: Optional(isReadOnlyMode),
        votes: Optional(proposal.votes),
        versions: Optional(proposal.versions),
        publish: Optional(proposal.publish),
      );

      unawaited(_commentsSub?.cancel());
      _commentsSub = _commentService
          // Note. watch comments on exact version of proposal.
          .watchCommentsWith(ref: proposalDocument.metadata.id)
          .distinct(listEquals)
          .listen(_handleCommentsChange);

      final proposalViewData = _rebuildProposalViewData();

      if (!isClosed) {
        emit(
          ProposalState(
            data: proposalViewData,
            invitation: invitation,
            readOnlyMode: isReadOnlyMode,
          ),
        );
      }

      if (proposalViewData.isCurrentVersionLatest == false &&
          isVotingStage &&
          _cache.activeAccountId != null) {
        emitSignal(const ViewingOlderVersionWhileVotingSignal());
      } else if (proposalViewData.isCurrentVersionLatest == false) {
        emitSignal(const ViewingOlderVersionSignal());
      }

      emit(state.copyWith(error: const Optional.empty()));
    } catch (error, stack) {
      _logger.severe('Loading ${proposal?.id} failed', error, stack);

      if (!isClosed) {
        _cache = _cache.copyWithoutProposal();
        emit(ProposalState(error: LocalizedException.create(error)));
      }
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  bool _isVotingStage(Campaign? campaign) {
    if (!_featureFlagsService.isEnabled(Features.voting)) return false;

    return campaign?.isVotingStateActive ?? false;
  }

  ProposalViewData _rebuildProposalViewData() {
    final proposal = _cache.proposal;
    final category = _cache.category;
    final commentTemplate = _cache.commentTemplate;
    final comments = _cache.comments ?? const [];
    final commentsSort = state.comments.commentsSort;
    final collaborators = _cache.collaborators ?? const [];
    final isFavorite = _cache.isFavorite ?? false;
    final isVotingStage = _cache.isVotingStage ?? false;
    final showComments = _cache.showComments ?? false;
    final readOnlyMode = _cache.readOnlyMode ?? false;
    final activeAccountId = _cache.activeAccountId;
    final votes = _cache.votes;
    final proposalVersions = _cache.versions;
    final publish = _cache.publish;

    final username = activeAccountId?.username;

    return _buildProposalViewData(
      activeAccountId: activeAccountId,
      hasAccountUsername: username != null && !username.isBlank,
      proposal: proposal,
      category: category,
      comments: comments,
      commentSchema: commentTemplate?.schema,
      commentsSort: commentsSort,
      collaborators: collaborators,
      isFavorite: isFavorite,
      readOnlyMode: readOnlyMode,
      isVotingStage: isVotingStage,
      showComments: showComments,
      lastCastedVote: votes?.casted,
      draftVote: votes?.draft,
      proposalVersions: proposalVersions ?? [],
      publish: publish,
    );
  }
}
