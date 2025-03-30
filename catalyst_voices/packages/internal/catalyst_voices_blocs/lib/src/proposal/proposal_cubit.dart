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
import 'package:flutter_bloc/flutter_bloc.dart';

final _logger = Logger('ProposalBloc');

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

  ProposalCubitCache _cache = const ProposalCubitCache();

  StreamSubscription<CatalystId?>? _activeAccountIdSub;
  StreamSubscription<List<CommentWithReplies>>? _commentsSub;

  ProposalCubit(
    this._userService,
    this._proposalService,
    this._commentService,
    this._campaignService,
    this._documentMapper,
  ) : super(const ProposalState()) {
    _cache = _cache.copyWith(
      activeAccountId: Optional(_userService.user.activeAccount?.catalystId),
    );
    _activeAccountIdSub = _userService.watchUser
        .map((event) => event.activeAccount?.catalystId)
        .distinct()
        .listen(_handleActiveAccountIdChanged);
  }

  @override
  Future<void> close() async {
    await _activeAccountIdSub?.cancel();
    _activeAccountIdSub = null;

    await _commentsSub?.cancel();
    _commentsSub = null;

    return super.close();
  }

  Future<void> load({required DocumentRef ref}) async {
    try {
      _logger.info('Loading $ref');

      _cache = _cache.copyWith(ref: Optional.of(ref));

      emit(state.copyWith(isLoading: true));

      final proposal = await _proposalService.getProposal(ref: ref);
      final category = await _campaignService.getCategory(proposal.categoryId);
      final commentTemplate = await _commentService.getCommentTemplateFor(
        category: proposal.categoryId,
      );
      final isFavorite =
          await _proposalService.watchIsFavoritesProposal(ref: ref).first;

      _cache = _cache.copyWith(
        proposal: Optional(proposal),
        category: Optional(category),
        commentTemplate: Optional(commentTemplate),
        comments: const Optional([]),
        isFavorite: Optional(isFavorite),
      );

      await _commentsSub?.cancel();
      _commentsSub = _commentService
          // Note. watch comments on exact version of proposal.
          .watchCommentsWith(ref: proposal.document.metadata.selfRef)
          .distinct(listEquals)
          .listen(_handleCommentsChange);

      if (!isClosed) {
        final proposalState = _rebuildProposalState();

        emit(ProposalState(data: proposalState));

        if (proposalState.isCurrentVersionLatest == false) {
          emitSignal(const ViewingOlderVersionSignal());
        }
      }
    } catch (error, stack) {
      _logger.severe('Loading $ref failed', error, stack);

      _cache = _cache.copyWith(
        proposal: const Optional.empty(),
        commentTemplate: const Optional.empty(),
        comments: const Optional.empty(),
        isFavorite: const Optional.empty(),
      );

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
    assert(proposalRef != null, 'Proposal ref not found. Load document first!');
    assert(
      proposalRef is SignedDocumentRef,
      'Can comment only on signed documents',
    );

    final activeAccountId = _cache.activeAccountId;
    assert(activeAccountId != null, 'No active account found!');

    final commentTemplate = _cache.commentTemplate;
    assert(commentTemplate != null, 'No comment template found!');

    final commentRef = SignedDocumentRef.generateFirstRef();
    final comment = CommentDocument(
      metadata: CommentMetadata(
        selfRef: commentRef,
        ref: proposalRef! as SignedDocumentRef,
        template: commentTemplate!.metadata.selfRef as SignedDocumentRef,
        reply: reply,
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
    final updatedComments =
        state.comments.updateCommentBuilder(ref: ref, show: show);

    emit(state.copyWith(comments: updatedComments));
  }

  void updateCommentReplies({
    required SignedDocumentRef ref,
    required bool show,
  }) {
    final updatedComments =
        state.comments.updateCommentReplies(ref: ref, show: show);

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

    emit(state.copyWithFavorite(isFavorite: value));

    if (value) {
      await _proposalService.addFavoriteProposal(ref: ref!);
    } else {
      await _proposalService.removeFavoriteProposal(ref: ref!);
    }
  }

  ProposalViewData _buildProposalViewData({
    required bool hasActiveAccount,
    required ProposalData? proposal,
    required CampaignCategory? category,
    required List<CommentWithReplies> comments,
    required DocumentSchema? commentSchema,
    required ProposalCommentsSort commentsSort,
    required bool isFavorite,
  }) {
    final proposalDocument = proposal?.document;
    final proposalDocumentRef = proposalDocument?.metadata.selfRef;

    final proposalVersions = proposal?.versions ?? const [];
    final versions = proposalVersions.mapIndexed((index, version) {
      final ver = version.document.metadata.selfRef.version;

      return DocumentVersion(
        id: ver ?? '',
        number: index + 1,
        isCurrent: ver == proposalDocumentRef?.version,
        isLatest: index == proposalVersions.length - 1,
      );
    }).toList();
    final currentVersion = versions.singleWhereOrNull((e) => e.isCurrent);

    final segments = proposal != null
        ? _buildSegments(
            proposal: proposal,
            category: category,
            version: currentVersion,
            comments: comments,
            commentSchema: commentSchema,
            commentsSort: commentsSort,
            hasActiveAccount: hasActiveAccount,
          )
        : const <Segment>[];

    final header = ProposalViewHeader(
      title: proposalDocument?.title ?? '',
      authorName: proposalDocument?.authorName ?? '',
      createdAt: proposalDocumentRef?.version?.tryDateTime,
      commentsCount: comments.length,
      versions: versions,
      isFavorite: isFavorite,
    );

    return ProposalViewData(
      isCurrentVersionLatest: currentVersion?.isLatest,
      header: header,
      segments: segments,
    );
  }

  List<Segment> _buildSegments({
    required ProposalData proposal,
    required CampaignCategory? category,
    required DocumentVersion? version,
    required List<CommentWithReplies> comments,
    required DocumentSchema? commentSchema,
    required ProposalCommentsSort commentsSort,
    required bool hasActiveAccount,
  }) {
    final document = proposal.document;
    final isDraftProposal = document.metadata.selfRef is DraftRef;

    final overviewSegment = ProposalOverviewSegment.build(
      categoryName: category?.categoryName ?? '',
      proposalTitle: document.title ?? '',
      data: ProposalViewMetadata(
        author: Profile(catalystId: DummyCatalystIdFactory.create()),
        description: document.description,
        status: ProposalStatus.draft,
        createdAt: version?.id.tryDateTime ?? DateTime.now(),
        warningCreatedAt: version?.isLatest == false,
        tag: document.tag,
        commentsCount: comments.length,
        fundsRequested: document.fundsRequested,
        projectDuration: document.duration,
        milestoneCount: document.milestoneCount,
      ),
    );

    final proposalSegments = mapDocumentToSegments(
      document.document,
      filterOut: [
        ProposalDocument.categoryNodeId,
      ],
    );

    final canReply = !isDraftProposal && hasActiveAccount;
    final canComment = canReply && commentSchema != null;
    final commentsSegment = ProposalCommentsSegment(
      id: const NodeId('comments'),
      sort: commentsSort,
      sections: [
        ProposalViewCommentsSection(
          id: const NodeId('comments.view'),
          comments: commentsSort.applyTo(comments),
          canReply: canReply,
        ),
        if (canReply && commentSchema != null)
          ProposalAddCommentSection(
            id: const NodeId('comments.add'),
            schema: commentSchema,
          ),
      ],
    );

    return [
      overviewSegment,
      ...proposalSegments,
      if (canComment || comments.isNotEmpty) commentsSegment,
    ];
  }

  void _handleActiveAccountIdChanged(CatalystId? data) {
    if (_cache.activeAccountId != data) {
      _cache = _cache.copyWith(activeAccountId: Optional(data));
      emit(state.copyWith(data: _rebuildProposalState()));
    }
  }

  void _handleCommentsChange(List<CommentWithReplies> comments) {
    _cache = _cache.copyWith(comments: Optional(comments));

    emit(state.copyWith(data: _rebuildProposalState()));
  }

  ProposalViewData _rebuildProposalState() {
    final proposal = _cache.proposal;
    final category = _cache.category;
    final commentTemplate = _cache.commentTemplate;
    final comments = _cache.comments ?? const [];
    final commentsSort = state.comments.commentsSort;
    final isFavorite = _cache.isFavorite ?? false;
    final activeAccountId = _cache.activeAccountId;

    return _buildProposalViewData(
      hasActiveAccount: activeAccountId != null,
      proposal: proposal,
      category: category,
      comments: comments,
      commentSchema: commentTemplate?.schema,
      commentsSort: commentsSort,
      isFavorite: isFavorite,
    );
  }
}
