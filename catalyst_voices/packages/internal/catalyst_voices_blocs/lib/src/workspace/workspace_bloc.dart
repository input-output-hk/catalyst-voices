import 'dart:math';

import 'package:catalyst_voices_blocs/src/common/bloc_error_emitter_mixin.dart';
import 'package:catalyst_voices_blocs/src/workspace/workspace_event.dart';
import 'package:catalyst_voices_blocs/src/workspace/workspace_state.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _logger = Logger('WorkspaceBloc');

final class WorkspaceBloc extends Bloc<WorkspaceEvent, WorkspaceState>
    with BlocErrorEmitterMixin {
  // ignore: unused_field
  final CampaignService _campaignService;
  final ProposalService _proposalService;

  // ignore: unused_field
  final List<Proposal> _proposals = [];

  WorkspaceBloc(
    this._campaignService,
    this._proposalService,
  ) : super(const WorkspaceState()) {
    on<LoadProposalsEvent>(_loadProposals);
    on<TabChangedEvent>(_handleTabChange);
    on<ImportProposalEvent>(_importProposal);
    on<SearchQueryChangedEvent>(
      _handleQueryChange,
      // TODO(damian-molinski): implement debounce
      transformer: null,
    );
  }

  Future<void> _handleQueryChange(
    SearchQueryChangedEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    // TODO(damian-molinski): implement filtering of _proposals

    final query = event.query;

    emit(state.copyWith(searchQuery: query));
  }

  Future<void> _handleTabChange(
    TabChangedEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    // TODO(damian-molinski): implement filtering of _proposals

    emit(state.copyWith(tab: event.tab));
  }

  Future<void> _importProposal(
    ImportProposalEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    try {
      final ref = await _proposalService.importProposal(event.proposalData);
      emit(state.copyWith(importedProposalRef: Optional(ref)));
    } catch (error, stackTrace) {
      _logger.severe('Exporting proposal failed', error, stackTrace);
      emitError(const LocalizedUnknownException());
    }
  }

  Future<void> _loadProposals(
    LoadProposalsEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        draftProposalCount: 0,
        finalProposalCount: 0,
        proposals: const [],
        error: const Optional.empty(),
      ),
    );

    // TODO(damian-molinski): implement fetching proposals
    // TODO(damian-molinski): implement filtering of _proposals

    final isSuccess = await Future.delayed(
      const Duration(milliseconds: 300),
      () => Random().nextBool(),
    );
    if (isClosed) return;

    final proposals = isSuccess
        ? List<WorkspaceProposalListItem>.generate(
            20,
            (index) => WorkspaceProposalListItem(
              id: '$index',
              name: 'Proposal [${index + 1}]',
            ),
          )
        : const <WorkspaceProposalListItem>[];

    final LocalizedException? error =
        isSuccess ? null : const LocalizedUnknownException();

    final newState = state.copyWith(
      isLoading: false,
      draftProposalCount: isSuccess ? 2 : 0,
      finalProposalCount: isSuccess ? 1 : 0,
      proposals: proposals,
      error: Optional(error),
    );

    emit(newState);
  }
}
