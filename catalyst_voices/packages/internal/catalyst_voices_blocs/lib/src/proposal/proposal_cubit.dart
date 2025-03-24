import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/document/document_to_segment_mixin.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid_plus/uuid_plus.dart';

part 'proposal_cubit_mock_data.dart';

final _logger = Logger('ProposalBloc');

final class ProposalCubit extends Cubit<ProposalState>
    with
        DocumentToSegmentMixin,
        BlocSignalEmitterMixin<ProposalSignal, ProposalState> {
  final UserService _userService;
  final ProposalService _proposalService;

  // Cache
  CatalystId? _activeAccountId;
  DocumentRef? _ref;
  ProposalData? _proposal;
  CommentTemplate? _commentTemplate;
  List<CommentWithReplies>? _comments;
  bool? _isFavorite;

  StreamSubscription<CatalystId?>? _activeAccountIdSub;

  // Note for integration.
  // 2. Observe document comments
  ProposalCubit(
    this._userService,
    this._proposalService,
  ) : super(const ProposalState()) {
    _activeAccountId = _userService.user.activeAccount?.catalystId;
    _activeAccountIdSub = _userService.watchUser
        .map((event) => event.activeAccount?.catalystId)
        .distinct()
        .listen(_handleActiveAccountIdChanged);
  }

  @override
  Future<void> close() async {
    await _activeAccountIdSub?.cancel();
    _activeAccountIdSub = null;

    return super.close();
  }

  Future<void> load({required DocumentRef ref}) async {
    try {
      _ref = ref;

      _logger.info('Loading $ref');

      emit(state.copyWith(isLoading: true));

      await Future<void>.delayed(const Duration(seconds: 2));

      throw ErrorResponseException(statusCode: 404);

      // final proposal = await _proposalService.getProposal(ref: ref);
      final comments = _buildComments();
      final isFavorite =
          await _proposalService.watchIsFavoritesProposal(ref: ref).first;

      _proposal = null;
      _commentTemplate = _buildCommentTemplate();
      _comments = comments;
      _isFavorite = isFavorite;

      if (!isClosed) {
        final proposalState = _rebuildProposalState();

        emit(ProposalState(data: proposalState));

        if (proposalState.isCurrentVersionLatest == false) {
          emitSignal(const ViewingOlderVersionSignal());
        }
      }
    } on LocalizedException catch (error, stack) {
      _logger.severe('Loading $ref failed', error, stack);

      _proposal = null;
      _commentTemplate = null;
      _comments = null;
      _isFavorite = null;

      emit(ProposalState(error: error));
    } catch (error, stack) {
      _logger.severe('Loading $ref failed', error, stack);

      _proposal = null;
      _commentTemplate = null;
      _comments = null;
      _isFavorite = null;

      emit(const ProposalState(error: LocalizedUnknownException()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> retryLastRef() async {
    final ref = _ref;
    if (ref != null) {
      await load(ref: ref);
    }
  }

  Future<void> submitComment({
    required Document document,
    SignedDocumentRef? reply,
  }) async {
    final proposalRef = _ref;
    assert(proposalRef != null, 'Proposal ref not found. Load document first!');

    final comment = CommentDocument(
      metadata: CommentMetadata(
        selfRef: SignedDocumentRef.generateFirstRef(),
        ref: proposalRef!,
        reply: reply,
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
    final ref = _ref;
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

  void _handleActiveAccountIdChanged(CatalystId? data) {
    if (_activeAccountId != data) {
      _activeAccountId = data;
      _rebuildProposalState();
    }
  }

  /* cSpell:enable */

  ProposalViewData _rebuildProposalState() {
    final proposal = _proposal;
    final commentTemplate = _commentTemplate;
    final comments = _comments ?? const [];
    final commentsSort = state.data.commentsSort;
    final isFavorite = _isFavorite ?? false;
    final activeAccountId = _activeAccountId;

    return _buildProposalViewData(
      hasActiveAccount: activeAccountId != null,
      proposal: proposal,
      comments: comments,
      commentSchema: commentTemplate?.document.schema,
      commentsSort: commentsSort,
      isFavorite: isFavorite,
    );
  }
}
