import 'package:catalyst_voices_blocs/src/proposal/proposal.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

    final data = ProposalViewData(
      header: ProposalViewHeader(
        title: 'Project Mayhem: Freedom by Chaos',
        authorDisplayName: 'Tyler Durden',
        createdAt: DateTime.timestamp(),
        commentsCount: 6,
        versions: const DocumentVersions(),
        isFavourite: false,
      ),
      segments: const [],
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
