import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/document/document_to_segment_mixin.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/data.dart';
import 'package:uuid/uuid.dart';

part 'proposal_cubit_mock_data.dart';

final _logger = Logger('ProposalBloc');

final class ProposalCubit extends Cubit<ProposalState>
    with
        DocumentToSegmentMixin,
        BlocSignalEmitterMixin<ProposalSignal, ProposalState> {
  // ignore: unused_field
  final UserService _userService;
  final ProposalService _proposalService;

  // Cache
  DocumentRef? _ref;

  // ignore: unused_field
  ProposalData? _proposal;

  // ignore: unused_field
  List<CommentWithReplies>? _comments;

  // 1. Fetch proposal document
  // 2. Observe document comments
  // 3. Observe active account
  // 4. Sort comments.
  ProposalCubit(
    this._userService,
    this._proposalService,
  ) : super(const ProposalState());

  Future<void> load({required DocumentRef ref}) async {
    try {
      _logger.info('Loading $ref');

      emit(state.copyWith(isLoading: true));

      final proposal = await _proposalService.getProposal(ref: ref);
      final comments = _buildComments();

      if (isClosed) {
        return;
      }

      final commentsSort = state.data.commentsSort;

      final proposalViewData = _buildProposalViewData(
        proposal: proposal,
        comments: comments,
        commentsSort: commentsSort,
        isFavorite: false,
      );

      _ref = ref;
      _proposal = proposal;
      _comments = comments;

      emit(ProposalState(data: proposalViewData));

      if (proposalViewData.isCurrentVersionLatest == false) {
        emitSignal(const ViewingOlderVersionSignal());
      }
    } on LocalizedException catch (error, stack) {
      _logger.severe('Loading $ref failed', error, stack);

      _ref = null;
      _proposal = null;
      _comments = null;

      emit(ProposalState(error: error));
    } catch (error, stack) {
      _logger.severe('Loading $ref failed', error, stack);

      _ref = null;
      _proposal = null;
      _comments = null;

      emit(const ProposalState(error: LocalizedUnknownException()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> submitComment({
    required Document document,
    SignedDocumentRef? parent,
  }) async {
    final comment = CommentDocument(
      metadata: CommentMetadata(
        selfRef: SignedDocumentRef.generateFirstRef(),
        parent: parent,
      ),
      document: document,
    );

    final data = state.data;

    final updatedData = data.addComment(comment);

    emit(state.copyWith(data: updatedData));

    // TODO(damian-molinski): integrate
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

  // TODO(damian-molinski): not implemented
  Future<void> updateIsFavorite({required bool value}) async {
    final proposalId = _ref?.id;
    assert(proposalId != null, 'Proposal ref not found. Load doc first');

    emit(state.copyWithFavorite(isFavorite: value));
  }

  ProposalViewData _buildProposalViewData({
    required ProposalData proposal,
    required List<CommentWithReplies> comments,
    required ProposalCommentsSort commentsSort,
    required bool isFavorite,
  }) {
    final proposalDocument = proposal.document;
    final proposalDocumentRef = proposalDocument.metadata.selfRef;
    final documentSegments = mapDocumentToSegments(proposalDocument.document);

    /* cSpell:disable */
    final versions = proposal.versions.mapIndexed((index, version) {
      return DocumentVersion(
        id: version,
        number: index + 1,
        isCurrent: version == proposalDocumentRef.version,
        isLatest: index == proposal.versions.length - 1,
      );
    }).toList();

    final currentVersion = versions.singleWhereOrNull((e) => e.isCurrent);

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
        createdAt: currentVersion?.id.tryDateTime ?? DateTime.now(),
        warningCreatedAt: currentVersion?.isLatest == false,
        tag: 'Community Outreach',
        commentsCount: comments.length,
        fundsRequested: 200000,
        projectDuration: 12,
        milestoneCount: 3,
      ),
    );

    final sortedComments = commentsSort.applyTo(comments);
    final commentsSegment = ProposalCommentsSegment.build(
      sort: ProposalCommentsSort.newest,
      commentSchema: _buildCommentTemplate().document.schema,
      comments: sortedComments,
    );

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
      segments: [
        overviewSegment,
        ...documentSegments,
        commentsSegment,
      ],
      commentsSort: commentsSort,
    );
    /* cSpell:enable */
  }
}
