import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/document/document_to_segment_mixin.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _logger = Logger('ProposalBloc');

final class ProposalBloc extends Bloc<ProposalEvent, ProposalState>
    with
        DocumentToSegmentMixin,
        BlocSignalEmitterMixin<ProposalSignal, ProposalState> {
  final ProposalService _proposalService;

  ProposalBloc(
    this._proposalService,
  ) : super(const ProposalState()) {
    on<ShowProposalEvent>(_handleShowProposalEvent);
    on<UpdateProposalFavoriteEvent>(_handleUpdateProposalFavoriteEvent);
  }

  ProposalViewData _buildProposalViewData(ProposalData proposal) {
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
        commentsCount: 6,
        fundsRequested: 200000,
        projectDuration: 12,
        milestoneCount: 3,
      ),
    );

    final commentsSegment = ProposalCommentsSegment.build(
      comments: const [],
    );

    return ProposalViewData(
      currentRef: proposalDocumentRef,
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

  Future<void> _changeDocumentTo({
    required DocumentRef ref,
    required Emitter<ProposalState> emit,
  }) async {
    try {
      _logger.info('Changing document to $ref');

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

  Future<void> _handleShowProposalEvent(
    ShowProposalEvent event,
    Emitter<ProposalState> emit,
  ) {
    return _changeDocumentTo(ref: event.ref, emit: emit);
  }

  Future<void> _handleUpdateProposalFavoriteEvent(
    UpdateProposalFavoriteEvent event,
    Emitter<ProposalState> emit,
  ) async {
    // TODO(damian-molinski): not implemented

    // ignore: unused_local_variable
    final proposalId = state.data.currentRef?.id;

    emit(state.copyWithFavorite(isFavorite: event.isFavorite));
  }
}
