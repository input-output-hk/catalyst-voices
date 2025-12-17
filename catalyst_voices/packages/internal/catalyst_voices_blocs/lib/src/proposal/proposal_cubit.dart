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
  final CampaignService _campaignService;
  final DocumentMapper _documentMapper;
  final VotingBallotBuilder _ballotBuilder;
  final VotingService _votingService;
  final FeatureFlagsService _featureFlagsService;

  ProposalCubitCache _cache = const ProposalCubitCache();

  StreamSubscription<CatalystId?>? _activeAccountIdSub;
  StreamSubscription<List<CommentWithReplies>>? _commentsSub;
  StreamSubscription<Vote?>? _watchedCastedVotesSub;

  ProposalCubit(
    this._userService,
    this._proposalService,
    this._commentService,
    this._campaignService,
    this._documentMapper,
    this._ballotBuilder,
    this._votingService,
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

  Future<void> load({required DocumentRef ref}) async {
    try {
      final isReadOnlyMode = await _isReadOnlyMode();
      final campaign = await _campaignService.getActiveCampaign();
      final isVotingStage = _isVotingStage(campaign);
      final showComments = campaign != null && !isVotingStage;
      _logger.info('Loading $ref');

      _cache = _cache.copyWith(ref: Optional.of(ref));

      emit(state.copyWith(isLoading: true));

      final proposal = await _proposalService.getProposalDetail(ref: ref);
      final category = await _campaignService.getCategory(proposal.document.metadata.parameters);
      final commentTemplate = await _commentService.getCommentTemplate(category: category.selfRef);
      final isFavorite = await _proposalService.watchIsFavoritesProposal(ref: ref).first;

      _cache = _cache.copyWith(
        proposal: Optional(proposal),
        category: Optional(category),
        commentTemplate: Optional(commentTemplate),
        comments: const Optional([]),
        isFavorite: Optional(isFavorite),
        isVotingStage: Optional(isVotingStage),
        showComments: Optional(showComments),
        readOnlyMode: Optional(isReadOnlyMode),
      );

      await _commentsSub?.cancel();
      _commentsSub = _commentService
          // Note. watch comments on exact version of proposal.
          .watchCommentsWith(ref: proposal.document.metadata.selfRef)
          .distinct(listEquals)
          .listen(_handleCommentsChange);

      await _watchedCastedVotesSub?.cancel();
      _watchedCastedVotesSub = _votingService
          .watchedCastedVotes()
          .map((vote) => vote.forProposal(ref))
          .listen(_handleLastCastedChange);

      _ballotBuilder.addListener(_handleBallotBuilderChange);

      if (!isClosed) {
        final proposalState = _rebuildProposalState();

        emit(ProposalState(data: proposalState, readOnlyMode: isReadOnlyMode));

        if (proposalState.isCurrentVersionLatest == false &&
            isVotingStage &&
            _cache.activeAccountId != null) {
          emitSignal(const ViewingOlderVersionWhileVotingSignal());
        } else if (proposalState.isCurrentVersionLatest == false) {
          emitSignal(const ViewingOlderVersionSignal());
        }
      }
    } catch (error, stack) {
      _logger.severe('Loading $ref failed', error, stack);

      _cache = _cache.copyWithoutProposal();

      emit(ProposalState(error: LocalizedException.create(error)));
    } finally {
      if (!isClosed) {
        emit(state.copyWith(isLoading: false));
      }
    }
  }

  Future<void> retryLastRef() async {
    final ref = _cache.ref;
    if (ref != null) {
      await load(ref: ref);
    }
  }

  Future<void> submitComment({
    required Document document,
    SignedDocumentRef? reply,
  }) async {
    final proposalRef = _cache.ref;
    final proposalParameters = _cache.proposal?.document.metadata.parameters;
    assert(proposalRef != null, 'Proposal ref not found. Load document first!');
    assert(proposalRef is SignedDocumentRef, 'Can comment only on signed documents');
    assert(proposalParameters != null, 'Proposal parameters not found!');

    final activeAccountId = _cache.activeAccountId;
    assert(activeAccountId != null, 'No active account found!');

    final commentTemplate = _cache.commentTemplate;
    assert(commentTemplate != null, 'No comment template found!');

    final commentRef = SignedDocumentRef.generateFirstRef();
    final comment = CommentDocument(
      metadata: CommentMetadata(
        selfRef: commentRef,
        proposalRef: proposalRef! as SignedDocumentRef,
        commentTemplate: commentTemplate!.metadata.selfRef as SignedDocumentRef,
        reply: reply,
        parameters: proposalParameters!,
        authorId: activeAccountId!,
      ),
      document: document,
    );

    final comments = (_cache.comments ?? []).addComment(comment: comment);
    _cache = _cache.copyWith(comments: Optional(comments));
    emit(state.copyWith(data: _rebuildProposalState()));

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
        emit(state.copyWith(data: _rebuildProposalState()));
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
      await _proposalService.addFavoriteProposal(ref: ref!);
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
    required bool hasActiveAccount,
    required bool hasAccountUsername,
    required ProposalDetailData? proposal,
    required CampaignCategory? category,
    required List<CommentWithReplies> comments,
    required DocumentSchema? commentSchema,
    required ProposalCommentsSort commentsSort,
    required bool isFavorite,
    required bool isVotingStage,
    required bool showComments,
    required bool readOnlyMode,
    required Vote? lastCastedVote,
    required Vote? draftVote,
  }) {
    final proposalDocument = proposal?.document;
    final proposalDocumentRef = proposalDocument?.metadata.selfRef;

    final proposalVersions = proposal?.versions ?? const [];
    final versions = proposalVersions.reversed.mapIndexed((index, version) {
      final ver = version.selfRef.version;

      return DocumentVersion(
        id: ver ?? '',
        number: index + 1,
        isCurrent: ver == proposalDocumentRef?.version,
        isLatest: index == proposalVersions.length - 1,
      );
    }).toList();
    final currentVersion = versions.singleWhereOrNull((e) => e.isCurrent);
    final commentsCount = showComments
        ? comments.fold(0, (prev, next) => prev + 1 + next.repliesCount)
        : null;

    final segments = proposal != null
        ? _buildSegments(
            proposal: proposal,
            category: category,
            version: currentVersion,
            comments: comments,
            commentSchema: commentSchema,
            commentsSort: commentsSort,
            hasActiveAccount: hasActiveAccount,
            hasAccountUsername: hasAccountUsername,
            commentsCount: commentsCount,
            isVotingStage: isVotingStage,
            showComments: showComments,
            readOnlyMode: readOnlyMode,
            lastCastedVote: lastCastedVote,
            draftVote: draftVote,
          )
        : const <Segment>[];

    final header = ProposalViewHeader(
      proposalRef: proposalDocumentRef,
      title: proposalDocument?.title ?? '',
      authorName: proposalDocument?.authorName,
      createdAt: proposalDocumentRef?.version?.tryDateTime,
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
    required ProposalDetailData proposal,
    required CampaignCategory? category,
    required DocumentVersion? version,
    required List<CommentWithReplies> comments,
    required DocumentSchema? commentSchema,
    required ProposalCommentsSort commentsSort,
    required bool hasActiveAccount,
    required bool hasAccountUsername,
    required int? commentsCount,
    required bool isVotingStage,
    required bool showComments,
    required bool readOnlyMode,
    required Vote? lastCastedVote,
    required Vote? draftVote,
  }) {
    final document = proposal.document;
    final isDraftProposal = document.metadata.selfRef is DraftRef;
    final isLatestVersion = version?.isLatest ?? false;

    final votingSegment = _buildProposalVotingOverviewSegment(
      isVotingStage: isVotingStage,
      hasActiveAccount: hasActiveAccount,
      isLatestVersion: isLatestVersion,
      isFinal: proposal.publish.isPublished,
      proposalRef: proposal.document.metadata.selfRef,
      lastCastedVote: lastCastedVote,
      draftVote: draftVote,
    );

    final overviewSegment = ProposalOverviewSegment.build(
      categoryName: category?.formattedCategoryName ?? '',
      proposalTitle: document.title ?? '',
      isVotingStage: (isVotingStage && isLatestVersion),
      data: ProposalViewMetadata(
        author: Profile(catalystId: document.authorId!),
        description: document.description,
        status: proposal.publish,
        createdAt: version?.id.tryDateTime ?? DateTimeExt.now(),
        warningCreatedAt: version?.isLatest == false,
        tag: document.tag,
        commentsCount: commentsCount,
        fundsRequested: document.fundsRequested,
        projectDuration: document.duration,
        milestoneCount: document.milestoneCount,
      ),
    );

    final proposalSegments = mapDocumentToSegments(document.document);

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

  void _handleActiveAccountIdChanged(CatalystId? data) {
    if (_cache.activeAccountId != data) {
      _cache = _cache.copyWith(activeAccountId: Optional(data));
      emit(state.copyWith(data: _rebuildProposalState()));
    }
  }

  void _handleBallotBuilderChange() {
    emit(state.copyWith(data: _rebuildProposalState()));
  }

  void _handleCommentsChange(List<CommentWithReplies> comments) {
    _cache = _cache.copyWith(comments: Optional(comments));

    emit(state.copyWith(data: _rebuildProposalState()));
  }

  void _handleLastCastedChange(Vote? vote) {
    _cache = _cache.copyWith(lastCastedVote: Optional(vote));

    emit(state.copyWith(data: _rebuildProposalState()));
  }

  Future<bool> _isReadOnlyMode() async {
    final campaignTimeline = await _campaignService.getCampaignPhaseTimeline(
      CampaignPhaseType.proposalSubmission,
    );
    final dateRangeStatus = campaignTimeline.timeline.rangeStatus(DateTimeExt.now());

    return switch (dateRangeStatus) {
      DateRangeStatus.after => true,
      _ => false,
    };
  }

  bool _isVotingStage(Campaign? campaign) {
    if (!_featureFlagsService.isEnabled(Features.voting)) return false;

    return campaign?.isVotingStateActive ?? false;
  }

  ProposalViewData _rebuildProposalState() {
    final proposal = _cache.proposal;
    final category = _cache.category;
    final commentTemplate = _cache.commentTemplate;
    final comments = _cache.comments ?? const [];
    final commentsSort = state.comments.commentsSort;
    final isFavorite = _cache.isFavorite ?? false;
    final isVotingStage = _cache.isVotingStage ?? false;
    final showComments = _cache.showComments ?? false;
    final readOnlyMode = _cache.readOnlyMode ?? false;
    final activeAccountId = _cache.activeAccountId;
    final ref = _cache.ref;
    final lastCastedVote = _cache.lastCastedVote;
    final draftVote = ref != null ? _ballotBuilder.getVoteOn(ref) : null;

    final username = activeAccountId?.username;

    return _buildProposalViewData(
      hasActiveAccount: activeAccountId != null,
      hasAccountUsername: username != null && !username.isBlank,
      proposal: proposal,
      category: category,
      comments: comments,
      commentSchema: commentTemplate?.schema,
      commentsSort: commentsSort,
      isFavorite: isFavorite,
      readOnlyMode: readOnlyMode,
      isVotingStage: isVotingStage,
      showComments: showComments,
      lastCastedVote: lastCastedVote,
      draftVote: draftVote,
    );
  }
}
