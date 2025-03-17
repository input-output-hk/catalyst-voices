import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/document/document_to_segment_mixin.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'proposal_cubit_mock_data.dart';

final _logger = Logger('ProposalBloc');

final class ProposalCubit extends Cubit<ProposalState>
    with
        DocumentToSegmentMixin,
        BlocSignalEmitterMixin<ProposalSignal, ProposalState> {
  final UserService _userService;
  final ProposalService _proposalService;

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

      if (isClosed) {
        return;
      }

      final proposalViewData = _buildProposalViewData(proposal);

      emit(ProposalState(data: proposalViewData));

      if (proposalViewData.isCurrentVersionLatest == false) {
        emitSignal(const ViewingOlderVersionSignal());
      }
    } on LocalizedException catch (error, stack) {
      _logger.severe('Change document to $ref failed', error, stack);

      emit(ProposalState(error: error));
    } catch (error, stack) {
      _logger.severe('Change document to $ref failed', error, stack);

      emit(const ProposalState(error: LocalizedUnknownException()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> updateIsFavorite({required bool value}) async {
    // TODO(damian-molinski): not implemented

    // ignore: unused_local_variable
    final proposalId = state.data.currentRef?.id;

    emit(state.copyWithFavorite(isFavorite: value));
  }

  ProposalViewData _buildProposalViewData(ProposalData proposal) {
    final activeAccountId = _userService.user.activeAccount?.catalystId;

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

    final firstComment = _buildComment(
      message: 'The first rule about fight club is...',
    );
    final comments = [
      CommentWithReplies(
        comment: firstComment,
        replies: [
          CommentWithReplies(
            comment: _buildComment(
              parent: firstComment.metadata.selfRef,
              message: 'Don’t talk about fight club',
            ),
            replies: const [],
            depth: 2,
          ),
        ],
        depth: 1,
      ),
      CommentWithReplies(
        comment: _buildComment(
          message: 'This proposal embodies a bold and disruptive vision that '
              'aligns with the decentralised ethos of the Cardano ecosystem. '
              'The focus on empowering individuals through grassroots action '
              'and the inclusion of open-source methodologies makes it a '
              'transformative initiative. The clear milestones and emphasis '
              'on secure, replicable strategies inspire confidence in the '
              'project’s feasibility and scalability. I look forward to '
              'seeing its impact.',
        ),
        replies: const [],
        depth: 1,
      ),
    ];

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

    final commentsSegment = ProposalCommentsSegment.build(
      sort: ProposalCommentsSort.newest,
      authorId: activeAccountId ??
          CatalystId.fromUri(
            Uri.parse(
              'id.catalyst://cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE',
            ),
          ),
      template: _buildCommentTemplate(),
      comments: comments,
    );

    return ProposalViewData(
      isCurrentVersionLatest: currentVersion?.isLatest,
      header: ProposalViewHeader(
        title: 'Project Mayhem: Freedom by Chaos',
        authorDisplayName: 'Tyler Durden',
        createdAt: DateTime.timestamp(),
        commentsCount: proposal.commentsCount,
        versions: versions,
        isFavorite: false,
      ),
      segments: [
        overviewSegment,
        ...documentSegments,
        commentsSegment,
      ],
    );
    /* cSpell:enable */
  }
}
