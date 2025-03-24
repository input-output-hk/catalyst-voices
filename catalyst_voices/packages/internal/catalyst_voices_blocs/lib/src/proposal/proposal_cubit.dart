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
        BlocSignalEmitterMixin<ProposalSignal, ProposalState> {
  final UserService _userService;
  final ProposalService _proposalService;
  final CommentService _commentService;
  final DocumentMapper _documentMapper;

  ProposalCubitCache _cache = const ProposalCubitCache();

  StreamSubscription<CatalystId?>? _activeAccountIdSub;
  StreamSubscription<List<CommentWithReplies>>? _commentsSub;

  ProposalCubit(
    this._userService,
    this._proposalService,
    this._commentService,
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
      final commentTemplate = await _commentService.getCommentTemplateFor(
        category: proposal.categoryId,
      );
      final isFavorite =
          await _proposalService.watchIsFavoritesProposal(ref: ref).first;

      _cache = _cache.copyWith(
        proposal: Optional(proposal),
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
    } on LocalizedException catch (error, stack) {
      _logger.severe('Loading $ref failed', error, stack);

      _clearProposalCache();

      emit(ProposalState(error: error));
    } on ApiException catch (error, stack) {
      _logger.severe('Loading $ref failed', error, stack);

      _clearProposalCache();

      final localizedError = LocalizedApiException.from(error);

      emit(ProposalState(error: localizedError));
    } catch (error, stack) {
      _logger.severe('Loading $ref failed', error, stack);

      _clearProposalCache();

      emit(const ProposalState(error: LocalizedUnknownException()));
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

    final comment = CommentDocument(
      metadata: CommentMetadata(
        selfRef: SignedDocumentRef.generateFirstRef(),
        ref: proposalRef! as SignedDocumentRef,
        reply: reply,
        authorId: activeAccountId!,
      ),
      document: document,
    );

    final data = state.data;
    final updatedData = data.addComment(comment);
    emit(state.copyWith(data: updatedData));

    // TODO(damian-molinski): send document
  }

  void updateCommentBuilder({
    required SignedDocumentRef ref,
    required bool show,
  }) {
    final showReplyBuilder = Map.of(state.data.showReplyBuilder);

    showReplyBuilder[ref] = show;

    final updatedData = state.data.copyWith(showReplyBuilder: showReplyBuilder);

    emit(state.copyWith(data: updatedData));
  }

  void updateCommentReplies({
    required SignedDocumentRef ref,
    required bool show,
  }) {
    final showReplies = Map.of(state.data.showReplies);

    showReplies[ref] = show;

    final updatedData = state.data.copyWith(showReplies: showReplies);

    emit(state.copyWith(data: updatedData));
  }

  void updateCommentsSort({required ProposalCommentsSort sort}) {
    final data = state.data;
    final segments = data.segments.sortWith(sort: sort).toList();

    final updatedData = data.copyWith(
      segments: segments,
      commentsSort: sort,
    );

    emit(state.copyWith(data: updatedData));
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
    required List<CommentWithReplies> comments,
    required DocumentSchema? commentSchema,
    required ProposalCommentsSort commentsSort,
    required bool isFavorite,
  }) {
    final proposalDocument = proposal?.document;
    final proposalDocumentRef = proposalDocument?.metadata.selfRef;

    /* cSpell:disable */
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
            version: currentVersion,
            comments: comments,
            commentSchema: commentSchema,
            commentsSort: commentsSort,
            hasActiveAccount: hasActiveAccount,
          )
        : const <Segment>[];

    return ProposalViewData(
      isCurrentVersionLatest: currentVersion?.isLatest,
      header: ProposalViewHeader(
        title: 'Project Mayhem: Freedom by Chaos',
        authorDisplayName: 'Tyler Durden',
        createdAt: DateTime.timestamp(),
        commentsCount: comments.length,
        versions: versions,
        isFavorite: isFavorite,
      ),
      segments: segments,
      commentsSort: commentsSort,
    );
    /* cSpell:enable */
  }

  /* cSpell:disable */
  List<Segment> _buildSegments({
    required ProposalData proposal,
    required DocumentVersion? version,
    required List<CommentWithReplies> comments,
    required DocumentSchema? commentSchema,
    required ProposalCommentsSort commentsSort,
    required bool hasActiveAccount,
  }) {
    final overviewSegment = ProposalOverviewSegment.build(
      categoryName: 'Cardano Partners: Growth & Acceleration',
      proposalTitle: 'Project Mayhem: Freedom by Chaos',
      data: ProposalViewMetadata(
        author: Profile(catalystId: DummyCatalystIdFactory.create()),
        description: 'Project Mayhem is a disruptive initiative to dismantle '
            'societal hierarchies through acts of controlled chaos. '
            'By targeting oppressive systems like credit structures and '
            'consumerist propaganda, we empower individuals to reclaim their '
            'agency. This ?decentralised movement fosters self-replication, '
            'inspiring global action for liberation and a return to human '
            'authenticity.',
        status: ProposalStatus.draft,
        createdAt: version?.id.tryDateTime ?? DateTime.now(),
        warningCreatedAt: version?.isLatest == false,
        tag: 'Community Outreach',
        commentsCount: comments.length,
        fundsRequested: 200000,
        projectDuration: 12,
        milestoneCount: 3,
      ),
    );

    final proposalSegments = mapDocumentToSegments(proposal.document.document);

    final commentsSegment = ProposalCommentsSegment(
      id: const NodeId('comments'),
      sort: commentsSort,
      sections: [
        ViewCommentsSection(
          id: const NodeId('comments.view'),
          comments: commentsSort.applyTo(comments),
        ),
        if (hasActiveAccount && commentSchema != null)
          AddCommentSection(
            id: const NodeId('comments.add'),
            schema: commentSchema,
          ),
      ],
    );

    return [
      overviewSegment,
      ...proposalSegments,
      commentsSegment,
    ];
  }

  void _clearProposalCache() {
    _cache = _cache.copyWith(
      proposal: const Optional.empty(),
      commentTemplate: const Optional.empty(),
      comments: const Optional.empty(),
      isFavorite: const Optional.empty(),
    );
  }

  void _handleActiveAccountIdChanged(CatalystId? data) {
    if (_cache.activeAccountId != data) {
      _cache = _cache.copyWith(activeAccountId: Optional(data));
      _rebuildProposalState();
    }
  }

  void _handleCommentsChange(List<CommentWithReplies> comments) {
    _cache = _cache.copyWith(comments: Optional(comments));

    _rebuildProposalState();
  }

  /* cSpell:enable */

  ProposalViewData _rebuildProposalState() {
    final proposal = _cache.proposal;
    final commentTemplate = _cache.commentTemplate;
    final comments = _cache.comments ?? const [];
    final commentsSort = state.data.commentsSort;
    final isFavorite = _cache.isFavorite ?? false;
    final activeAccountId = _cache.activeAccountId;

    return _buildProposalViewData(
      hasActiveAccount: activeAccountId != null,
      proposal: proposal,
      comments: comments,
      commentSchema: commentTemplate?.schema,
      commentsSort: commentsSort,
      isFavorite: isFavorite,
    );
  }
}
