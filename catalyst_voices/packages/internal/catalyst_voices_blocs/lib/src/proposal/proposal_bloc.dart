import 'package:catalyst_voices_blocs/src/document/document_to_segment_mixin.dart';
import 'package:catalyst_voices_blocs/src/proposal/proposal.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class ProposalBloc extends Bloc<ProposalEvent, ProposalState>
    with DocumentToSegmentMixin {
  final ProposalService _proposalService;

  ProposalBloc(
    this._proposalService,
  ) : super(const ProposalState()) {
    on<ShowProposalEvent>(_handleShowProposalEvent);
    on<UpdateProposalFavoriteEvent>(_handleUpdateProposalFavoriteEvent);
  }

  Future<void> _handleShowProposalEvent(
    ShowProposalEvent event,
    Emitter<ProposalState> emit,
  ) async {
    emit(const ProposalState(isLoading: true));

    final ref = event.ref;

    final proposal = await _proposalService.getProposal(ref: ref);
    final proposalDocument = proposal.document;
    final proposalDocumentRef = proposalDocument.metadata.selfRef;

    final documentSegments = mapDocumentToSegments(proposalDocument.document);

    /* cSpell:disable */
    final overviewSegment = ProposalOverviewSegment.build(
      categoryName: 'Cardano Partners: Growth & Acceleration',
      proposalTitle: 'Project Mayhem: Freedom by Chaos',
      data: ProposalViewMetadata(
        author: const Profile(
          catalystId: 'cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE',
        ),
        description: 'Project Mayhem is a disruptive initiative to dismantle '
            'societal hierarchies through acts of controlled chaos. '
            'By targeting oppressive systems like credit structures and '
            'consumerist propaganda, we empower individuals to reclaim their '
            'agency. This ?decentralised movement fosters self-replication, '
            'inspiring global action for liberation and a return to human '
            'authenticity.',
        status: ProposalStatus.draft,
        createdAt: DateTime.now(),
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

    final versions = proposal.versions.mapIndexed((index, version) {
      return DocumentVersion(
        id: version,
        nr: index + 1,
        isCurrent: version == proposalDocumentRef.version,
        isLatest: index == proposal.versions.length - 1,
      );
    }).toList();

    final data = ProposalViewData(
      header: ProposalViewHeader(
        id: event.ref.id,
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

    emit(ProposalState(data: data));
  }

  Future<void> _handleUpdateProposalFavoriteEvent(
    UpdateProposalFavoriteEvent event,
    Emitter<ProposalState> emit,
  ) async {
    // TODO(damian-molinski): not implemented

    // ignore: unused_local_variable
    final proposalId = state.data.header.id;

    emit(state.copyWithFavorite(isFavorite: event.isFavorite));
  }
}
