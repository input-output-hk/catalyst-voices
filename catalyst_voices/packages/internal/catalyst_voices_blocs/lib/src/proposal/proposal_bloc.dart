import 'package:catalyst_voices_blocs/src/proposal/proposal.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

final class ProposalBloc extends Bloc<ProposalEvent, ProposalState> {
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
    final document = proposal.document;

    final current = const Uuid().v7();

    final data = ProposalViewData(
      header: ProposalViewHeader(
        id: event.ref.id,
        title: 'Project Mayhem: Freedom by Chaos',
        authorDisplayName: 'Tyler Durden',
        createdAt: DateTime.timestamp(),
        commentsCount: 6,
        versions: DocumentVersions(
          current: current,
          all: [
            current,
            ...List.generate(4, (_) => const Uuid().v7()),
          ],
        ),
        isFavourite: false,
      ),
      segments: [
        ProposalOverviewSegment.build(data: 1),
        ProposalCommentsSegment.build(comments: []),
      ],
    );

    emit(ProposalState(data: data));
  }

  Future<void> _handleUpdateProposalFavoriteEvent(
    UpdateProposalFavoriteEvent event,
    Emitter<ProposalState> emit,
  ) async {
    // TODO(damian-molinski): not implemented

    emit(state.copyWithFavourite(isFavourite: event.isFavorite));
  }
}
